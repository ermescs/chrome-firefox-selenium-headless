FROM ubuntu:bionic

ARG GECKODRIVER_VERSION=v0.24.0
ARG FIREFOX_VERSION=67.0.4
ARG CHROMEDRIVER_VERSION=75.0.3770.90
ARG CHROME_VERSION=75.0.3770.80


RUN apt-get update && apt-get install -y \
    python3 python3-pip \
    fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 \
    libnspr4 libnss3 lsb-release xdg-utils libxss1 libdbus-glib-1-2 \
    curl unzip wget \
    xvfb


# install geckodriver and firefox

RUN wget https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
    tar -zxf geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz -C /usr/local/bin && \
    chmod +x /usr/local/bin/geckodriver && \
    rm geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz


RUN FIREFOX_SETUP=firefox-setup.tar.bz2 && \
    apt-get purge firefox && \
    wget -O $FIREFOX_SETUP "http://ftp.mozilla.org/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2" && \
    tar xjf $FIREFOX_SETUP -C /opt/ && \
    ln -s /opt/firefox/firefox /usr/bin/firefox && \
    rm $FIREFOX_SETUP


# install chromedriver and google-chrome

RUN wget https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip -d /usr/bin && \
    chmod +x /usr/bin/chromedriver && \
    rm chromedriver_linux64.zip


RUN VERSION=`echo $CHROME_VERSION | cut -d'.' -f1` && \
    if [ $VERSION -lt 69 ] ; then CHROME_FILE=lnx%2Fchrome64_$CHROME_VERSION.deb ; else CHROME_FILE=files%2F$CHROME_VERSION%2Fgoogle-chrome-stable_current_amd64.deb ; fi && \
    CHROME_SETUP=google-chrome.deb && \
    wget -O $CHROME_SETUP "https://www.slimjet.com/chrome/download-chrome.php?file=$CHROME_FILE" && \
    apt-get --assume-yes install ./$CHROME_SETUP && \
    rm $CHROME_SETUP


RUN pip3 install selenium
RUN pip3 install pyvirtualdisplay

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONUNBUFFERED=1
