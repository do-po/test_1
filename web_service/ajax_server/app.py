from flask import Flask, request, render_template
from random import choice

app = Flask(__name__)

# index.html를 보여주는 api 생성
@app.route('/')
def index():
    return render_template('index.html')


# form 태그를 이용한 데이터를 받는 api

@app.route('/data')
def data():
    # get 방식으로 들어온 데이터를 확인
    req = request.args
    print("form 태그를 이용한 요청 메시지 : ", req)
    return "hungry!" # return 없으면 에러나서 빈 텍스트 하나 리턴하는 것

# ajax 태그를 이용해 데이터를 받는 api

@app.route('/ajax_data')
def ajax_data():
    # get 방식으로 들어온 데이터를 확인
    req = request.args
    print("ajax를 이용한 요청 메시지 : ", req)
    return "hungry?"

@app.route('/game')
def game():
    return render_template('game.html')

# /game_result [post] api 생성

@app.route('/game_result', methods=['post'])
def game_result():
    # 유저가 보낸 데이터를 변수에 저장
    _user = request.form['user']
    print("유저가 선택한 데이터 : ", _user)
    
    # 서버도 가위/바위/보 셋 중 하나를 랜덤하게 선택

    _list = ['가위', '바위', '보']
    # 여기 choice는 random.choice야
    _server = choice(_list)
    print("서버가 선택한 데이터 : ", _server)



    # 가위바위보의 승 무 패를 리턴
    # 승부의 결과를 조건문으로 작성 (if문 반복 사용시)


    # if _user == _server:
    #     result = '무승부'
    
    # else:
    #     if _user == '가위':
    #         if _server == '바위':
    #             result = '패배'
    #         else:
    #             result = '승리'

    #     elif _user == '바위':
    #         if _server == '보':
    #             result = '패배'
    #         else:
    #             result = '승리'

    #     else:
    #         if _server == '가위':
    #             result = '패배'
    #         else:
    #             result = '승리'

    # 승부의 결과를 조건문으로 작성 (dict에서의 key - value 사용시)
    game_table = {
        '가위' : {
            '바위' : '패배',
            '보' : '승리'
        },
        '바위' : {
            '보' : '패배',
            '가위' : '승리'
        },
        '보' : {
            '가위' : '패배',
            '바위' : '승리'
        }
    }

    if _user == _server:
        result = '무승부'
    else:
        result = game_table[_user][_server]

    

    # ajax 통신에서 결과값의 타입 == json
    # return 데이터를 dict 형태로 되돌려준다 (_user, _server, result 모두 return 하기 위해)
    return_data = {
        'user' : _user,
        'server' : _server,
        'result' : result
    }

    return return_data


@app.route('/game_result2')
def game_result2():
        # 유저가 보낸 데이터를 변수에 저장
        # html에서 dict 형태로 전송하는데 key 값은 name인 'g2'로 보내기 때문에 key 값을 넣어서 value 찾아야 함
    _user = request.args['g2']
    print("유저가 선택한 데이터 : ", _user)
    
    # 서버도 가위/바위/보 셋 중 하나를 랜덤하게 선택

    _list = ['가위', '바위', '보']
    # 여기 choice는 random.choice야
    _server = choice(_list)
    print("서버가 선택한 데이터 : ", _server)

    game_table = {
        '가위' : {
            '바위' : '패배',
            '보' : '승리'
        },
        '바위' : {
            '보' : '패배',
            '가위' : '승리'
        },
        '보' : {
            '가위' : '패배',
            '바위' : '승리'
        }
    }

    if _user == _server:
        result = '무승부'
    else:
        result = game_table[_user][_server]

    return result



app.run(debug=True)