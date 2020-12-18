var express = require("express");
var router = express.Router();
const bcrypt = require('bcrypt');
var mysql = require('mysql');
const connection = require("../dbconfig");

const TWO_HOURS = 1000 * 60 * 60 * 2;

/* Check username and password */
router.post("/login", async function(req, res, next) {
    
    connection.query(`CALL sp_get_password_with_username(?)`, [req.body.username],
        function (error, results, fields) {
            if (error) throw error;

            try{
                let fromDB = results[0][0].PersonPassword;

                let compared = new Promise((resolve, reject) => {
                    if (bcrypt.compare(connection.escape(req.body.password), fromDB)) {
                        resolve(true);
                    } else {
                        reject('Failed');
                    }
                });
                
                compared
                .then((bool) => {
                    if(bool) {
                        let pkg = {
                            exists: bool,
                            username: req.body.username,
                        };
                        res.send(pkg);
                    }
                })
                .catch((err) => { console.log('Err: ' + err)});
            } catch {
                res.status(500).send();
            }
          })
});


/* ADD A User */
router.post("/AddUser", async function(req, res, next) {
    try {
        const hashedPassword = await bcrypt.hash(connection.escape(req.body.password), 10);

        let userSettings = [req.body.username, hashedPassword, req.body.firstName,
                            req.body.lastName, req.body.email, req.body.occupation, req.body.roleType
                            ]

        connection.query(`CALL sp_create_new_user(?, ?, ?, ?, ?, ?, ?)`, userSettings,
        function (error, results, fields) {
            if (error) throw error;
            res.send(results);                        
            console.log(results);
          });
        // .then(results => {
        //     res.send(results);
        // })
        // .catch(err => {
        //     console.log(err);
        // })
    } catch(error) {
        console.log('/AddUser error: ' + error);
        res.status(500).send();
    }
});

module.exports = router;