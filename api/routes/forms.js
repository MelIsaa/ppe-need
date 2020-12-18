var express = require("express");
var router = express.Router();
var mysql = require('mysql');
const connection = require("../dbconfig");

// Search providers by Name
router.post("/ProvidersSearch/Name", function(req, res, next) {
    // mysqlx.getSession(config)
    connection.query(`CALL sp_view_provider_by_name(?)`, [req.params.providerName], 
    function (error, results, fields) {
        if (error) throw error;
        res.send(results);
      })
});

// Search Providers by City
router.post("/ProvidersSearch/city", function(req, res, next) {    
    connection.query(`CALL sp_search_providers_city(?)`, [req.params.city],
    function (error, results, fields) {
        if (error) throw error;
        res.send(results);
      })
});

// Search Providers by State
router.post("/ProvidersSearch/state", function(req, res, next) {
  connection.query(`CALL sp_view_providers_state(?)`, [req.params.state],
  function (error, results, fields) {
      if (error) throw error;
      res.send(results);
    })
});

/* ADD AN ITEM */
router.post("/AddItem", function(req, res, next) {
    connection.query(
        `CALL sp_create_new_item(?, ?, ?, ?, ?, ?)`,
        [req.body.provider, req.signedCookies.username, req.body.itemName, req.body.amount, req.body.recurring, req.body.recurringTime],
        function (error, results, fields) {
        if (error) throw error;
        res.send(results);
      })
});

module.exports = router;