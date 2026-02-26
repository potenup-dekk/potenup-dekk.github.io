---
title: "소셜 로그인 API 세팅 가이드"
date: 2026-02-23 00:00:00 +0900
categories: [Backend]
tags: [oauth, login]
author: "woongblack"
---

> **작성자:** 정재웅

본 문서는 DEKK 프로젝트의 Google 및 Kakao 소셜 로그인을 위한 API 키 발급 및 로컬 환경변수 세팅 방법을 안내합니다.

---

## 1. 카카오(Kakao) 로그인 API 키 확인
카카오 로그인을 위해서는 REST API 키와 Client Secret 두 가지가 필요합니다.

### 1-1. REST API 키 및 기본 설정
* **접속 경로:** 카카오 디벨로퍼스 > 내 애플리케이션 > [애플리케이션 이름]
* **키 확인:** 왼쪽 메뉴 **[앱 설정] > [요약 정보]**에서 REST API 키 확인 가능
* REST API키를 누르게 되면 리다이렉트 URL, 클라이언트 시크릿키 확인 가능

![카카오 앱 설정 및 요약 정보](/assets/img/social-login-api-guide/img.png)

* **리다이렉트 URI 설정:** [제품 설정] > [카카오 로그인]
* **활성화 설정:** ON
* **Redirect URI:** `http://localhost:8080/login/oauth2/code/kakao`

![카카오 리다이렉트 URI 설정](/assets/img/social-login-api-guide/img_1.png)

### 1-2. Client Secret (보안 키)
* **접속 경로:** 왼쪽 메뉴 [제품 설정] > [카카오 로그인] > [보안]
* **상태:** 활성화 ON
* **코드:** Client Secret 코드 확인 (이 코드는 유출되지 않도록 주의!)

![카카오 Client Secret 설정](/assets/img/social-login-api-guide/img_2.png)


## 2. 구글(Google) 로그인 API 키 확인
구글 로그인은 Client ID와 Client Secret이 필요합니다.

### 2-1. API 및 서비스 설정
* **접속 경로:** 구글 클라우드 콘솔 > 사용자 인증 정보
* **키 확인:** OAuth 2.0 클라이언트 ID 목록에서 현재 프로젝트 클릭
![구글 클라이언트 ID 및 보안 비밀번호](/assets/img/social-login-api-guide/img_3.png)


### 2-2. 승인된 리디렉션 URI 설정 및 구글 클라이언트 ID 및 보안 비밀번호 
* 같은 화면의 하단 **[승인된 리디렉션 URI]** 항목 확인
* **등록된 URI:** `http://localhost:8080/login/oauth2/code/google`
* 상단 우측에서 클라이언트 ID와 클라이언트 보안 비밀번호(Client Secret) 확인 가능
![구글 승인된 리디렉션 URI 설정](/assets/img/social-login-api-guide/img_4.png)

---
> **💡 참고 사항**
> 발급받은 API 키와 Secret 정보는 절대 GitHub에 직접 커밋되지 않도록 `application.yml`이나 `.env` 파일에 분리하고 `.gitignore`에 추가되어 있는지 꼭 확인해 주세요!

