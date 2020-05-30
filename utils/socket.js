const sync = require('./sync')

module.exports = function(io) {
  const gameSocket = io.of('/game')

  gameSocket.on('connection', function(socket) {

    console.log("Connected to Game Socket")

    socket.on('join', function(room) {

      socket.join(room)
      console.log("Joined Room")

      io.of('/game').in(room).clients(function(err, clients) {
          console.log(clients);
          if (clients.length === 2) {
            console.log("Two people have joined the game")
          }
      })

    })

    socket.on('disconnect', function(socket) {})

  })

  function clearSocketRoom(room, namespace = '/') {}
}
