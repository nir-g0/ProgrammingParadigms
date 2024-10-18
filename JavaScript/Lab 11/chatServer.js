var net = require('net')
var eol = require('os').EOL

var srvr = net.createServer()
var clientList = []

srvr.on('connection', function (client) {
  client.name = client.remoteAddress + ':' + client.remotePort
  client.write('Welcome, ' + client.name + eol)
  clientList.push(client)

  client.on('data', function (data) {
    let dataToString = data.toString()
    let dataToStringArray = dataToString.split(' ')

    switch (dataToStringArray[0]) {
      case '\\list' + eol:
        listClients(client)
        break
      case '\\rename':
        renameClient(client, dataToStringArray[1])
        break
      case '\\private':
        privateMessage(
          client,
          dataToStringArray[1],
          dataToStringArray.slice(2).join(' ')
        )
        break
      default:
        broadcast(data, client)
        break
    }
  })
})

function listClients (client) {
  for (other in clientList) {
    if (client !== clientList[other]) {
      client.write(clientList[other].name + ',' + eol)
    }
  }
}

function renameClient (client, input) {
  client.name = input.split(eol)[0]
}

function privateMessage (client, dest, message) {
  for (destination in clientList) {
    if (clientList[destination].name === dest) {
      clientList[destination].write(
        'Private Chat from ' + client.name + ': ' + message
      )
      break
    }
  }
}

function broadcast (data, client) {
  for (var i in clientList) {
    if (client !== clientList[i]) {
      clientList[i].write(client.name + ' says ' + data)
    }
  }
}

srvr.listen(9000)
