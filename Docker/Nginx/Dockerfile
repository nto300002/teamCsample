FROM nginx:1.21-alpine

# ローカルのdefault.confをコンテナにコピー
COPY Docker/Nginx/conf /etc/nginx/conf.d
COPY Docker/Nginx/uwsgi_params /etc/nginx/uwsgi_params