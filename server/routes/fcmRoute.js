const express = require("express");
const dbHelper = require("../helpers/dbHelper");
const bodyHelper = require("../helpers/bodyHelper");
var request = require('request');
require("dotenv/config");

const router = express.Router();

router.post('/sendmessage', (req, res) => {
    if (bodyHelper.checkArgumentsExist(
            req.body.topic_name,
            req.body.body_text,
            req.body.title_text)) {
        res.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    };

    request({
        url: "https://fcm.googleapis.com/fcm/send",
        method: "POST",
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'key=' + process.env.FCMSERVERKEY
        },
        json: true,
        body: {
            to: "/topics/" + req.body.topic_name,
            notification: {
                body: req.body.body_text,
                title: req.body.title_text,
            }
        }
    }, function (error, response, body) {
        if(!body["message_id"]){
            res.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
            return;
        }
        console.log(body);
        res.status(dbHelper.createDataResponse(body).status).send(dbHelper.createDataResponse(body));
    });
});

module.exports = router;