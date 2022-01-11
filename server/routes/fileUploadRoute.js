const express = require("express");
const formidable = require("formidable");
const dbHelper = require("../helpers/dbHelper");
var uuid = require('uuid');
var fs = require('fs');
const router = express.Router();

router.post('/imageupload', (req, res) => {
  var x = __dirname.split("\\");
  var parentPath = "";
  for (let i = 0; i < x.length - 1; i++) {
    parentPath += x[i] + "/";
  }
  var form = new formidable.IncomingForm();
  form.parse(req, (err, fields, files) => {
    if (files.file == undefined) {
      res.send(dbHelper.createFailDataResponse({
        "path": ""
      }, "İstekteki form datasında 'file' alanı olmalıdır"));
      return;
    }
    if (err) {
      res.send(dbHelper.createFailDataResponse({
        "path": ""
      }, "Resim yükleme başarısız"));
      return;
    }
    if (files.file.mimetype != "image/jpeg" && files.file.mimetype != "image/png") {
      res.send(dbHelper.createFailDataResponse({
        "path": ""
      }, "Yalnızca .png veya .jpg uzantılı resim dosyalarını yükleyebilirsiniz"));
      return;
    }
    if (files.file.size > 5242880) { // > 5MB
      res.send(dbHelper.createFailDataResponse({
        "path": ""
      }, "En fazla 5MB boyutunda resim dosyası yükleyebilirsiniz"));
      return;
    }
    var newFileName = uuid.v4();
    if (files.file.mimetype == "image/jpeg") newFileName += ".jpg";
    if (files.file.mimetype == "image/png") newFileName += ".png";

    var oldpath = files.file.filepath;
    var newpath = parentPath + "public/images/" + newFileName;
    fs.rename(oldpath, newpath, (err) => {
      if (err) res.send(dbHelper.createFailDataResponse({
        "path": ""
      }, "Resim yükleme başarısız"));
      res.send(dbHelper.createDataResponse({
        "path": ("images/" + newFileName)
      }, "Resim başarıyla yüklendi"));
    });
  });
});

router.post('/fileupload', (req, res) => {
  var x = __dirname.split("\\");
  var parentPath = "";
  for (let i = 0; i < x.length - 1; i++) {
    parentPath += x[i] + "/";
  }
  var form = new formidable.IncomingForm();
  form.parse(req, (err, fields, files) => {
    if (files.file == undefined) {
      res.send(dbHelper.createFailDataResponse({
        "path": ""
      }, "İstekteki form datasında 'file' alanı olmalıdır"));
      return;
    }
    if (err) {
      res.send(dbHelper.createFailDataResponse({
        "path": ""
      }, "Dosya yükleme başarısız"));
      return;
    }
    if (files.file.mimetype != "image/jpeg" &&
      files.file.mimetype != "image/png" &&
      files.file.mimetype != "application/pdf" &&
      files.file.mimetype != "application/vnd.openxmlformats-officedocument.wordprocessingml.document") {
      res.send(dbHelper.createFailDataResponse({
        "path": ""
      }, "Bu dosyayı yükleyemezsiniz. İzin verilen dosya uzantıları: .png, .jpg, .docx, .pdf"));
      return;
    }
    if (files.file.size > 20971520) { // > 20MB
      res.send(dbHelper.createFailDataResponse({
        "path": ""
      }, "En fazla 20MB boyutunda dosya yükleyebilirsiniz"));
      return;
    }
    var newFileName = uuid.v4();
    if (files.file.mimetype == "image/jpeg") newFileName += ".jpg";
    if (files.file.mimetype == "image/png") newFileName += ".png";
    if (files.file.mimetype == "application/pdf") newFileName += ".pdf";
    if (files.file.mimetype == "application/vnd.openxmlformats-officedocument.wordprocessingml.document") newFileName += ".docx";

    var oldpath = files.file.filepath;
    var newpath = parentPath + "public/files/" + newFileName;
    fs.rename(oldpath, newpath, (err) => {
      if (err) res.send(dbHelper.createFailDataResponse({
        "path": ""
      }, "Dosya yükleme başarısız"));
      res.send(dbHelper.createDataResponse({
        "path": ("files/" + newFileName)
      }, "Dosya başarıyla yüklendi"));
    });
  });
});

module.exports = router;