FROM python:3.7.3-slim

# Install Pipenv
RUN pip install pipenv==2018.11.26
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# Install dependencies
COPY Pipfile Pipfile
COPY Pipfile.lock Pipfile.lock

RUN pipenv install --deploy --system
RUN pip install gunicorn==19.9.0

COPY ./src /src
WORKDIR /src

RUN useradd -ms /bin/bash worker
RUN chown -R worker:worker /src
USER worker

EXPOSE 5000

CMD ["gunicorn", "-c", "gunicorn.ini", "wsgi:app"]