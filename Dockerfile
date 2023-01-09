FROM python:3-slim

COPY requirements.txt  /requirements.txt 
RUN pip install -r requirements.txt --no-cache-dir


COPY . /app
COPY main.py /main.py

CMD ["python", "/main.py"]