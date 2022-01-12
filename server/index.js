const express = require("express");
const app = express();
const bodyParser = require("body-parser");

const uzmanlikAlaniRouter = require("./routes/uzmanlikAlaniRoute");
const mesajRouter = require("./routes/mesajRoute");
const doktorUzmanlikAlaniRouter = require("./routes/doktorUzmanlikAlaniRoute");
const anabilimDaliRoute = require("./routes/anabilimDaliRoute");
const hastaRoute = require("./routes/hastaRoute");
const doktorRoute = require("./routes/doktorRoute");
const fileuploadRoute = require("./routes/fileUploadRoute");
const fcmRoute = require("./routes/fcmRoute");

app.use(bodyParser.json());
app.use(express.static('public'));

app.get("/", (req, res) => {
    res.send("Welcome Healmob API")
})

app.use('/uzmanlikalani', uzmanlikAlaniRouter);
app.use('/mesaj', mesajRouter);
app.use('/doktoruzmanlikalani', doktorUzmanlikAlaniRouter);
app.use('/anabilimdali', anabilimDaliRoute);
app.use('/hasta', hastaRoute);
app.use('/doktor', doktorRoute);
app.use('/files', fileuploadRoute);
app.use('/fcm', fcmRoute);

app.listen(3000, function () {
    console.log('Server running(localhost:3000)');
});