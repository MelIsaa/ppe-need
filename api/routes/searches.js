var express = require("express");
var router = express.Router();
var mysql = require('mysql');
const connection = require("../dbconfig");

// Search providers by Name
router.post("/Name", function(req, res, next) {
    connection.query(`CALL sp_search_providers_name(?)`, [req.body.providerName], 
    function (error, results, fields) {
        if (error) throw error;
        res.send(results);
      })
});

// Search Providers by City
router.post("/City", function(req, res, next) {    
    connection.query(`CALL sp_search_providers_city(?)`, [req.body.city],
    function (error, results, fields) {
        if (error) throw error;
        res.send(results);
      })
});

// Search Providers by State
router.post("/State", function(req, res, next) {
  connection.query(`CALL sp_view_providers_state(?)`, [req.body.state],
  function (error, results, fields) {
      if (error) throw error;
      res.send(results);
    })
});

// Search Providers by Item
router.post("/Item", function(req, res, next) {
  connection.query(`CALL sp_view_providers_item(?)`, [req.body.item],
  function (error, results, fields) {
      if (error) throw error;
      res.send(results);
    })
});

module.exports = router;