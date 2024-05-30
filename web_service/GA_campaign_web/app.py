# 필요한 라이브러리 로드

from flask import Flask, render_template, request

app  = Flask(__name__)

@app.route('/')
def link_page():
    return render_template('link_page.html')

@app.route('/test')
def test():
    utm_source = request.args['utm_source']
    utm_campaign = request.args['utm_campaign']
    utm_medium = request.args['utm_medium']
    tempGald = request.args['tempGald']

    return render_template('test.html')






# 웹페이지를 실행

app.run(debug=True)