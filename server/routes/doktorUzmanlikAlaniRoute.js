const express = require("express");
const dbHelper = require("../helpers/dbHelper");
const bodyHelper = require("../helpers/bodyHelper");

const router = express.Router();

router.get('/getall', (request, response) => {
    var command = "SELECT * FROM tbldoktor_uzmanlik_alani";

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.get('/getallbydoktorno/:doktorno', (request, response) => {
    if (!bodyHelper.isStringJustNumbers(request.params.doktorno)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    var command = `SELECT * FROM tbldoktor_uzmanlik_alani WHERE doktor_no = ${request.params.doktorno}`;
    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.get('/getallbyuzmanlikalaniid/:uzmanlikalaniid', (request, response) => {
    if (!bodyHelper.isStringJustNumbers(request.params.uzmanlikalaniid)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    var command = `SELECT * FROM tbldoktor_uzmanlik_alani WHERE uzmanlik_alani_id = ${request.params.uzmanlikalaniid}`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.get('/getbyid/:id', (request, response) => {
    if (!bodyHelper.isStringJustNumbers(request.params.id)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    var command = `SELECT * FROM tbldoktor_uzmanlik_alani WHERE id = ${request.params.id}`

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.post('/add', (request, response) => {
    if (bodyHelper.checkArgumentsExist(request.body.doktor_no, request.body.uzmanlik_alani_id)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }
    if (!bodyHelper.isStringJustNumbers(request.body.doktor_no)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.body.doktor_no < 1) {
        var finalResponse = dbHelper.createBadRequestResponse("Doktor no 0 dan büyük olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (!bodyHelper.isStringJustNumbers(request.body.uzmanlik_alani_id)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.body.uzmanlik_alani_id < 1) {
        var finalResponse = dbHelper.createBadRequestResponse("Uzmanlık alanı id 0 dan büyük olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    var command = `INSERT INTO tbldoktor_uzmanlik_alani (doktor_no, uzmanlik_alani_id) VALUES (${request.body.doktor_no}, ${request.body.uzmanlik_alani_id})`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});

router.post('/delete', (request, response) => {
    if (bodyHelper.checkArgumentsExist(request.body.id)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (!bodyHelper.isStringJustNumbers(request.body.id)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.body.id < 1) {
        var finalResponse = dbHelper.createBadRequestResponse("Id 0 dan büyük olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    var command = `DELETE FROM tbldoktor_uzmanlik_alani WHERE id = ${request.body.id}`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});

router.post('/update', (request, response) => {
    if (bodyHelper.checkArgumentsExist(request.body.id, request.body.doktor_no, request.body.uzmanlik_alani_id)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (!bodyHelper.isStringJustNumbers(request.body.id)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.body.id < 1) {
        var finalResponse = dbHelper.createBadRequestResponse("Id 0 dan büyük olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (!bodyHelper.isStringJustNumbers(request.body.doktor_no)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.body.doktor_no < 1) {
        var finalResponse = dbHelper.createBadRequestResponse("Doktor no 0 dan büyük olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (!bodyHelper.isStringJustNumbers(request.body.uzmanlik_alani_id)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.body.uzmanlik_alani_id < 1) {
        var finalResponse = dbHelper.createBadRequestResponse("Uzmanlık alanı id 0 dan büyük olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    var command = `UPDATE tbldoktor_uzmanlik_alani SET doktor_no = ${request.body.doktor_no}, uzmanlik_alani_id = ${request.body.uzmanlik_alani_id} WHERE id = ${request.body.id}`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});

module.exports = router;