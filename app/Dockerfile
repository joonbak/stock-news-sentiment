FROM python:3.10-slim

WORKDIR /app

ADD . /app

RUN pip install -r requirements.txt

COPY . .

CMD [ "python", "app.py" ]