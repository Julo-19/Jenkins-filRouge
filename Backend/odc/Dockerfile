FROM python:3.13-slim
EXPOSE 8000
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt
CMD [ "gunicorn", "--bind", "0.0.0.0:8000", "odc.wsgi:application" ]
