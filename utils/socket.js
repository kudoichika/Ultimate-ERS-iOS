module.exports = function(io) {
  const lobbySocket = io.of('/lobby')
  const roomSocket = io.of('/room')
  const gameSocket = io.of('/game')

  lobbySocket.on('connection', function(socket) {

    socket.on('disconnect', function(socket) {})
  })

  roomSocket.on('connection', function(socket) {

    roomSocket.on('disconnect', function(socket) {})
  })

  gameSocket.on('connection', function(socket) {

    gameSocket.on('disconnect', function(socket) {})
  })

  function clearSocketRoom(room, namespace = '/') {}
}
