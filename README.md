# 🍱 FoodieLog (푸디로그) 
> ### 방문한 맛집을 나만의 리뷰로 저장할 수 있는 앱
<br />

<p align="center">
  <img width="35%" src="https://github.com/user-attachments/assets/2ce31aca-adbf-48ed-9611-1ed4e25fff56" />
</p>

<br />

<p align="center">
  <a href="https://apps.apple.com/kr/app/foodielog/id6736481989">
    <img width="20%" src="https://github.com/user-attachments/assets/f181fe0f-4bbe-47f5-9d65-32a7f36a377e" />
  </a>
</p>

<br />

<p align="center">
  <img width="24%" src="https://github.com/user-attachments/assets/6d83ab9b-1360-4bad-8151-23c932fd0f93" />
  <img width="24%" src="https://github.com/user-attachments/assets/99c6f9c3-8855-4a6a-b70a-1547776edd66" />
  <img width="24%" src="https://github.com/user-attachments/assets/9a29f791-fcd9-4130-ad41-fcb8d171acba" />
  <img width="24%" src="https://github.com/user-attachments/assets/4d23b5b8-584b-4b3a-9788-33cfb7d8c0d5" />
</p>

<br />

## 프로젝트 소개
> **개발 기간** : 2024. 09. 12 (목) ~ 2024. 10. 03 (목) <br />
> **개발 인원** : 1인 개발 <br />
> **최소 버전** : iOS 16.0+ <br />

<br />

## 사용 기술 및 개발 환경
- **iOS** : Swift 5, Xcode 15.3
- **UI** : SwiftUI, Swift Charts
- **Architecture** : MVVM (Input-Output), Repository 
- **Reactive** : Combine
- **Network** : URLSession (Swift Concurrency)
- **Local DB** : RealmSwift
<br />

## 주요 기능
- 현재 위치 기반 **맛집 추천**
- 별점, 음식 사진, 식당 위치 정보 등을 포함한 **리뷰 등록**
- 최근 등록한 리뷰를 **별점 카드** 형식으로 제작
- 음식 카테고리, 별점별 **리뷰 필터** 기능
- 별점, 카테고리, 방문 횟수 기반 **차트**
- 다국어 지원 (영어)
<br />

## 프로젝트 주요 구현사항
### Google Places API 및 MapKit을 활용한 위치 기반 맛집 추천
- `CoreLocation`과 `MapKit`을 통합하여 실시간 사용자 위치 추적 및 권한 관리 구현
- `Publishers.CombineLatest`를 활용해 위치 정보와 맛집 데이터를 실시간으로 결합하여 표시

### Realm DB를 활용한 리뷰 관리 시스템
- Repository Pattern을 적용하여 일관된 리뷰 CRUD 작업 
- Auto Refresh 기능으로 리뷰 데이터 변경 사항 실시간 반영

### GeometryReader와 DragGesture를 결합한 커스텀 카드 뷰
- GeometryReader로 동적 카드 크기 계산 및 스크롤 위치 추적 처리
- DragGesture의 translation과 predictedEndTranslation으로 스와이프 동작 감지
<br />

## 업데이트 내역
### v1.0.1 (24.10.18)
- 음식 카테고리 추가
- 작성한 리뷰 정렬 기능 추가
