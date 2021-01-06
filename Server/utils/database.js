require('./config')
const Logger = require('./Logger')

module.exports = function(mongoose) {

  const dbName = process.env.DB_NAME
  const dbPort = process.env.DB_PORT

  const logger = new Logger('DATABASE')
  
  mongoose.connect('mongodb://localhost:'+ dbPort + '/' + dbName)
  .then(function(res) {
    logger.log('Database Connected')
  })
  .catch(function(err) {
    logger.log('Database could not be Connected')
  })

  //These Functions are not correctly being invoked
  mongoose.connection.on('connected', function() {
    logger.log('Connected to the MongoDB Database')
  })

  mongoose.connection.on('error', function(err) {
    logger.log('Mongoose Database Connection Error')
  })

  mongoose.connection.on('disconnect', function(err) {
    logger.log('Disconnected from the MongoDB Database')
  })
}
