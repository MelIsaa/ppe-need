var express = require("express");
var router = express.Router();
var mysql = require('mysql');
const connection = require("../dbconfig");

router.get("/", function(req, res, next) {
    connection.query('CALL sp_view_items(0, 10)', function (error, results, fields) {
        if (error) throw error;
        console.log(results);
      })
});

module.exports = router;