# flask 웹 프레임워크 로드
# database 안에 있는 MyDB Class 로드
from flask import Flask, render_template, url_for
from static.python.database import MyDB

from  dotenv import load_dotenv
import os

# .env 로드

load_dotenv()

# Flask Class 생성

app = Flask(__name__)

# MyDB Class 생성
    # Class에서 _host 자리에 뭘 받겠다니깐 그냥 value만 넣어주면 됨

mydb = MyDB(
    os.getenv('host'),
    int(os.getenv('port')),
    os.getenv('user'),
    os.getenv('pw'),
    os.getenv('db')
)

# localhost:5000/ api 생성하여 img_slide.html를 되돌려주는 함수 생성

@app.route('/')
def slide():

    # DB 서버에 있는 company_list table의 정보를 로드
    select_query = '''
        select
        *
        from
        company_list
    '''

    # Class 생성한 mydb 안에 내장된 함수를 호출

    db_data = mydb.db_execute(select_query)

    # db_data의 타입은 [{name : xxxx}, {img_url : xxxx}, {link_url : xxxx}] 형식
        # 필요한 데이터는 img_url, link_url

        # db_data에서 img_url만 따로 추출
    img_urls  = []
    link_urls = []
    for data in db_data:
        img_urls.append(data['img_url'])
        link_urls.append(data['link_url'])

    # 로그찍기
    # print(img_urls)
    # print(link_urls)

    return render_template('img_slide.html',
                           imgs = img_urls,
                           links = link_urls,
                           cnt = len(img_urls))

# 웹서버를 실행

app.run(debug= True)