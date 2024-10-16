# syntax=docker/dockerfile:1
FROM python:3.10-alpine
WORKDIR /code
COPY requirements.txt .
COPY LAB5_2/ .
RUN python3 -m venv ./LAB5_2
RUN pip install -r requirements.txt
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
RUN apk add --no-cache gcc musl-dev linux-headers
EXPOSE 5000
COPY . .
CMD ["flask", "run", "--debug"]
