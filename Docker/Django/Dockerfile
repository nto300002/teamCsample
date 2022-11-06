# Pythonのイメージを指定
FROM python:3.10.7-buster

# PYTHONDONTWRITEBYTECODEとPYTHONUNBUFFEREDはオプション
# pycファイル(および__pycache__)の生成を行わないようにする
ENV PYTHONDONTWRITEBYTECODE=1
# 標準出力・標準エラーのストリームのバッファリングを行わない
ENV PYTHONUNBUFFERED=1
# コンテナにcodeワークディレクトリを作成
RUN mkdir /code
# コンテナのワークディレクトリを/codeに指定
WORKDIR /code

# # [wsgi.ini]作成編(記述途中)
# COPY Docker/Django/ex /code/
# RUN chmod +x wsgi.sh
# RUN ./wsgi.sh

# ローカルのrequirements.txtをコンテナの/codeフォルダ直下に置く
COPY requirements.txt /code/
# コンテナ内でpip install -r requirements.txtを実行
RUN pip install -U pip && \
    pip install -r requirements.txt
# ソースコードをコンテナにコピー
COPY . /code/