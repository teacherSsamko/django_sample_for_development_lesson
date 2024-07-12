#!/bin/bash

cd /home/lion/django_sample_for_development_lesson/sampleapp
gunicorn -c sampleapp/gunicorn_config.py sampleapp.wsgi:application
