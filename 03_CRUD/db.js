const fs = require('fs');
const path = require('path');
const mysql = require('mysql2');

const sqlPath = path.join(__dirname, 'banco.sql');

const db = mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    port: Number(process.env.DB_PORT) || 3306,
    multipleStatements: true
});

function initDb(callback) {
    db.connect((err) => {
        if (err) return callback(err);

        db.query('CREATE DATABASE IF NOT EXISTS restaurant; USE restaurant;', (errDb) => {
            if (errDb) return callback(errDb);

            db.query("SHOW TABLES LIKE 'prato'", (errTbl, rows) => {
                if (errTbl) return callback(errTbl);

                if (rows.length === 0) {
                    const sql = fs.readFileSync(sqlPath, 'utf8');
                    return db.query(sql, callback);
                }

                db.query('SELECT COUNT(*) AS total FROM categoria', (errCount, countRows) => {
                    if (errCount) return callback(errCount);
                    if (countRows[0].total > 0) return callback(null);

                    const insertCategorias = `
                        INSERT INTO categoria (nome) VALUES
                            ('Entradas'),
                            ('Pratos Principais'),
                            ('Sobremesas'),
                            ('Bebidas');
                    `;
                    db.query(insertCategorias, callback);
                });
            });
        });
    });
}

module.exports = { db, initDb };
