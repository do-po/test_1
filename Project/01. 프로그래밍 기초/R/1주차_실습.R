# 변수 생성

a <- 10
print(a)

"text" -> b
print(b)
c = TRUE
print(c)

#변수의 타입을 확인

print(typeof(a))
print(typeof(b))
print(typeof(c))


d <- "1"
print(typeof(d))

#기존에 존재하던 변수에 새로운 데이터를 대입하는 경우

a <- 20

# 벡터 데이터 생성
# 데이터들의 타입은 모두 같아야 한다
# c() 라는 함수를 이용하여 벡터 데이터 생성

vector_a <- c(1,3,5,7)
vector_b <- c("test1", "test2", "test3")
print(vector_a)
print(vector_b)

# 벡터 데이터의 특정 위치의 데이터만 출력
# R은 이상하게 1부터 시작하네

print(vector_a[3])
print(vector_b[2])

# 그냥 vector_a(2,4) 하면 에러가 날거야 이건 (2,4)는 2차원 데이터를 찾는 과정을
# 의미하기 떄문이야
# vector_a(c(2,4))를 해줘야 한다

print(vector_a[c(2,4)])

# 숫자 형태의 데이터를 벡터로 생성

vector_c <- 1:10
print(vector_c)


# 행렬 데이터 생성
# 1,2차원 데이터 생성 가능
# 일반적으로 2차원 데이터 생성시 사용

arr_x = array(1:20, dim=c(4,5))

# 행렬의 데이터보다 행, 열의 수가(공간이) 더 크면 빈 공간에 반복적으로 채워진다

arr_y = array(1:10, dim=c(4,5))

# 행렬의 데이터가 더 작으면 데이터가 다 담기지 않는다

arr_z = array(1:20, dim=c(3,3))

print(arr_z)

# 행렬에서 value 찾으려면 X,Y 값을 입력하면 된다

print(arr_z[2,3])

# 리스트 데이터 생성
# 벡터 데이터와 흡사하지만 여러 타입의 데이터 대입이 가능하고 
# 벡터에선 위치를 기준으로 데이터를 추출한다면
# 리스트 데이터에선 key 값을 기준으로 데이터를 추출할 수 있도록 구성되어있다
# 리스트 생성시 key = value 넣어서 생성

list_a = list(
  name = 'test',
  age = 20,
  phone = '01012345678'
)

print(list_a)
print(list_a[2])
print(list_a['name'])

# 2차원 list 생성

list_b <- list(
  name = c('test1', 'test2'),
  age = c(20, 30),
  phone = c('01012345678', '01098765432')
)

# 데이터 프레임 생성

df <- data.frame(
  name = c('test1', 'test2', 'test3'),
  age = c(20, 30, 40),
  loc = c('seoul', 'busan', 'daejeon')
)

print(df)

# 데이터 프레임에서 특정 값 출력하기

print(df[['age']][2])
print(df[2, 'age'])
print(df$age[2])

# 연산자

# 산술 연산자


x <- 10
y <- 3

print(x + y)
print(x - y)
print(x * y)

div <- x/y
print(div)

# 나눈 값의 나머지를 출력

print(x%%y)

# 나눈 값의 몫을 출력

print(x%/%y)

# 비교 연산자
# 두 개의 데이터를 비교하여 참/거짓의 형태로 출력

z <- 5
print(x == y)
print(x != y)
print(x > y)
print(x < y)
print(x <= y)
print(x >= y)
print(y < z)
print(x <= z + y)

# 에러 발생 코드
# 변수에 특수기호를 넣을 수 없기 때문에 에러 발생 (= 먼저 실행돼서 변수에 집어넣는것으로 판단하는 것)

print(x =< y)

# 논리 연산자
# 부정

print(!TRUE)

# and 연산자
# 두개의 논리값이 모두 참인 경우에 참, 나머지 경우는 거짓

print(TRUE & TRUE)
print(TRUE & FALSE)
print(FALSE & FALSE)

# or 연산자
# 두 개의 논리값 중 하나라도 참이라면 참, 모두 거짓인 경우엔 거짓

print(TRUE | TRUE)
print(TRUE | FALSE)
print(FALSE | FALSE)

# 값이 3개인 경우 논리 연산자를 2개 사용하면 된다

print(TRUE & TRUE & FALSE)
print(TRUE | FALSE | TRUE)
print(TRUE & TRUE | FALSE)
print(TRUE | FALSE & TRUE)
print(TRUE & FALSE | FALSE)

# 조건문 (if문)

x1 <- 10

if (x1 > 5){
  # 위의 조건식이 참인 경우 실행할 코드
  print('x1는 5보다 크다')
}

x2 <- 3

if (x2 > 5){
  print('x2는 5보다 크다')
} # 결과가 나오지 않은 것은 조건문이 거짓이기 때문에 아무 행동도 하지 않은 것

# 참인 경우 실행할 코드와 거짓일 경우 실행할 코드를 모두 작성하는 경우

if (x2 > 5){
  # 조건식이 참인 경우 실행하는 코드
  print('x2는 5보다 크다')
}else{
  # 조건식이 거짓인 경우 실행하는 코드
  print('x2가 5보다 작거나 같다')
}

# 조건식이 여러개인 경우

score <- 75

if( score >= 90){
  # score가 90 이상인 경우
  print('A')
  # score가 80 이상, 90 미만인 경우
}else if((score >= 80) & (score < 90)){
  # 근데 90 미만인 경우는 굳이 적을 필요가 없어.
  # 이미 90 이상인 점수들은 윗 조건에서 다 걸러졌기 때문이야.
  print('B')
}else if(score >= 70){
  print('C')
}else if(score >= 60){
  print('D')
}else{
  print('F')
}

# 0일땐 FALSE, 1이상일땐 TRUE로 반환

g <- 1
if(g){
  print('TRUE')
}

# 두 개의 조건식을 모두 만족해야 되는 경우

input_id <- "test"
input_pass <- 1234

if( (input_id == 'test') & (input_pass == 1234)){
  print('로그인 성공')
}else{
  print('로그인 실패')
}

# 같은 식을 다르게 표현 가능

if(input_id == 'test'){
  if(input_pass == 1234){
    print('로그인 성공')
  }else{
    print('로그인 실패')
  }
}else{
  print('로그인 실패')
}


# which 문
# 자료형 데이터에서 조건식과 일치하는 데이터의 위치를 출력
# 참이 되는 위치의 데이터만을 출력한다고 생각하면 된다

index <- c('test1', 'test2', 'test3')

index == 'test2'
which(index == 'test2')

index != 'test2'
which(index != 'test2')

arr_a <- array(1:10, dim = c(4,5))

print(arr_a)

arr_a == 4

which(arr_a == 4)

which(arr_a == 12)

# 반복문
# for 문

arr_b = 1:10

for (i in arr_b){
  print(i)
}

arr_c <- c('test1', 'test2', 'test3')

for(i in arr_c){
  print(i)
}

# 1부터 10까지 합계를 구한다

num <- 1:10
res <- 0

for(i in num){
  res = res + i
}
print(res)


## 문제
## 1부터 100까지 숫자중 짝수인 숫자들의 누적 합계

## case 1 (내가 한 것)

sum_1 = 0 # 초기값이 0인 데이터 생성

nums <- 1:100 # 1부터 100까지의 벡터 데이터 생성

for(n in nums){ # for 문을 이용하여 nums 만큼 반복하는 반복문 작성
  if(n %% 2 == 0){    # n의 값이 짝수인지에 대한 조건문 작성  ### 여기서 오류가 났는데, if문에 () 안 써서 났던거였어. 항상 괄호 신경쓰기
    sum_1 = sum_1 + n # 짝수일 때 누적 합계 계산
  } # 여기서 else{next} 작성했는데 이건 굳이 할 필요 없어. 어차피 조건 미달이면 아무 행동도 하지 않거든. 
}

print(sum_1) # 누적 합계 출력


## case 2

sum_2 = 0
arr_d = 1:50
for(j in arr_d){
  sum_2 = sum_2 + 2*j
}
print(sum_2)

# while문
# while 뒷 조건문이 거짓이 될 때 까지 반복 실행하는 구문

k <- 1
while (k<=10) {
  print(k)
  k = k + 1
}

# 만약 k = k + 1 없으면 1이 계속 출력될 것
# break == 반복문을 강제로 종료

h <- 1
while (TRUE) {
  print(h)
  h = h + 1
  if(h == 10){
    break
  }
}

k <- 1
result = 0

while (k<=10) {
  result = result + k
  k = k + 1
}

----------------------------

k <- 1
while (k<=10) {
  k = k + 1
  result = result + k
}
# 위와 아래가 다른 이유는 순서 때문 (위는 k가 1부터 시작하지만, 아래는 k가 2부터 시작함)
# 위는 result가 0+1, 1+2, ... , 45+10 이 되지만
# 아래는 result가 0+2, 2+3, ... , 54 + 11 이 되기 때문이다

## 다중 for문
## 구구단을 출력하라 (2단부터 9단까지)

# 첫 번째 반복문에서는 2부터 9까지 반복하는 반복문을 생성
for (i in 2:9){
   #print(i)
  for (j in 1:9){
    #print(j)
    print(c(i, j, i * j))
  }
}

## 문제
## 2개의 주사위를 굴려서 합이 7인 경우의 수를 모두 출력하시오

for(i in 1:6){ # 첫 번째 주사위의 경우의 수를 반복문으로 생성
  for(j in 1:6){ # 두 번째 주사위의 경우의 수를 반복문으로 생성
    if(i + j == 7){ # 2개의 주사위의 합이 7인 경우의 조건문 생성
      print(c(i, j)) # 조건식이 참인 경우 첫 번째 주사위와 두 번째 주사위의 값을 출력
    }
  }
}

