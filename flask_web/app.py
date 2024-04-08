## 기본적인 웹서버 설정
## flask 웹프레임 워크를 로드

from flask import Flask

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
    return 'Hello World'

## 주소를 생성
## localhost:5000/second 라고 요청이 들어온다면 

@app.route('/second')
def second():
    return 'Second Page'


## Flass Class 안에 있는 함수(웹 서버의 구동)를 호출 (이 코드는 항상 제일 마지막에 배치해야 함)

app.run() # 이 환경에서 구동하지 말고 cmd에서 app.py를 python으로 구동하는게 에러가 덜 나옴

