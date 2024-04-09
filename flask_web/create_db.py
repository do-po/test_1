## 데이터 베이스에 테이블을 생성하는 쿼리문들을 모아서 저장

import database

# 서버 정보를 입력 (Class 생성)

_db = database.MyDB() # 매개변수 없다면 내 컴퓨터에 접속하겠다는 의미였어

## 게시판 테이블을 생성하는 쿼리문을 작성

board_create = '''
    create table
    if not exists
    `board`(
        `No` int primary key auto_increment,
        `title` text not null,
        `writer` varchar(32) not null,
        `create_dt` varchar(64) not null,
        `content` text
    )
'''

result = _db.sql_query(board_create)

print(result)