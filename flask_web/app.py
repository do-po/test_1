## 기본적인 웹서버 설정
## flask 웹프레임 워크를 로드

from flask import Flask, render_template, request, redirect
## module 로드
import database

## Flask라는 Class 생성

## 생성자 함수 필수 인자 == 파일의 이름 (app.py)
## __name__ == 현재 파일의 이름


app = Flask(__name__) # 현재 파일의 이름을 인자로 받음

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

    # _id가 'test'이고 _pass가 '1234'라면 로그인 성공 메시지 리턴
    if (_id == 'test') & (_pass == '1234'):
        return '로그인 성공'
    # 아니라면 로그인 페이지 (/second)로 돌아간다.
    else: 

        return redirect('/second')



## Flass Class 안에 있는 함수(웹 서버의 구동)를 호출 (이 코드는 항상 제일 마지막에 배치해야 함)

app.run(debug= True) # 이 환경에서 구동하지 말고 cmd에서 app.py를 python으로 구동하는게 에러가 덜 나옴
