from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time
import os
from bs4 import BeautifulSoup as bs
import pandas as pd
import requests

# Chrome으로 실행

driver = webdriver.Chrome()
time.sleep(1)

# 네이버에서 탐색

driver.get('https://m.naver.com')
time.sleep(1)

# 네이버 검색창 element 설정 후 클릭

element = driver.find_element(By.ID, 'MM_SEARCH_FAKE')
element.click()
time.sleep(1)

# 검색창에 '구로디지털역 맛집' 검색

element2 = driver.find_element(By.ID, 'query')
element2.send_keys('구로디지털역 맛집')
search_element = driver.find_element(By.XPATH, '//*[@id="sch_w"]/div/form/button')
search_element.click()
time.sleep(3)

# 검색결과에서 지도 주소로 이동

map_element = driver.find_element(By.XPATH, '//*[@id="place-main-section-root"]/div/div[2]/a')
map_element.click()
time.sleep(2)

# 지도 화면에서 목록보기 클릭

list_button = driver.find_element(By.XPATH, '//*[@id="_place_portal_root"]/div/a')
list_button.click()
time.sleep(2)

# 검색할 가게 선택

store = driver.find_element(By.CLASS_NAME, 'TYaxT')
store.click()
time.sleep(2)

# 가게의 리뷰 탐색

review_button = driver.find_elements(By.XPATH, """//*[contains(text(), '리뷰')]""")
review_button[2].click()
time.sleep(2)

# 리뷰 더보기 클릭

more_button = driver.find_element(By.CLASS_NAME, 'fvwqf')

# 더보기 수(n) == range(n)

for i in range(2):
    more_button.click()
    # 1초 대기
    time.sleep(1)

# 현재 화면의 html 파싱

soup = bs(driver.page_source, 'html.parser')

# html 파싱하여 가져왔기에 웹 브라우저 종료

driver.close()

# html 구문들 중 li 태그중 class가 owAeM인 모든 태그를 찾는다.

li_list = soup.find_all('li', attrs={
    'class' : 'owAeM'
})

# 리뷰글을 저장할 빈 리스트 생성

reviews = []

# 저장할 사진의 파일명을 1씩 증가시키기 위해 생성한 변수

i = 1

# 이미지를 저장하는 함수를 생성

def image_save(img_path, save_path, file_name):
    html_data = requests.get(img_path)
    imageFile = open(
        os.path.join(
            save_path,
            file_name
        ),
        'wb' # ??
    )

    # 이미지 데이터의 크기 설정

    # 이미지 데이터의 크기 == chunk_size

    chunk_size = 100000000 # 크기 기준은 byte
    for chunk in html_data.iter_content(chunk_size): # ???
        imageFile.write(chunk)
        imageFile.close()
    print('파일 저장 완료')

for li_data in li_list:
    review_data = li_data.find('span', attrs={
    'class' : 'zPfVt'
    }).get_text()

    reviews.append(review_data)

    # 프로필 사진을 제외한 구역의 이미지를 가져오기 위해 filter

    div_data = li_data.find('div', attrs={
        'class' : 'VAvOk'
    })

    try:

        # list_data에서 이미지 주소를 모두 출력
        img_list = div_data.find_all('img')

        # 저장할 파일 이름 == f'name_{file_number}.extention

        for img in img_list:
            file_name = f'review_{i}.png'
            save_path = './img/'
            image_save(img_path= img['src'], save_path= save_path, file_name= file_name)
            i += 1

    except:
        continue


data = pd.Series(reviews)

# 리뷰글들을 파일로 저장
    # 파일 이름  == data.to_csv('name.extension)

data.to_csv('reviews.csv')

