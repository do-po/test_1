from flask import Flask, request, render_template
import database as db

app = Flask(__name__)

@app.route("/")
def index():
    return render_template('main.html')

@app.route('/submit', methods=['post'])
def second():
    num1 = request.form['num1']
    num2 = request.form['num2']
    etc = request.form['etc']
    # print(num1, num2, etc)
    _db = db.MyDB1()
    sql = """
        insert into research(num1, num2, etc) values (%s, %s, %s)
    """
    if etc == "":
        etc = "없음"
    try:
        _db.sql_query(sql, num1, num2, etc)
        return "제출완료"
    except:
        return "에러"



app.run(host = '0.0.0.0', port=8080)