FROM python:3.11

ARG APP_HOME=/app

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN mkdir $APP_HOME
WORKDIR ${APP_HOME}

COPY ./requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY . $APP_HOME

WORKDIR ${APP_HOME}/sampleapp

RUN python manage.py migrate
RUN python manage.py collectstatic

CMD [ "gunicorn", "sampleapp.wsgi:application", "--config", "sampleapp/gunicorn_config.py" ]
