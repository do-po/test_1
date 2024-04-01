## 데이터들의 평균을 구하는 함수 생성
## 함수에 매개변수는 인자의 개수가 가변인 상태로 생성
## 평균 : 인자들의 총합 / 인자들의 개수
def mean_a(*_values):
    sum_value = 0
    cnt = 0
    for val in _values:
        # val에 대입이 되는 데이터 : 인자
        sum_value += val
        cnt += 1
    result = sum_value / cnt
    return result