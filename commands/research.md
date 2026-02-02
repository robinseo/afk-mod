---
description: "Feature 구현을 위한 프로젝트 구조와 기존 코드 패턴을 분석합니다. Researcher Agent를 호출합니다."
argument-hint: "<feature-id>"
allowed-tools:
  - Read
  - Grep
  - Glob
disallowedTools:
  - Write
  - Edit
---

# /afk:research <feature-id>

> **NOTE**: 이 파일의 모든 예시 대화는 **Issue Tracker 프로젝트**를 기반으로 한 예시입니다.
> 실제 사용 시, 프로젝트의 도메인과 요구사항에 맞게 용어와 구조를 수정하여 적용하세요.

**STAGE 2: RESEARCH** - Feature 구현을 위한 프로젝트 구조와 기존 코드 패턴을 분석합니다.

## 동작

### 0단계: 프로젝트 설계 확인

**가장 먼저 프로젝트 설계가 완료되었는지 확인합니다.**

````
클로드코드> Feature 1.1.1: 이슈 생성 리서치를 시작합니다.

프로젝트 설계 상태를 확인 중...

[project-design.json이 존재하지 않는 경우]

❌ 프로젝트 설계가 완료되지 않았습니다.

먼저 /afk:design으로 프로젝트를 설계해주세요.

---

[project-design.json이 존재하고 설계가 완료된 경우]

✅ 프로젝트 설계 확인 완료.
- Architecture: 2-tier (Frontend + Backend + Database)
- Frontend: React + Vite + shadcn/ui
- Backend: FastAPI + PostgreSQL
````

### 1단계: Feature 확인

1. `<feature-id>`로 Feature를 찾습니다
2. Feature의 수락기준(AC)을 확인합니다
3. 현재 프로젝트 구조를 파악합니다

### 2단계: Researcher Agent 호출

Researcher Agent를 호출하여 다음 분석을 수행합니다:

````
클로드코드> Feature 1.1.1에 대한 리서치를 시작합니다.

---

## STAGE 2: RESEARCH

### 프로젝트 구조 분석

#### 현재 파일 구조

```
web/
├── src/
│   ├── components/
│   │   ├── IssueForm.tsx
│   │   └── IssueList.tsx
│   ├── services/
│   │   └── IssueService.ts
│   └── types/
│       └── Issue.ts
api/
├── app/
│   └── api/
│       └── issues.py
```

#### 관련 컴포넌트/파일
- **Frontend**: `IssueForm`, `IssueList`, `IssueService`
- **Backend**: `/api/issues` 엔드포인트
- **Database**: `issues` 테이블

---

### 기존 코드 패턴 분석

#### Service Layer 패턴
- API 호출은 `Service` 클래스에서 담당
- 메서드명: `createIssue()`, `getIssues()`, `updateIssue()`
- 에러 처리: `ValidationError` 커스텀 클래스 사용

```typescript
// 기존 패턴 예시
class IssueService {
  async createIssue(input: CreateIssueInput): Promise<Issue> {
    // 1. 입력 검증
    this.validate(input);

    // 2. API 호출
    const response = await fetch('/api/issues', {
      method: 'POST',
      body: JSON.stringify(input)
    });

    // 3. 응답 처리
    if (!response.ok) {
      throw new ValidationError('이슈 생성 실패');
    }

    return response.json();
  }
}
```

#### State Management 패턴
- 서버 상태: React Query (`useQuery`, `useMutation`)
- 로컬 상태: React `useState`
- 폼 상태: React Hook Form

```typescript
// React Query 패턴
const { data: issues } = useQuery(['issues'], IssueService.getIssues);
const createMutation = useMutation(IssueService.createIssue, {
  onSuccess: () => queryClient.invalidateQueries(['issues'])
});
```

#### Error Handling 패턴
- 검증 에러: `ValidationError` 클래스
- API 에러: `try-catch` + 사용자 알림
- 네트워크 에러: React Query `retry` 옵션

#### Testing 패턴
- Frontend: Vitest + Testing Library
- Backend: Pytest
- 테스트 파일 위치: `__tests__/` 또는 `test_` 접두사

````typescript
// 테스트 패턴 예시
describe('IssueService', () => {
  it('should create an issue with valid input', async () => {
    const issue = await IssueService.createIssue(validInput);
    expect(issue.title).toBe(validInput.title);
  });

  it('should throw ValidationError when title is empty', async () => {
    await expect(IssueService.createIssue({ title: '' }))
      .rejects.toThrow(ValidationError);
  });
});
````

---

### 의존성 확인

```
#### Frontend 의존성
- **Framework**: React 18.2.0
- **Build**: Vite 4.3.0
- **UI**: shadcn/ui (Radix UI 기반)
- **State**: @tanstack/react-query 4.29.0
- **Forms**: react-hook-form 7.43.0
- **Testing**: vitest 0.31.0, @testing-library/react 14.0.0

#### Backend 의존성
- **Framework**: FastAPI 0.95.0
- **ORM**: SQLAlchemy 2.0.0
- **Database**: PostgreSQL (psycopg2 2.9.0)
- **Testing**: pytest 7.3.0
```

---

### 구현 난이도 평가

```
#### 복잡도: 중간

**예상 소요 시간**: 2시간

**선행 작업**: 없음

**잠재적 리스크**:
- 기존 `IssueService`와 충돌 가능성
- UI 폼 유효성 검증 로직 중복
- API 엔드포인트 버전 관리 필요

**의존성 확인**:
- ✅ React Query 설치됨
- ✅ shadcn/ui 컴포넌트 사용 가능
- ⚠️ `ValidationError` 클래스 import 경로 확인 필요
```

---

### 추천 접근 방식

```
#### 1. 기존 코드 확장 전략
- `IssueService` 클래스에 `createIssue()` 메서드 추가
- 기존 `IssueForm` 컴포넌트 재사용
- API 엔드포인트는 `api/app/api/issues/`에 새 라우트 추가

#### 2. 테스트 파일 구조
- Frontend: `web/src/services/__tests__/IssueService.test.ts`
- Backend: `api/tests/test_issues.py`

#### 3. 구현 순서
1. Backend API 엔드포인트 구현 (Pytest로 테스트)
2. Frontend Service 메서드 구현 (Vitest로 테스트)
3. UI 컴포넌트 연동
4. 전체 통합 테스트
```

---

### 참고 자료

- [React Query 공식 문서](https://tanstack.com/query/latest)
- [FastAPI 공식 문서](https://fastapi.tiangolo.com/)
- [Vitest 공식 문서](https://vitest.dev/)

---

✅ Research 완료.

이제 `/afk:start 1.1.1`로 TDD 사이클을 시작하세요.
````

## Researcher Agent 역할

### 프로젝트 구조 파악
- 현재 파일/폴더 구조 분석
- Feature 구현과 관련된 기존 파일 식별
- 새로 생성해야 할 파일 위치 제안

### 기존 코드 패턴 분석
- Service Layer 패턴 (API 호출 방식)
- State Management 패턴 (React Query, Context 등)
- Error Handling 패턴 (커스텀 에러 클래스)
- Testing 패턴 (테스트 프레임워크, 파일 위치)

### 의존성 확인
- 사용 중인 라이브러리 및 버전
- 설치가 필요한 새로운 패키지 확인
- 버전 호환성 검사

### 구현 난이도 평가
- 복잡도: 단순 / 중간 / 복잡
- 예상 소요 시간
- 선행 작업 확인
- 잠재적 리스크 식별

### 추천 접근 방식
- 기존 코드 확장 vs 새로운 파일 생성
- 테스트 파일 구조 제안
- 구현 순서 제안

## 출력 형식

Researcher Agent는 다음 순서로 결과를 출력합니다:

1. **프로젝트 구조 분석** (파일 구조, 관련 컴포넌트)
2. **기존 코드 패턴 분석** (Service, State, Error, Testing)
3. **의존성 확인** (사용 중인 라이브러리)
4. **구현 난이도 평가** (복잡도, 리스크)
5. **추천 접근 방식** (구현 전략)
6. **참고 자료 링크**

## 완료 메시지

Research 완료 후 다음 단계 안내:

````
✅ Research 완료.

이제 `/afk:start <feature-id>`로 TDD 사이클을 시작하세요.
````
