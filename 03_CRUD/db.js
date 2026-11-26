const fs = require('fs');
const path = require('path');
const mysql = require('mysql2');

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    multipleStatements: true
});

function initDb(callback) {
    db.connect((err) => {
        if (err) return callback(err);

        db.query('CREATE DATABASE IF NOT EXISTS restaurant; USE restaurant;', (err) => {
            if (err) return callback(err);

            db.query("SHOW TABLES LIKE 'prato'", (err, rows) => {
                if (err) return callback(err);
                if (rows.length > 0) return callback(null);

                const sql = fs.readFileSync(path.join(__dirname, 'banco.sql'), 'utf8');
                db.query(sql, callback);
            });
        });
    });
}

module.exports = { db, initDb };
