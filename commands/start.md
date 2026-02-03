---
description: "Task를 시작하고 TDD 사이클을 실행합니다 (RED → GREEN → REFACTOR)"
argument-hint: "<task-id>"
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - AskUserQuestion
  - Task
  - TaskCreate
  - TaskGet
  - TaskUpdate
  - TaskList
---

# /afk:start <task-id>

Task를 시작하고 **자동 TDD 사이클**을 실행합니다.

## 전제 조건

1. `.afk-mod/state.json`이 존재해야 합니다
2. `workflow`가 `ready_to_develop` 또는 `task_in_progress`여야 합니다
3. `<task-id>`가 `.afk-mod/tasks/`에 존재해야 합니다

전제 조건이 충족되지 않으면 사용자에게 안내하세요.

---

## 1단계: Task 확인

1. `.afk-mod/tasks/task-groups.json`을 읽어서 `<task-id>`가 속한 그룹을 찾습니다
2. 해당 그룹의 JSON 파일을 읽어서 Task 상세 정보를 가져옵니다
3. Task의 `blockedBy`를 확인하여 선행 Task가 완료되었는지 검증합니다

선행 Task가 완료되지 않았으면:

````
⚠️ 이 Task를 시작할 수 없습니다.

## 선행 Task 미완료

Task 1.1.3는 다음 Task가 완료되어야 시작할 수 있습니다:
- Task 1.1.1 (완료 ✅)
- Task 1.1.2 (미완료 ❌)

먼저 `/afk:start 1.1.2`를 실행하세요.
````

---

## 2단계: 재진입 감지

이미 진행 중인 Task를 다시 시작할 경우, 재진입 안내를 제공합니다.

### state.json 확인

```json
{
  "currentTask": "1.1.1",
  "tasks": {
    "1.1.1": {
      "status": "in_progress",
      "tdd": {
        "red": { "status": "completed" },
        "green": { "status": "completed" },
        "refactor": { "status": "in_progress" }
      }
    }
  }
}
```

### 재진입 메시지

````text
⚠️ 이 Task는 이미 진행 중입니다.

## 현재 상태

### Task 1.1.1: 로그인 폼 UI 구현
- 그룹: tg-1.1-auth (인증 시스템)
- 예상 시간: 30m
- 마지막 작업: 2025-02-03 10:35

### TDD 사이클 상태
✅ RED    → 테스트 작성 완료
✅ GREEN  → 최소 구현 완료
🔄 REFACTOR → 코드 정리 진행 중

### 마지막 작업
- 타입 정의 추가
- 검증 로직 분리

---

어디서부터 다시 시작할까요?
1. 중단된 지점부터 계속 (REFACTOR 완료)
2. 처음부터 다시 시작 (기존 작업 초기화)
3. 상태만 보기
4. 취소
````

### 재진입 옵션별 동작

#### 옵션 1: 중단된 지점부터 계속

```
사용자> 1

중단된 지점부터 다시 시작합니다.

[해당 TDD Phase 재개]
- RED 진행중 → 테스트 작성 재개
- GREEN 진행중 → 구현 재개
- REFACTOR 진행중 → 코드 정리 재개
```

#### 옵션 2: 처음부터 다시 시작

```
사용자> 2

정말 처음부터 다시 시작하시겠습니까?

⚠️ 주의: 다음 작업이 초기화됩니다.
- 생성된 테스트 파일
- 구현된 코드
- Task 진행 상태

정말 다시 시작하시겠습니까?
1. 예 (모두 초기화)
2. 아니오 (취소)
```

#### 옵션 3: 상태만 보기

```
사용자> 3

## Task 1.1.1 상태

### 기본 정보
- ID: 1.1.1
- 제목: 로그인 폼 UI 구현
- 그룹: tg-1.1-auth (인증 시스템)
- 예상 시간: 30m

### TDD 진행 상황
| 단계 | 상태 | 파일 |
|------|------|------|
| RED | ✅ 완료 | LoginForm.test.tsx |
| GREEN | ✅ 완료 | LoginForm.tsx |
| REFACTOR | 🔄 진행중 | - |

### 다음 단계
REFACTOR 단계를 완료하세요.
```

#### 옵션 4: 취소

```
사용자> 4

취소했습니다.

다음 명령어를 사용할 수 있습니다:
- /afk:checkin - 현재 상황 다시 확인
- /afk:task - 전체 Task 목록 보기
```

---

## 3단계: TDD 사이클 시작

새 Task를 시작할 때 TDD 사이클을 실행합니다.

### RED 단계: 테스트 작성

````text
## Task 1.1.1: 로그인 폼 UI 구현

### TDD 사이클 시작...

---

### RED 단계: 테스트 작성

테스트 케이스 정의:
- 이메일 입력 필드 렌더링
- 비밀번호 입력 필드 렌더링 (type="password")
- 로그인 버튼 렌더링
- 이메일 유효성 검사
- 빈 입력 시 버튼 비활성화

`src/components/__tests__/LoginForm.test.tsx` 생성 완료

테스트 실행 결과:
```
FAIL src/components/__tests__/LoginForm.test.tsx
  ✓ should render email input field
  ✓ should render password input field
  ✗ should render login button
    ReferenceError: LoginForm is not defined
  ✗ should validate email format
    ReferenceError: LoginForm is not defined
```

✓ **RED 단계 완료**: 테스트가 예상대로 실패했습니다.
````

### state.json 업데이트 (RED 완료)

```json
{
  "currentTask": "1.1.1",
  "tasks": {
    "1.1.1": {
      "status": "in_progress",
      "groupId": "tg-1.1-auth",
      "tdd": {
        "red": {
          "status": "completed",
          "testFile": "src/components/__tests__/LoginForm.test.tsx",
          "completedAt": "2025-02-03T10:30:00Z"
        },
        "green": { "status": "pending" },
        "refactor": { "status": "pending" }
      }
    }
  }
}
```

---

### GREEN 단계: 최소 구현

````text
### GREEN 단계: 최소 구현

테스트 실패 분석:
- `LoginForm` 컴포넌트가 정의되지 않음

`src/components/LoginForm.tsx` 생성 완료

테스트 실행 결과:
```
PASS src/components/__tests__/LoginForm.test.tsx
  ✓ should render email input field
  ✓ should render password input field
  ✓ should render login button
  ✓ should validate email format
  ✓ should disable button when inputs are empty
```

✓ **GREEN 단계 완료**: 모든 테스트 통과
````

### state.json 업데이트 (GREEN 완료)

```json
{
  "currentTask": "1.1.1",
  "tasks": {
    "1.1.1": {
      "status": "in_progress",
      "groupId": "tg-1.1-auth",
      "tdd": {
        "red": { "status": "completed" },
        "green": {
          "status": "completed",
          "implFile": "src/components/LoginForm.tsx",
          "completedAt": "2025-02-03T10:32:00Z"
        },
        "refactor": { "status": "in_progress" }
      }
    }
  }
}
```

---

### REFACTOR 단계: 코드 정리

````text
### REFACTOR 단계: 코드 정리

리팩토링 항목:
1. 타입 정의 추가 (`LoginFormProps`, `LoginFormValues`)
2. 이벤트 핸들러 분리
3. 스타일을 별도 파일로 분리
4. 유효성 검사 로직 분리

테스트 실행 결과:
```
PASS src/components/__tests__/LoginForm.test.tsx
  ✓ should render email input field
  ✓ should render password input field
  ✓ should render login button
  ✓ should validate email format
  ✓ should disable button when inputs are empty
```

✓ **REFACTOR 단계 완료**: 테스트 통과 유지
````

### state.json 업데이트 (REFACTOR 완료)

```json
{
  "currentTask": null,
  "workflow": "task_in_progress",
  "tasks": {
    "1.1.1": {
      "status": "completed",
      "groupId": "tg-1.1-auth",
      "tdd": {
        "red": { "status": "completed" },
        "green": { "status": "completed" },
        "refactor": {
          "status": "completed",
          "completedAt": "2025-02-03T10:35:00Z"
        }
      }
    },
    "1.1.2": { "status": "pending", "groupId": "tg-1.1-auth" }
  }
}
```

---

## 4단계: Task 완료

````text
## Task 1.1.1 완료

TDD 사이클이 완료되었습니다.

### 생성된 파일
- `src/components/__tests__/LoginForm.test.tsx` (테스트)
- `src/components/LoginForm.tsx` (구현)
- `src/components/LoginForm.module.css` (스타일)
- `src/types/LoginForm.ts` (타입 정의)

### 완료 시간
30분 (예상: 30m)

### 다음 Task로 넘어갈까요?
다음 완료 가능한 Task:
- Task 1.1.2: 로그인 API 엔드포인트 구현 (의존성 없음)
- Task 1.1.3: 로그인 폼과 API 연결 (1.1.1, 1.1.2 필요)

1. 다음 Task 자동 시작 (1.1.2)
2. 수동으로 Task 선택 (/afk:task)
3. 멈춤
````

---

## Agent 호출

TDD 사이클 각 단계에서 적절한 에이전트를 호출합니다:

- **RED**: `test-writer` 에이전트로 테스트 작성
- **GREEN**: `implementer` 에이전트로 최소 구현
- **REFACTOR**: `implementer` 에이전트로 코드 정리

---

## Human-in-the-Loop

- **TDD 사이클 내**: 자동 진행 (RED → GREEN → REFACTOR)
- **Task 완료 후**: 다음 Task 진행 여부 확인
