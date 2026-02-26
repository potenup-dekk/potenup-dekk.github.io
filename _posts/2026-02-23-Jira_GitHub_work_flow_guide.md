---
title: "Jira x GitHub 연동 및 자동화 워크플로우 가이드"
date: 2026-02-23 14:15:00 +0900
categories: [All]
tags: [jira, github, automation, workflow]
author: "woongblack"
---

> **작성자:** 정재웅

안녕하세요 팀원 여러분! 본격적인 DEKK 프로젝트 개발에 앞서, 우리가 작성한 코드의 진행 상황을 Jira에 일일이 수동으로 업데이트하는 번거로움을 없애고자 **Jira와 GitHub 연동 및 자동화 세팅**을 완료했습니다.

불필요한 마우스 클릭(동선)을 최소화하고 개발에만 몰입하기 위해, 우리 팀이 앞으로 사용할 **이슈 기반 개발 워크플로우**를 안내해 드립니다.

---

# 1. 🎯 무엇이 달라지나요? (자동화 규칙)

현재 Jira 프로젝트에 GitHub 애플리케이션(GitHub for Jira)이 연동되어 있으며, 아래 3가지 자동화 규칙이 백그라운드에서 실행됩니다.

1. **브랜치 생성 시:** 상태가 자동으로 `진행 중`으로 변경됩니다.
2. **Pull Request 생성 시:** 상태가 자동으로 `검토 중`으로 변경됩니다.
3. **Pull Request 머지 시:** 상태가 자동으로 `완료`로 변경되며 티켓이 닫힙니다.

> 💡 **주의:** 이 모든 마법은 **Jira 이슈 키(예: DK-12)**가 연결고리 역할을 했을 때만 작동합니다!

---

# 2. 🚀 DEKK 팀 표준 개발 워크플로우 (How to work)

앞으로 작업을 시작할 때는 무조건 GitHub으로 먼저 가지 마시고, **Jira 티켓**에서 출발해 주세요!

### Step 1. 작업 시작 (Jira에서 브랜치 생성) - 필수 ⭐️

<img src="/assets/img/jira-workflow/workflow_1.png" alt="Jira 이슈 개발 패널에서 브랜치 만들기 버튼" style="width: 40%; display: block;margin-top: 20px; margin-bottom: 20px;">

1. 본인에게 할당된 Jira 티켓(예: `DK-12`) 상세 페이지로 들어갑니다.
2. 우측 **개발(Development)** 섹션에 있는 **[브랜치 만들기(Create branch)]** 링크를 클릭합니다.
3. GitHub 화면이 열리며 브랜치 이름이 `DK-12-이슈제목` 형식으로 자동 완성됩니다.
   *(Tip: 이슈 제목을 한글로 쓰면 브랜치명도 한글로 따라가기 때문에 이슈 제목을 영문으로, 설명을 한글로 쓰는 게 좋습니다.)*
<img src="/assets/img/jira-workflow/workflow_2.png" alt="브랜치 생성 화면" style="width: 40%; display: block;margin-top: 20px; margin-bottom: 20px;">
   <br>
4. 그대로 **Create**를 눌러주세요.
   👉 *(자동화 발동: Jira 티켓이 `진행 중`으로 자동 이동합니다!)*

### Step 2. 로컬 개발 및 커밋 - 자유롭게 💡

로컬로 해당 브랜치를 pull 받아 코드를 작성하고 커밋합니다.
이미 브랜치 이름에 이슈 키(`DK-12`)가 포함되어 있기 때문에, **일반 커밋 메시지에는 이슈 번호를 달지 않아도 Jira가 알아서 다 추적해 줍니다.** 자유롭게 커밋하셔도 됩니다!

다만, 나중에 터미널에서 `git log`만 보고 히스토리를 빠르게 파악하거나 중요 시점의 코드를 리뷰할 때를 대비해, 의미 있는 큰 커밋에는 적어주시는 것을 **권장**합니다.

```bash
# ⭕ 자유롭게 작성 (Jira가 브랜치명으로 알아서 묶어줌)
git commit -m "JWT 필터 기본 구조 잡기"

# 🌟 권장 (Git 히스토리 파악이 훨씬 쉬워짐)
git commit -m "[DK-12] JWT 발급 필터 및 예외 처리 구현 완료"
```
---
### 📊 최종 Workflow 요약
```bash
[Jira] 이슈 시작 
   │
   ▼ (브랜치 만들기 버튼 클릭)
[GitHub] 브랜치 생성  ━━━━▶  [Jira] 상태 변경: 진행 중 
   │
   ▼ (코드 작성 후 PR 날리기)
[GitHub] PR 리뷰 요청 ━━━━▶  [Jira] 상태 변경: 검토 중
   │
   ▼ (리뷰 완료 후 Merge)
[GitHub] 브랜치 닫힘  ━━━━▶  [Jira] 상태 변경: 완료 (티켓 닫힘)
```
---

### 🗑️ GitHub 머지 후 브랜치 자동 삭제 설정법
해당 레포지토리의 Admin(관리자) 권한이 있는 분이 세팅할 수 있습니다.

1. GitHub 레포지토리 이동: DEKK 프로젝트의 GitHub 저장소로 들어갑니다.
Settings 탭 클릭: 상단 메뉴 가장 우측에 있는 톱니바퀴 모양의 **[Settings]**를 누릅니다.
<img src="/assets/img/jira-workflow/close-branch1.png" alt="settings" style="width: 60%; display: block; margin-top: 20px; margin-bottom:0px;">
<br>
2. General 메뉴 확인: 좌측 메뉴에서 General이 선택되어 있는지 확인하고 스크롤을 중간쯤 내립니다.
Pull Requests 섹션 찾기: 여러 체크박스들이 모여있는 곳에서 Automatically delete head branches (헤드 브랜치 자동 삭제) 옵션을 찾아 체크(✅) 합니다.
<img src="/assets/img/jira-workflow/close-branch2.png" alt="close branch" style="width: 40%; display: block; margin-top: 20px; margin-bottom: 20px;">
<br>
