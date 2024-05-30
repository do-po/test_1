from flask import Flask, render_template, redirect, request

app = Flask(__name__)

@app.route('/')
def choose():
    # return 'hello'
    return render_template('index.html')

@app.route('/select')
def select():
    # args에서 받아오기
    s1 = request.args['select1']
    s2 = request.args['select2']
    return render_template('select.html',
                            select1 = s1,
                            select2 = s2)

app.run(debug=True)