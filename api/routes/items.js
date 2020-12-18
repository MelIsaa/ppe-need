/*
    FILE: items.js
    DATE: 2020-05-19
    AUTHOR: Melissa Isaacson
    DESCRIPTION:
        SQL calls for item search.    
*/

var express = require("express");
var router = express.Router();
var mysql = require('mysql');
const connection = require("../dbconfig");

router.get("/:start-:amount", function(req, res, next) {
    connection.query(`CALL sp_view_items(?, ?, ?)`,
    [req.params.provider_id, req.params.start, req.params.amount],
    function (error, results, fields) {
      if (error) throw error;
      res.send(results);
    })
});

/* View Items by Provider */
router.post("/ByProvider", function(req, res, next) {
  connection.query(`CALL sp_view_items_by_provider(?)`,
  [req.body.provider_id],
  function(error, results, fields) {
    if(error) throw error;

    res.send(results);
  })
});

/* View Items by ID */
router.post("/Item", function(req, res, next) {
  connection.query(`CALL sp_view_items_by_id(?)`,
  [req.body.itemId],
  function(error, results, fields) {
    if(error) throw error;

    res.send(results);
  })
});

/* Create a new item */
router.post('/AddItem', function(req, res, next) {
  connection.query(`CALL sp_create_new_item(?, ?, ?, ?)`,
  [req.body.providerId, req.body.username, req.body.itemName, req.body.amount],
  function(error, results, fields) {
    if(error) throw error;

    res.send(results);
  })
});

/* Edit an item */
router.post('/EditItem', function(req, res, next) {
  connection.query(`CALL sp_update_item_all(?, ?, ?, ?)`,
  [req.body.itemId, req.body.username, req.body.itemName, req.body.amount],
  function(error, results, fields) {
    if(error) throw error;

    res.send(results);
  })
});

/* Deactivate an item */
router.post('/DeactivateItem', function(req, res, next) {
  connection.query(`CALL sp_deactivate_item(?, ?)`,
  [req.body.itemId, req.body.username],
  function(error, results, fields) {
    if(error) throw error;

    res.send(results);
  })
});


module.exports = router;