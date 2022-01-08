const mysql = require("mysql");
require("dotenv/config");

class dbHelper {
    static runCommandInDb(inputCommand, callback) {
        var connection = mysql.createConnection({
            host: process.env.HOST,
            user: process.env.USER,
            password: process.env.PASSWORD,
            database: process.env.DATABASE,
        });

        connection.connect(err => {
            if (err) {
                console.log("Database connection error! Error:");
                console.log(err);
                return callback(dbHelper.createBadRequestResponse("Could not connect to database"));
            } else {
                console.log("Connected to Database!");
            }
        });

        connection.query(inputCommand, function (err, result) {
            if (err) {
                if (err.errno == 1062) {
                    //Duplicate error
                    //Message = "Duplicate entry 'XXXX' for key 'XXXX'"
                    return callback(dbHelper.createBadRequestResponse(err.sqlMessage));
                }
                if (err.sqlState = '45000') {
                    //Duplicate error for db triggers
                    //Message = "Kayit zaten var"
                    return callback(dbHelper.createBadRequestResponse(err.sqlMessage));
                }

                console.log(err); //DELETE
                return callback(dbHelper.defaultBadRequestResponse);
            }

            if (result.affectedRows != null) { // If the query is an add/delete/update query
                var manipulationResult = {
                    affectedRows: result.affectedRows,
                    insertId: result.insertId,
                    changedRows: result.changedRows
                }
                return callback(dbHelper.createDataResponse(manipulationResult));
            }
            return callback(dbHelper.createDataResponse(result));
        });
    }

    static defaultBadRequestResponse = {
        data: "",
        success: false,
        message: "Bad request",
        status: "400",
    };

    static createDataResponse(inputData) {
        return {
            data: inputData,
            success: true,
            message: "Successful",
            status: "200",
        };
    }

    static createBadRequestResponse(message) {
        return {
            data: dbHelper.defaultBadRequestResponse.data,
            success: dbHelper.defaultBadRequestResponse.success,
            message: message,
            status: dbHelper.defaultBadRequestResponse.status,
        };
    }
}

module.exports = dbHelper;