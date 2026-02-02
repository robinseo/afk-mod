# /afk:checkin

> **NOTE**: 이 파일의 모든 예시 대화는 **Issue Tracker 프로젝트**를 기반으로 한 예시입니다.
> 실제 사용 시, 프로젝트의 도메인과 요구사항에 맞게 용어와 구조를 수정하여 적용하세요.

**중단된 작업을 다시 시작할 때 현재 상황을 파악하고 다음 단계를 안내합니다.**

## 동작

### 1단계: 상태 확인

**가장 먼저 `state.json`을 확인하여 현재 작업 상태를 파악합니다.**

```
클로드코드> 현재 작업 상황을 확인하겠습니다.

[state.json이 존재하지 않는 경우]

📋 현재 진행 중인 작업이 없습니다.

새로운 Feature를 시작하시려면:
1. `/afk:design` - 프로젝트 설계
2. `/afk:feature-list` - Feature 목록 확인
3. `/afk:start <feature-id>` - Feature 개발 시작

---

[state.json이 존재하는 경우]

👋 다시 오셨군요! 현재 작업 상황을 확인했습니다.
```

### 2단계: Feature 상태 확인

`state.json`의 `currentFeature`를 확인하여 현재 작업 중인 Feature를 표시합니다.

```
## 📊 현재 작업 중

### Feature 1.1.1: 이슈 생성

**상태**: IN_PROGRESS (60% 완료)
**시작일**: 2025-02-02 10:00
**마지막 작업**: 2025-02-02 10:35
```

### 3단계: Task 상태 확인

`state.json`의 `currentTask`와 `tddPhase`를 확인하여 현재 진행 중인 Task와 TDD 단계를 표시합니다.

````
#### 진행 중인 Task

**Task 1**: 이슈 생성 기능 구현
상태: 🔄 REFACTOR 진행 중

#### TDD 사이클 상태
```
✅ RED    → 테스트 작성 완료 (10:30)
✅ GREEN  → 최소 구현 완료 (10:32)
🔄 REFACTOR → 코드 정리 진행 중
```
````

### 4단계: 마지막 작업 내역

마지막으로 수행한 작업과 생성된 파일을 표시합니다.

```
#### 마지막 작업 내역
- 타입 정의 추가 (`CreateIssueInput`, `Issue`)
- 검증 로직을 별도 메서드로 분리
- `ValidationError` 커스텀 에러 클래스 사용

#### 생성된 파일
- `src/services/__tests__/IssueService.test.ts`
- `src/services/IssueService.ts`
- `src/types/Issue.ts`
```

### 5단계: 다음 단계 안내

현재 상태에 따라 다음에 해야 할 작업을 안내합니다.

```
## 🚀 다음 단계

### REFACTOR 단계 완료가 필요합니다.

남은 작업:
1. ID 생성 로직 분리
2. 불필요한 주석 제거
3. 메서드 순서 재정렬

완료 후 다음 Task로 넘어갈까요?

1. **계속하기** - REFACTOR 완료 후 Task 2로 진행
2. **검토하기** - 현재 코드 먼저 검토
3. **상태보기** - 전체 Task 목록 보기 (/afk:task)
4. **취소** - 나중에 다시 시작
```

## TDD Phase별 체크인 메시지

### RED 단계 진행 중

```
## 🚀 다음 단계

### RED 단계 진행 중입니다.

현재 작업:
- 테스트 케이스 작성 중
- 아직 완료되지 않은 테스트: 3개

다음 단계:
1. **계속하기** - 테스트 작성 완료
2. **상태보기** - 테스트 목록 확인
```

### GREEN 단계 진행 중

```
## 🚀 다음 단계

### GREEN 단계 진행 중입니다.

현재 작업:
- 최소 구현 작성 중
- 실패한 테스트: 2개

다음 단계:
1. **계속하기** - 구현 완료
2. **테스트 실행** - 현재 테스트 결과 확인
```

### REFACTOR 단계 진행 중

```
## 🚀 다음 단계

### REFACTOR 단계 진행 중입니다.

현재 작업:
- 코드 정리 중
- 완료된 리팩토링: 2/5

다음 단계:
1. **계속하기** - 리팩토링 완료
2. **테스트 실행** - 리팩토링 후 테스트 확인
```

### Task 완료 상태

````
## 🚀 다음 단계

### Task 1 완료! 축하합니다. 🎉

모든 TDD 단계가 완료되었습니다.
````
✅ RED 완료
✅ GREEN 완료
✅ REFACTOR 완료
````

다음으로 넘어갈 Task:
- **Task 2**: UI 폼 컴포넌트 생성 (pending)

1. **다음 Task 시작** - Task 2 시작
2. **전체 보기** - 모든 Task 목록 보기
````

### Feature 시작 전 상태

````
## 🚀 다음 단계

### Feature는 준비되었지만 아직 시작하지 않았습니다.

권장 순서:
1. `/afk:research 1.1.1` - 프로젝트 구조와 코드 패턴 분석
2. `/afk:start 1.1.1` - TDD 사이클 시작

1. **Research 시작** - /afk:research 실행
2. **바로 시작** - /afk:start 실행
3. **취소** - 나중에 시작
````

## state.json 스키마

```json
{
  "currentFeature": "1.1.1",
  "currentTask": "task-001",
  "tddPhase": "REFACTOR",
  "lastCheckpoint": {
    "timestamp": "2025-02-02T10:35:00Z",
    "message": "코드 정리 진행 중",
    "files": [
      "src/services/__tests__/IssueService.test.ts",
      "src/services/IssueService.ts"
    ]
  },
  "tasks": {
    "task-001": {
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

## 출력 형식 요약

````mermaid
flowchart TD
    A["/afk:checkin"] --> B{state.json<br/>존재?}
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
````

## 사용 예시

### 예시 1: REFACTOR 진행 중

````
사용자> /afk:checkin

클로드코드> 👋 다시 오셨군요! 현재 작업 상황을 확인하겠습니다.

---

## 📊 현재 작업 중

### Feature 1.1.1: 이슈 생성

#### 진행 중인 Task
**Task 1**: 이슈 생성 기능 구현
상태: 🔄 REFACTOR 진행 중

#### TDD 사이클 상태
```
✅ RED    → 테스트 작성 완료 (10:30)
✅ GREEN  → 최소 구현 완료 (10:32)
🔄 REFACTOR → 코드 정리 진행 중
```

#### 마지막 작업 내역
- 타입 정의 추가
- 검증 로직 분리

---

## 🚀 다음 단계

REFACTOR 단계를 완료하고 다음 Task로 넘어갈까요?

1. **계속하기** - REFACTOR 완료 후 Task 2로 진행
2. **검토하기** - 현재 코드 먼저 검토
3. **상태보기** - 전체 Task 목록 보기
````

### 예시 2: 새로운 세션 (진행 중인 작업 없음)

```
사용자> /afk:checkin

클로드코드> 현재 작업 상황을 확인하겠습니다.

---

📋 현재 진행 중인 작업이 없습니다.

새로운 Feature를 시작하시려면:
1. `/afk:design` - 프로젝트 설계
2. `/afk:feature-list` - Feature 목록 확인
3. `/afk:start <feature-id>` - Feature 개발 시작
```

### 예시 3: Task 완료 후

````
사용자> /afk:checkin

클로드코드> 👋 다시 오셨군요!

---

## 📊 현재 작업 중

### Feature 1.1.1: 이슈 생성

#### 최근 완료한 Task
✅ **Task 1**: 이슈 생성 기능 구현 (완료)

모든 TDD 단계 완료:
```
✅ RED 완료
✅ GREEN 완료
✅ REFACTOR 완료
```

---

## 🚀 다음 단계

### Task 1 완료! 축하합니다. 🎉

다음으로 넘어갈 Task:
- **Task 2**: UI 폼 컴포넌트 생성 (pending)

1. **다음 Task 시작** - Task 2 시작
2. **전체 보기** - 모든 Task 목록 보기
````

## Human-in-the-Loop

모든 단계에서 사용자가 명확한 선택지를 제공받습니다:

- **계속하기**: 중단된 지점부터 작업 재개
- **검토하기**: 현재 코드/상태 먼저 확인
- **상태보기**: `/afk:task`로 전체 상태 확인
- **취소**: 나중에 다시 시작

## /afk:task와의 차이점

| 특징 | /afk:checkin | /afk:task |
|------|--------------|-----------|
| 목적 | 중단 후 재개 시 상태 파악 | 전체 Task 목록 및 상태 관리 |
| 출력 | 사용자 친화적 요약 | 기술적 상세 정보 |
| 다음 단계 | 명확한 안내 및 옵션 | 상태 확인 후 수동 재개 |
| 사용 시점 | 세션 재시작 시 | 언제든지 |
