net = require 'net'
fs = require 'fs'
mail = require 'mailer'

server = ["demo.1pm.com.hk"]
port = [80]
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

      mail.send(
        host : "smtp.gmail.com"
        port : "587"
        ssl : true
        domain : "playmore.com.hk"
        to : "pak@onepm.com.hk"
        from : "lucille@playmore.com.hk"
        subject : "Service Error"
        body: "#{message}"
        authentication: "login"
        username: "Y2hlY2VydmljZS5sb2dAZ21haWwuY29t"
        password: "b25lcG1sdGQ=")

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
