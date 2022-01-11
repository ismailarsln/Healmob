const express = require("express");
const dbHelper = require("../helpers/dbHelper");
const bodyHelper = require("../helpers/bodyHelper");

const router = express.Router();

router.get('/getall', (request, response) => {
    var command = "SELECT * FROM tblhasta";

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.get('/getbyhastano/:hastano', (request, response) => {
    if (!bodyHelper.isStringJustNumbers(request.params.hastano)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    var command = `SELECT * FROM tblhasta WHERE hasta_no = ${request.params.hastano}`
    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.get('/getbyemail/:email', (request, response) => {
    var command = `SELECT * FROM tblhasta WHERE email LIKE '%${request.params.email}%'`
    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.get('/getbyname/:name', (request, response) => {
    var command = `SELECT * FROM tblhasta WHERE ad LIKE '%${request.params.name}%'`
    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.get('/getbysurname/:surname', (request, response) => {
    var command = `SELECT * FROM tblhasta WHERE soyad LIKE '%${request.params.surname}%'`
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

    var command = `SELECT * FROM tblhasta WHERE cinsiyet = ${request.params.cinsiyet}`
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

    var command = `SELECT * FROM tblhasta WHERE aktif_durum = ${request.params.durum}`
    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'}`);
        response.status(result.status).send(result);
    });
});

router.post('/add', (request, response) => {
    if (bodyHelper.checkArgumentsExist(
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
        `INSERT INTO tblhasta 
    (email, sifre, ad, soyad, telefon, cinsiyet, aktif_durum) 
    VALUES 
    ('${request.body.email}', '${request.body.sifre}', '${request.body.ad}', '${request.body.soyad}', '${request.body.telefon}', ${request.body.cinsiyet}, ${request.body.aktif_durum})`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});

router.post('/delete', (request, response) => {
    if (bodyHelper.checkArgumentsExist(
            request.body.hasta_no)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (!bodyHelper.isStringJustNumbers(request.body.hasta_no)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.body.hasta_no < 1) {
        var finalResponse = dbHelper.createBadRequestResponse("Hasta no 0 dan büyük olmalıdır");
        response.status(finalResponse.status).send(finalResponse);
        return;
    }

    var command =
        `DELETE FROM tblhasta WHERE hasta_no = ${request.body.hasta_no}`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});

router.post('/update', (request, response) => {
    if (bodyHelper.checkArgumentsExist(
            request.body.hasta_no,
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

    if (!bodyHelper.isStringJustNumbers(request.body.hasta_no)) {
        response.status(dbHelper.defaultBadRequestResponse.status).send(dbHelper.defaultBadRequestResponse);
        return;
    }

    if (request.body.hasta_no < 1) {
        var finalResponse = dbHelper.createBadRequestResponse("Hasta no 0 dan büyük olmalıdır");
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
        `UPDATE tblhasta SET 
      email = '${request.body.email}', 
      sifre = '${request.body.sifre}', 
      ad = '${request.body.ad}', 
      soyad = '${request.body.soyad}', 
      telefon = '${request.body.telefon}', 
      cinsiyet = ${request.body.cinsiyet}, 
      aktif_durum = ${request.body.aktif_durum},
      resim_yolu = '${request.body.resim_yolu}' WHERE hasta_no = ${request.body.hasta_no}`;

    dbHelper.runCommandInDb(command, (result) => {
        console.log(`${command} ---> ${result.status}${result.status=='200' ? ' OK' : ' BAD REQUEST'} (${result.status=='200' ? `A:${result.data.affectedRows}, I:${result.data.insertId}, C:${result.data.changedRows}` : result.message})`);
        response.status(result.status).send(result);
    });
});

module.exports = router;