FROM python:3.6

RUN apt-get -yqq update && apt-get -y clean
RUN echo 1