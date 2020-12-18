var express = require("express");
var router = express.Router();
var mysql = require('mysql');
const connection = require("../dbconfig");

router.get("/", function(req, res, next) {
    res.send("API is working properly");
});

router.get("/testdb", function(req, res, next) {
    // mysqlx.getSession(config)
    connection.query('SELECT * FROM Provider', function (error, results, fields) {
        if (error) throw error;
      })
    });

module.exports = router;