from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import pandas as pd
import os 
from dotenv import load_dotenv
import requests
from konlpy.tag import Okt
import time

load_dotenv()

# 이미지를 저장하는 함수를 생성

def image_save(img_path, save_path, file_name):
    html_data = requests.get(img_path)
    imageFile = open(
        os.path.join(
            save_path,
            file_name
        ),
        'wb' # write binary, open 함수의 mode를 쓰기 모드로 설정 해 주는 것.
    )

    # 이미지 데이터의 크기

    chunk_size = 100000000 # 크기 기준은 byte
    for chunk in html_data.iter_content(chunk_size): # html 응답 데이터를 조각(chunk) 단위로 반복적으로 읽어오는 함수
        imageFile.write(chunk)
        imageFile.close()
    print('파일 저장 완료')

def search_insta(_text):
    # _text == instagram에서 검색어를 인자값으로 저장하는 변수
    
    # 웹 브라우져를 실행 
    driver = webdriver.Chrome()

    ## 인스타그램에 요청 
    driver.get('https://www.instagram.com')

    # 대기 10초
    driver.implicitly_wait(10)
    
    # 10초로 안될 것 같아서 강제 1초 휴식 
    time.sleep(1)
    
    # 인스타그램에 로그인 
    id_element = driver.find_element(
        By.CSS_SELECTOR, 
        'input[name="username"]')
    # id_element에 아이디 값(.env에 있는 id)을 입력 
    id_element.send_keys(os.getenv('id'))
    pass_element = driver.find_element(
        By.CSS_SELECTOR, 
        'input[name="password"]'
    )
    # pass_element에 패스워드(.env에 있는 password)를 입력
    pass_element.send_keys(os.getenv('password'))
    # implicitly_wait() : html, css 정보가 모두 로드가 되면 시간에 무관하게 다음 코드가 실행
    # 입력한 시간이 초과될때 로드가 전부 안되어있으면 에러 발생
    driver.implicitly_wait(10)
    pass_element.send_keys(Keys.ENTER)

    # svg 태그 중 aria-label="검색" 인 태그를 선택
    driver.implicitly_wait(10)
    search_element = driver.find_element(By.CSS_SELECTOR, 
                                        'svg[aria-label="검색"]')
    # search_element를 클릭
    search_element.click()

    driver.implicitly_wait(10)
    # 검색창에 input 태그를 선택
    search_input = driver.find_element(By.CSS_SELECTOR, 
                                    'input[aria-label="입력 검색"]')
    # search_input에 특정 문자열을 입력
    search_input.send_keys(_text)

    driver.implicitly_wait(10)
    
    # 10초로 되지 않을 것 같아 강제로 1초 휴식
    
    time.sleep(1)
    ## 검색 리스트 전체를 검색
        # CSS_SELECTOR == .~~ .~~ tag 구분을 .으로 하고 태그 안의 태그를 찾는 경우 사이에 공백을 둔다.
    list_element = driver.find_elements(
        By.CSS_SELECTOR, 
        '.x9f619.x78zum5.xdt5ytf.x1iyjqo2.x6ikm8r.x1odjw0f.xh8yej3.xocp1fn .x1i10hfl'
    )
    # print(len(list_element))
    
    # 검색 리스트에서 첫번째를 클릭 
    list_element[0].click()

    # insta가 막으면 새로고침해서 뚫기 위한 코드
    driver.implicitly_wait(10)
    time.sleep(1)
    driver.refresh()

    driver.implicitly_wait(10)
    
    ## 게시글 링크를 모두 찾는다. 
    imgs = driver.find_elements(
        By.CLASS_NAME, '_aagw'
    )
    # 게시글의 첫번째를 클릭 
    imgs[0].click()

    # data를 저장할 공간 생성
    data = {
        'ID' : [], 
        'Commet' : []
    }

    driver.implicitly_wait(20)

    # n개의 게시글에서 크롤링

    for i in range(3):
        # 다음 버튼이 존재하지 않으면 ? -> 에러 발생 
        # try 구문을 이용하여 에러 발생시 print로 출력
        try:
            driver.implicitly_wait(20)
            # ids = driver.find_elements(By.CLASS_NAME, '_a9zc')
            # commets = driver.find_elements(By.CLASS_NAME, '_a9zs')
            ids = driver.find_elements(By.CSS_SELECTOR, 
                                    'h2[class="_a9zc"]')
            ids.extend(
                driver.find_elements(By.CSS_SELECTOR, 
                                    'h3[class="_a9zc"]')
            )
            commets = driver.find_elements(By.CSS_SELECTOR, 
                                        'div[class="_a9zs"]')
            
             # 이미지를 저장
                # _aa20 없애도 되는건 겹치는 태그들을 선택해도 되는건데 _aa20이 없는 이미지에서 _aa20 태그를 있는 조건으로 뽑으려다보니 error 생기는 것임
            img_element = driver.find_element(By.CSS_SELECTOR,
                                            '._aagu._aato ._aagv .x5yr21d.xu96u03.x10l6tqk.x13vifvy.x87ps6o.xh8yej3')
            # 해당하는 이미지 태그에서 src 속성의 값을 출력
            img_src = img_element.get_attribute('src')
            # print(img_src)

            image_save(img_src,
                    './',
                    f'{_text}_{i}.png')


            # print(len(ids))
            # print(len(commets))

            for id, commet in zip(ids, commets):
                data['ID'].append(id.text)
                data['Commet'].append(commet.text.replace('\n', ' '))
            next_element = driver.find_element(By.CSS_SELECTOR, 
                                            '._aaqg ._abl-')
            next_element.click()
        except:
            print('다음 버튼이 존재하지 않거나 에러 발생')
            # 이미지가 아닌 비디오가 올라와 있을 때 다음 이미지로 넘어가기 위한 버튼
            next_element = driver.find_element(By.CSS_SELECTOR, '._aaqg ._abl-')
            next_element.click()
    # 게시물을 닫아준다. 
    close_element = driver.find_element(By.CSS_SELECTOR, 
                                        'svg[aria-label="닫기"]')
    close_element.click()
    df = pd.DataFrame(data)

    # 문자에서 형태소를 분석하는 class
    okt = Okt()

    # for 반복문을 이용 (map 사용하게 되면 함수 속 함수 정의가 되어서 for 사용)

    col_data = []

    for i in range(len(df)):
        nouns = okt.nouns(df.loc[i, 'Commet'])
        if nouns:
            words = [n for n in nouns if len(n) > 1]
        else:
            words = ''
        col_data.append(words)
        
    df['words2'] = col_data

    df.to_csv(f'{_text}.csv', index=  False)

    # 웹 브라우저 종료

    driver.close()
    