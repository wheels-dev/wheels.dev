FROM ortussolutions/commandbox:latest

# Set working directory
WORKDIR /app

#Copy files to working directory
COPY . .

# Expose the port
EXPOSE 8080

#Keep the server from trying to open in a browser
RUN box config set server.defaults.openBrowser=false

#Start the server
CMD ["box", "server", "start", "--console"]