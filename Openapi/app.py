# api 형태에 대한 분석을 진행하는 것이 목표

# 프레임 워크 로드

# 웹을 만들기 위해 로드
from flask import Flask, request

# 외부의 csv 파일을 dict 형태로 변환해 api에 집어넣기 위해 로드
import pandas as pd

# MySQL과의 연동을 위해 로드 (만든 모듈이야)
import database


# Flask Class 생성

# __name__ == 현재 파일의 이름

app = Flask(__name__)

# database에 있는 MyDB Class 생성

_db = database.MyDB(
    _host = '172.30.1.22',
    _user = 'ubion',
    _pw = '1234',
    _db = 'ubion'
)

# api를 생성

# 127.0.0.1:5000/ 요청 시 아래의 함수를 호출
# id와 password를 데이터로 입력받는다.

@app.route('/')
def index():
    # 유저가 보낸 데이터를 확인하고 변수에 저장
    # try 구문을 사용하여 입력받은 데이터가 올바르다면 정상 작동, 올바르지 않다면 오류가 나는 것이 아니라 오류 메시지를 출력

    try:
        _id = request.args['input_id']
        _pw = request.args['input_pw']
    except:
        return 'parameter error'

    print(_id, _pw)

    query = '''
        select
        *
        from
        `user`
        where
        `id` = %s and `password` = %s
    '''
    result = _db.sql_query(query, _id, _pw)

    # result가 존재할 때 아래 구문 실행, 존재하지 않을 때는 메시지 출력
        # 로그인 성공시 구문 실행, 실패시 메시지 출력

    if result:

        # 외부의 csv 파일을 로드
        # 상위 폴더로 이동 -> csv 하위 폴더로 이동 -> 파일 이름

        df = pd.read_csv('../csv/corona.csv', index_col= 0) # index_col= 0 == 0 번째 열의 데이터를 index로 사용하겠다
        
        # csv 데이터를 dict 형태로 변환
        data = df.to_dict()
        
        return data


    else:
        return '입력 데이터 오류'


### web service와 open api간의 차이는
    # web service는 return으로 html을, open api는 xml, dict 같은 데이터를 돌려준다.



## 웹 서버를 실행 (항상 가장 아랫단에 위치)

app.run(debug= True)