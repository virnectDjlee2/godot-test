# godot-test

Godot 4.4 기반 3D CAD 뷰어 테스트 프로젝트.
Flow CLI 스펙 기반 빌드 파이프라인과 연동하여 AR-CAD-Placer 기능을 검증합니다.

## 구조

```
godot-test/
├── main.gd / main.tscn      # 3D 회전 큐브 데모 씬
├── viewer.gd / viewer.tscn   # CAD 3D 뷰어 (orbit/zoom/pan)
├── assets/models/             # GLB 모델 (manifold_block.glb)
├── test/                      # GUT 유닛 테스트
├── docs/specs/                # Flow 스펙 (F-001 ~ F-018)
├── .flow/                     # Flow CLI 설정
└── export_presets.cfg         # Godot Web export 프리셋
```

## 스펙 목록 (AR-CAD-Placer)

| ID | 제목 | 상태 |
|----|------|------|
| F-001 | STEP/IGES → GLB 변환 스크립트 | draft |
| F-002 | STL/OBJ/FBX → GLB 변환 스크립트 | draft |
| F-003 | GLB 썸네일 및 메타데이터 생성 | draft |
| F-004 | 카탈로그 manifest.json 생성 및 앱 배치 | draft |
| F-005 | Room DB 스키마 및 DAO | draft |
| F-006 | 번들 모델 카탈로그 Repository | draft |
| F-007 | 모델 서버 FastAPI | draft |
| F-008 | Retrofit 네트워크 레이어 | draft |
| F-009 | 스플래시 및 온보딩 화면 | draft |
| F-010 | 홈 화면 — 프로젝트 목록 | draft |
| F-011 | 모델 카탈로그 화면 | draft |
| F-012 | 3D 프리뷰 화면 | draft |
| F-013 | 프로젝트 상세 화면 | draft |
| F-014 | ARCore 초기화 및 평면 감지 | draft |
| F-015 | AR 모델 배치 (Hit Test + 렌더링) | draft |
| F-016 | AR 모델 조작 (이동/회전/스케일) | draft |
| F-017 | AR 편집 툴바 (삭제/복제/높이조절) | draft |
| F-018 | 스크린샷/저장/공유 | draft |

## 실행

```bash
# Godot 에디터에서 열기
godot --editor project.godot

# GUT 테스트 실행
godot --headless -s addons/gut/gut_cmdln.gd

# Web export 빌드
godot --headless --export-release "Web" build/web/index.html
```

## Flow CLI 연동

```bash
# 프로젝트 디렉토리에서
flow spec list          # 스펙 목록 조회
flow spec show F-001    # 스펙 상세 보기
flow build              # 빌드 실행
flow test               # 테스트 실행
```
