# Mental backend image (stateless Examiner service).
#   docker build -f backend/Dockerfile -t mental-backend .
# (On Railway: set the Dockerfile path to backend/Dockerfile, root context.)
FROM python:3.12-slim

WORKDIR /app/backend

COPY backend/requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY backend/app app
ENV PYTHONUNBUFFERED=1

# $PORT is provided by most hosts (Railway/Render); default to 8000 locally.
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}"]
