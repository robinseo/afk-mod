# /afk:task

현재 Feature의 Task List를 표시하고 관리합니다. **TDD 단계별 상태**를 포함합니다.

## 동작

1. 현재 활성화된 Feature를 확인합니다 (`.afk-mod/state.json`에서 `currentFeature`)
2. 현재 TDD 단계를 확인합니다 (`currentTask`, `tddPhase`)
3. 해당 Feature의 Task 목록을 `.afk-mod/features/{feature-id}/tasks/`에서 읽습니다
4. Task 목록을 다음 정보와 함께 표시합니다:
   - Task ID
   - Task 설명
   - 상태 (pending, in_progress, completed, blocked)
   - **TDD 단계별 상태** (red, green, refactor)
   - 의존성 (blockedBy)
   - 병렬 실행 가능한 Task 그룹

## Task 관리

- `/afk:task` - 현재 Task List 표시
- `/afk:task --status=pending` - 특정 상태의 Task만 표시
- `/afk:task --parallel` - 병렬 실행 가능한 Task 그룹핑 표시
- `/afk:task --set-status=<task-id>:completed` - Task 상태 변경
- `/afk:task --continue` - TDD 사이클 재개

## 출력 형식

```markdown
# Feature 1.1.1: 이슈 생성 - Task List

## 현재 작업 중

### Task 1: 이슈 생성 기능 구현
상태: in_progress | TDD Phase: REFACTOR

**TDD 진행 상태:**
- ✅ RED: `src/services/__tests__/IssueService.test.ts` 생성 완료
- ✅ GREEN: `src/services/IssueService.ts` 최소 구현 완료
- 🔄 REFACTOR: 코드 정리 진행 중

**생성된 파일:**
- `src/services/__tests__/IssueService.test.ts`
- `src/services/IssueService.ts`
- `src/types/Issue.ts`

---

## 병렬 실행 가능한 Task 그룹 1
- [task-2] 🔵 pending: UI 폼 컴포넌트 생성
- [task-3] 🔵 pending: 저장 버튼 핸들러 구현

## 병렬 실행 가능한 Task 그룹 2 (task-2, task-3 완료 후)
- [task-4] ⚪ blocked: Backend API 연동 (blockedBy: task-2)
- [task-5] ⚪ blocked: 유효성 검사 개선 (blockedBy: task-2, task-3)

## 진척도: 20% (1/5 완료, TDD: REFACTOR 단계)
```

## TDD 단계별 상태 표시

각 Task는 TDD 사이클의 세 단계 상태를 추적합니다:

```markdown
### Task 1: 이슈 생성 기능 구현

**TDD 상태:**

| 단계 | 상태 | 파일 | 완료 시간 |
|------|------|------|-----------|
| RED | ✅ 완료 | `src/services/__tests__/IssueService.test.ts` | 10:30 |
| GREEN | ✅ 완료 | `src/services/IssueService.ts` | 10:32 |
| REFACTOR | 🔄 진행중 | `src/services/IssueService.ts` | - |

**최근 테스트 결과:**
\```
PASS src/services/__tests__/IssueService.test.ts
  ✓ should create an issue with valid input
  ✓ should throw error when title is empty
  ✓ should throw error when title contains only whitespace
  ✓ should throw error when description is empty
  ✓ should allow duplicate titles
\```
````

## TDD 사이클 재개

`/afk:task --continue`로 중단된 TDD 사이클을 재개할 수 있습니다:

```
클로드코드> TDD 사이클을 재개합니다.

## Task 1: REFACTOR 단계 재개

마지막으로 실행한 작업:
- 코드 정리 진행 중

테스트 실행:
```
PASS src/services/__tests__/IssueService.test.ts
  ✓ all tests passed
```

✓ **REFACTOR 완료**: Task 1이 완료되었습니다.

### 다음 Task로 넘어갈까요?
1. 예 (Task 2 시작)
2. 아니오
```

## state.json 스키마

```json
{
  "currentFeature": "1.1.1",
  "currentTask": "task-001",
  "tddPhase": "REFACTOR",
  "tasks": {
    "task-001": {
      "id": "task-001",
      "description": "이슈 생성 기능 구현",
      "status": "in_progress",
      "acceptanceCriteria": [
        "제목 중복 허용",
        "필수 항목(제목, 설명) 검증"
      ],
      "tdd": {
        "red": {
          "status": "completed",
          "testFile": "src/services/__tests__/IssueService.test.ts",
          "completedAt": "2025-02-02T10:30:00Z"
        },
        "green": {
          "status": "completed",
          "implFile": "src/services/IssueService.ts",
          "completedAt": "2025-02-02T10:32:00Z"
        },
        "refactor": {
          "status": "in_progress",
          "startedAt": "2025-02-02T10:32:00Z",
          "changes": [
            "타입 정의 추가",
            "검증 로직 분리"
          ]
        }
      },
      "files": [
        "src/services/__tests__/IssueService.test.ts",
        "src/services/IssueService.ts",
        "src/types/Issue.ts"
      ]
    },
    "task-002": {
      "id": "task-002",
      "description": "UI 폼 컴포넌트 생성",
      "status": "pending",
      "tdd": {
        "red": { "status": "pending" },
        "green": { "status": "pending" },
        "refactor": { "status": "pending" }
      }
    }
  }
}
```
