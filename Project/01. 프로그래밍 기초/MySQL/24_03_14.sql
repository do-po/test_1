# 데이터 베이스를 선택

use ubion;

# 데이터 베이스에서 emp table의 데이터를 모두 출력

select * from emp;

# emp table에서 SAL 컬럼의 데이터가 1500 이상인 사원의 정보를 출력

select * from emp where sal >= 1500;

# emp table에서 job이 manager이고 sal이 1500 이상인 사원의 이름을 출력

	# 컬럼 조건식 = 사원의 이름(ename)
    # 인덱스 조건식 = job = 'manager', sal >= 1500 
SELECT 
    `ename`
FROM
    `emp`
WHERE
    `job` = 'manager' AND `sal` >= 1500;

# `emp`에서 `sal`이 1500 이상이고 2500 이하인 사원의 정보를 출력
# case 1
SELECT 
    *
FROM
    `emp`
WHERE
    `sal` >= 1500 AND `sal` <= 2500;
    
#case 2 (BETWEEN 사용)
SELECT 
    *
FROM
    `emp`
WHERE
    `sal` BETWEEN 1500 AND 2500;

# emp table에서 job이 manager 이거나 salesman인 사원의 정보를 출력

#case 1
SELECT 
    *
FROM
    `emp`
WHERE
    `job` = 'manager' OR `job` = 'salesman';

#case 2
SELECT 
    *
FROM
    `emp`
WHERE
    `job` IN ('manager' , 'salesman');
    
# 사원의 이름이 특정 문자(s)로 시작하는 사원의 정보를 출력

select
	*
from
	`emp`
where
	`ename` like 's%';

# 사원의 이름에 특정 문자가 포함되어있는 사원의 정보를 출력

select
	*
from
	`emp`
where
`ename` like '%a%'; # % 의미는 % 앞에는 아무것도 없고 뒤로는 문자들이 존재한다는 뜻

# 사원의 이름이 특정 문자로 끝이 나는 사원의 정보를 출력

select
	*
from
	`emp`
where
	`ename` like '%s';

# 두 개의 테이블을 특정 조건에 맞게 열 결합(join 결합)    
	# `emp`와 `dept` join 결합

SELECT 
    *
FROM
    `emp` INNER JOIN `dept`
    ON # join의 조건
		`emp`.`deptno` = `dept`.`deptno`
# chicago에 사는 사람만 출력
where
	`loc` = 'chicago';
    
# 두 개의 테이블을 특정 조건에 맞게 열 결합 후 부서 번호가 20인 사원 정보 출력

select
	*
from
	`emp` left join `dept`
    on
		`emp`.`deptno` = `dept`.`deptno`
	where `deptno` = '20'; # `deptno`가 두 테이블에 있기에 이렇게만 작성하면 어떤 테이블의 컬럼을 가져와야 하는 지 몰라서 에러 발생
    
    select
	*
from
	`emp` left join `dept`
    on
		`emp`.`deptno` = `dept`.`deptno`
	where `emp`.`deptno` = '20';
    
## 부서의 지역이 new york인 사원의 정보만 출력

# case 2

select
	*
from
	`emp` left join `dept`
	on `emp`.`deptno` = `dept`.`deptno`
where
	`dept`.`loc` = 'new york';

# case 1
select `deptno`
from `dept`
where `loc` = 'new york'; # 10
    
select
	*
from
	`emp`
where
	`emp`.`deptno` = 10;
    
# case 3 (sub query = 쿼리 속 쿼리, 하위 쿼리)

select
	*
from
	`emp`
where
	`deptno` = ( # sub query 넣을 떄 여기 = 말고 in 넣으면 에러 발생이 줄어든다
				 # 하위 쿼리 결과가 20, 30, 40 이면 = (20, 30, 40) 인 결과(모두 만족)를 찾으려고 하다보니까 에러 발생
	select
    `deptno`
    from
    `dept`
    where
    `loc` = 'new york');
    
# 단순한 행 결합 (유니언 결합)    

select
	*
from
	`tran_1`
union
select
	*
from
	`tran_2`;
    
# ``를 사용하는 이유
	# table의 이름이나 column의 이름에 공백이 존재하는 경우
    
select
	*
from
	sales records; # 에러, ubion.sales 까지만 인식함 (sales / records 로 인식함)
    
select 
	`item type`, `sales channel`
from
	`sales records`;
    
## 그룹화
	# 그룹화
    # 조건을 처리하고 그룹
    # 조건 처리 그룹 조건 처리
    # 조건 처리 그룹 조건 처리 정렬
    
# sales record에서 대륙별 총 이윤의 합계

SELECT 
    `region`, SUM(`total profit`) AS `sum`
FROM
    `sales records`
GROUP BY `region`
ORDER BY `sum` DESC; 

## 국가(country)별 총 이윤(total profit)의 합계를 구하고 
## 총 이윤을 기준으로 내림차순 정렬

select `country`, sum(`total profit`) as `sum`
from `sales records`
group by `country`
having `sum` > 28000000 # 그룹화 이후 조건
order by `sum` desc
limit 3; # 3개만 출력 제한

## 아시아의 국가들 중 총 이윤의 합계가 높은 5개 국가를 출력

select `country`, sum(`total profit`) as `sum`
from `sales records`
where `region` in ('asia') # 여기 ('asia') 대신 'asia' 하면 에러 # 나 'asia'를 `asia`로 적어서 에러
group by `country`
order by `sum` desc # 높은 5갠데 이거 desc 안 넣어서 오름차순으로 넣는 실수 :>
limit 5;