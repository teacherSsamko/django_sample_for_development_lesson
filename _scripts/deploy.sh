#!/bin/bash

echo "start to clone"
git clone https://github.com/teacherSsamko/django_sample_for_development_lesson.git
cd django_sample_for_development_lesson

echo "start to install venv"
sudo apt install -y python3.8-venv

echo "start to create venv"
python3 -m venv venv

echo "start to activate venv"
source venv/bin/activate

echo "start to install requirements"
pip install -r requirements.txt

echo "start to runserver"
cd sampleapp && python manage.py runserver 0.0.0.0:8000
