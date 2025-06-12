FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir torch==2.7.0+cpu --extra-index-url https://download.pytorch.org/whl/cpu

COPY . .

CMD [ "gunicorn", "--bind", "0.0.0.0:5000", "app:app" ]