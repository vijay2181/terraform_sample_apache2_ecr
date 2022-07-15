FROM ubuntu
MAINTAINER vijay
RUN apt update
RUN apt install -y  apache2
RUN apt install  apache2-utils
RUN echo "Hi there, Iam a GEEK" | tee /var/www/html/index.html
RUN apache2ctl start
RUN apt clean
EXPOSE 80
CMD apachectl -D FOREGROUND
