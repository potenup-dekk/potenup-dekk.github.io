## 🎯 포스트 작성 가이드

### 1️⃣ 포스트 작성

#### **파일 위치 및 명명**

```
_posts/
└── YYYY-MM-DD-포스트-제목.md
```

**예시:**

```
_posts/2026-02-22-react-memo-optimization.md
_posts/2026-02-22-database-indexing-guide.md
```

#### **Front Matter (메타데이터)**

모든 포스트는 다음 정보를 포함해야 합니다:

```yaml
---
title: "포스트 제목 (영문으로 SEO 친화적으로)"
date: 2026-02-22 10:30:00 +0900
categories: [Frontend]
tags: [react, optimization, performance] # 소문자, 하이픈 사용
author: "작성자 이름 (또는 github username)"
---
```

**카테고리 옵션:**

- `ALL` - 직군 무관, 모든 팀원이 알면 좋을 내용
- `Frontend` - Frontend 모든 주제
- `Backend` - Backend 모든 주제
- `Design` - UI/UX, 디자인 시스템, 협업 관련 내용

**태그 규칙:**

- 소문자, 하이픈 사용 (예: `react-hooks`, `database-optimization`)
- 기술 스택 태그 (예: `react`, `typescript`, `nodejs`, `postgresql`)
- 주요 키워드 태그 (예: `performance`, `bug-fix`, `security`)

---

### 3️⃣ 콘텐츠 작성 템플릿

```markdown
---
title: "포스트 제목: 문제 해결 또는 학습 내용"
date: 2026-02-22 10:30:00 +0900
categories: [Frontend]
tags: [react, performance, optimization]
author: "username"
---

## 📌 개요 (2-3줄)

이 글에서 다루는 내용을 간단히 요약합니다.

## 🤔 배경 (문제 상황)

- 어떤 상황에서 이 문제를 만났는지 설명
- 왜 중요한지 공유
- 해결 전 영향도

## ✅ 해결 방법 (또는 배운 내용)

### 방법 1: ...

`code example`

### 방법 2: ...

`code example`

## 📊 결과 & 성능

- 개선 전/후 비교
- 메트릭 (성능 개선율, 시간 절감 등)
- 그래프나 스크린샷 활용

## 🎓 배운 점

- 주요 인사이트
- 팀에게 공유할 가치 있는 내용
- 다음에 개선할 사항

## 🔗 참고 자료

- [링크 제목](URL)
- [다른 참고 자료](URL)
```

---

### 4️⃣ 콘텐츠 작성 팁

**글 작성하기 좋은 주제들:**

| ALL                            | FE                           | BE                        | Design                      |
| ------------------------------ | ---------------------------- | ------------------------- | --------------------------- |
| 개발 문화 & 협업 방식 공유     | React Hook으로 성능 개선하기 | SQL 쿼리 최적화 사례      | 디자인 시스템 구축 사례     |
| 유용한 개발 도구 소개          | 상태 관리 라이브러리 비교    | API 캐싱 전략             | 컴포넌트 스펙 정의 방법     |
| 코드 리뷰 문화 & 팁            | 번들 사이즈 줄이기 실전      | 데이터베이스 마이그레이션 | UX 개선 사례                |
| 기술 트렌드 & 아티클 정리      | 접근성(a11y) 개선 기록       | 인증/인가 보안 강화       | 디자이너-개발자 협업 경험   |
| 온보딩 가이드 & 팀 컨벤션      | CSS 성능 최적화              | 에러 로깅 및 모니터링     | Figma 활용 팁               |

**팁:**

- ✅ **구체적이게**: "성능 개선"보다 "React.memo로 30% 번들 사이즈 감소"
- ✅ **코드 샘플 포함**: 실제 구현 코드 제시
- ✅ **Before/After**: 개선 이전과 이후 비교
- ✅ **3-5분 분량**: 간결하고 집중도 높은 글
- ✅ **스크린샷이나 다이어그램**: 복잡한 내용은 시각화

---

## 🚀 제출 프로세스

### 1단계: 저장소 클론 (처음 한 번만)

```bash
git clone https://github.com/potenup-dekk/potenup-dekk.github.io.git
cd potenup-dekk.github.io
```

### 2단계: 브랜치 생성

```bash
git checkout -b feat/your-post-name
```

### 3단계: 포스트 작성

`_posts/YYYY-MM-DD-title.md` 파일을 작성하세요.
[위의 템플릿](#3️⃣-콘텐츠-작성-템플릿)을 참조하세요.

### 4단계: 커밋 및 푸시

```bash
git add _posts/YYYY-MM-DD-title.md
git commit -m "[ALL] 포스트 제목 설명"
# [ALL], [Frontend], [Backend], [Design] 중 해당하는 카테고리 사용

git push origin feat/your-post-name
```

### 5단계: PR 생성 및 자동 배포

- GitHub에서 PR을 생성하세요
- 팀원의 리뷰를 받습니다
- **PR이 병합되면 자동으로 배포됩니다!** ✨ (별도의 로컬 테스트 불필요)

---

## ✨ 포스트 작성 체크리스트

- [ ] 파일명이 `YYYY-MM-DD-title.md` 형식인가?
- [ ] Front Matter에 모든 필수 정보가 있는가? (title, date, categories, tags, author)
- [ ] **포스트 날짜가 오늘 이전 날짜인가?** (미래 날짜는 표시 안 됨)
- [ ] 포스트가 `_posts/` 폴더에 있는가?
- [ ] 마크다운 문법이 올바른가?
- [ ] 코드 블록에 언어 타입을 명시했는가? (`javascript, `python 등)
- [ ] 이미지 경로가 올바른가? (있다면)
- [ ] 오타나 문법 오류를 확인했는가?
- [ ] 커밋 메시지에 [ALL], [Frontend], [Backend], [Design] 중 올바른 태그를 붙였는가?

---

## 📸 이미지 추가하기

이미지는 `assets/img/` 폴더에 저장하세요:

```bash
assets/img/
└── 2025/
    ├── 02/
    │   └── react-optimization-diagram.png
    │   └── performance-chart.png
```

마크다운에서 참조:

```markdown
![이미지 설명](assets/img/2025/02/react-optimization-diagram.png)
```

---

## 🔍 마크다운 문법 예시

### 제목

```markdown
# 제목 1

## 제목 2

### 제목 3
```

### 강조

```markdown
**굵은 텍스트**
_기울임_
~~취소선~~
```

### 코드 블록

```markdown
\`\`\`javascript
const greeting = "Hello, World!";
console.log(greeting);
\`\`\`
```

### 리스트

```markdown
- 항목 1
- 항목 2
  - 하위 항목

1. 첫 번째
2. 두 번째
```

### 링크 & 이미지

```markdown
[링크 텍스트](URL)
![이미지](image_path)
```

### 인용구

```markdown
> 인용문
```

---

## ❓ FAQ

**Q. 글을 얼마나 자주 작성해야 하나요?**
A. 월 1회 이상 작성을 권장합니다. 팀 문화에 따라 조정될 수 있습니다.

**Q. 칭찬이나 피드백은?**
A. PR에서 댓글로 자유롭게 공유하세요. 긍정적인 피드백 문화를 만들어갑시다!

**Q. 글을 수정하고 싶어요.**
A. 병합 후라도 수정 가능합니다. 새 브랜치를 만들어 수정 사항을 PR로 제출하세요.

**Q. 다른 언어로도 작성할 수 있나요?**
A. 기본은 한글이지만, 국제적 공유가 필요하면 영문도 가능합니다. 팀장과 상의하세요.

---

## 📞 질문이 있으신가요?

- 🐛 **Issue**: [GitHub Issues](https://github.com/potenup-dekk/potenup-dekk.github.io/issues) 에서 질문
