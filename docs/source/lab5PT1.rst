
==========================================
Lab 5: Docker Compose Flask and Redis Exercise
==========================================

This is the documentation for the CNIT 48101 Lab 5 "Docker Compose" Flask and Redis Exercise Created by Jacob Bauer & Nick Kuenning


Section 1 (Flask and Redis Exercise)
####################################

In this lab docker composed was used to create a python flask application (app.py) to be used with docker-compose. First a Dockerfile was created to create the container to run the python flask application. This Dockerfile used a python:alpine image to build upon and installed some pip modules (requirements.txt) upon buildtime. A virtual envrionment of Python3 was created within the container to be used by the python application. A compose.yaml file was also created to use with docker-compse to define two services (web and redis). After succesful testing of the app a openweather api was added to the app at the /weather route to show weather data on the webpage. Finally, a infra.yaml was created to split up the redis container from the web container and into seperate files.

The Dockerfile

.. code-block:: Docker

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


The App.py File

.. code-block:: python

    import time
    import requests
    import redis
    from flask import Flask
    
    app = Flask(__name__)
    cache = redis.Redis(host='redis', port=6379)
    
    def get_hit_count():
        retries = 5
        while True:
            try:
                return cache.incr('hits')
            except redis.exceptions.ConnectionError as exc:
                if retries == 0:
                    raise exc
                retries -= 1
                time.sleep(0.5)
    
    
    @app.route('/')
    def hello():
        count = get_hit_count()
        return 'Hello from Docker! I have been seen {} times.\n'.format(count)
    
    @app.route('/weather')
    def get_weather():
        api_key = "93a15b1668a3dbe03afe5a5fbf693237"
        city = "Chicago"
        url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}"
        response = requests.get(url)
        return response.json()

The Compose.yaml File

.. code-block:: yaml

    include:
        - infra.yaml
    services:
        web:
        build: .
        ports:
            - "8000:5000"
        develop:
            watch:
            - action: sync
                path: .
                target: /code
        redis:
        image: "redis:alpine"

The Infra.yaml File

.. code-block:: yaml
  
  services:
    redis:
      image: "redis:alpine"
  
