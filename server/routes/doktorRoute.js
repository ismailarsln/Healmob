const express = require("express");
const dbHelper = require("../helpers/dbHelper");
const bodyHelper = require("../helpers/bodyHelper");

const router = express.Router();

router.get('/getall', (request, response) => {
    var command = "SELECT * FROM tbldoktor";

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.get('/getbydoktorno/:doktorno', (request, response) => {
    if (!bodyHelper.isStringJustNumbers(request.params.doktorno)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    var command = `SELECT * FROM tbldoktor WHERE doktor_no = ${request.params.doktorno}`
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

    var command = `SELECT * FROM tbldoktor WHERE anabilim_dali_no = ${request.params.anabilimdalino}`
    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.get('/getbyemail/:email', (request, response) => {
    var command = `SELECT * FROM tbldoktor WHERE email LIKE '%${request.params.email}%'`
    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.get('/getbyname/:name', (request, response) => {
    var command = `SELECT * FROM tbldoktor WHERE ad LIKE '%${request.params.name}%'`
    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.get('/getbysurname/:surname', (request, response) => {
    var command = `SELECT * FROM tbldoktor WHERE soyad LIKE '%${request.params.surname}%'`
    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.get('/getbycinsiyet/:cinsiyet', (request, response) => {
    if (!bodyHelper.isStringJustNumbers(request.params.cinsiyet)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.params.cinsiyet != 1 && request.params.cinsiyet != 0) {
        var finalResponse = dbHelper.createBadRequestResponse("Cinsiyet 0 (erkek) veya 1 (kadin) olabilir");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    var command = `SELECT * FROM tbldoktor WHERE cinsiyet = ${request.params.cinsiyet}`
    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.get('/getbyaktifdurum/:durum', (request, response) => {
    if (!bodyHelper.isStringJustNumbers(request.params.durum)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.params.durum != 1 && request.params.durum != 0) {
        var finalResponse = dbHelper.createBadRequestResponse("Aktiflik durumu 0 (aktif değil) veya 1 (aktif) olabilir");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    var command = `SELECT * FROM tbldoktor WHERE aktif_durum = ${request.params.durum}`
    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.post('/add', (request, response) => {
    if (bodyHelper.checkArgumentsExist(
            request.body.anabilim_dali_no,
            request.body.email,
            request.body.sifre,
            request.body.ad,
            request.body.soyad,
            request.body.telefon,
            request.body.cinsiyet,
            request.body.aktif_durum)) {
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

    if (request.body.sifre.length < 6) {
        var finalResponse = dbHelper.createBadRequestResponse("Şifre en az 6 karakter olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (request.body.ad.length < 3) {
        var finalResponse = dbHelper.createBadRequestResponse("Ad en az 3 karakter olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (request.body.soyad.length < 3) {
        var finalResponse = dbHelper.createBadRequestResponse("Soyad en az 3 karakter olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (!bodyHelper.isStringJustNumbers(request.body.telefon)) {
        var finalResponse = dbHelper.createBadRequestResponse("Telefon sadece sayılardan oluşmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (request.body.telefon.length < 10) {
        var finalResponse = dbHelper.createBadRequestResponse("Telefon en az 10 karakter olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (request.body.cinsiyet != 1 && request.body.cinsiyet != 0) {
        var finalResponse = dbHelper.createBadRequestResponse("Cinsiyet 0 (erkek) veya 1 (kadin) olabilir");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (request.body.aktif_durum != 1 && request.body.aktif_durum != 0) {
        var finalResponse = dbHelper.createBadRequestResponse("Aktiflik durumu 0 (aktif değil) veya 1 (aktif) olabilir");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    var command =
        `INSERT INTO tbldoktor 
    (anabilim_dali_no, email, sifre, ad, soyad, telefon, cinsiyet, aktif_durum) 
    VALUES 
    (${request.body.anabilim_dali_no}, '${request.body.email}', '${request.body.sifre}', '${request.body.ad}', '${request.body.soyad}', '${request.body.telefon}', ${request.body.cinsiyet}, ${request.body.aktif_durum})`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});

router.post('/delete', (request, response) => {
    if (bodyHelper.checkArgumentsExist(
            request.body.doktor_no)) {
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

    var command =
        `DELETE FROM tbldoktor WHERE doktor_no = ${request.body.doktor_no}`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});

router.post('/update', (request, response) => {
    if (bodyHelper.checkArgumentsExist(
            request.body.doktor_no,
            request.body.anabilim_dali_no,
            request.body.email,
            request.body.sifre,
            request.body.ad,
            request.body.soyad,
            request.body.telefon,
            request.body.cinsiyet,
            request.body.aktif_durum)) {
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

    if (!bodyHelper.isStringJustNumbers(request.body.anabilim_dali_no)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.body.anabilim_dali_no < 1) {
        var finalResponse = dbHelper.createBadRequestResponse("Anabilim dali no 0 dan büyük olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (request.body.sifre.length < 6) {
        var finalResponse = dbHelper.createBadRequestResponse("Şifre en az 6 karakter olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (request.body.ad.length < 3) {
        var finalResponse = dbHelper.createBadRequestResponse("Ad en az 3 karakter olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (request.body.soyad.length < 3) {
        var finalResponse = dbHelper.createBadRequestResponse("Soyad en az 3 karakter olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (!bodyHelper.isStringJustNumbers(request.body.telefon)) {
        var finalResponse = dbHelper.createBadRequestResponse("Telefon sadece sayılardan oluşmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (request.body.telefon.length < 10) {
        var finalResponse = dbHelper.createBadRequestResponse("Telefon en az 10 karakter olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (request.body.cinsiyet != 1 && request.body.cinsiyet != 0) {
        var finalResponse = dbHelper.createBadRequestResponse("Cinsiyet 0 (erkek) veya 1 (kadin) olabilir");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    if (request.body.aktif_durum != 1 && request.body.aktif_durum != 0) {
        var finalResponse = dbHelper.createBadRequestResponse("Aktiflik durumu 0 (aktif değil) veya 1 (aktif) olabilir");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    var command =
        `UPDATE tbldoktor SET 
      anabilim_dali_no = ${request.body.anabilim_dali_no},
      email = '${request.body.email}', 
      sifre = '${request.body.sifre}', 
      ad = '${request.body.ad}', 
      soyad = '${request.body.soyad}', 
      telefon = '${request.body.telefon}', 
      cinsiyet = ${request.body.cinsiyet}, 
      aktif_durum = ${request.body.aktif_durum} WHERE doktor_no = ${request.body.doktor_no}`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});

module.exports = router;