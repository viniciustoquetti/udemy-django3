FROM python:3.8.5
LABEL MAINTAINER="Rodrigo Cunha <rodrigo.cunha@usp.br>"

RUN apt-get update && \
apt-get upgrade -y

RUN apt-get install bash

ENV GROUP_ID=1000 \
    USER_ID=1000

WORKDIR /code/

ADD requirements.txt /code/
RUN pip install --upgrade pip setuptools
RUN pip install -r requirements.txt

RUN addgroup --gid $GROUP_ID django
RUN adduser --uid $USER_ID --ingroup django --shell /bin/bash django
RUN usermod -aG 100 django

USER django

WORKDIR /home/django

EXPOSE 8000
# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
