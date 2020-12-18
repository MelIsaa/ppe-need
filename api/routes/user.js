var express = require('express');
var router = express.Router();
const connection = require("../dbconfig");

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

// Get a user by name
router.post("/GetUser", function(req, res, next) {
  connection.query(`CALL sp_get_user_by_name(?)`, [req.body.username],
  function (error, results, fields) {
      if (error) throw error;
      res.send(results);
    })
});

// Initial page load call
router.post("/EditUser", function(req, res, next) {
  connection.query(`CALL sp_edit_user_by_name(?, ?, ?, ?, ?)`, [req.body.username,
    req.body.firstname, req.body.lastname, req.body.email,
    req.body.occupation],
  function (error, results, fields) {
      if (error) throw error;
      res.send(results);
    })
});

module.exports = router;
                                            