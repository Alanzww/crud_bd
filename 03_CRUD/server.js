const path = require('path');
const express = require('express');
const { db, initDb } = require('./db');

const app = express();
const PORT = 3000;

app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

app.get('/pratos', (req, res) => {
    const sql = `
        SELECT p.id_prato, p.nome, p.descricao, p.preco, p.id_categoria, c.nome AS categoria
        FROM prato p
        INNER JOIN categoria c ON p.id_categoria = c.id_categoria
        ORDER BY p.id_prato DESC
    `;
    db.query(sql, (err, rows) => {
        if (err) return res.status(500).json({ erro: 'Erro ao listar pratos' });
        res.json(rows);
    });
});

app.post('/pratos', (req, res) => {
    const { nome, descricao, preco, id_categoria } = req.body;
    if (!nome || preco === undefined || !id_categoria) {
        return res.status(400).json({ erro: 'Preencha os campos obrigatórios' });
    }

    const sql = 'INSERT INTO prato (nome, descricao, preco, id_categoria) VALUES (?, ?, ?, ?)';
    db.query(sql, [nome, descricao || null, preco, id_categoria], (err, result) => {
        if (err) return res.status(500).json({ erro: 'Erro ao cadastrar prato' });
        res.json({ id_prato: result.insertId });
    });
});

app.put('/pratos/:id', (req, res) => {
    const { id } = req.params;
    const { nome, descricao, preco, id_categoria } = req.body;

    const sql = 'UPDATE prato SET nome = ?, descricao = ?, preco = ?, id_categoria = ? WHERE id_prato = ?';
    db.query(sql, [nome, descricao || null, preco, id_categoria, id], (err) => {
        if (err) return res.status(500).json({ erro: 'Erro ao atualizar prato' });
        res.json({ ok: true });
    });
});

app.delete('/pratos/:id', (req, res) => {
    const { id } = req.params;

    db.query('DELETE FROM pedido_prato WHERE id_prato = ?', [id], (err) => {
        if (err) return res.status(500).json({ erro: 'Erro ao excluir prato' });

        db.query('DELETE FROM prato WHERE id_prato = ?', [id], (err) => {
            if (err) return res.status(500).json({ erro: 'Erro ao excluir prato' });
            res.json({ ok: true });
        });
    });
});

initDb((err) => {
    if (err) {
        console.log('Erro ao conectar no MySQL:', err.message);
        return;
    }
    app.listen(PORT, () => {
        console.log(`Servidor rodando em http://localhost:${PORT}`);
    });
});
