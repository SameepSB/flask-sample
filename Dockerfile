# syntax=docker/dockerfile:1

FROM python:3.9.2

WORKDIR python-docker

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

COPY . .
ENV FLASK_APP=hello.py
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
