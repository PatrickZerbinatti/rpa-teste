FROM mcr.microsoft.com/playwright:v1.27.0-focal

RUN apt-get update && apt-get upgrade -y
RUN apt-get install python 3.11
RUN pip install robotframework
RUN pip install rpaframework
RUN pip install robotframework-browser
