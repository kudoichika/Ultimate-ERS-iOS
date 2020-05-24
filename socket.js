//Socket.js

//Export module with all SocketIO Logic
module.exports = function (io) {

  io.sockets.on('connection', function(socket) {
    console.log('New Connection formed with Id:', socket.id)

    socket.on('disconnect', function() {})
  })
}
