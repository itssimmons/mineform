#!/bin/bash

# Download PaperMC 1.20.4
PAPER_VERSION="1.20.4"
PAPER_API="https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}"

echo "Fetching latest build for Paper ${PAPER_VERSION}..."

# Get the latest build number
LATEST_BUILD=$(curl -s "${PAPER_API}" | grep -o '"builds":\[[^]]*\]' | grep -o '[0-9]\+' | tail -n 1)

if [ -z "$LATEST_BUILD" ]; then
    echo "Error: Could not fetch the latest build number."
    exit 1
fi

echo "Latest build: ${LATEST_BUILD}"

# Construct the download URL
DOWNLOAD_URL="https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds/${LATEST_BUILD}/downloads/paper-${PAPER_VERSION}-${LATEST_BUILD}.jar"

echo "Downloading Paper ${PAPER_VERSION} build ${LATEST_BUILD}..."

curl -o "paper-${PAPER_VERSION}-${LATEST_BUILD}.jar" "${DOWNLOAD_URL}"

if [ $? -eq 0 ]; then
    echo "Download complete: paper-${PAPER_VERSION}-${LATEST_BUILD}.jar"
else
    echo "Error: Download failed."
    exit 1
fi
