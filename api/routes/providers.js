/*
    FILE: providers.js
    DATE: 2020-05-19
    AUTHOR: Melissa Isaacson
    DESCRIPTION:
        SQL calls for providers.    
*/

// Initial connections
var express = require("express");
var router = express.Router();
var mysql = require('mysql');
const connection = require("../dbconfig");

// Initial page load call
router.get("/", function(req, res, next) {
    connection.query('CALL sp_view_providers()',
    function (error, results, fields) {
        if (error) throw error;
        res.send(results);
      })
});

// Initial page load call
router.get("/providers", function(req, res, next) {
    connection.query('CALL sp_view_providers()',
    function (error, results, fields) {
        if (error) throw error;
        res.send(results);
      })
});

// call for a count of all providers
router.get("/count", function(req, res, next) {
    connection.query('CALL sp_providers_count()',
    function (error, results, fields) {
        if (error) throw error;
        res.send(results);
      })
});

// call a certain number of providers
router.get("/:start-:amount", function(req, res, next) {
    connection.query(`CALL sp_view_limited_providers(?, ?)`,
      [req.params.start, req.params.amount],
    function (error, results, fields) {
        if (error) throw error;

        res.send(results);
      })
});

// Search new Provider by name
router.post("/SearchProviderByName", function(req, res, next){
  connection.query(`CALL sp_search_providers_name(?)`, [req.body.providerName],
  function (error, results, fields) {
    if(error) throw error;
    res.send(results);
  })
});

// Search new Provider by City
router.post("/SearchProviderByCity", function(req, res, next){
  connection.query(`CALL sp_view_providers_city(?)`, [req.body.city],
  function (error, results, fields) {
    if(error) throw error;
    res.send(results);
  })
});

// Search new Provider by State
router.post("/SearchProviderByState", function(req, res, next){
  connection.query(`CALL sp_view_providers_state(?)`, [req.body.state],
  function (error, results, fields) {
    if(error) throw error;
    res.send(results);
  })
});

// Search new Provider by Item
router.post("/SearchProviderByItem", function(req, res, next){
  connection.query(`CALL sp_view_providers_item(?)`, [req.body.item],
  function (error, results, fields) {
    if(error) throw error;
    res.send(results);
  })
});

// New Provider Form
router.post("/AddProvider", function(req, res, next) {
  let addressLine2;

  if(req.body.addressLine2 !== '') {
    connection.query(`CALL sp_create_new_listing(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [req.body.providerName, req.body.username, req.body.addressLine1,
      req.body.addressLine2, req.body.zipcode, req.body.city, req.body.state,
      '1', req.body.phoneNumber, req.body.phoneType, req.body.email],
    function (error, results, fields) {
        if (error) throw error;
        res.send(results);
      })
  } else {
    connection.query(`CALL sp_create_new_listing(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [req.body.providerName, req.body.username, req.body.addressLine1, 'NULL',
      req.body.zipcode, req.body.city, req.body.state, '1', req.body.phoneNumber,
      req.body.phoneType, req.body.email],
    function (error, results, fields) {
        if (error) throw error;
        res.send(results);
      })
  }
});

// Get a provider based on multiple information input
router.post("/GetSingleProvider", function(req, res, next) {
  connection.query(`CALL sp_view_providers_multi_info(?, ?, ?)`,
    [req.body.providerName, req.body.addressLine1, req.body.phoneNumber],
  function (error, results, fields) {
      if (error) throw error;

      if(req.signedCookies.username) {
        results[1].username = req.signedCookies.username;
      } else {
        results[1].username = null;
      }

      res.send(results);
    })
});

// Get a provider based on multiple information input
router.post("/GetProvider", function(req, res, next) {
  connection.query(`CALL sp_view_provider_by_id(?)`, [req.body.providerId],
  function (error, results, fields) {
      if (error) throw error;

      res.send(results);
    })
});

// Edit a provider
router.post("/EditProvider", function(req, res, next) {
  connection.query(`CALL sp_edit_provider(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
  [req.body.providerId, req.body.providerName, req.body.addressLine1,
    req.body.addressLine2, req.body.zipcode, req.body.city, req.body.state, '1',
    req.body.phoneNumber, req.body.phoneType, req.body.email],
  function (error, results, fields) {
      if (error) throw error;

      res.send(results);
    })
});

// Soft Delete a provider
router.post("/DeleteProvider", function(req, res, next) {
  connection.query(`CALL sp_soft_delete_provider(?)`, [req.body.providerId],
  function (error, results, fields) {
      if (error) throw error;

      res.send(results);
    })
});

module.exports = router;