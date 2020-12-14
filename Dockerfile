FROM python:3-slim

COPY . /app
COPY main.py /main.py

CMD ["python", "/main.py"]