var mysql = require('mysql')

var connection = mysql.createConnection({
  host: '',
  user: '',
  password: '',
  database: '',
  // port: 9000
})

module.exports = connection;