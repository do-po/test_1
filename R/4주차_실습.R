## sav 확장자 파일을 로드
## 외부의 ~~ 다운로드

install.packages('psych')

library(psych)

install.packages('foreign')

library(foreign)

welfare <- read.spss('./csv/Koweps.sav', to.data.frame = T)

View(welfare)

library(dplyr)
library(ggplot2)

# 컬럼의 이름을 변경

welfare %>% 
  rename(
    gender = h10_g3,
    birth = h10_g4,
    code_job = h10_eco9,
    income = p1002_8aq1,
    loc = h10_reg7
  ) -> welfare

## 복사본 데이터를 생성

df <- welfare %>% 
  select(
    gender, birth, loc, code_job, income
  )

## 결측치 확인 == 존재 유무 (is) + 결측치(na) -> is.na()

NA == NA

table(is.na(df))
table(is.na(df$gender))
table(is.na(df$birth))
table(is.na(df$income))  # 결측치 
table(is.na(df$loc))
table(is.na(df$code_job)) # 결측치

# 직업 코드가 없는 사람 (code_job 결측치) < 임금이 없는 사람 (income 결측치)



## 데이터를 수정
## 성별 column의 데이터의 빈도수 체크
  # 1 == 남자, 2 == 여자, 9 == 무응답

table(df$gender) # 무응답 없고 결측치 없는 것 확인

## 데이터가 1이면 male, 2면 female로 변환


ifelse(
  df$gender == 1,
  'male', 'female'
) -> df$gender

## 확인용

table(df$gender)

## 데이터 프레임의 base 함수를 이용하여 필터링
## 남자의 데이터들만 모아서 임금의 평균
## 여자의 데이터들만 모아서 임금의 평균

## 남자의 데이터들만 모으기

male_flag <- df$gender == 'male'

## 남자 데이터들의 임금만 모으기

df[male_flag, 'income'] -> male_income

  ## 결측치가 있기 때문에 결과가 결측치가 나옴

mean(male_income)

  ## 결측치 제거 후 결과 만들기

mean(male_income, na.rm = T)

## 여성 데이터들의 임금만 모으기

female_flag <- df$gender == 'female'
df[female_flag, 'income'] -> female_income

  # 결측치 제거 후 결과 만들기

mean(female_income, na.rm = T)

### 이렇게도 가능 (변수 생성 안 하고 계산 가능, but 데이터가 추가되면 결과가 달라짐)

mean(df[!male_flag, 'income'], na.rm = T)

## dplyr로 같은 작업
  
  # 그룹화 후 그룹화 연산 (결측치를 제외하고 연산)

df %>% 
  group_by(gender) %>% 
  summarise(income_mean = mean(income, na.rm = T))

  # 결측치를 제외 후 그룹화, 그룹화 연산

df %>% 
  filter(!is.na(income)) %>% 
  group_by(gender) %>% 
  summarise(income_mean = mean(income))

##  income 데이터에서 0, 9999(무응답)을 결측치로 변환하여 결과에 영향을 주지 않도록 제거

  # 실제로 해당하는 데이터가 있는 지 확인

table(df$income == 0 | df$income == 9999)
  # 다른 방법
table(df$income %in% c(0, 9999))

  # 1번 방법

ifelse(
  df$income == 0 | df$income == 9999,
  NA,
  df$income
) # -> df$income

  # 2번 방법
    # df에서 income이 0, 9999 있는 행 , income 열의 값
df[df$income %in% c(0, 9999), 'income']
    # 따라서 0이 14개 나오는 것
    # 이를 NA로 바꿔주는 것

df[df$income %in% c(0, 9999), 'income'] # = NA

# 확인용

table(df$income %in% c(0, 9999)) # 대입되어서 14개의 TRUE가 모두 FALSE로 바뀜 // NA로 바뀌어서 없다고 나오는 것

# 다시 연산하여 결과 확인
  # female 행의 income_mean이 1 증가

df %>% 
  filter(!is.na(income)) %>% 
  group_by(gender) %>% 
  summarise(income_mean = mean(income)) -> gender_income_mean

## 그래프 시각화 (막대 그래프 geom_col) (goem_bar는 빈도수)  

ggplot(data = gender_income_mean, aes(x = gender, y = income_mean)
) + geom_col()


## 나이에 따른 평균 임금의 차이가 어떻게 되는가?
## age column을 생성 == 현재 년도(2015) - 태어난 년도(birth)
## income 데이터에서 결측치를 제외
## age를 기준으로 그룹화
## 그룹화 연산 (income의 평균 값)
## 그래프로 시각화
## 가장 평균 임금이 높은 나이를 출력

  ### 내가 짠 코드

View(df$birth) # 나이를 어떻게 계산해야 할 지 알아보기 위해서 birth 확인인

df %>% 
  mutate(df, age = 2015 - birth) %>% # df에 age column 생성 ## 여기서 앞에 df 쓸 필요 없지 ! 왜냐면 이미 df %>% 로 넣어놨잖아 :,(
  filter(!is.na(income)) %>% # income 결측치 제외
  group_by(age) %>%  # age를 기준으로 그룹화
  summarise(income_mean = mean(income)) -> age_income_mean # income의 평균값 그룹화 연산하여 age_income_mean 변수에 대입

ggplot(data = age_income_mean, aes(x = age, y = income_mean) # 나이와 평균 임금의 상관관계를 보기 위해  age_income_mean 데이터와 age, income_mean을 축으로 하는 바탕 생성
) + geom_col() # 막대 그래프 생성

print( # 출력
  head(  # 평균 임금이 높은 나이를 출력하기 위해 상위 데이터 확인
    arrange( # 정렬
      age_income_mean, 
      desc(income_mean) # 오름차순으로 순서 변경
            ), 1 # 최상위 데이터만 출력하기 위해 1개의 데이터만 받아옴
    )
  )

  ### 강사님이 짜신 코드

df %>% 
  mutate(age = 2015 - birth) %>% 
  filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(income_mean = mean(income)) -> age_income

ggplot(data = age_income, aes(x = age, y = income_mean)
) + geom_col()

age_income %>% 
  arrange(desc(income_mean)) %>% 
  head(1)  # 파이프 써서 출력하는게 가독성이 훨씬훨씬 훨훨씬 좋네

## 연령대별 평균 임금의 차이를 확인
## age가 40 미만이면 'young'
## age가 40 이상 60 미만이면 'middle'
## age가 60 이상이면 'old'
## ageg column에 대입
## ageg를 기준으로 그룹화
## 임금의 평균을 출력

df %>% 
  mutate(age = 2015 - birth, ageg = ifelse(age < 40,
                                           'young',
                                           ifelse(age > 60,
                                                  'old', 'middle'))) %>% 
  group_by(ageg) %>% 
  summarise(income_mean = mean(income, na.rm = T)) -> ageg_income_mean

ggplot(ageg_income_mean, aes(x = ageg, y = income_mean)
       ) + geom_col()         # 'middle', 'old', 'youn' 순서로 나오는 이유는 알파벳 순서로 나오기 때문

## 이 때 'young', 'middle', 'old' 순서로 보고 싶으니까
## 그래프의 x축의 순서를 커스텀

ggplot(ageg_income_mean, aes(x = ageg, y = income_mean)
) + geom_col() + scale_x_discrete( # x축의 순서를 다시 만들겠다(재구축 하겠다다)
  limits = c('young', 'middle', 'old') # c('young', 'middle', 'old') 순서로 제한을 두겠다
)

## 지역별 평균 임금을 확인하자

df$loc # 숫자로 나오는 이유는 원본 데이터에서 숫자가 의미하는 지역 번호가 있기 때문

df %>% 
  filter(!is.na(income)) %>% 
  group_by(loc) %>% 
  summarise(income_mean = mean(income)) -> loc_income_mean

ggplot(loc_income_mean, 
       aes(x = loc, y = income_mean)
       )+ geom_col()

## 연령대, 성별을 기준으로 평균 임금 그래프 시각화

df %>% 
  mutate(age = 2015 - birth, ageg = ifelse(age < 40,
                                           'young',
                                           ifelse(age > 60,
                                                  'old', 'middle'))) %>%
  group_by(ageg, gender) %>% 
  summarise(income_mean = mean(income, na.rm = T)) -> ageg_gender_income_mean

ggplot(
  data = ageg_gender_income_mean,
  aes(x = ageg, y = income_mean, fill = gender) # ggplot으로 2D 그래프를 그릴 수 있으니까 gender를 기준으로 다르게 fill 해주겠다
) + geom_col()

# 그래프를 다르게 그려보겠다

ggplot(
  data = ageg_gender_income_mean,
  aes(x = ageg, y = income_mean, fill = gender) # ggplot으로 2D 그래프를 그릴 수 있으니까 gender를 기준으로 다르게 fill 해주겠다
) + geom_col(position = 'dodge' # position 값을 바꿔 막대를 여러개 그리게 해 주겠다
) + scale_x_discrete( # x축 값들을 재구축 하겠다
  limits = c('young', 'middle', 'old') # 제한을 'young', 'middle', 'old' 순으로 두겠다
)


## 직업별 평균 임금
## 월급이 높은 상위 10개의 직업을 확인
## 10개의 데이터를 그래프로 표시

  ## df에는 직업 코드(code_job)만 존재
  ## codebook 파일에 2번째 시트에 직업코드별 직업명 존재
  ## codebook 파일을 로드

  # 엑셀 데이터 로드하기 위한 패키지 설치

install.packages('readxl')
library(readxl)

read_excel('./csv/Koweps_codebook.xlsx', sheet = 2) -> code_book

View(code_book)

# df와 code_book 데이터 join
  # 임금을 계산해야 하기에 df를 살려야 함 따라서 left, full.
    # full을 쓸거면 df에 있는 code_job 값이 NA인 데이터들을 없애는 작업을 다시 해야 하기에 left

total.df <- left_join(df, code_book, by = 'code_job')

View(total.df)

total.df %>% 
  filter(!is.na(code_job)) %>% 
  filter(!is.na(income)) %>% 
  group_by(job) %>% 
  summarise(income_mean = mean(income)) %>% 
  arrange(desc(income_mean)) %>% 
  head(10) -> job_income_mean

View(job_income_mean)

ggplot(data = job_income_mean,
       aes(x = reorder(job, income_mean), y = income_mean # x 축 job을 income_mean의 순서로 재배치
       )) + geom_col(
       ) + coord_flip() # 가로에 글씨가 오면 너무 지저분해서 위치 바꿔줌

# x축 y축 바꿔서 해도 되네 (coord_flip 안 써도 되긴 하네)

ggplot(data = job_income_mean,
       aes(x = income_mean, y = reorder(job, income_mean))
       ) + geom_col()

## 나이, 성별 그룹화 라인 그래프 시각화

df %>% 
  mutate(age = 2015 - birth) %>% 
  filter(!is.na(income)) %>% 
  group_by(age, gender) %>%
  summarise(income_mean = mean(income)) -> age_gender_income_mean_2

# 라인 그래프

ggplot(
  data = age_gender_income_mean_2,
  aes(x = age, y = income_mean, color = gender)
) + geom_line() -> a_line # 인터렉티브 그래프로 만들어 주기 위해 변수로 설정 (파이프 쓰면 뭐 되긴 하겠다)

## 인터렉티브 그래프를 위한 패키지

install.packages('plotly')
library(plotly)

ggplotly(a_line) # 만들어둔 라인 그래프를 인터렉티브 그래프로 변환

# R 끝입니다 :D