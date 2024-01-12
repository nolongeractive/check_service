net = require 'net'
fs = require 'fs'
email = require 'mailer'

server = ["xxx@xxx.com]
port = [6226]
log_path = "/tmp/check_service.log"
time = new Date()

for servers in server
  for ports in port

    connection = net.createConnection ports, servers

    connection.on 'error', (error) ->
      message = "***ERR*** #{servers}:#{ports} - Error on #{time}.\n"
      console.log(message)
      log = fs.createWriteStream(log_path, {'flags': 'a'})
      log.write(message)
      connection.end()

      i = 0

      while i < 1
        email.send
          ssl: true
          host: "smtp.gmail.com"
          port: 465
          domain: "[127.0.0.1]"
          to: "xxx@xxx.com"
          from: "xxx@xxx.com"
          subject: "Service Error - #{servers}:#{ports}"
          reply_to: "xxx@xxx.com"
          body: "#{message}"
          authentication: "login"
          username: "xxx@xxx.com
          password: "xxx"
          debug: true
        , (err, result) ->
          console.log err  if err
        i++

    connection.on 'connect', () ->
      message = "***TRY*** #{servers}:#{ports} - Connecting on #{time}.\n"
      console.log(message)
      log = fs.createWriteStream(log_path, {'flags': 'a'})
      log.write(message)
      connection.end()

    connection.on 'data', (data) ->
      message = "***DAT*** #{servers}:#{ports} - Connected on #{time}.\n"
      console.log(message)
      log = fs.createWriteStream(log_path, {'flags': 'a'})
      log.write(message)
      connection.end()

    connection.on 'end', (data) ->
      message = "***END*** #{servers}:#{ports} - Connection End on #{time}.\n"
      console.log(message)
      log = fs.createWriteStream(log_path, {'flags': 'a'})
      log.write(message)
      connection.end()
