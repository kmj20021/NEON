import mariadb

def get_conn():
    try:
        print("연결성공!")
        return mariadb.connect(
            user="minje",
            password="minje",
            host="localhost",
            port=3306,
            database="neon"
        )
    except mariadb.Error as e:
        print(f"연결실패: {e}")