# 워크플로우 상세

AFK-Mod의 전체 개발 워크플로우를 상세히 설명합니다.

## 6단계 TDD 워크플로우

AFK-Mod는 6단계 TDD 워크플로우를 따릅니다:

```mermaid
flowchart TD
    A["STAGE 1: Feature Refinement<br/>/afk:design"] --> B["STAGE 2: Research<br/>/afk:research"]
    B --> C["STAGE 3: Architecture Design<br/>/afk:design"]
    C --> D["STAGE 4: RED<br/>Test Writer"]
    D --> E["STAGE 5: GREEN<br/>Implementer"]
    E --> F["STAGE 6: Test Verification<br/>All Green Check"]
    F --> G[WORKFLOW COMPLETE]

    style A fill:#e1f5fe
    style B fill:#fff3e0
    style C fill:#f3e5f5
    style D fill:#ffebee
    style E fill:#e8f5e9
    style F fill:#e0f2f1
    style G fill:#c8e6c9
```

### STAGE 1: Feature Refinement

**명령어**: `/afk:design`

**Input**: 원본 요구사항
**Output**: 수락기준(AC) 포함 피처 명세서
**Gate**: 사용자 승인 필요

```
사용자> /afk:design

클로드코드> Feature 1.1.1: 이슈 생성

## 수락기준 (Acceptance Criteria)
AC1: 사용자는 제목, 설명, 우선순위, 담당자를 입력하여 이슈를 생성할 수 있다
AC2: 제목이 비어있으면 ValidationError가 발생한다
AC3: 설명이 비어있으면 ValidationError가 발생한다

승인하시겠습니까?
1. Accept
2. Decline
```

### STAGE 2: Research

**명령어**: `/afk:research <feature-id>`

**Output**: 리서치 보고서
- 프로젝트 구조 파악
- 기존 코드 패턴 분석
- 의존성 및 기술 스택 확인
- 구현 난이도 평가

```
사용자> /afk:research 1.1.1

클로드코드> ## STAGE 2: RESEARCH

### 프로젝트 구조 분석
- 현재 파일: web/src/services/, api/app/api/
- 관련 컴포넌트: IssueForm, IssueList, IssueService

### 기존 코드 패턴
- Service Layer: API 호출은 Service 클래스에서 담당
- State: React Query로 서버 상태 관리
- Error: ValidationError 커스텀 클래스 사용
- Testing: Vitest (Frontend), Pytest (Backend)

### 구현 난이도 평가
- 복잡도: 중간
- 예상 소요 시간: 2시간
- 선행 작업: 없음

### 추천 접근 방식
1. 기존 IssueService 확장
2. 테스트는 web/src/services/__tests__/에 작성
3. API 엔드포인트는 api/app/api/issues/에 추가

✅ Research 완료. 이제 /afk:start 1.1.1로 TDD를 시작하세요.
```

### STAGE 3: Architecture Design

**명령어**: `/afk:design`

**Output**: 2~4개 아키텍처 옵션
- 각 옵션별 장단점
- 비교 매트릭스
- 추천 옵션

**Gate**: 사용자 아키텍처 선택

```
사용자> /afk:design

클로드코드> ## 아키텍처 옵션

### Option 1: 2-tier (Frontend + Backend + Database)
- 장점: 관리 용이, 팀 분업 용이
- 단점: 네트워크 지연

### Option 2: 1-tier (Frontend only + Local Storage)
- 장점: 빠른 프로토타이핑
- 단점: 확장성 제한

### Option 3: 3-tier (Frontend + API Gateway + Backend + Database)
- 장점: 확장성, 보안
- 단점: 복잡도 증가

어떤 아키텍처를 선택하시겠습니까?
```

### STAGE 4: TEST CASE (RED Phase)

**명령어**: `/afk:start <feature-id>`

- 구현 전에 테스트 먼저 작성
- 모든 테스트가 실패해야 함 (RED)

```
클로드코드> ## RED 단계: 테스트 작성

Test Writer Agent가 테스트를 작성합니다.

테스트 케이스 정의:
- 정상 입력으로 이슈 생성 성공
- 빈 제목으로 이슈 생성 시도 → ValidationError
- 빈 설명으로 이슈 생성 시도 → ValidationError

`src/services/__tests__/IssueService.test.ts` 생성 완료

테스트 실행 결과:
\```
FAIL src/services/__tests__/IssueService.test.ts
  IssueService.createIssue
    ✗ should create an issue with valid input
      ReferenceError: IssueService is not defined
\```

✓ RED 단계 완료: 테스트가 예상대로 실패했습니다.
```

### STAGE 5: IMPLEMENTATION (GREEN Phase)

**명령어**: `/afk:start <feature-id>` (자동 진행)

- 테스트를 통과시키는 최소한의 코드 작성
- 점진적 구현

```
클로드코드> ## GREEN 단계: 최소 구현

Implementer Agent가 최소 구현을 작성합니다.

테스트 실행 결과:
\```
PASS src/services/__tests__/IssueService.test.ts
  ✓ should create an issue with valid input
  ✓ should throw error when title is empty
  ✓ should throw error when title contains only whitespace
  ✓ should throw error when description is empty
\```

✓ GREEN 단계 완료: 모든 테스트 통과
```

### STAGE 6: TEST VERIFICATION

**명령어**: `/afk:start <feature-id>` (자동 진행)

- 전체 테스트 스위트 실행
- ALL GREEN 확인
- 실패 시 Stage 5로 회귀 (최대 3회)

```
클로드코드> ## TEST VERIFICATION

전체 테스트 스위트 실행 결과:
\```
PASS src/services/__tests__/IssueService.test.ts
PASS src/components/__tests__/IssueForm.test.ts
PASS api/tests/test_issues.py

All tests passed! (15/15)
\```

✓ TEST VERIFICATION 완료: ALL GREEN 확인
```

### Human-in-the-Loop 지점

```
AFK-Mod 6단계 워크플로우:
1. AC 승인 (/afk:design) ✓
2. Research 완료 (/afk:research) ✓
3. 아키텍처 선택 (/afk:design) ✓
4. RED → GREEN → REFACTOR (자동 진행)
5. Task 완료 승인 (/afk:start) ✓
```

## 전체 워크플로우

```mermaid
flowchart TD
    A[시작] --> B[설치 및 설정]
    B --> C[Feature List 준비]

    C --> D["afk:design<br/>STAGE 1: Feature Refinement"]
    D --> E[AC 포함 피처 명세서]
    E --> F["afk:design<br/>STAGE 3: Architecture Design"]
    F --> G[project_design_json 생성]

    G --> H{개발 시작}
    H --> I["afk:research<br/>STAGE 2: Research"]
    I --> J[리서치 보고서]

    J --> K["afk:start<br/>STAGE 4: RED"]
    K --> L["afk:start<br/>STAGE 5: GREEN"]
    L --> M["afk:start<br/>STAGE 6: Test Verification"]

    M --> N{완료?}
    N -->|아니오| L
    N -->|예| O{다음 Feature?}

    O -->|예| H
    O -->|아니오| P[완료]

    G -.->|Feature 변경| Q{"afk:reload<br/>갱신"}
    Q --> H
```

## Phase 1: 준비 단계

```mermaid
flowchart TD
    A[Phase 1: 준비] --> B[플러그인 설치]
    B --> C[Feature List 준비]

    C --> D{준비 방법}
    D -->|CSV| E[feature_list_csv]
    D -->|JSON| F[feature_list_json]
    D -->|대화형| G[afk_design]

    E --> H[afk_design]
    F --> H
    G --> H
```

### 1.1 플러그인 설치

```mermaid
sequenceDiagram
    participant U as 사용자
    participant R as 저장소
    participant P as 프로젝트
    participant C as Claude Code

    U->>R: AFK-Mod 복사
    R->>P: .claude-plugin/ 복사
    U->>P: commands/ 복사
    U->>P: agents/ 복사
    P->>C: 플러그인 로드
    C-->>U: 설치 완료
```

### 1.2 Feature List 준비

```mermaid
flowchart LR
    subgraph CSV 방식
        A1[기존 CSV] --> B1[afk_mod_dir 복사]
        B1 --> C1[afk_design]
        C1 --> D1[자동 JSON 변환]
    end

    subgraph JSON 방식
        A2[기존 JSON] --> B2[afk_mod_dir 복사]
        B2 --> C2[afk_design]
    end

    subgraph 대화형 방식
        A3[afk_design] --> B3[클로드코드와 대화]
        B3 --> C3[feature_list_json 생성]
    end
```

## Phase 2: 설계 단계

```mermaid
flowchart TD
    A[Phase 2: 설계] --> B[afk_design 실행]

    B --> C[Feature List 분석]
    C --> D[카테고리 파악]
    D --> E[기능적 요구사항 추론]

    E --> F[아키텍처 결정]
    F --> F1[2-tier]
    F --> F2[1-tier]
    F --> F3[3-tier]

    F1 --> G[기술 스택 결정]
    F2 --> G
    F3 --> G

    G --> H[Frontend 기술]
    G --> I[Backend 기술]

    H --> J[UI 라이브러리]
    I --> K[Database 선택]

    J --> L[최종 설계 문서]
    K --> L

    L --> M{승인?}
    M -->|아니오| G
    M -->|예| N[project_design_json 저장]
```

### 2.1 설계 프로세스 상세

```mermaid
stateDiagram-v2
    [*] --> Feature분석: afk_design
    Feature분석 --> 카테고리파악
    카테고리파악 --> 요구사항추론

    요구사항추론 --> 아키텍처제안
    아키텍처제안 --> 사용자선택: 2-tier/1-tier/3-tier

    사용자선택 --> Frontend기술
    Frontend기술 --> UI라이브러리

    사용자선택 --> Backend기술
    Backend기술 --> Database

    UI라이브러리 --> 설계승인
    Database --> 설계승인

    설계승인 --> 저장: Accept
    설계승인 --> Frontend기술: Decline

    저장 --> [*]: project_design_json
```

## Phase 3: 개발 단계 (6단계 TDD 워크플로우)

```mermaid
flowchart TD
    A[Phase 3: 개발] --> B[Feature 선택]

    B --> C["STAGE 2: Research<br/>/afk:research"]
    C --> D[리서치 보고서]

    D --> E["STAGE 4: RED<br/>/afk:start"]
    E --> F["STAGE 5: GREEN<br/>/afk:start"]
    F --> G["STAGE 6: Test Verification<br/>/afk:start"]

    G --> H{완료?}
    H -->|진행중| F
    H -->|완료| I{다음 Task?}

    I -->|예| E
    I -->|아니오| J[Feature 완료]
```

### 3.1 단순 Feature vs 복잡 Feature

```mermaid
graph TD
    A[Feature 시작] --> B{복잡도 판단}

    B -->|단순| C[즉시 Task 분해]
    C --> D[Task List 제안]
    D --> E[승인 후 저장]

    B -->|복잡| F[에이전트 호출]

    F --> G[UX Designer]
    F --> H[CTO]
    F --> I[Researcher]

    G --> J[사용자 흐름 설계]
    H --> K[아키텍처 설계]
    I --> L[기술 리서치]

    J --> M[종합 분석]
    K --> M
    L --> M

    M --> N[Task List 제안]
    N --> O[승인 후 저장]
```

### 3.2 Task 실행 흐름

```mermaid
flowchart LR
    A[Task List] --> B[의존성 분석]
    B --> C[병렬 그룹 생성]

    C --> D[그룹 1<br/>실행 가능]
    C --> E[그룹 2<br/>blockedBy 그룹1]
    C --> F[그룹 3<br/>blockedBy 그룹2]

    D --> G[병렬 실행]
    G --> H[그룹 1 완료]

    H --> E
    E --> I[그룹 2 실행]
    I --> J[그룹 2 완료]

    J --> F
    F --> K[그룹 3 실행]
    K --> L[모두 완료]
```

## Phase 4: 관리 단계

```mermaid
flowchart TD
    A[Phase 4: 관리] --> B{관리 작업}

    B -->|Feature 조회| C[afk_feature_list]
    B -->|상태 갱신| D[afk_reload]
    B -->|Task 관리| E[afk_task]
    B -->|Feature 추출| F[afk_extract]

    C --> G[Markdown 표 표시]
    D --> H[feature_list_json 재로드]
    E --> I[Task 상태 관리]
    F --> J[코드베이스 분석]
```

## 반복 워크플로우

```mermaid
flowchart LR
    A[Feature 완료] --> B{다음 Feature?}
    B -->|예| C["/afk:research"]
    B -->|아니오| D[완료]

    C --> E["/afk:start"]
    E --> F["STAGE 4~6 TDD 사이클"]

    F -.->|중단| G["/afk:checkin"]
    G --> F

    F -.->|Feature 변경| H["/afk:reload"]
    H --> C
```

## 에이전트 협업 워크플로우

6단계 TDD 워크플로우에서 에이전트 간 협업 흐름입니다.

```mermaid
sequenceDiagram
    participant U as 사용자
    participant C as Claude Code
    participant R as Researcher
    participant TW as Test Writer
    participant IMP as Implementer

    U->>C: /afk:research <feature-id>
    C->>R: STAGE 2 Research 요청
    R-->>C: 리서치 보고서
    C-->>U: Research 완료

    U->>C: /afk:start <feature-id>

    C->>TW: STAGE 4 RED 시작
    TW->>TW: 테스트 작성
    TW-->>C: RED 완료 (테스트 실패)

    C->>IMP: STAGE 5 GREEN 시작
    IMP->>IMP: 최소 구현
    IMP-->>C: GREEN 완료 (테스트 통과)

    C->>IMP: STAGE 6 Test Verification
    IMP->>IMP: 전체 테스트 실행
    IMP-->>C: ALL GREEN 확인
    C-->>U: Feature 완료
```

## 상태 관리 워크플로우

```mermaid
stateDiagram-v2
    [*] --> STAGE1: Feature 생성
    STAGE1 --> STAGE3: AC 승인 완료

    STAGE3 --> STAGE2: 아키텍처 선택 완료
    STAGE2 --> STAGE4: Research 완료

    STAGE4 --> STAGE5: RED 완료
    STAGE5 --> STAGE6: GREEN 완료

    STAGE6 --> STAGE6: Test 재실행 (실패 시)
    STAGE6 --> DONE: ALL GREEN

    DONE --> [*]

    note right of STAGE1
        /afk:design
        Feature Refinement
    end note

    note right of STAGE2
        /afk:research
        Research
    end note

    note right of STAGE3
        /afk:design
        Architecture Design
    end note

    note right of STAGE4
        /afk:start
        RED (Test Writer)
    end note

    note right of STAGE5
        /afk:start
        GREEN (Implementer)
    end note

    note right of STAGE6
        /afk:start
        Test Verification
    end note
```

## 세션 재개 워크플로우

사용자가 중간에 작업을 중단했다가 다시 돌아왔을 때의 워크플로우입니다.

```mermaid
flowchart TD
    A[세션 재개] --> B["/afk:checkin 호출"]
    B --> C{state.json<br/>존재?}

    C -->|아니오| D[새로 시작 안내]
    D --> E["/afk:design 또는<br/>/afk:start"]

    C -->|예| F[현재 상태 로드]
    F --> G[currentFeature 확인]
    G --> H{currentTask<br/>있음?}

    H -->|아니오| I[Feature 시작 전]
    I --> J["/afk:research 권장"]

    H -->|예| K[TDD Phase 확인]
    K --> L{Phase 상태}

    L -->|RED 진행중| M[테스트 작성 재개]
    L -->|GREEN 진행중| N[구현 재개]
    L -->|REFACTOR 진행중| O[코드 정리 재개]
    L -->|완료됨| P[다음 Task 안내]

    M --> Q[재개 옵션 제시]
    N --> Q
    O --> Q
    P --> Q
```

### /afk:checkin 사용 시나리오

```
[첫 번째 세션 - 작업 진행 중]
사용자> /afk:start 1.1.1
... TDD 사이클 진행 ...
[중단 - 작업 중이던 REFACTOR 단계]

[두 번째 세션 - 재접속 후]
사용자> /afk:checkin

클로드코드> 👋 다시 오셨군요!

## 📊 현재 작업 중
### Feature 1.1.1: 이슈 생성
**Task 1**: REFACTOR 진행 중

## 🚀 다음 단계
1. 계속하기 - REFACTOR 완료
2. 검토하기 - 현재 코드 확인
```

### /afk:start 재진입 감지

```
사용자> /afk:start 1.1.1

클로드코드> ⚠️ 이 Feature는 이미 진행 중입니다.

## 현재 상태
- Task 1: REFACTOR 단계 진행 중
- 마지막 작업: 코드 정리 진행

어디서부터 다시 시작할까요?
1. 중단된 지점부터 계속
2. 처음부터 다시 시작
3. 취소
```

