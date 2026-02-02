# /afk:reload

> **NOTE**: 이 파일의 모든 예시 대화는 **Issue Tracker 프로젝트**를 기반으로 한 예시입니다.
> 실제 사용 시, 프로젝트의 도메인과 요구사항에 맞게 용어와 구조를 수정하여 적용하세요.

Feature List JSON 파일을 다시 읽어 메모리 상태를 갱신합니다.

## 동작

1. `.afk-mod/feature-list.json` 파일을 다시 읽습니다
2. 기존 `state.json`과 병합:
   - 새 Feature 추가
   - 삭제된 Feature 보존 (archive 상태로 변경)
   - 변경된 내용 감지 및 리포트
3. 갱신 결과를 표시합니다

## 사용 예시

````
사용자> /afk:reload

클로드코드> Feature List를 갱신하고 있습니다...

## 갱신 결과

- 새 Feature: 3개
- 변경된 Feature: 5개
- 삭제된 Feature: 0개

## 새 Feature
- [4.1] 알림 기능 (PENDING)
- [4.2] 웹훅 관리 (PENDING)
- [4.3] 이벤트 로그 (PENDING)

## 변경된 Feature
- [1.2.1] 변수 추출 로직 변경됨
- [3.3.1] 실험 생성 조건 추가됨
- ...

상태를 .afk-mod/state.json에 저장했습니다.
````

## JSON 파일 위치

기본 위치: `.afk-mod/feature-list.json`

다른 위치 지정: `/afk:reload --path=/path/to/custom.json`
