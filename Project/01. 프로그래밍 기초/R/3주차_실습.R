# dplyr 패키지를 사용

library(dplyr)

# 외부의 데이터 파일을 로드
# 현재 디렉토리(./)에서 csv 하위폴더로(csv/) 이동 후 csv_exam.csv 로드

df <- read.csv("./csv/csv_exam.csv")

# 잘 됐나 확인해보는 거 :>

head(df)

# 파이프 연산자를 이용하여 함수를 호출
# %>% == Ctrl(command) + Shift + M 단축키를 사용하면 자동완성됨 얏호 !

# filter(조건식) == index의 조건식으로 index를 기준으로 filter

df %>%
  filter(class == 1)

# base 함수를 이용 시

df$class == 1 -> flag

df[flag, ]

# select (조건식) == column의 조건식으로 column을 기준으로 filter

df %>% 
  select(id, class)

# base 함수를 이용하여 id와 class column만 추출

df[ ,c('id', 'class')] 


# select (조건식) 에서 조건식의 column에 '-' 를 붙이면
# 해당하는 column을 제외한다

df %>% 
  select(-class)

# column의 범위를 설정 == 시작 column : 종료 column

df %>% 
  select(math : science)

# class가 3 이상인 데이터들(index 조건) 중에 math, english, science 성적을 확인(column 조건)
  # 패키지 이용 방법

df %>% 
  filter(class >= 3) %>% 
  select(math, english, science)

  # base 함수 이용 방법

flag_2 <- df$class >= 3
df[flag_2, c('math', 'english', 'science')]

## 정렬을 변경(오름차순, 내림차순)
  # arrange()
  # 오름차순

df %>% 
  arrange(math)

  # 내림차순

df %>% 
  arrange(desc(math))

df %>% 
  arrange(-math)

  # base 함수 사용
    # 오름차순

df[order(df$math), ]

    # 내림차순

df[order(df$math, decreasing = TRUE), ]

df[order(-df$math), ]

# 차순 정렬시 기준이 2개 이상인 경우

df %>% 
  arrange(desc(class), math)

df %>% 
  arrange(-class, math)

# 그룹화 데이터를 생성
# 특정 column을 선택해서 해당하는 column의 데이터들이 같은 데이터들의 묶음

df %>% 
  group_by(class) %>% 
  summarise(mean_math = mean(math))

df %>% 
  summarise(mean_math = mean(math))

# 파이프 %>% 안 쓰고 만드는 방법

summarise(
  group_by(df, class),
  mean_math = mean(math))

## 데이터 프레임의 결합

## 유니언 결합 (union join) (단순하게 행이나 열을 결합)

df_1 <- data.frame(
  id = 1:3,
  score = c(80, 70, 90)
)

df_2 <- data.frame(
  id = 2:5,
  weight = c(60, 70, 50, 65)
)

# rbind() == 행을 추가하는 결합 방식 이용시
  # column의 구조가 다르기 때문에 에러 발생
rbind(df_1, df_2)

# 패키지에서 bind_rows() 사용시
  # id 1:3 == df_1, 4:7 == df_2
  # 결측치 발생

df_1 %>% 
  bind_rows(df_2)

# bind_cols() 이건 진짜 잘 쓸 일 없고, 여기서 오류난건
# id가 겹쳐서

df_1 %>% 
  bind_cols(df_2)

# join 결합
# 집합의 개념으로 생각해봐
# df_1의 id의 집합 == 1, 2, 3
# df_2의 id의 집합 ==    2, 3, 4, 5



# 교집합
# inner_join(df1, df2, by='key')

inner_join(df_1, df_2, by= 'id')

# 왼쪽의 데이터를 기준으로 결합
# left_join(df1, df2, by='key')

left_join(df_1, df_2, by= 'id')

# 오른쪽의 데이터를 기준으로 결합
# right_join(df1, df2, by='key')

right_join(df_1, df_2, by = 'id')

# 합집합
# full_join(df1, df2, by='key')

full_join(df_1, df_2, by = 'id')

# %>% 사용하여 join

df_1 %>% 
  inner_join(df_2, by = 'id')



df_3 <- data.frame(
  id = c(2, 5),
  gender = c(1, 2)
)

# bind_rows() 이용하여 2개 이상의 df 유니온 결합

bind_rows(df_1, df_2, df_3)

# 3개의 df join 결합은 정상적으로 동작하지 않음

full_join(df_1, df_2, df_3, by = 'id')

# 따라서 df_1과 df_2를 결합한 변수를 생성 후 결합을 하던지

total_df <- full_join(df_1, df_2, by = 'id')

full_join(total_df, df_3, by = 'id')

# 파이프를 이용해 결합해야 한다
  # 이 방법은 변수를 만들지 않기 때문에 자원 관리 면에서 효율적
  # 일반적으로 이 방법 사용

df_1 %>% 
  full_join(df_2, by = 'id') %>% 
  full_join(df_3, by = 'id')

# 또 다른 방법으론 full_join() 안에 full_join을 넣어서 사용 가능

full_join(
  full_join(
    df_1, df_2, by = 'id'
  ), df_3, by = 'id'
)



## 예제 문제
## df_a를 기준으로
## 세 df를 join 결합으로 결합

df_a <- data.frame(
  name = c('test1', 'test2', 'test3', 'test4'),
  company = c('A', 'A', 'B', 'C')
)

df_b <- data.frame(
  name = c('test1', 'test2', 'test3', 'test4'),
  sal = c(1000, 1100, 1200, 1300)
)

df_c <- data.frame(
  company = c('A', 'B', 'C', 'D'),
  loc = c('seoul', 'busan', 'daegu', 'ulsan')
)


  # 내가 작성한 코드

df_a %>% 
  left_join(df_b, by = 'name') %>% 
  left_join(df_c, by = 'company')

  # 강사님이 작성한 코드

df_a %>% 
  left_join(df_b, by = 'name') %>% 
  left_join(df_c, by = 'company')

  # 똑같네 :D


installed.packages('ggplot2')
library(ggplot2)

## 샘플 데이터셋을 로드 (midwest 지역의 데이터)

midwest <- ggplot2::midwest

## 데이터 프레임의 정보를 출력

str(midwest)

## 데이터 프레임의 크기 출력

dim(midwest)

## 상위 6개 데이터 출력

head(midwest)

## 뷰어창에서 테이블을 확인

View(midwest)

## 데이터 프레임에서 column의 이름을 변경
  ## rename(df, 변경할 이름 = 변경전 이름)

## popasian column을 asian으로 변경
## poptotal column을 total로 변경

rename(midwest, asian = popasian)
rename(midwest, total = poptotal)

# 변경된 이름 저장하기

midwest %>% 
  rename(asian = popasian) %>% 
  rename(total = poptotal) -> df_midwest


# 특정 column 추출하기

df_midwest %>% 
  select(county, total, asian)

df_midwest [c('county', 'total', 'asian')]

## 전체 인구수 대비 아시아인의 인구 비율 확인

  # 이걸 사용하지 않는 이유는 column 추가되기 때문 ( 근데 오류난다 :,( )

df_midwest$asian / df_midwest$total * 100

  # 이걸 사용해서 추가 :>

df_midwest %>% 
  mutate(ratio = asian / total * 100)

# 확인확인

df_midwest %>% 
  select(ratio)

# 반복문을 이용하여 새로운 column의 데이터 대입
  # for문 사용시
  # 전체 인구수 대비 아시아인의 인구 비율 계산식

df_midwest[1, 'ratio'] = df_midwest[1, 'asian'] / df_midwest[1, 'total'] * 100
  
  # 데이터 프레임의 index의 수

dim(df_midwest)[1] #437

for (i in 1:dim(df_midwest)[1]){
  df_midwest[i, 'ratio'] = df_midwest[i, 'asian'] / df_midwest[i, 'total'] * 100
}

  # while문 사용시
  # ratio2라는 column을 생성하여 데이터를 대입

i = 1 

while (i <= dim(df_midwest)[1]) {
  df_midwest[i, 'ratio2'] = df_midwest[i, 'asian'] / df_midwest[i, 'total'] * 100
  i = i + 1
}

  # 확인용

df_midwest$ratio2

# 특정 column (ratio2)의 제거

df_midwest %>% 
  select(-ratio2) -> df_midwest

### 작업용으로 df 만들어놓기

df_m <- df_midwest %>% 
  select(county, total, asian, ratio)


## 특정 조건에 맞춰서 파생변수를 생성하여 데이터 대입
## ratio의 전체 평균 값보다 ratio의 데이터가 크다면 'large'
## 같다면 'middle'
## 같다면 'small' 이라는 데이터를
## 파생변수 group에 대입

df_m$group <- ifelse(
  mean(df_m$ratio) < df_m$ratio, 'large', ifelse(
  mean(df_m$ratio) == df_m$ratio, 'middle', 'small'
  )
)

df_m

table(df_m$group)

qplot(df_m$group)

### 파이프 연산자를 이용하여 데이터를 정제

midwest %>% 
  rename(asian = popasian) %>% 
  rename(total = poptotal) %>% 
  select(county, asian, total) %>% 
  mutate(ratio = asian / total * 100) %>% 
  mutate(group = ifelse(
    ratio > mean(ratio), 'large',
    ifelse(
      ratio == mean(ratio), 'middle',
      'small'
    )))


## midwest 데이터 정제
## 전체 인구수 대비 미성년자의 인구 비율
## popadualts column의 이름을 adult (rename)
## poptotal column의 이름을 total (rename)
## county, adult, total colum만 추출 (select)
## child column을 생성 <- total - adult (mutate)
## child_ratio column을 생성하여 전체 인구수 대비 미성년자의 인구 비율을 대입 (mutate)
## 미성년자의 인구 비율이 높은 상위 5개의 지역을 출력 (arrange, head | filter())

midwest %>% 
  rename(adults = popadults) %>% 
  rename(total = poptotal) %>% 
  # 중간중간 확인하고 계산된 수가 내가 원하는 방향으로 계산되어 나온 수가 맞는 지 확인해야 해
  select(county, total, adults) %>% 
  mutate(child = total - adults) %>%
  mutate(child_ratio = child / total) %>% 
  arrange(desc(child_ratio)) %>% 
  head(5) %>% 
  # filter를 이용하는 경우
    # head(5) %>%  대신
    # filter() 사용하면 되는데 이건 아직 보류
  select(county)

## ifelse() 함수와 같은 기능을 하는 커스텀 함수를 생성
## iftest() 함수를 생성
## 매개변수 3개
## C=c(TRUE, TRUE, FALSE) == c(2번째 인자값, 2번째 인자값, 3번째 인자값) 하는 함수 생성

iftest <- function(flag, t, f){
  
  # 해당하는 함수를 호출했을 때 결과 값의 타입 == 벡터
  
  result <- c()
  
  # flag 매개변수는 인자값의 데이터의 타입 == 벡터
  # for 반복문 사용해서 인자값들 하나하나 불러와
  # result 값들의 위치값을 추가하기 위해 extractor 설정
  
  cnt = 1
  for (i in flag) {
    
    # i 변수에 대입되는 데이터의 타입 == (TRUE | FALSE) == bool
    # 확인용 print()
    
    print(i)
    if(i){
      
      # i가 TRUE라면 result에 cnt번째의 위치에 t 데이터 대입
        ### 이거 근데 왜 i = TRUE가 아니라 i라고만 썼을까 ???
          ### i가 어차피 TRUE 아니면 FALSE로 나오니까 굳이 i = TRUE로 비교할 필요가 없지
          ### (i)TRUE & (if)TRUE, (i)TRUE & (if)FALSE 라고 되어있는 것임
      
      result[cnt] = t
    }else{
      
      # i가 FALSE라면 result에 cnt번째의 위치에 f 데이터 대입
      
      result[cnt] = f
    } 
  cnt = cnt + 1
  }
  return(result)
}

# 확인 해 보자 !

iftest(df_m$ratio >= mean(df_m$ratio), 'large', 'small')

# 원하는 목표 !

iftest(c(TRUE, TRUE, FALSE, TRUE), 'large', 'small')

## 그래프 시각화

mpg <- ggplot2::mpg

# 산점도 그래프

ggplot(data = mpg, aes(x = displ, y = hwy)
       ) + geom_point()

# 막대 그래프 (빈도수를 기준으로 한 막대)

ggplot(data = mpg, aes(x = drv)
) + geom_bar()

# 막대 그래프 (x, y 데이터를 모두 대입)

mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy = mean(hwy)) -> group_data
ggplot(
  data = group_data,
  aes(x = drv, y = mean_hwy)
) + geom_col()

# 박스 플롯

ggplot(
  data = mpg,
  aes(x = drv, y = hwy) 
  ) + geom_boxplot()

# 라인 그래프

group_data2 <- mpg %>% 
  group_by(year) %>% 
  summarise(count = n())

# 확인용

group_data2

ggplot(
  data = group_data2,
  aes(x = year, y = count)
) + geom_line()
