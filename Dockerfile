FROM mcr.microsoft.com/playwright:v1.27.0-focal

RUN apt-get update && apt-get upgrade -y
RUN sudo apt install python3.11
RUN pip install robotframework
RUN pip install rpaframework
RUN pip install robotframework-browser
