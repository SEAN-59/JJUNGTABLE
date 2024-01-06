README.md
# 목차
[1. 개발 기록](#개발-기록)   
[2. 생각 거리](#생각-거리)

---   
---

# 개발 기록
### 2024.01.06
<details>
<summary>내용</summary>

1. ReserveView: datePicker 수정   
    - 오늘 날짜보다 이전 예약은 막아야 하는데 내부 로직 상 날짜 입력이 제대로 처리 되지 않아 수정  
    - yyyyMMdd 로 되어야 하는데 두자리 수 미만의 [월,일]이 입력되는 경우에 yyyyMd 와 같이 이상한 형태로 들어오는것을 확인 하였음
2. ReserveView: MapView_searchView 수정  
    -  지도 확인을 위해 띄우는 VC에서 AutoLayout 설정과 꺼졌다 켜짐 등에 대한 부분을 수정
</details>  

---

### 2024.01.05
<details>
<summary>내용</summary>

1. Git 등록  
    - Local 관리를 하다가 체계적인 관리의 필요성을 다시 느껴서 작업물을 Git에 등록
2. 내부 로직 수정  
    - 내부 로직을 대대로 수정하면서 "InputUserInfoView" 와의 연결이 끊겨 있는 문제를 수정

</details>


---
---
   
# 생각 거리

### 생각중
<details>
<summary>2024.01.06</summary>

```
[ ] 1. ViewDelegate와  BaseVCDelegate 를 활용하는데 이 부분을 나중에 다른 요소로 대체를 할 수 있으면 해야 할 것으로 보임 
```
> 이건 너무 과하게 전 범위를 커버치려고 하다보니 세세하게 하나하나 다 고려를 해야 하고 값을 넣어줘야 하는 문제가 있음을 느낌

</details>

### 실행
<details>
<summary>2024.01.05</summary>

```
[✓] 1. DatabaseManager의 Delegate 부분이 너무나도 불편하게 구성이 되어있음 completion 방식으로 변경 하는게 어떠할까 함
```
> 불편하게 구성이 되어있다보니 common 단으로 구성을 했음에도 불구하고 계속해서 특정 상황에 맞는 매개변수를 추가하고 하는 이상한 짓을 하게 되어서 수정을 해야 함을 느낌

</details>