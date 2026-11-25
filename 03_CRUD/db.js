const fs = require('fs');
const path = require('path');
const sqlite3 = require('sqlite3').verbose();

const dbPath = path.join(__dirname, 'restaurante.db');
const sqlPath = path.join(__dirname, 'banco.sql');

const db = new sqlite3.Database(dbPath);

function initDb(callback) {
    db.get("SELECT name FROM sqlite_master WHERE type='table' AND name='categoria'", (err, row) => {
        if (err) return callback(err);
        if (row) return callback(null);

        const sql = fs.readFileSync(sqlPath, 'utf8');
        db.exec(sql, callback);
    });
}

module.exports = { db, initDb };
