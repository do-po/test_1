# 새로운 함수 생성

func_1 <- function(){
  print('Hello R')
}

# 인자값을 저장시킬 공간이 존재하지 않기 때문에 에러 발생
func_1('test')

# 함수 호출

func_2 <- function(x, y){
  result <- x ^ y
  return (result) # result가 지역변수기 때문에 계산 후 사라진다. 따라서 result를 return으로 보여준다.
}

# 함수 호출
func_2(5,2)

# 변수의 종류
  # 전역 변수
    # 어디서든 사용이 가능한 변수
    # 오브젝트 뷰어에 저장이 되는 변수
    # 비 휘발성 변수

  # 지역 변수
    # 특정 구역에서만 사용이 가능한 변수
    # 오브젝트 뷰어에 표시가 되지 않는다
    # 휘발성 변수 (특정 지역에서 한 번 사용이 되고 결과는 사라진다)
    # 메모리를 아끼기 위해 사용함
    # 매개변수(위의 x,y), 함수 안에서 생성된 변수(위의 result)

# 함수 생성 매개변수에 기본값이 설정

func_3 <- function(x, y=3){
  result = x ^ y
  return(result)
}

# funx_3 (x = 10, y = 3) --> result = 10 ^ 3
# result = 1000
print(func_3(10))

# func_3 (x = 10, y = 2) --> result = 10 ^ 2
# result = 100
print(func_3(10, 2))

# y 값을 고정시킨 매개 변수가 하나인 함수가 존재할 때

func_4 <- function(x){
  y = 3
  result = x ^ y
  return(result)
}

# 매개변수 x 에만 값을 넣으면 결과가 나오지만

print(func_4(10))

# 매개변수가 하나인데 인자가 둘이라서 에러 발생
print(func_4(10, 2))


array(10:20, dim= c(4,5))

# 함수 생성 매개변수가 3개인 경우, 기본값이 2개인 경우

func_5 <- function(x, y = 3, z = 2){
  result = (x - y) ^ z
  return(result)
}

print(func_5(10))

# z 값을 변경하고 싶을 때
print(func_5(10, 3, 3))
print(func_5(10, ,z = 3)) # 위에 array에서 dim 값을 c(4,5)로 넣은 것과 같은 원리

# 인자의 개수가 가변인 경우

func_6 <- function(...){
  print(c(...))
}

func_6(1,2,3,4,5)
func_6()
func_6(1,3)

# 가변으로 안 사용하고 인자를 벡터를 넣을 수도 있지만 이건 귀찮으니까 가변으로 두는것, 인자값을 넣지 않으면 에러가 나올거야.
# 가변인 경우에는 NULL이 출력됐어

func_7 <- function(x){
  print(x)
}
func_7(c(1,2,3))

# 매개변수에 저장이 될 데이터가 존재하지 않기 때문에 에러 발생

func_7()


## 함수 생성 매개변수 2개
## 매개변수 2개의 사이의 값들의 합을 구하는 함수

func_8 <- function(x,y){
  sum_1 = 0
  for(i in x:y){
    sum_1 = sum_1 + i
  }
  return(sum_1)
}

func_8(1,10)
func_8(10,1) # 내림차순도 계산 해주네 신기신기

## func_8과 같이 start 부터 end 까지의 누적합을 구하는 함수를
## while 문으로 생성

### 이건 내가 작성하다 에러난 것 ## 에러난 이유는 break가 while 문에서 실행돼야 했는데 while문 괄호가 닫히고 나서 break 입력해서 그렇게 됨.
func_9 <- function(x, y){
  sum_2 <- 0
  while (TRUE){
    sum_2 = sum_2 + x
    x = x + 1
    }if(x > y){
      break
    }
  }
  print(sum_2)
}

### 수정하면 이렇게 되어야 함 (이건 잘 된다 !)
func_9 <- function(x, y){
  sum_2 <- 0
  while (TRUE){
    sum_2 = sum_2 + x
    x = x + 1
  if(x > y){
    break
  }
}
print(sum_2)
}


### 이건 되는데 :>

func_9_1 <- function(x, y){
  sum_2 <- 0
  while (x <= y){
    sum_2 = sum_2 + x
    x = x + 1
  }
  print(sum_2)
}





func_9(1,10)

### 이건 강사님이 작성하신 것

func_10 <- function(start, end){
  # 합계 변수 생성
  result = 0
  # 초기값
  i = start
  ## start가 end보다 작은 경우
  if (start <= end){
    while(i <= end){
      result = result + i
      i = i + 1
    }
    return(result)
  }else{ ## start가 end보다 큰 경우우
    while(i >= end){
      result = result + i
      i = i - 1
    }
    return(result)
  }
  }

func_10(1, 10)

# start가 end보다 큰 경우 코드를 더 줄이고 싶다면 ! 다른 함수를 이용 해 보자

func_10(10, 1)

func_11 <- function(start, end){
  result = 0
  # 시작값 == start와 end 중에 작은 데이터
  i <- min(start,end)
  while(i <= max(start,end)){
    result = result + i
    i = i + 1
  }
  return(result)
}

func_11(1, 10)
func_11(10, 1)

min(4, 2, 7, 1)

## 평균을 구하는 함수
## 매개변수는 가변
## 모든 인자값들은 합해준다
## 모든 인자들의 합 / 인자의 개수
means <- function(...){
  # 합계를 구하는 변수를 하나 생성
  sums = 0
  # 인자의 개수를 구하는 변수를 하나 생성
  nums = 0
  for (i in c(...)){
    sums = sums + i
    nums = nums + 1
  }
  if (nums == 0){
    result = 0
  }else{
    result = sums / nums
  }
  return(result)
}

means(1,2,3,4,5)
means(10,30,40,50)
means()

# 내장함수를 쓰면 이렇게 됨

means_2 <- function(...){
  sums <- sum(...)
  nums <- length(c(...))
  if (nums == 0){
    result = 0
  }else{
    result = sums / nums
  }
  return(result)
}

means_2()



## 커스텀 연산자

"%a%" <- function(x, y){
  result <- (x + y) ^ y
  return(result)
}

10%a%2

## 데이터 프레임

name <- c('test1', 'test2', 'test3', 'test4')
grade <- c(1,1,3,2)

# 벡터 데이터를 이용해 데이터 프레임 생성

student <- data.frame(name, grade)

student

# 벡터 데이터를 이용해 행렬 데이터 생성

midterm <- c(80, 90, 70, 40)
final <- c(90, 70, 100, 80)

cbind(midterm, final) -> score

# 벡터 데이터들끼리의 합

midterm + final -> total

## 데이터프레임 + 행렬 + 벡터 데이터를 결합해 새로운 데이터 프레임 생성
## 결합 조건 == 데이터 프레임과 행렬은 행의 수가 같아야 하고
## 벡터 데이터는 데이터의 갯수가 같아야 한다.

students <- data.frame(student, score, total)

students

## 벡터 데이터와 단일 숫자와의 합

midterm + 5 # 각 원소들에 5씩 더해짐

# students에 새로운 컬럼을 추가

gender = c('F', 'M', 'F', 'M')
cbind(students, gender)
students <- cbind(students, gender)
students

## R에서 기본적으로 제공해주는 데이터 프레임 필터링
## 특정 컬럼의 데이터를 출력
## 데이터 프레임명 $ 컬럼명 | 데이터 프레임명[['컬럼명']] | 데이터 프레임명[[컬럼 위치]]

students$final
students[['final']]
students[[1]]

## []를 이용하여 데이터 필터
## 데이터 프레임명[행의 조건식, 열의 조건식]

students[, c('midterm', 'final')]
students[1, ]
students[1]
students[c(1,4), ]

## 중간 성적이 70점 이상인 학생의 정보를 확인하자

flag <- students$midterm >= 70
students[flag, ]

### 조건식으로 따로 변수를 설정하는게 좋은게 반대의 경우를 본다던가 하는
### 다양한 행위가 가능하기 때문에 자원을 덜 쓴다
### 아래처럼 쓰면 비효율적적

students[midterm >= 70, ]

flag
## 이건 왜 다 뜰까?

students[flag]

  ##이게 다 뜨는게 아니라 flag 값에 TRUE 값과 FALSE 값이 저장이 되는데
  ## 이 저장된 것을 가지고 열의 조건에 들어가게 되는 것.
  ## 예를들어 TRUE TRUE FALSE TRUE로 flag가 설정되면
  ## 열의 조건에 flag를 넣었을 때 3번째 열만 제외하고 보여주게 되는 그런 것임
  ## 열이 4개보다 많아지면 TRUE TRUE FALSE TRUE TRUE TRUE FALSE TRUE 식으로
  ## 로테이션이 돌아감감

## 중간 성적이 70점 이상이고 전체 점수가 170이상인 학생의 이름을 출력
## 행의 조건 == 중간 성적이 70점 이상이고 전체 점수가 170이상인 학생
## 열의 조건 == 학생의 이름

good <- students$midterm >= 70 & students$total >= 170

students[good, 'name']

## 행을 추가하는 함수
## rbind()
## 데이터 프레임의 구조가 같은 행 데이터를 결합

new_student <- data.frame(name = 'test5', grade = 2, midterm = 80, final = 70, total = 150, gender = 'M')
new_student

students = rbind(students, new_student)

students

## 순서가 다른 경우도 키값의 이름이 같으면 잘 결합된다

new_student2 <- data.frame(name ='test6', midterm = 90, final = 70, total = 160, grade = 1, gender = 'F')

students = rbind(students, new_student2)

## 차순 정렬
## 데이터 프레임의 행의 순서를 변경
## order()
## 오름차순 정렬

order_flag <- order(students$midterm)

students[order_flag, ]

## 내림차순 정렬

order_flag2 <- order(students$midterm, decreasing = TRUE)

students[order_flag2, ]

  ## 차순정렬 데이터가 숫자일 때만 가능함
order_flag3 <- order(-students$midterm)

students[order_flag3, ]



### 경로 (파일의 주솟값)
  # 절대 경로
    # 절대적인 주소를 의미
    # 환경(컴퓨터)이 변하더라도 같은 위치를 지정
    # 같은 위치를 지정하기 때문에 환경이 변하면 에러 발생생
    # ex) window == c:/users/admin/document/R/csv/a.csv
    # ex) mac == ~/admin/document/R/csv/a.csv
    # ex) URL == https://www.google.com
    # R은 \ 하나만 쓰면 오류나기에 \\ 로 주소를 설정해야 한다

df <- read.csv('C:\\Users\\USER\\Documents\\R\\csv\\csv_exam.csv') 


  # 상대 경로
    # 상대적인 주소를 의미
    # 환경이 변화할 때 마다 위치도 같이 변화
    # 환경이 변화해도 에러 발생 가능성이 상대적으로 낮음
    # 현재 위치(working directory)에서 상위나 하위 폴더로 이동하는 것
    # ex) ./ == 현재 작업중인 디렉토리
    # ex) ../ == 상위 디렉토리로 이동
    # ex) 디렉토리명/ = 하위 디렉토리로 이동한다

df2 <- read.csv('./csv/csv_exam.csv')

# 데이터 프레임에서 상위 n개의 데이터를 출력

head(df)
head(df2, 2)

# 데이터df2# 데이터 프레임에서 하위 n개의 데이터를 출력

tail(df2)
tail(df, 1)

# 데이터 프레임의 크기를 출력하는 함수

dim(df)

# 데이터 프레임의 기본 정보를 출력하는 함수

str(df2)

# 데이터 프레임의 뷰어창에서 확인 (읽기 전용)

View(df)

# 통계 요약 정보를 출력

summary(df2)

## df에서 english, math, science 데이터들의 합을 구해서
## df에 total 컬럼에 데이터를 대입
## meas_score 컬럼에 total을 3으로 나눈 데이터를 대입

english <- df[['english']]
math <- df[['math']]
science <- df[['science']]

# 자원을 아끼고 싶다면 전역 변수 설정하지 않고
  # total <- df$english + df$math + df$science 해도 됨

total <- english + math + science

mean_score <- total / 3

# mean_score 변수 작성하지 않고 df$mean_score <- total / 3 해도 됨 (알아서 df에서 mean_score 만들어줌)

df = cbind(df, total, mean_score)

df

## 평균 성적을 기준으로 합격 여부를 판단하는 컬럼을 생성
## 조건식을 이용한 파생변수 생성
## mean_score >= 65면 pass, <= 65면 fail
## ifelse(조건식, 참일때의 데이터, 거짓일때의 데이터)

df$check <- ifelse(df$mean_score >= 65, 'pass', 'fail')

df

## 평균 성적이 65점 초과인 경우 pass
## 성적이 65점인 경우 hold
## 65점 미만인 경우 fail
## 조건식 안에 조건식을 넣어도 되기 때문에 ifelse 안에 ifelse 사용 가능

df$check2 <- ifelse(df$mean_score > 65, 'pass', ifelse(df$mean_score == 65, 'hold', 'fail'))

df

# 외부의 패키지를 설치
# 패키지 == 다른 사람들이 만들어놓은 함수 모음집 (기능별로 모아놓음)
# install.packages('패키지명')

install.packages('dplyr')

# 외부의 패키지 사용
# library(패키지명)

library(dplyr)

## 컬럼의 이름을 변경
## dlpyr 안에 내장되어 있는 함수 rename()
## rename(데이터 프레임명, 새 컬럼명 = 기존 컬럼명)
## rename()만 하면 새 컬럼명이 기존 컬럼명을 대체하지 않음 (결과만 보여주는 것)

df <- rename(df, total_score = total)

df
