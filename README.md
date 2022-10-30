# Docker_Django_uWSGI_Sample
Docker + Django + Nginx + uWSGI + MySQL

1. docker-compose.ymlと同じ階層に「.env」ファイルを作成し記述


2. プロジェクトを新規作成
```
# 例：
docker compose run django django-admin startproject [プロジェクト名] .
```


3. settings.pyを編集
```
# osのモジュールをインポート
import os

# SECRET_KEYを.envから取得
SECRET_KEY = os.environ.get("SECRET_KEY")

# DEBUGを.envから取得
DEBUG = os.environ.get("DEBUG")

# ALLOWED_HOSTSを.envから取得
ALLOWED_HOSTS = os.environ.get("DJANGO_ALLOWED_HOSTS").split(" ")

# MySQLのパラメータを.envから取得
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        # コンテナ内の環境変数をDATABASESのパラメータに反映
        "NAME": os.environ.get("MYSQL_DATABASE"),
        "USER": os.environ.get("MYSQL_USER"),
        "PASSWORD": os.environ.get("MYSQL_PASSWORD"),
        "HOST": os.environ.get("MYSQL_HOST"),
        "PORT": os.environ.get("MYSQL_PORT"),
    }
}

# 言語を日本語に設定
LANGUAGE_CODE = 'ja'
# タイムゾーンをAsia/Tokyoに設定
TIME_ZONE = 'Asia/Tokyo'

# STATIC_ROOTを設定
# Djangoの管理者画面にHTML、CSS、Javascriptが適用されます
STATIC_ROOT = "/static/"
STATIC_URL = "/static/"


# [・・・]

TEMPLATES = [
    {
     ....
        'DIRS': [os.path.join(BASE_DIR, 'templates')],
     ....
]

```


4. 下記コマンドを実行する
```
docker compose up -d
```

* ブラウザで確認
http://localhost:8000


5. DBのマイグレーション
```
./.migration.sh
```


6. 管理者アカウントの作成
  * 入力を求められるのでメッセージ従い入力
```
docker compose exec django ./manage.py createsuperuser
```
* ブラウザで確認
http://localhost:8000/admin


7. CSSを反映する
```
docker compose exec django ./manage.py collectstatic --noinput
```


8. 一旦Dockerをリセットする
```
docker compose down -v

docker rm $(docker ps -a -q)

docker rmi $(docker images -q)

docker system prune

```


9. Dockerを起動
```
docker compose up -d --build
```


10. Django_App内でDjangoアプリを開発して行く

* 本番環境設定

11. docker-compose.prod.ymlの編集
```
uwsgi --socket :8000 --module [アプリ名].wsgi --py-autoreload 1 --logto /tmp/mylog.log
```


12. [wsgi.ini]作成編(記述途中)
* /<プロジェクト名>/uwsgi.iniを作成する
```
[uwsgi]
chdir            = /home/www-user/<プロジェクト名>
module           = <プロジェクト名>.wsgi:application
pidfile          = /run/<プロジェクト名>/<プロジェクト名>.pid
socket           = /run/<プロジェクト名>/<プロジェクト名>.sock
home             = /home/www-user/<プロジェクト名>/.venv
daemonize        = /home/www-user/<プロジェクト名>/<プロジェクト名>.log
uid              = www-user
gid              = www-users

master           = true
processes        = 5
harakiri         = 30
max-requests     = 5000
vacuum           = true

disable-logging  = true
log-4xx          = false
log-5xx          = true

env DJANGO_SETTINGS_MODULE = <プロジェクト名>.settings
```



13. 本番環境で立ち上げ
```
docker compose -f docker-compose.prod.yml up -d --build
```


* ブラウザで確認
http://localhost


14. Dockerの停止・削除
```
docker compose down -v

docker stop nginx

docker rm $(docker ps -a -q)

docker rmi $(docker images -q)

docker system prune

```