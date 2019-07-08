#!/bin/bash

GECKODRIVER_VERSION=${1:-v0.24.0}
FIREFOX_VERSION=${2:-67.0.4}
CHROMEDRIVER_VERSION=${3:-75.0.3770.90}
CHROME_VERSION=${4:-75.0.3770.80}

REPO="ermescs/chrome-firefox-selenium-headless:firefox${FIREFOX_VERSION}-chrome${CHROME_VERSION}"
echo "Building '${REPO}'"

docker build --pull \
    --build-arg GECKODRIVER_VERSION=${GECKODRIVER_VERSION} \
    --build-arg FIREFOX_VERSION=${FIREFOX_VERSION} \
    --build-arg CHROMEDRIVER_VERSION=${CHROMEDRIVER_VERSION} \
	--build-arg CHROME_VERSION=${CHROME_VERSION} \
    -t $REPO .

read -p "Do you want to push '${REPO}' to the Docker public registry? [yN] " answer
case $answer in
    [yY] )
        docker push ${REPO}
        ;;
    * )
        ;;
esac