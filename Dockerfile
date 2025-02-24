FROM python:3.11-buster AS builder

WORKDIR /app
RUN pip install --upgrade pip && pip install poetry
COPY pyproject.toml /app
COPY poetry.lock /app
RUN poetry config virtualenvs.create false \
&& poetry install --no-root --no-interaction --no-ansi

FROM python:3.11-buster AS app
COPY --from=builder /usr /usr
COPY --from=builder /app /app
WORKDIR  /app
EXPOSE 8000
COPY entrypoint.sh /app
ENTRYPOINT ["./entrypoint.sh"]
CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]