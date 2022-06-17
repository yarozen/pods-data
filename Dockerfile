FROM python
WORKDIR /usr/app
COPY app.py .
RUN pip install -r requirements.txt
CMD [ "python", "app.py" ]