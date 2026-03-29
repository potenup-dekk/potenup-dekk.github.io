---
title: "QueryDSL 온보딩 가이드"
description: "@Query 문자열 기반 쿼리의 한계를 극복하기 위해 QueryDSL을 도입하게 된 배경과 기본 사용법, 그리고 기존 쿼리를 단계적으로 마이그레이션하는 전략을 정리합니다."
date: 2026-03-23 23:00:00 +0900
categories: [Backend]
tags: [querydsl, query, dynamic-query, migration]
author: "dd-jiyun"
---

## 0. 왜 QueryDSL을 도입하게 됐나?

> Spring Boot 3.x + Jakarta EE 기준

동적 쿼리가 늘어나면서 Repository에 아래와 같은 코드가 쌓이기 시작했습니다.

```java
@Query("SELECT DISTINCT c FROM Card c "
        + "JOIN FETCH c.cardImage "
        + "LEFT JOIN FETCH c.cardProducts cp "
        + "LEFT JOIN FETCH cp.product p "
        + "LEFT JOIN FETCH p.productImage "
        + "WHERE c.id IN :ids ORDER BY c.createdAt DESC")
List<Card> findAllByIdInWithProducts(@Param("ids") List<Long> ids);
```

이 방식의 문제점은 다음과 같습니다.

- **가독성** - 문자열 이어붙이기로 인해 쿼리가 길어질수록 읽기 어려워짐
- **타입 안정성 없음** - 필드명 오타, 엔티티 리팩토링 시 런타임에서야 오류 발견
- **동적 조건 처리 한계** - 조건이 조금만 달라져도 쿼리 메서드를 새로 추가해야 함
- **유지보수 비용** - 비슷하지만 다른 쿼리가 Repository에 계속 쌓임

QueryDSL을 도입하면 위 쿼리를 아래처럼 작성할 수 있습니다.

```java
queryFactory
    .selectDistinct(card)
    .from(card)
    .join(card.cardImage).fetchJoin()
    .leftJoin(card.cardProducts, cardProduct).fetchJoin()
    .leftJoin(cardProduct.product, product).fetchJoin()
    .leftJoin(product.productImage).fetchJoin()
    .where(card.id.in(ids))
    .orderBy(card.createdAt.desc())
    .fetch();
```

문자열 없이 코드로만 쿼리를 구성하기 때문에, IDE 자동완성과 컴파일 오류의 도움을 받을 수 있습니다.

## 1. QueryDSL이란?

QueryDSL은 **타입에 안전한(Type-safe)** 방식으로 쿼리를 작성할 수 있게 해주는 프레임워크입니다.
`@Query` 어노테이션의 쿼리 문자열 대신, Java 코드로 쿼리를 구성하여 **컴파일 시점에 오류를 잡을 수 있습니다.**

| 장점          | 설명                                                                  |
| ------------- | --------------------------------------------------------------------- |
| 타입 안정성   | 컴파일 시점에 필드명·타입 오류를 잡아냄. 오타로 인한 런타임 오류 방지 |
| IDE 자동완성  | Q클래스의 필드를 IDE가 자동완성해 주어 생산성 향상                    |
| 동적 쿼리     | 조건에 따라 where절을 프로그래밍 방식으로 조합 가능                   |
| 리팩토링 안전 | 엔티티 필드명 변경 시 Q클래스도 자동 반영, 쿼리도 컴파일 오류로 감지  |

## 2. Gradle 설정 (Spring Boot 3.x)

Spring Boot 3.x는 Jakarta EE를 사용하므로 **`:jakarta` classifier를 반드시 붙여야 합니다.**

> ⚠️ Spring Boot 2.x는 `javax` 기반이므로 `:jakarta`를 붙이면 안 됩니다. 이 문서는 3.x 기준입니다.

```gradle
dependencies {
    // QueryDSL JPA - :jakarta classifier 필수
    implementation "com.querydsl:querydsl-jpa:5.1.0:jakarta"
    annotationProcessor "com.querydsl:querydsl-apt:5.1.0:jakarta"

    // Q클래스 생성에 필요한 어노테이션 프로세서
    annotationProcessor "jakarta.persistence:jakarta.persistence-api"
    annotationProcessor "jakarta.annotation:jakarta.annotation-api"
}
```

### JPAQueryFactory 빈 등록

```java
@Configuration
public class QueryDSLConfig {

    @PersistenceContext
    private EntityManager entityManager;

    @Bean
    public JPAQueryFactory jpaQueryFactory() {
        return new JPAQueryFactory(entityManager);
    }
}
```

## 3. Q클래스 생성

`@Entity`가 붙은 도메인 모델을 기반으로 Q클래스가 자동 생성됩니다. 빌드 시 한 번만 실행하면 됩니다.

```bash
./gradlew compileJava
```

예를 들어 아래 엔티티가 있으면:

```java
@Entity
public class Customer {
    private String firstName;
    private String lastName;
    private int level;
}
```

QueryDSL이 자동으로 `QCustomer` 클래스를 생성합니다.

```java
QCustomer customer = QCustomer.customer;      // 기본 싱글턴 인스턴스
QCustomer customerAlias = new QCustomer("c"); // 직접 변수명 지정 (조인 시 유용)
```

> 💡 IntelliJ IDEA에서 Q클래스가 보이지 않으면 **Build > Rebuild Project**를 실행하세요.

## 4. 기본 쿼리 작성법

### 4.1 단건 조회

```java
Customer bob = queryFactory
    .selectFrom(customer)
    .where(customer.firstName.eq("Bob"))
    .fetchOne();
```

### 4.2 다건 조회

```java
List<Customer> list = queryFactory
    .selectFrom(customer)
    .where(customer.level.gt(2))
    .fetch();
```

### 4.3 다중 조건 (AND / OR)

```java
// AND - 두 방법 모두 동일한 결과
queryFactory.selectFrom(customer)
    .where(customer.firstName.eq("Bob"),
           customer.lastName.eq("Wilson"))
    .fetch();

// OR
queryFactory.selectFrom(customer)
    .where(customer.firstName.eq("Bob")
        .or(customer.lastName.eq("Wilson")))
    .fetch();
```

### 4.4 정렬

```java
queryFactory.selectFrom(customer)
    .orderBy(customer.lastName.asc(),
             customer.firstName.desc())
    .fetch();
```

### 4.5 페이징

```java
queryFactory.selectFrom(customer)
    .offset(0)
    .limit(10)
    .fetch();
```

> 💡 페이징 시에는 **콘텐츠 조회 쿼리(fetch)** 와 **카운트 쿼리(count)** 를 분리해서 작성하는 방식을 권장합니다.
> 이때 카운트 쿼리에도 콘텐츠 쿼리와 **동일한 조건(where)** 을 반영해야 실제 페이지 수가 정확해집니다.

```java
BooleanExpression predicate = customer.level.gt(2);

List<Customer> content = queryFactory
    .selectFrom(customer)
    .where(predicate)
    .offset(pageable.getOffset())
    .limit(pageable.getPageSize())
    .fetch();

Long total = queryFactory
    .select(customer.count())
    .from(customer)
    .where(predicate)
    .fetchOne();
```

### 4.6 그룹핑

```java
queryFactory
    .select(customer.lastName)
    .from(customer)
    .groupBy(customer.lastName)
    .fetch();
```

## 5. 동적 쿼리 (핵심 기능)

동적 쿼리는 QueryDSL의 가장 강력한 기능입니다.
`@Query`로 동적 조건을 처리하면 코드가 복잡해지기 쉽지만, QueryDSL은 `BooleanBuilder` 또는 `BooleanExpression` 조합으로 유연하게 처리할 수 있습니다.

### 5.1 BooleanBuilder 사용

```java
public List<Customer> search(String name, Integer minLevel) {
    BooleanBuilder builder = new BooleanBuilder();

    if (name != null) {
        builder.and(customer.firstName.eq(name));
    }
    if (minLevel != null) {
        builder.and(customer.level.goe(minLevel));
    }

    return queryFactory
        .selectFrom(customer)
        .where(builder)
        .fetch();
}
```

### 5.2 BooleanExpression 다중 파라미터 방식

실무에서는 조건 메서드를 분리한 뒤, `where()`에 쉼표로 나열하는 패턴도 자주 사용합니다.
`where()`에 `null`이 들어가면 해당 조건은 자동으로 무시됩니다.

```java
public List<Customer> search(String name, Integer minLevel) {
    return queryFactory
        .selectFrom(customer)
        .where(
            nameEq(name),
            levelGoe(minLevel)
        )
        .fetch();
}

private BooleanExpression nameEq(String name) {
    return (name == null || name.isBlank()) ? null : customer.firstName.eq(name);
}

private BooleanExpression levelGoe(Integer minLevel) {
    return minLevel == null ? null : customer.level.goe(minLevel);
}
```

> 어떤 방식이 "절대적으로" 더 낫다고 보긴 어렵습니다.
> 단순한 동적 조건은 `BooleanExpression` 분리 방식이 읽기 쉽고 재사용성이 좋고,
> 복잡한 OR/AND 중첩 조건은 `BooleanBuilder`가 더 명확한 경우가 많습니다.

### 5.3 @Query vs QueryDSL 비교

|           | @Query (기존)                               | QueryDSL (이후)                                                                     |
| --------- | ------------------------------------------- | ----------------------------------------------------------------------------------- |
| 방식      | `"WHERE (:name IS NULL OR u.name = :name)"` | `if (name != null) builder.and(...)` 또는 `where(nameEq(name), levelGoe(minLevel))` |
| 오류 감지 | 런타임 오류                                 | 컴파일 오류                                                                         |
| 동적 조건 | 조건마다 쿼리 메서드 추가                   | BooleanBuilder/BooleanExpression 조합                                               |

## 6. 조인

JPA 환경에서는 주로 `innerJoin`, `leftJoin`, `join`을 사용합니다.
`fullJoin`은 기술적으로 표현 가능하더라도 JPA/JPQL 및 DB 조합에 따라 제약이 있을 수 있으니 주의하세요.
같은 엔티티를 여러 번 조인할 때는 별도 별칭을 만들어야 합니다.

```java
QCat cat = QCat.cat;
QCat mate = new QCat("mate");  // 별칭 지정

queryFactory
    .selectFrom(cat)
    .innerJoin(cat.mate, mate)
    .leftJoin(cat.kittens)
    .fetch();
```

## 7. DML (수정 / 삭제)

> ⚠️ QueryDSL JPA의 DML은 JPA 영속성 컨텍스트를 거치지 않고 직접 실행됩니다. 영속성 전파 규칙과 2차 캐시에 주의하세요.

벌크 연산은 영속성 컨텍스트를 우회하므로, 실행 후에는 `clear()`로 영속성 컨텍스트를 비워 조회 정합성을 맞추는 것을 권장합니다.
벌크 연산 전에 아직 반영되지 않은 변경이 있다면, 필요 시 `flush()`로 먼저 DB에 반영한 뒤 실행하세요.

### 7.1 Update

```java
entityManager.flush(); // 필요 시: 벌크 실행 전 영속성 컨텍스트 변경사항 반영

long count = queryFactory
    .update(customer)
    .where(customer.firstName.eq("Bob"))
    .set(customer.firstName, "Bobby")
    .execute();

entityManager.clear();
```

### 7.2 Delete

```java
entityManager.flush(); // 필요 시: 벌크 실행 전 영속성 컨텍스트 변경사항 반영

// 전체 삭제
queryFactory.delete(customer).execute();

// 조건부 삭제
queryFactory
    .delete(customer)
    .where(customer.level.lt(3))
    .execute();

entityManager.clear();
```

## 8. Repository 패턴 적용

QueryDSL을 Repository에 통합하는 표준 패턴입니다.
Custom 인터페이스를 만들어 `JpaRepository`와 함께 사용합니다.

### Step 1. Custom 인터페이스 정의

```java
public interface CustomerRepositoryCustom {
    List<Customer> search(String name, Integer minLevel);
}
```

### Step 2. 구현체 작성

```java
@RequiredArgsConstructor
public class CustomerRepositoryImpl implements CustomerRepositoryCustom {

    private final JPAQueryFactory queryFactory;
    private final QCustomer customer = QCustomer.customer;

    @Override
    public List<Customer> search(String name, Integer minLevel) {
        BooleanBuilder builder = new BooleanBuilder();
        if (name != null) builder.and(customer.firstName.eq(name));
        if (minLevel != null) builder.and(customer.level.goe(minLevel));

        return queryFactory
            .selectFrom(customer)
            .where(builder)
            .fetch();
    }
}
```

### Step 3. JpaRepository에 통합

```java
public interface CustomerRepository
    extends JpaRepository<Customer, Long>, CustomerRepositoryCustom {
}
```

## 9. 자주 쓰는 표현식 레퍼런스

| SQL 의미       | QueryDSL 표현식 | 예시                           |
| -------------- | --------------- | ------------------------------ |
| `=`            | `.eq()`         | `customer.name.eq("Bob")`      |
| `!=`           | `.ne()`         | `customer.name.ne("Bob")`      |
| `LIKE`         | `.contains()`   | `customer.name.contains("ob")` |
| `>`            | `.gt()`         | `customer.level.gt(3)`         |
| `>=`           | `.goe()`        | `customer.level.goe(3)`        |
| `<`            | `.lt()`         | `customer.level.lt(3)`         |
| `<=`           | `.loe()`        | `customer.level.loe(3)`        |
| `IS NULL`      | `.isNull()`     | `customer.email.isNull()`      |
| `IS NOT NULL`  | `.isNotNull()`  | `customer.email.isNotNull()`   |
| `IN (...)`     | `.in()`         | `customer.level.in(1, 2, 3)`   |
| `NOT IN (...)` | `.notIn()`      | `customer.level.notIn(1, 2)`   |
| `BETWEEN`      | `.between()`    | `customer.level.between(1, 5)` |

## 10. 기존 쿼리 마이그레이션 계획

### 왜 한 번에 바꾸지 않나?

기존에 잘 동작하는 쿼리를 한꺼번에 전환하면 다음과 같은 위험이 있습니다.

- **회귀 버그** — 문자열 JPQL과 QueryDSL은 내부 동작이 미묘하게 다를 수 있음. 특히 `JOIN FETCH`, `DISTINCT` 조합에서 결과가 달라질 수 있음
- **검증 범위 폭발** — 한 번에 쿼리를 많이 바꾸면 어디서 문제가 생겼는지 추적이 어려워짐
- **기능 개발 병행 어려움** — 마이그레이션 작업이 진행 중인 기능 개발과 충돌할 수 있음

따라서 아래 단계로 **점진적으로** 전환합니다.

### 마이그레이션 단계

**1단계 — 설정만 먼저**
기존 `@Query`는 전혀 건드리지 않고, QueryDSL 의존성과 `JPAQueryFactory` 빈만 추가합니다. 이 시점에서 기존 동작은 100% 동일합니다.

**2단계 — 신규 기능부터**
새로 만드는 복잡한 쿼리는 처음부터 QueryDSL로 작성합니다. 팀 전체가 실전에서 QueryDSL에 익숙해지는 단계입니다.

**3단계 — 동적 쿼리 우선 전환**
`@Query`로 처리하기 힘들었던 동적 조건 쿼리부터 교체합니다. 전환 후에는 반드시 기존과 동일한 결과를 반환하는지 테스트를 통해 검증합니다.

**4단계 — 단순 쿼리는 나중에 (혹은 유지)**
JPA 메서드명 쿼리나 단순한 `@Query`는 굳이 바꾸지 않아도 됩니다. QueryDSL과 `@Query`는 같은 Repository에서 공존할 수 있습니다.

> ⚠️ `nativeQuery = true`로 작성된 네이티브 SQL 쿼리는 QueryDSL로 대체할 수 없으므로 그대로 유지합니다.

---

## 참고

[QueryDSL 공식 문서 (GitHub)](https://github.com/querydsl/querydsl)
[QueryDSL Reference (Latest)](https://querydsl.github.io/static/querydsl/latest/reference/html/)
