const express = require("express");
const dbHelper = require("../helpers/dbHelper");
const bodyHelper = require("../helpers/bodyHelper");

const router = express.Router();

router.get('/getall', (request, response) => {
    var command = "SELECT * FROM tblanabilim_dali";

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.get('/getbyanabilimdalino/:anabilimdalino', (request, response) => {
    if (!bodyHelper.isStringJustNumbers(request.params.anabilimdalino)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    var command = `SELECT * FROM tblanabilim_dali WHERE anabilim_dali_no = ${request.params.anabilimdalino}`
    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});



router.get('/getbyname/:name', (request, response) => {
    var command = `SELECT * FROM tblanabilim_dali WHERE anabilim_dali_adi LIKE '%${request.params.name}%'`

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.post('/add', (request, response) => {
    if (bodyHelper.checkArgumentsExist(request.body.anabilim_dali_adi)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.body.anabilim_dali_adi.length < 5) {
        var finalResponse = dbHelper.createBadRequestResponse("Anabilim dalı adı en az 5 karakter olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    var command = `INSERT INTO tblanabilim_dali (anabilim_dali_adi) VALUES ('${request.body.anabilim_dali_adi}')`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});

router.post('/delete', (request, response) => {
    if (bodyHelper.checkArgumentsExist(request.body.anabilim_dali_no)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (!bodyHelper.isStringJustNumbers(request.body.anabilim_dali_no)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.body.anabilim_dali_no < 1) {
        var finalResponse = dbHelper.createBadRequestResponse("Anabilim dali no 0 dan büyük olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    var command = `DELETE FROM tblanabilim_dali WHERE anabilim_dali_no = ${request.body.anabilim_dali_no}`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});

router.post('/update', (request, response) => {
    if (bodyHelper.checkArgumentsExist(request.body.anabilim_dali_no, request.body.anabilim_dali_adi)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (!bodyHelper.isStringJustNumbers(request.body.anabilim_dali_no)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.body.anabilim_dali_no < 1) {
        var finalResponse = dbHelper.createBadRequestResponse("Anabilim dali no 0 dan büyük olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (request.body.anabilim_dali_adi.length < 5) {
        var finalResponse = dbHelper.createBadRequestResponse("Anabilim dalı adı en az 5 karakter olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    var command = `UPDATE tblanabilim_dali SET anabilim_dali_adi = '${request.body.anabilim_dali_adi}' WHERE anabilim_dali_no = ${request.body.anabilim_dali_no}`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});

module.exports = router;