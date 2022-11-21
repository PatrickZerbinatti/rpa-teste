FROM mcr.microsoft.com/playwright:v1.27.0-focal

RUN apt-get update && apt-get install -y python3-pip unzip wget curl -y
RUN apt install -y build-essential libssl-dev libffi-dev python3-dev
RUN pip install -U pip
RUN pip install robotframework
RUN pip install rpaframework
RUN pip install robotframework-browser
