# flask 프레임 워크 안의 특정 기능들을 로드
# flask, html을 text로 받아오는 render_template, request, 페이지 이동하는 redirect

from flask import Flask, render_template, request, redirect

# mysql과 연동을 하는 라이브러리 로드

import pymysql
import pymysql.cursors

# Flask라는 class 생성 (인자를 파일명으로 받아옴, 파일명이 이 파일의 이름일 경우 __name__)

app = Flask(__name__)

# DB server와 연결 -> 가상 공간 Cursor 생성 -> 
# 매개변수 query문, data 값을 이용하여 -> 질의 보냄 (execute) ->
# 결과 값을 받아오거나 DB 서버와 동기화 (fetchall or commit) -> DB 서버와 연결을 종료 (close)

def db_execute(query, *data): # *data == data 매개변수의 갯수는 가변적이다

    # 데이터 베이스와 연결

    _db = pymysql.connect(
        host = 'localhost',
        port = 3306,
        user = 'root',
        password = '0000',
        db = 'ubion'
    )

    # 가상공간 Cursor 생성
        # pymysql의 커서들 중 DictCursor로 불러와야겠다 (값이 list 안의 dict 형태로 나옴)

    cursor = _db.cursor(pymysql.cursors.DictCursor)

    # 매개변수 query, data를 이용하여 질의 (질의가 DB에 바로 영향을 주는 구문 형태가 아니기에 cursor에서 구문을 실행하는 것)

    cursor.execute(query, data)

    # query가 select라면 결과값을 변수(result)에 저장
        # query가 길어지면 \n으로 줄을 나눠주기 때문에 좌, 우의 공백을 제거하는게 필요

    if query.strip().upper().startswith('SELECT'):
        result = cursor.fetchall()

    # query가 select가 아니라면 DB 서버와 동기화 하고 변수(result)는 Query Done 문자를 대입

    else:
        _db.commit()
        result = 'Query Done'

    # DB 서버와의 연결을 종료

    _db.close()

    # 결과(result) return

    return result


# 메인페이지 api 생성
    # 로그인 화면

@app.route("/")
def sign_in():
    
    # 요청이 들어왔을 때 state라는 데이터가 존재하면

    try: # 로그인이 실패해서 redirect로 state가 2 인 값을 받아오는 경우
        _state = request.args['state']

    # 예외가 발생

    except: # 처음 로그인을 하는 경우
        _state = 1

    # log_in.html과 state를 되돌려준다.
    
    return render_template('login.html', state = _state)

# 로그인 화면에서 id, password 데이터를 보내는 api 생성

@app.route("/main", methods=['post'])
def main():
    # 유저가 보낸 데이터 == id, pw 2개
    # 유저가 보낸 id 값의 key -> input_id로 잡아보자
    # 유저가 보낸 pw 값의 key -> input_pass로 잡아보자

    _id = request.form['input_id']
    _pass = request.form['input_pass']

    # 받아온 데이터를 확인 (어디서 나온 정보인 지 확인하기 위해 주소 식별자도 넣어주면 쉬움)

    print(f'/main[post] -> 유저 id : {_id}, pw : {_pass}')

    # 유저가 보낸 데이터를 DB server의 table data와 비교

    log_in_query = '''
    select
    *
    from
    user
    where
    id = %s
    and
    password = %s
    '''

    # 함수를 호출

    db_result = db_execute(log_in_query, _id, _pass)

    # 로그인의 성공 여부 == db_result가 존재 여부

    # 로그인 성공 경우
        # main.html return

    if db_result:
        return render_template('main.html')

    # 로그인 실패 경우
        # login 화면인 '/' 으로 되돌아간다

    else:
        return redirect('/?state=2')

# 웹 서버를 실행

app.run(debug= True)