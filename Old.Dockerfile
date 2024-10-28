# # Stage 1 - Build Backend
# FROM python:3.11-slim

# # Install bash
# RUN apt-get update && \ 
#     apt-get install -y curl && \
#     apt-get install -y bash

# # Set the working directory
# WORKDIR /app

# # Copy the current directory contents into the container at /app
# COPY ./app /app

# Stage 2 - Build Frontend
FROM node:20-alpine AS frontend 
COPY ./app/frontend /app/frontend
WORKDIR /app/frontend

RUN yarn install
RUN yarn build

# EXPOSE 5173

# # Run yarn dev to debug
# CMD ["yarn", "dev", "--host", "0.0.0.0"]

# Final Stage - Combine Backend and Frontend
FROM python:3.11-slim

# Install bash
RUN apt-get update && \ 
    apt-get install -y curl && \
    apt-get install -y bash

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY ./app /app

# Set the working directory
WORKDIR /app

# Copy backend and built frontend from previous stages
COPY --from=0 /app /app
COPY --from=frontend /app/frontend/ /app/frontend/

# Install python packages
RUN pip install -r /app/backend/requirements.txt

# Set environment variable
ENV RUNNING_IN_PRODUCTION=true

# Expose port

# set working directory to backend
WORKDIR /app/backend

RUN ls -la /app

EXPOSE 50505

# Start backend
CMD ["python", "-m", "quart", "--app", "main:app", "run", "--port", "50505", "--host", "0.0.0.0", "--reload"]




# Make app/backend directory


# # Use an official Python runtime as a parent image
# FROM python:3.9-slim

# # Install Node.js
# RUN apt-get update && \
#     apt-get install -y curl && \
#     curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
#     apt-get install -y nodejs

# # Install bash
# RUN apt-get install -y bash

# # Set the working directory
# WORKDIR /app

# # Copy the current directory contents into the container at /app
# COPY ./app /app

# # Install azd CLI
# RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# # Load environment variables
# RUN azd env get-values | bash -c 'while read line; do \
#     if [[ $line =~ ([^=]+)=(.*) ]]; then \
#         key=${BASH_REMATCH[1]}; \
#         value=${BASH_REMATCH[2]}; \
#         export $key=$value; \
#     fi \
# done'

# # Create Python virtual environment
# RUN python -m venv .venv

# # Install backend Python packages
# RUN .venv/bin/pip install -r backend/requirements.txt

# # Install frontend npm packages
# WORKDIR /app/frontend
# RUN npm install

# # Build frontend
# RUN npm run build

# # Expose port
# EXPOSE 50505

# # Start backend
# WORKDIR /app/backend
# CMD [".venv/bin/python", "-m", "quart", "--app", "main:app", "run", "--port", "50505", "--host", "0.0.0.0", "--reload"]









# # Stage 1: Build the frontend
# FROM node:20-alpine AS frontend  
# RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app


# WORKDIR /home/node/app 
# COPY ./app/frontend/package.json ./app/frontend/yarn.lock ./  
# USER node
# # RUN yarn install
# # RUN yarn global add typescript
# # RUN yarn global add vite
# COPY --chown=node:node ./app/frontend/ ./frontend  
# COPY --chown=node:node ./app/backend/static/ ./backend/static 
# WORKDIR /home/node/app/frontend
# # RUN NODE_OPTIONS=--max_old_space_size=8192 yarn build

# RUN ls -la /home/node/app

# # Stage 2: Set up the backend
# FROM python:3.11-alpine
# RUN apk add --no-cache --virtual .build-deps \
#     build-base \
#     libffi-dev \
#     openssl-dev \
#     curl \
#     && apk add --no-cache \
#     libpq \
#     && apk add --no-cache \
#     bash \
#     && apk add --no-cache \
#     powershell

# # COPY ./app/backend/requirements.in /usr/src/app/
# # RUN pip install --no-cache-dir -r /usr/src/app/requirements.in \
# #     && rm -rf /root/.cache

# COPY . /usr/src/app/
# # COPY --from=frontend /home/node/app/static/ /usr/src/app/static/
# WORKDIR /usr/src/app
# EXPOSE 80

# RUN ls -la /usr/src/app
# RUN ls -la /usr/src/app/app

# # Set entry point to run start.ps1
# ENTRYPOINT ["pwsh", "./app/start.ps1"]


















# # Stage 1: Build the frontend
# FROM node:20-alpine AS frontend  
# RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

# WORKDIR /home/node/app 
# COPY ./app/frontend/package.json ./app/frontend/yarn.lock ./  
# USER node
# # Uncomment the following lines if you need to build the frontend
# # RUN yarn install
# # RUN yarn global add typescript
# # RUN yarn global add vite
# # COPY --chown=node:node ./app/frontend/ ./frontend  
# # COPY --chown=node:node ./app/backend/static/ ./backend/static 
# # WORKDIR /home/node/app/frontend
# # RUN NODE_OPTIONS=--max_old_space_size=8192 yarn build

# # RUN ls -la /home/node/app

# # Stage 2: Set up the backend
# FROM python:3.11-slim
# RUN apt-get update && apt-get install -y \
#     build-essential \
#     libffi-dev \
#     libssl-dev \
#     curl \
#     libpq-dev \
#     bash \
#     software-properties-common

# # Add Microsoft repository and install PowerShell
# RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
#     && add-apt-repository https://packages.microsoft.com/debian/10/prod \
#     && apt-get update \
#     && apt-get install -y powershell

# # Update pip to the latest version
# RUN pip install --upgrade pip

# COPY ./app/backend/requirements.in /usr/src/app/
# RUN pip install --no-cache-dir -r /usr/src/app/requirements.in \
#     && rm -rf /root/.cache

# COPY . /usr/src/app/
# COPY --from=frontend /home/node/app/static/ /usr/src/app/static/
# WORKDIR /usr/src/app
# EXPOSE 80

# # Set entry point to run start.ps1
# ENTRYPOINT ["pwsh", "start.ps1"]




















# # Stage 1: Build the frontend
# FROM node:20-alpine AS frontend  
# RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

# WORKDIR /home/node/app 
# COPY ./frontend/package.json ./frontend/yarn.lock ./  
# USER node
# RUN yarn install
# RUN yarn global add typescript
# RUN yarn global add vite
# COPY --chown=node:node ./frontend/ ./frontend  
# COPY --chown=node:node ./static/ ./static 
# WORKDIR /home/node/app/frontend
# RUN NODE_OPTIONS=--max_old_space_size=8192 yarn build

# RUN ls -la /home/node/app

# # Stage 2: Set up the backend
# FROM python:3.11-alpine
# RUN apk add --no-cache --virtual .build-deps \
#     build-base \
#     libffi-dev \
#     openssl-dev \
#     curl \
#     && apk add --no-cache \
#     libpq

# COPY requirements.txt /usr/src/app/
# RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt \
#     && rm -rf /root/.cache

# COPY . /usr/src/app/
# COPY --from=frontend /home/node/app/static/ /usr/src/app/static/
# WORKDIR /usr/src/app
# EXPOSE 80

# # CMD ["gunicorn", "-b", "0.0.0.0:80", "app:app"]
# CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "80"]