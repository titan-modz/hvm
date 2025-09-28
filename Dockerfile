FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /usr/src/app

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential gcc libpq-dev curl \
    && rm -rf /var/lib/apt/lists/*

COPY hvm/requirements.txt ./hvm/requirements.txt
COPY requirements.txt ./requirements.txt

RUN pip install --upgrade pip setuptools wheel
RUN if [ -f "./hvm/requirements.txt" ]; then pip install -r ./hvm/requirements.txt; elif [ -f "./requirements.txt" ]; then pip install -r ./requirements.txt; fi

COPY . .

RUN useradd --create-home appuser || true
RUN chown -R appuser:appuser /usr/src/app
USER appuser

ARG PORT
ENV PORT=${PORT:-3000}
EXPOSE ${PORT}

RUN chmod +x ./start.sh

CMD ["./start.sh"]
