# /afk:feature-list

> **NOTE**: 이 파일의 모든 예시 대화는 **Issue Tracker 프로젝트**를 기반으로 한 예시입니다.
> 실제 사용 시, 프로젝트의 도메인과 요구사항에 맞게 용어와 구조를 수정하여 적용하세요.

Feature List와 진척도를 표시합니다.

## 전제 조건

- 프로젝트 설계가 완료되어야 합니다 (`state.json.projectDesignStatus == "completed"`)
- `.afk-mod/feature-list.json` 파일이 존재해야 합니다

## 프로젝트 설계가 없는 경우

```
사용자> /afk:feature-list

클로드코드> 프로젝트 설계가 완료되지 않았습니다.
먼저 /afk:design으로 프로젝트를 설계해주세요.
```

## 동작

1. `.afk-mod/feature-list.json` 파일을 읽습니다
2. `.afk-mod/state.json`에서 현재 상태를 로드합니다
3. Feature 목록을 Markdown 표로 표시합니다:
   - ID (Feature ID)
   - Title (제목)
   - Parent (부모 ID, 없으면 "-")
   - Status (상태: PENDING, IN_PROGRESS, DONE, BLOCKED)
   - Progress (진척도 0~100%)

## 필터/정렬 옵션

- `/afk:feature-list --status=IN_PROGRESS` - 특정 상태만 표시
- `/afk:feature-list --parent=1` - 특정 부모 하위만 표시
- `/afk:feature-list --sort=progress` - 진척도순 정렬

## 출력 형식

### Markdown 표 (기본)

```markdown
# Feature List

| ID | Title | Parent | Status | Progress |
|----|-------|--------|--------|----------|
| 1 | 이슈 관리 | - | PENDING | 0% |
| 1.1 | 이슈 CRUD | 1 | IN_PROGRESS | 80% |
| 1.1.1 | 이슈 생성 | 1.1 | DONE | 100% |
| 1.1.2 | 이슈 목록 조회 | 1.1 | IN_PROGRESS | 60% |
| 1.1.3 | 이슈 상세 조회 | 1.1 | PENDING | 0% |
| 1.1.4 | 이슈 수정 | 1.1 | PENDING | 0% |
| 1.1.5 | 이슈 삭제 | 1.1 | PENDING | 0% |
| 1.2 | 이슈 상태 워크플로우 관리 | 1 | PENDING | 0% |
| 1.2.1 | 이슈 상태 변경 | 1.2 | PENDING | 0% |
| 1.2.2 | 이슈 담당자 지정/변경 | 1.2 | PENDING | 0% |
| 1.3 | 이슈 태그 관리 | 1 | PENDING | 0% |
| 1.3.1 | 이슈 태그 추가/삭제 | 1.3 | PENDING | 0% |
| 1.4 | 이슈 우선순위 관리 | 1 | PENDING | 0% |
| 1.4.1 | 이슈 우선순위 설정 | 1.4 | PENDING | 0% |
| 2 | 스프린트 관리 | - | PENDING | 0% |
| 2.1 | 스프린트 CRUD | 2 | PENDING | 0% |
| 2.1.1 | 스프린트 생성 | 2.1 | PENDING | 0% |
| 2.1.2 | 스프린트 목록 조회 | 2.1 | PENDING | 0% |
...
```

### CSV 입력 예시

```
/afk:feature-list
```

`sample-feature-list.csv`에서 다음과 같이 CSV 형식으로 Feature를 정의할 수 있습니다:

| Depth1 | Depth2 | Depth3 | 넘버링 | 설명 | User Action | System Outcome | Dependencies | Acceptance Criteria |
|--------|--------|--------|--------|------|-------------|----------------|--------------|---------------------|
| 이슈 관리 | | | 1 | 이슈 생성, 조회, 수정, 삭제 기능 | | | | |
| 이슈 관리 | CRUD | | 1.1 | 이슈 기본 CRUD 기능 | | | | |
| 이슈 관리 | CRUD | 생성 | 1.1.1 | 이슈 생성 | 사용자가 "새 이슈"에서 제목/설명/우선순위/담당자를 입력 후 저장한다 | 새 이슈가 생성되고 목록에 추가된다 | - | 제목 중복 허용; 필수 항목(제목, 설명) 검증; 저장 성공 시 목록/상세로 이동; 실패 시 원인 메시지 표시 |
