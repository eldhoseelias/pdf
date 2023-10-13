
FROM node:18.14.0-buster-slim
# We don't need the standalone Chromium
ENV DEBUG puppeteer:*
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
#RUN /bin/bash -c "adduser --disabled-password --gecos '' myuser "

# Install Google Chrome Stable and fonts
# Note: this installs the necessary libs to make the browser work with Puppeteer.
RUN apt-get update && apt-get install gnupg wget -y && \
  wget --quiet --output-document=- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-archive.gpg && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
  apt-get update && \
  apt-get install google-chrome-stable -y --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
#ENV DBUS_SESSION_BUS_ADDRESS autolaunch:
# Copy package.json
COPY package.json ./

# Install NPM dependencies for function
RUN npm install
# Install puppeteer so it's available in the container.
#RUN npm init -y &&  \
   # npm i puppeteer 
# Copy handler function and tsconfig
COPY server.js ./

# Expose app
EXPOSE 3000
#RUN /bin/bash -c "chown -R myuser /srv "
# Run app
CMD ["node", "server.js"]
