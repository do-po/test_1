## 기본적인 웹서버 설정
## flask 웹프레임 워크를 로드

from flask import Flask, render_template, request, redirect, url_for
## module 로드
import database
from datetime import datetime

## Flask라는 Class 생성

## 생성자 함수 필수 인자 == 파일의 이름 (app.py)
## __name__ == 현재 파일의 이름


app = Flask(__name__) # 현재 파일의 이름을 인자로 받음

## database에 있는 MyDB Class를 생성

_db = database.MyDB(
    _host = '172.30.1.55', # 교수님 db에 접속
    _user = 'ubion',
    _pw = '1234',
    _db = 'ubion'
)


## 주소를 생성 (api 생성) -> request 하고 response 할 무언가를 만드는 작업
## localhost:5000/ 요청시 index 함수를 호출
    # :5000은 port 번호

@app.route('/') # @ ==  navigator, '/' == '/라고 요청을 보낸다면', route == 웹 서버의 다양한 함수, 요소들과 연결하기 위해 port를 통합하여 관리하는 것
                # route에 인자가 있다면 해당 인자를 받으면 아래의 함수를 response

def index():
    # 문자열을 return 하는 것이 아니라 html 문서를 return
    # return 'Hello World'
    return render_template('index.html') # render_template라는 함수가 현재 경로 중 templates라는 폴더를 기본 경로로 받도록 설정되어 있기에 이렇게만 적어도 된다.

## 주소를 생성
## localhost:5000/second 라고 요청이 들어온다면 

@app.route('/second')
def second():
    # return 'Second Page'
    return render_template('login.html')

## 주소를 생성
## 로그인 정보(request 메시지)를 받아오는 주소

@app.route('/login')
def login():
    # 해당 주소로 요청이 들어왔을 때 (유저가 보낸 데이터가 포함)
    ## request.args는 유저가 서버에게 get 방식으로 보낸 데이터가 저장되어 있는 공간

    req = request.args
    print(req)

    ## user가 보낸 아이디, 패스워드 값을 변수에 저장
    _id = req['input_id']
    _pass = req['input_pass']

    print(f'유저가 보낸 id : {_id}, 유저가 보낸 비밀번호 : {_pass}')

# 127.0.0.1:5000/login2 [post] 주소 생성

    ## user가 보낸 데이터를 DB server의 정보와 비교
    ## table명과 column 명에는 `` 넣는거 습관화 :>
    ## %s == 변수에 들어가 있는 데이터를 받아오는 것

    query = '''
        select * from user where `id` = %s and `password` = %s 
    '''

    # _db 안에 있는 sql_query() 함수를 호출

    result = _db.sql_query(query, _id, _pass)
    print(result)
    
    # 로그인이 성공? == result에 데이터가 존재할 때
    # 로그인이 실패? == result == []

    if result:
        return '로그인 성공'
    else: # 로그인 실패시 로그인 화면으로 되돌아간다
        return redirect('/second')


# post 방식으로 데이터 전송시

@app.route('/login2', methods = ['post'])

def login2():
    # get 방식으로 데이터를 보내는 경우 -> request.args
    # post 방식으로 데이터를 보내는 경우 -> request.form

    req = request.form

    print('post 방식 데이터 : ', req)

    _id = req['input_id']
    _pass = req['input_pass']

    print(f'유저가 보낸 id : {_id}, 유저가 보낸 비밀번호 : {_pass}')

    query = '''
        select * from `user` where `id` = %s and `password` = %s
    '''

    result = _db.sql_query(query, _id, _pass)
    print(result)

    if result:
        # return '로그인 성공'
        # 로그인 성공시 main.html을 되돌려준다.
        # 로그인 정보 중 유저의 이름을 변수에 저장

        user_name = result[0]['name']

        print('로그인을 한 유저의 이름은 : ', user_name)

        return redirect('/board')
    else:
        return redirect('/second')

# 게시글을 보여주는 주소를 생성

@app.route('/board')
def board():
    # DB 서버에 있는 board table의 정보를 로드
    query = '''
        select
        `No`, `title`, `writer`, `create_dt`
        from
        `board`
        order by
        `No` desc
    '''

    result = _db.sql_query(query)
    print(f'board_table의 data : {result}')
    return render_template('main.html', _data = result, _cnt = len(result))


    # # _id가 'test'이고 _pass가 '1234'라면 로그인 성공 메시지 리턴
    # if (_id == 'test') & (_pass == '1234'):
    #     return '로그인 성공'
    # # 아니라면 로그인 페이지 (/second)로 돌아간다.
    # else: 

    #     return redirect('/second')

# 회원 가입 화면을 보여주는 주소를 생성

@app.route('/signup')
def signup():
    return render_template('signup.html')

# 회원의 정보를 받아오는 주소를 생성
# 127.0.0.1:5000/signup2 [post]

@app.route('/signup2', methods=['post'])
def signup2():
    
    # 유저가 보낸 정보를 확인 -> 변수에 저장
    # 유저가 보낸 정보 -> request 안에 저장, 데이터의 형태는 dict로 구성, key는 input으로 받은 name 속성으로 존재, value는 input 태그에 유저가 입력한 데이터로 존재
    # {input_name : input_data} 
    # post 방식으로 데이터를 보내면 request 안에 form에 데이터가 존재, get 방식은 args에 존재
    
    req = request.form
    
    print('회원가입 데이터 : ', dict(req))

    _id = req['input_id']
    _pass = req['input_pass']
    _name = req['input_name']

    print(f'회원의 ID = {_id}, 비밀번호 = {_pass}, 이름 = {_name}')

    # 받아온 회원 정보를 DB에 insert 문을 실행
        # column에 모두 집어넣으려고 하기에 column명은 적지 않아도 된다.

    query = '''
        insert into 
        `user`
        values (%s, %s, %s) 
    '''

    try:
        result = _db.sql_query(query, _id, _pass, _name)
        print(result)
        
        # 회원 가입이 완료되었다면

        return redirect('/second')
    
    except: # ID는 primary key였기에 중복된 데이터가 들어간다면 오류 발생
        return 'ID 중복'

# 글쓰기 화면을 보여주는 주소를 생성

@app.route('/write')
def write():
    return render_template('write.html')

# 유저가 보내는 글의 정보를 DB 서버에 저장하는 주소
@app.route('/save_content', methods= ['post'])
def save_content():
    # 유저가 보낸 글의 정보를 확인하고 변수에 저장
    req = request.form

    _title = req['input_title']
    _writer = req['input_writer']
    _content = req['input_content']

    print(f'글 제목 : {_title}')
    print(f'작성자 : {_writer}')
    print(f'본문 : {_content}')

    # 현재 시간?
    _time = datetime.now()
    print(f'현재 시간 : {_time}')

    # DB 서버에 data 저장

    query = '''
        insert into
        `board` (`title`, `writer`, `create_dt`, `content`)
        values (%s, %s, %s, %s)
'''

    result = _db.sql_query(query, _title, _writer, _time, _content)

    print(f'DB 서버의 결과 : {result}')

    return redirect('/board')


# 게시글 하나의 정보를 출력하는 주소를 생성
@app.route('/read')
def read():
    # get 방식으로 보낸 데이터를 변수에 저장
    _no = request.args['No']
    print(_no)
    query = '''
        select
        `title`, `writer`, `content`
        from
        `board`
        where
        `No` = %s
    '''

    result = _db.sql_query(query, _no)
    data = result[0] # 데이터가 [{}]로 단 하나만 오기에 list 벗기기 위해 첫번째 원소를 선택하는 것. 이러면 데이터가 {}로 나옴

    print(data)

    return render_template('view_content.html', _data = data)

## Flass Class 안에 있는 함수(웹 서버의 구동)를 호출 (이 코드는 항상 제일 마지막에 배치해야 함)

app.run(debug= True) # 이 환경에서 구동하지 말고 cmd에서 app.py를 python으로 구동하는게 에러가 덜 나옴

                        # 디버깅 모드(저장한 데이터를 바로 서버에 반영)시 run()의 debug 매개변수를 True로 변경

