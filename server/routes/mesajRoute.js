const express = require("express");
const dbHelper = require("../helpers/dbHelper");
const bodyHelper = require("../helpers/bodyHelper");

const router = express.Router();

router.get('/getall', (request, response) => {
    var command = "SELECT * FROM tblmesaj";
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

    var command = `SELECT * FROM tblmesaj WHERE mesaj_id = ${request.params.id}`
    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.get('/getallbyhastano/:hastano', (request, response) => {
    if (!bodyHelper.isStringJustNumbers(request.params.hastano)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    var command = `SELECT * FROM tblmesaj WHERE hasta_no = ${request.params.hastano}`;
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

    var command = `SELECT * FROM tblmesaj WHERE doktor_no = ${request.params.doktorno}`;
    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.post('/sendmessage', (request, response) => {
    if (bodyHelper.checkArgumentsExist(request.body.hasta_no, request.body.doktor_no, request.body.hasta_mesaj)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (!bodyHelper.isStringJustNumbers(request.body.hasta_no)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (!bodyHelper.isStringJustNumbers(request.body.doktor_no)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    /* 
      Sonrasında burada dosya ek yolu çalışması yapılacak.
    */

    if (request.body.hasta_mesaj.length > 6000) {
        var finalResponse = dbHelper.createBadRequestResponse("Mesaj en fazla 6000 karakter olabilir");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    var command = `INSERT INTO tblmesaj (hasta_no, doktor_no, hasta_mesaj) VALUES (${request.body.hasta_no}, ${request.body.doktor_no}, '${request.body.hasta_mesaj}')`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});

router.post('/delete', (request, response) => {
    if (bodyHelper.checkArgumentsExist(request.body.mesaj_id)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (!bodyHelper.isStringJustNumbers(request.body.mesaj_id)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.body.mesaj_id < 1) {
        var finalResponse = dbHelper.createBadRequestResponse("Mesaj id 0 dan büyük olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    var command = `DELETE FROM tblmesaj WHERE mesaj_id = ${request.body.mesaj_id}`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});

router.post('/replytomessage', (request, response) => {
    if (bodyHelper.checkArgumentsExist(request.body.mesaj_id, request.body.doktor_yanit)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    /* 
      Sonrasında burada dosya ek yolu çalışması yapılacak.
    */

    if (!bodyHelper.isStringJustNumbers(request.body.mesaj_id)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.body.mesaj_id < 1) {
        var finalResponse = dbHelper.createBadRequestResponse("Mesaj id 0 dan büyük olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (request.body.doktor_yanit.length > 6000) {
        var finalResponse = dbHelper.createBadRequestResponse("Yanıtınız en fazla 6000 karakter olabilir");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    var command = `UPDATE tblmesaj SET doktor_yanit = '${request.body.doktor_yanit}' WHERE mesaj_id = ${request.body.mesaj_id}`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});

module.exports = router;