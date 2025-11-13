# tiny, production-ish python image

FROM python:3.11-slim

WORKDIR /app

# avoid caching issues
COPY requirments.txt .
RUN python -m pip install --upgrade pip && pip install -r requirments.txt

COPY . .

ENV PORT=8080
EXPOSE 8080

# use gunicorn for production

CMD [ "python", "app.py" ]