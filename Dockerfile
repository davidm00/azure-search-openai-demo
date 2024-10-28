# # Stage 1 - Build Frontend
# FROM node:18-alpine AS frontend

# RUN mkdir -p /app/frontend/node_modules && chown -R node:node /app/frontend
# RUN mkdir -p /app/backend && chown -R node:node /app/backend

# COPY ./app/frontend/package.json ./app/frontend/yarn.lock ./app/frontend
# COPY ./app/backend/requirements.txt ./app/backend

# RUN ls -la 

# USER node
 
# COPY --chown=node:node ./app/ ./app/ 

# WORKDIR /app/frontend

# RUN yarn install
# RUN NODE_OPTIONS=--max_old_space_size=8192 yarn build

# Stage 2 - Build Backend
FROM python:3.11-slim

RUN apt-get update && \ 
    apt-get install -y curl && \
    apt-get install -y bash && \
    apt-get install -y npm

RUN ls -la .

# COPY --from=frontend /app /app
COPY ./app /app

RUN pip install --no-cache-dir -r ./app/backend/requirements.txt \
    && rm -rf /root/.cache

WORKDIR /app/frontend
RUN npm install
RUN npm run build

ENV RUNNING_IN_PRODUCTION=true

# Expose port
EXPOSE 50505

WORKDIR /app/backend

# Debugging steps
RUN ls -la /app 
RUN ls -la /app/frontend 
RUN ls -la /app/backend
RUN ls -la /app/backend/static


# Start backend
CMD ["python", "-m", "quart", "--app", "main:app", "run", "--port", "50505", "--host", "0.0.0.0", "--reload"]

