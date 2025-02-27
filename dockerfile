FROM ortussolutions/commandbox:latest

# Set working directory
WORKDIR /app

#Copy files to working directory
COPY . .

# Expose the port
EXPOSE 60051
ENV PORT 60051
ENV HEALTHCHECK_URI         "http://127.0.0.1:60051/"
#ENV ENV_MODE                "remote"

#Keep the server from trying to open in a browser
RUN box config set server.defaults.openBrowser=false

#Start the server
CMD ["box", "server", "start", "--console"]