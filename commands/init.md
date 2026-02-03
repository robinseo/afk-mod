---
description: AFK 프로젝트를 초기화합니다
argument-hint: ""
allowed-tools:
  - AskUserQuestion
  - Write
  - Bash
---

# AFK 프로젝트 초기화

새로운 AFK 프로젝트를 시작하기 위해 프로젝트 정보를 수집하고 `.afk-mod/` 디렉토리를 생성합니다.

## 1단계: 프로젝트 기본 정보 수집

먼저 프로젝트에 대한 기본 정보를 입력해주세요:

- **프로젝트 이름**: 프로젝트의 식별자 (예: `my-awesome-app`)
- **프로젝트 목적**: 프로젝트가 해결하려는 문제나 목표 (간단히 설명)

사용자로부터 위 두 가지 정보를 입력받으세요.

## 2단계: 디렉토리 구조 생성

`.afk-mod/` 디렉토리를 생성하고 다음 파일들을 생성합니다:

### `project-info.json`

```json
{
  "projectName": "[사용자가 입력한 프로젝트 이름]",
  "description": "[사용자가 입력한 프로젝트 목적]",
  "createdAt": "[현재 ISO8601 타임스탬프]",
  "version": "0.3.0"
}
```

### `state.json`

```json
{
  "version": "0.3.0",
  "project": {
    "name": "[프로젝트 이름]",
    "description": "[프로젝트 목적]",
    "initCompletedAt": "[현재 ISO8601 타임스탬프]"
  },
  "workflow": "initialized",
  "currentStage": "awaiting_feature_list",
  "stages": {
    "architecture": { "status": "pending", "artifact": "architecture-design.md" },
    "design": { "status": "pending", "artifact": "design-design.md" },
    "environment": { "status": "pending", "artifact": "environment-setup.md" }
  },
  "tasks": {},
  "currentTask": null,
  "updatedAt": "[현재 ISO8601 타임스탬프]"
}
```

### `tasks/` 디렉토리 생성

```bash
mkdir -p .afk-mod/tasks
```

## 3단계: 다음 단계 안내

초기화가 완료되었습니다! 다음 단계:

1. **Feature List 준비**: `docs/feature-list-template.csv`를 참고하여 Feature List를 작성하세요
2. **Feature List 배치**: 작성한 `feature-list.csv`를 `.afk-mod/` 디렉토리에 복사하세요
3. **Feature 분해 시작**: `/afk:feature-decompose`를 실행하여 4단계 Feature 분해를 시작하세요

## 주의사항

- `.afk-mod/` 디렉토리는 Git에 커밋하는 것을 권장합니다
- `feature-list.csv` 형식은 `docs/feature-list-format.md`를 참고하세요
