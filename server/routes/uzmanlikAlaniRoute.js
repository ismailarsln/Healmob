const express = require("express");
const dbHelper = require("../helpers/dbHelper");
const bodyHelper = require("../helpers/bodyHelper");

const router = express.Router();

router.get('/getall', (request, response) => {
    var command = "SELECT * FROM tbluzmanlik_alani";
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

    var command = `SELECT * FROM tbluzmanlik_alani WHERE uzmanlik_alani_id = ${request.params.id}`
    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});



router.get('/getbyname/:name', (request, response) => {
    var command = `SELECT * FROM tbluzmanlik_alani WHERE uzmanlik_alani_adi LIKE '%${request.params.name}%'`
    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});



router.post('/add', (request, response) => {
    if (bodyHelper.checkArgumentsExist(request.body.uzmanlik_alani_adi)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.body.uzmanlik_alani_adi.length < 5) {
        var finalResponse = dbHelper.createBadRequestResponse("Uzmanlık alanı adı en az 5 karakter olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    var command = `INSERT INTO tbluzmanlik_alani (uzmanlik_alani_adi) VALUES ('${request.body.uzmanlik_alani_adi}')`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});



router.post('/delete', (request, response) => {
    if (bodyHelper.checkArgumentsExist(request.body.uzmanlik_alani_id)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
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

    var command = `DELETE FROM tbluzmanlik_alani WHERE uzmanlik_alani_id = ${request.body.uzmanlik_alani_id}`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});



router.post('/update', (request, response) => {
    if (bodyHelper.checkArgumentsExist(request.body.uzmanlik_alani_id, request.body.uzmanlik_alani_adi)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
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

    if (request.body.uzmanlik_alani_adi.length < 5) {
        var finalResponse = dbHelper.createBadRequestResponse("Uzmanlık alanı adı en az 5 karakter olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    var command = `UPDATE tbluzmanlik_alani SET uzmanlik_alani_adi = '${request.body.uzmanlik_alani_adi}' WHERE uzmanlik_alani_id = ${request.body.uzmanlik_alani_id}`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});


module.exports = router;