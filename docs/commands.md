# 명령어 상세 가이드

AFK-Mod의 모든 명령어와 사용 방법을 상세히 설명합니다.

## 명령어 개요

```mermaid
flowchart TD
    A[AFK-Mod 명령어] --> B[설계]
    A --> C[Feature 관리]
    A --> D[개발]
    A --> E[유지보수]

    B --> B1[afk_design]

    C --> C1[afk_feature_list]
    C --> C2[afk_reload]
    C --> C3[afk_extract]

    D --> D1[afk_checkin]
    D --> D2[afk_research]
    D --> D3[afk_start]
    D --> D4[afk_task]

    E --> E1[afk_reload]
```

## afk_design

프로젝트 설계를 수행하는 첫 번째 명령어입니다.

### 동작 흐름

```mermaid
flowchart TD
    A[afk_design 호출] --> B{Feature List<br/>존재?}
    B -->|아니오| C[대화형 생성 안내]
    C --> D[Feature List 생성]
    D --> E

    B -->|예| E{project_design_json<br/>존재?}
    E -->|예| F[기존 설계 표시]
    E -->|아니오| G[Feature List 분석]

    F --> H{수정할까요?}
    H -->|예| G
    H -->|아니오| I[종료]

    G --> J[카테고리 분석]
    J --> K[아키텍처 제안]
    K --> L[기술 스택 결정]
    L --> M[승인]
    M --> N[project_design_json 저장]
    N --> O[state.json 업데이트]
```

### 사용 예시

```
afk_design
```

### 옵션

| 옵션 | 설명 |
|------|------|
| `--file=<path>` | 특정 Feature List 파일 지정 |

---

## afk_feature_list

Feature 목록과 진척도를 표시합니다.

### 동작 흐름

```mermaid
flowchart TD
    A[afk_feature_list 호출] --> B{프로젝트 설계<br/>완료?}
    B -->|아니오| C[에러 메시지]
    B -->|예| D[feature_list_json 로드]

    D --> E[state.json 로드]
    E --> F[Markdown 표 생성]

    F --> G{필터 옵션?}
    G -->|status| H[상태 필터링]
    G -->|parent| I[부모 필터링]
    G -->|sort| J[정렬]

    H --> K[결과 표시]
    I --> K
    J --> K
```

### 출력 형식

```
# Feature List

| ID | Title | Parent | Status | Progress |
|----|-------|--------|--------|----------|
| 1 | 이슈 관리 | - | PENDING | 0% |
| 1.1 | 이슈 CRUD | 1 | IN_PROGRESS | 80% |
| 1.1.1 | 이슈 생성 | 1.1 | DONE | 100% |
```

### 옵션

| 옵션 | 설명 | 예시 |
|------|------|------|
| `--status` | 특정 상태만 표시 | `--status=IN_PROGRESS` |
| `--parent` | 특정 부모 하위만 표시 | `--parent=1` |
| `--sort` | 정렬 기준 | `--sort=progress` |

---

## afk_research

**STAGE 2: RESEARCH** - Feature 구현을 위한 프로젝트 구조와 기존 코드 패턴을 분석합니다.

### 동작 흐름

```mermaid
flowchart TD
    A[afk_research <feature-id>] --> B{프로젝트 설계<br/>완료?}
    B -->|아니오| C[에러 메시지]
    B -->|예| D[Feature 확인]

    D --> E[Researcher Agent 호출]
    E --> F[프로젝트 구조 분석]
    F --> G[기존 코드 패턴 분석]
    G --> H[의존성 확인]
    H --> I[구현 난이도 평가]
    I --> J[추천 접근 방식 제시]
    J --> K[리서치 보고서 출력]
```

### 사용 예시

```
afk_research 1.1.1
```

### 출력 형식

```
## STAGE 2: RESEARCH

### 프로젝트 구조 분석
#### 현재 파일 구조
web/
├── src/
│   ├── components/
│   │   ├── IssueForm.tsx
│   │   └── IssueList.tsx
│   ├── services/
│   │   └── IssueService.ts
│   └── types/
│       └── Issue.ts

### 기존 코드 패턴 분석
#### Service Layer 패턴
- API 호출은 Service 클래스에서 담당
- 에러 처리: ValidationError 커스텀 클래스

### 의존성 확인
- Frontend: React, Vite, shadcn/ui, React Query
- Backend: FastAPI, SQLAlchemy, PostgreSQL

### 구현 난이도 평가
- 복잡도: 중간
- 예상 소요 시간: 2시간

### 추천 접근 방식
1. 기존 IssueService 확장
2. 테스트는 __tests__/에 작성
3. API 엔드포인트는 api/app/api/issues/에 추가

✅ Research 완료. 이제 /afk:start 1.1.1로 TDD를 시작하세요.
```

### 옵션

| 옵션 | 설명 |
|------|------|
| `--depth=quick` | 빠른 분석 (파일 구조만) |
| `--depth=full` | 상세 분석 (코드 패턴 포함) |

---

## afk_checkin

**중단된 작업을 다시 시작할 때 현재 상황을 파악하고 다음 단계를 안내합니다.**

### 동작 흐름

```mermaid
flowchart TD
    A[afk_checkin 호출] --> B{state.json<br/>존재?}
    B -->|아니오| C[새로 시작 안내]
    C --> D["/afk:start로<br/>Feature 시작"]

    B -->|예| E[현재 상태 로드]
    E --> F[currentFeature 확인]
    F --> G{currentTask<br/>있음?}

    G -->|아니오| H[Feature 시작 전 안내]
    H --> I["/afk:research 권장"]

    G -->|예| J[TDD Phase 확인]
    J --> K{Phase 상태}

    K -->|RED| L[테스트 작성 재개 안내]
    K -->|GREEN| M[구현 재개 안내]
    K -->|REFACTOR| N[코드 정리 재개 안내]
    K -->|완료| O[다음 Task 안내]

    L --> P[다음 단계 옵션]
    M --> P
    N --> P
    O --> P
```

### 사용 예시

```
afk_checkin
```

### 출력 형식

```
## 📊 현재 작업 중

### Feature 1.1.1: 이슈 생성

#### 진행 중인 Task
**Task 1**: 이슈 생성 기능 구현
상태: 🔄 REFACTOR 진행 중

#### TDD 사이클 상태
\```
✅ RED    → 테스트 작성 완료 (10:30)
✅ GREEN  → 최소 구현 완료 (10:32)
🔄 REFACTOR → 코드 정리 진행 중
\```
````

#### 마지막 작업 내역
- 타입 정의 추가
- 검증 로직 분리

---

## 🚀 다음 단계

REFACTOR 단계를 완료하고 다음 Task로 넘어갈까요?

1. **계속하기** - REFACTOR 완료 후 Task 2로 진행
2. **검토하기** - 현재 코드 먼저 검토
3. **상태보기** - 전체 Task 목록 보기 (/afk:task)
```

### TDD Phase별 체크인 메시지

| Phase | 메시지 |
|-------|--------|
| RED 진행 중 | 테스트 케이스 작성 중, 완료되지 않은 테스트 N개 |
| GREEN 진행 중 | 최소 구현 작성 중, 실패한 테스트 N개 |
| REFACTOR 진행 중 | 코드 정리 중, 완료된 리팩토링 N/M |
| Task 완료 | Task 완료! 다음 Task로 넘어갈 준비 |
| Feature 시작 전 | Research 권장, /afk:start로 시작 가능 |

### /afk:task와의 차이점

| 특징 | /afk:checkin | /afk:task |
|------|--------------|-----------|
| 목적 | 중단 후 재개 시 상태 파악 | 전체 Task 목록 및 상태 관리 |
| 출력 | 사용자 친화적 요약 | 기술적 상세 정보 |
| 다음 단계 | 명확한 안내 및 옵션 | 상태 확인 후 수동 재개 |
| 사용 시점 | 세션 재시작 시 | 언제든지 |

---

## afk_start

Feature 개발을 시작하고 Task 분해를 수행합니다.

### 동작 흐름

```mermaid
flowchart TD
    A[afk_start <feature-id>] --> B{프로젝트 설계<br/>완료?}
    B -->|아니오| C[에러 메시지]
    B -->|예| D[Feature 확인]

    D --> E{이미 진행 중?}
    E -->|예| F[재진입 안내]
    F --> G{재시작 옵션}
    G -->|계속| H[중단된 지점부터 재개]
    G -->|다시 시작| I[초기화 후 처음부터]
    G -->|취소| J[종료]

    E -->|아니오| K{복잡도 판단}
    K -->|단순| L[즉시 Task 분해]
    K -->|복잡| M[에이전트 호출]

    L --> N[Task List 제안]
    M --> O[UX Designer 분석]
    O --> P[CTO 분석]
    P --> Q[Researcher 분석]
    Q --> R[종합 Task List 제안]

    N --> S{승인?}
    R --> S
    S -->|예| T[Task 저장]
    S -->|아니오| U[재제안]
    U --> S
```

### 사용 예시

```
afk_start 1.1.1
```

### 복잡도 판단 기준

| 조건 | 복잡도 |
|------|--------|
| 3개 이상 하위 Feature | 복잡 |
| 새로운 기술 도입 필요 | 복잡 |
| UI/UX 설계 필요 | 복잡 |
| 아키텍처 변경 필요 | 복잡 |
| 그 외 | 단순 |

---

## afk_task

현재 Feature의 Task 목록을 표시하고 관리합니다.

### 동작 흐름

```mermaid
flowchart TD
    A[afk_task 호출] --> B[현재 Feature 확인]
    B --> C[Task 파일 로드]

    C --> D[의존성 분석]
    D --> E[병렬 실행 가능 그룹 생성]

    E --> F{옵션?}
    F -->|status| G[상태 필터링]
    F -->|parallel| H[병렬 그룹 표시]
    F -->|set-status| I[상태 변경]

    G --> J[결과 표시]
    H --> J
    I --> K[state.json 업데이트]
```

### 출력 형식

```
# Feature 1.1.2: 이슈 목록 조회 - Task List

## 병렬 실행 가능한 Task 그룹 1
- [task-1] 🔵 pending: CSV 파싱 모듈 구현
- [task-2] 🔵 pending: UI 컴포넌트 기본 구조 생성

## 병렬 실행 가능한 Task 그룹 2 (task-1, task-2 완료 후)
- [task-3] ⚪ blocked: 필터/정렬 로직 구현 (blockedBy: task-1)

## 진척도: 20% (1/5 완료)
```

### 옵션

| 옵션 | 설명 | 예시 |
|------|------|------|
| `--status` | 특정 상태의 Task만 표시 | `--status=pending` |
| `--parallel` | 병렬 실행 가능한 그룹 표시 | `--parallel` |
| `--set-status` | Task 상태 변경 | `--set-status=task-1:completed` |

---

## afk_reload

Feature List 파일을 다시 읽어 상태를 갱신합니다.

### 동작 흐름

```mermaid
flowchart TD
    A[afk_reload 호출] --> B[feature_list_json 로드]
    B --> C[state.json 로드]

    C --> D[변경 감지]
    D --> E{변경 유형}

    E -->|추가| F[새 Feature 추가]
    E -->|변경| G[내용 갱신]
    E -->|삭제| H[archive 상태로 변경]

    F --> I[state.json 병합]
    G --> I
    H --> I

    I --> J[갱신 리포트]
```

### 사용 예시

```
afk_reload
```

### 옵션

| 옵션 | 설명 |
|------|------|
| `--path` | 다른 경로의 파일 지정 |

---

## afk_extract

기존 코드베이스를 분석하여 Feature List를 추출합니다.

### 동작 흐름

```mermaid
flowchart TD
    A[afk_extract 호출] --> B[파일 시스템 분석]
    B --> C[Git 히스토리 분석]

    C --> D{분석 깊이}
    D -->|quick| E[파일 시스템만]
    D -->|full| F[코드 내용 포함]

    E --> G[임시 Feature 매핑]
    F --> G

    G --> H[사용자 검증]
    H --> I{수정 필요?}
    I -->|예| J[피드백 반영]
    J --> H
    I -->|아니오| K[feature_list_json 저장]
```

### 사용 예시

```
afk_extract
```

### 옵션

| 옵션 | 설명 |
|------|------|
| `--depth=quick` | 빠른 분석 (파일 시스템만) |
| `--depth=full` | 상세 분석 (코드 내용 포함) |
| `--commits` | 분석할 커밋 수 지정 |

---

## 명령어 비교

```mermaid
graph LR
    A[명령어] --> B[목적]
    A --> C[입력]
    A --> D[출력]

    E[afk_design] --> E1[프로젝트 설계]
    E --> E2[Feature List]
    E --> E3[project_design_json]

    F[afk_feature_list] --> F1[Feature 조회]
    F --> F2[state.json]
    F --> F3[Markdown 표]

    G[afk_start] --> G1[개발 시작]
    G --> G2[Feature ID]
    G --> G3[Task 목록]

    H[afk_task] --> H1[Task 관리]
    H --> H2[현재 Feature]
    H --> H3[Task 상태]

    I[afk_reload] --> I1[상태 갱신]
    I --> I2[Feature List 파일]
    I --> I3[갱신 리포트]

    J[afk_extract] --> J1[Feature 추출]
    J --> J2[코드베이스]
    J --> J3[feature_list_json]
```
