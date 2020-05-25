require('./config')

module.exports = function(mongoose) {

  const dbName = process.env.DB_NAME
  const dbPort = process.env.DB_PORT

  mongoose.connect('mongodb://localhost:'+ dbPort + '/' + dbName)
  .then(function(res) {
    console.log("Database Connected")
  })
  .catch(function(err) {
    console.log("Database could not be Connected")
  })

  mongoose.connection.on('connected', function() {
    console.log("Connected to the MongoDB Database")
  })

  mongoose.connection.on('error', function(err) {
    console.log("Mongoose Database Connection Error")
  })

  mongoose.connection.on('disconnect', function(err) {
    console.log("Disconnected from the MongoDB Database")
  })
}
