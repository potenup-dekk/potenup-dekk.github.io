# 🎯 DEKK Archive 설정 및 운영 가이드

이 문서는 GitHub 블로그 관리자를 위한 기술 문서입니다.

---

## 📋 목차

1. [기술 스택](#-기술-스택)
2. [프로젝트 구조](#-프로젝트-구조)
3. [카테고리 매핑](#-카테고리-매핑)
4. [로컬 환경 설정](#-로컬-환경-설정)
5. [포스트 날짜 규칙](#-포스트-날짜-규칙)
6. [배포 프로세스](#-배포-프로세스)
7. [트러블슈팅](#-트러블슈팅)

---

## 🛠️ 기술 스택

| 항목           | 버전           | 설명                       |
| -------------- | -------------- | -------------------------- |
| **Jekyll**     | 4.4.1          | 정적 블로그 생성기         |
| **Theme**      | Chirpy 7.4.1   | 고급 기능의 Jekyll 테마    |
| **Ruby**       | 3.1.7          | 필수 런타임                |
| **Ruby Gems**  | 42개           | 의존성 관리 (Gemfile 참고) |
| **Deployment** | GitHub Pages   | 자동 배포 환경             |
| **CI/CD**      | GitHub Actions | jekyll-deploy.yml 사용     |

---

## 📂 프로젝트 구조

```
potenup-dekk.github.io/
│
├── _posts/                          # 블로그 포스트 (마크다운 파일)
│   ├── ...
│
├── _tabs/                           # 고정 페이지 (카테고리 페이지 등)
│   ├── about.md                     # 블로그 소개
│   ├── archives.md                  # 모든 포스트 목록
│   ├── categories.md                # 카테고리 목록
│   └── tags.md                      # 태그 목록
│
├── _data/                           # 메타데이터
│   ├── authors.yml                  # 작성자 정보
│   ├── contact.yml                  # 연락처
│   └── share.yml                    # 공유 설정
│
├── assets/                          # 정적 에셋
│   └── img/                         # 이미지 파일
│
├── _config.yml                      # Jekyll 전역 설정
├── Gemfile                          # Ruby 의존성 정의
├── Gemfile.lock                     # 의존성 버전 고정
├── .ruby-version                    # Ruby 버전 지정 (3.1.7)
├── start.sh                         # 로컬 서버 시작 스크립트
├── CONTRIBUTING.md                  # 포스트 작성 가이드
├── README.md                        # 프로젝트 소개
└── SETUP.md                         # 이 파일 (관리자 가이드)
```

---

## 🏷️ 카테고리 매핑

### 카테고리 설정 규칙

포스트의 Front Matter에 `categories` 필드를 정의하면, Jekyll이 자동으로 카테고리 페이지를 생성합니다.

| 카테고리명 | 페이지 이름 | \_tabs 파일 | URL  |
| ---------- | ----------- | ----------- | ---- |
| `Frontend` | fe.md       | fe.md       | /fe/ |
| `Backend`  | be.md       | be.md       | /be/ |

### Front Matter 예시

```yaml
---
title: "포스트 제목"
description: "간단한 포스트 설명"
date: 2026-02-22 10:30:00 +0900
categories: [Frontend] # ← 여기서 정의
tags: [react, optimization]
author: "username"
---
```

**중요**: `category` 필드 값이 포스트의 `categories` 배열의 항목과 **정확히 일치**해야 포스트가 표시됩니다.

---

## 🖥️ 로컬 환경 설정

### 필수 사항

- **macOS/Linux**: Ruby 3.1.7 이상
- **Windows**: WSL2 추천 (또는 Docker)

### 설정 방법

#### 1단계: Ruby 설치 (macOS)

```bash
# Homebrew로 Ruby 3.1 설치
brew install ruby@3.1

# .zshrc 또는 .bashrc에 추가
export PATH="/opt/homebrew/opt/ruby@3.1/bin:$PATH"
```

#### 2단계: 프로젝트 클론

```bash
git clone https://github.com/potenup-dekk/potenup-dekk.github.io.git
cd potenup-dekk.github.io
```

#### 3단계: 의존성 설치

```bash
# Ruby 3.1 사용:
/opt/homebrew/opt/ruby@3.1/bin/bundle install

# 또는 start.sh 스크립트 사용:
./start.sh
```

#### 4단계: 로컬 서버 실행

```bash
# 방법 1: 스크립트 사용 (권장)
./start.sh

# 방법 2: 직접 명령어
/opt/homebrew/opt/ruby@3.1/bin/bundle exec jekyll serve

# 브라우저에서 http://localhost:4000 접속
```

---

## 📅 포스트 날짜 규칙

### ⚠️ 중요: Jekyll의 미래 날짜 정책

Jekyll은 **현재 날짜보다 미래**의 포스트를 기본적으로 제외합니다.

**현재 날짜**: 2026년 2월 22일

| 포스트 날짜 | 상태      | 이유                                 |
| ----------- | --------- | ------------------------------------ |
| 2026-02-21  | ✅ 표시됨 | 과거 날짜                            |
| 2026-02-22  | ⚠️ 조건부 | 오늘 날짜 (시간에 따라 다를 수 있음) |
| 2026-02-23  | ❌ 숨겨짐 | 미래 날짜                            |
| 2025-02-22  | ❌ 숨겨짐 | 미래 날짜 (현재가 2026년)            |

### 포스트 날짜 설정 가이드

```yaml
---
# ❌ 틀린 예: 미래 날짜
date: 2025-02-22 14:30:00 +0900   # 표시 안 됨!

# ✅ 올바른 예: 현재 또는 과거 날짜
date: 2026-02-22 14:30:00 +0900   # 표시됨
date: 2026-02-21 10:00:00 +0900   # 표시됨
---
```

### 해결 방법

미래 날짜 포스트를 보려면:

```bash
# 방법 1: start.sh 수정 (미래 포스트 포함)
bundle exec jekyll serve --future

# 방법 2: _config.yml 수정
future: true  # 추가
```

---

## 🚀 배포 프로세스

### 자동 배포 흐름

```
로컬 작성 → GitHub에 Push → GitHub Actions 실행 → GitHub Pages 배포 ✨
```

### GitHub Actions 워크플로우

- **파일 위치**: `.github/workflows/jekyll-deploy.yml`
- **트리거**: `main` 브랜치 push 또는 PR 병합
- **작업 내용**:
  1. Ruby 3.1 설정
  2. 의존성 설치 (bundle install)
  3. Jekyll 빌드 (jekyll build)
  4. GitHub Pages로 배포

### 배포 확인

```bash
# GitHub에서 확인:
1. "Actions" 탭 → "jekyll-deploy" 워크플로우 선택
2. 최신 워크플로우 실행 상태 확인 (초록색 ✅ = 성공)
3. 완료되면 몇 초 내에 https://potenup-dekk.github.io/ 업데이트됨
```

---

## 🔧 트러블슈팅

### 1. 로컬에서 포스트가 안 보임

**원인**: 포스트 날짜가 미래

**해결책**:

```bash
# 옵션 1: 포스트 날짜를 현재/과거로 변경
date: 2026-02-22 10:30:00 +0900

# 옵션 2: 미래 포스트 포함하여 빌드
bundle exec jekyll serve --future
```

### 2. "Could not find 'bundler'" 에러

**원인**: Ruby 2.6으로 실행 중

**해결책**:

```bash
# Ruby 3.1 전체 경로로 실행
/opt/homebrew/opt/ruby@3.1/bin/bundle exec jekyll serve

# 또는 start.sh 사용
./start.sh
```

### 3. 카테고리 페이지가 비어 있음

**원인**: 카테고리명 불일치

**확인 사항**:

- `_tabs/fe.md`의 `category: Frontend`
- 포스트의 `categories: [Frontend]`
- 두 값이 **정확히 일치**하는지 확인

### 4. 번들 설치 실패

**원인**: Ruby 버전 호환성 문제

**해결책**:

```bash
# Ruby 3.1 명시적으로 사용
/opt/homebrew/opt/ruby@3.1/bin/gem install bundler:2.5.11
/opt/homebrew/opt/ruby@3.1/bin/bundle install
```

### 5. 로컬 변경 후 배포 안 됨

**원인**: 로컬 커밋을 push하지 않음

**확인 사항**:

```bash
# 변경 사항 확인
git status

# 커밋 및 푸시
git add .
git commit -m "[Frontend] 변경 내용"
git push origin main
```

---

## 📊 모니터링

### 배포 상태 확인

```bash
# 최근 배포 히스토리 (GitHub에서)
Settings > Environments > github-pages > Active deployments

# 또는 "Actions" 탭에서 jekyll-deploy 워크플로우 확인
```

### 로그 확인

```bash
# GitHub Actions 로그
1. "Actions" 탭 → "jekyll-deploy" 선택
2. 최신 워크플로우 클릭
3. "Deploy to GitHub Pages" 작업 클릭
4. 콘솔 로그 확인
```

---

## 📞 유용한 명령어

```bash
# 캐시 삭제 후 재빌드
rm -rf _site
/opt/homebrew/opt/ruby@3.1/bin/bundle exec jekyll serve

# 특정 코드 라인 개수 세기
find _posts -name "*.md" | xargs wc -l | tail -1

# 모든 포스트의 Front Matter 확인
for f in _posts/*.md; do echo "=== $f ==="; head -10 "$f"; done
```

---

## 📚 참고 자료

- [Jekyll 공식 문서](https://jekyllrb.com/docs/)
- [Chirpy 테마 문서](https://chirpy.cotes.page/)
- [GitHub Pages 가이드](https://pages.github.com/)
- [마크다운 문법](https://markdownguide.org/)
