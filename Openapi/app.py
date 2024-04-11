# api 형태에 대한 분석을 진행하는 것이 목표

# 프레임 워크 로드

# 웹을 만들기 위해 로드
from flask import Flask

# 외부의 csv 파일을 dict 형태로 변환해 api에 집어넣기 위해 로드
import pandas as pd

# MySQL과의 연동을 위해 로드 (만든 모듈이야)
import database

# Flask Class 생성

# __name__ == 현재 파일의 이름

app = Flask(__name__)

# api를 생성

# 127.0.0.1:5000/ 요청 시 아래의 함수를 호출

@app.route('/')
def index():
    # 외부의 csv 파일을 로드
    # 상위 폴더로 이동 -> csv 하위 폴더로 이동 -> 파일 이름

    df = pd.read_csv('../csv/corona.csv', index_col= 0) # index_col= 0 == 0 번째 열의 데이터를 index로 사용하겠다
    
    # csv 데이터를 dict 형태로 변환
    data = df.to_dict()
    
    return data




### web service와 open api간의 차이는
    # web service는 return으로 html을, open api는 xml, dict 같은 데이터를 돌려준다.



## 웹 서버를 실행 (항상 가장 아랫단에 위치)

app.run()