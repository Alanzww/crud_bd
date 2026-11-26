const path = require('path');
const express = require('express');
const { db, initDb } = require('./db');

const app = express();
const PORT = 3000;

app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

function validarPrato(body) {
    const nome = typeof body.nome === 'string' ? body.nome.trim() : '';
    const descricao = typeof body.descricao === 'string' ? body.descricao.trim() : '';
    const preco = Number(body.preco);
    const id_categoria = Number(body.id_categoria);

    if (!nome || !Number.isInteger(id_categoria) || id_categoria <= 0 || Number.isNaN(preco) || preco < 0) {
        return null;
    }
    return { nome, descricao: descricao || null, preco, id_categoria };
}

app.get('/categorias', (req, res) => {
    db.query('SELECT id_categoria, nome FROM categoria ORDER BY id_categoria', (err, rows) => {
        if (err) return res.status(500).json({ erro: 'Erro ao listar categorias.' });
        res.json(rows);
    });
});

app.get('/pratos', (req, res) => {
    const sql = `
        SELECT p.id_prato, p.nome, p.descricao, p.preco, p.id_categoria, c.nome AS categoria
        FROM prato p
        INNER JOIN categoria c ON p.id_categoria = c.id_categoria
        ORDER BY p.id_prato DESC
    `;
    db.query(sql, (err, rows) => {
        if (err) return res.status(500).json({ erro: 'Erro ao listar pratos.' });
        res.json(rows);
    });
});

app.post('/pratos', (req, res) => {
    const dados = validarPrato(req.body);
    if (!dados) return res.status(400).json({ erro: 'Dados inválidos.' });

    const sql = 'INSERT INTO prato (nome, descricao, preco, id_categoria) VALUES (?, ?, ?, ?)';
    db.query(sql, [dados.nome, dados.descricao, dados.preco, dados.id_categoria], (err, result) => {
        if (err) return res.status(500).json({ erro: 'Erro ao cadastrar prato.' });
        res.status(201).json({ id_prato: result.insertId, ...dados });
    });
});

app.put('/pratos/:id', (req, res) => {
    const id = Number(req.params.id);
    const dados = validarPrato(req.body);
    if (!Number.isInteger(id) || id <= 0 || !dados) {
        return res.status(400).json({ erro: 'Dados inválidos.' });
    }

    const sql = 'UPDATE prato SET nome = ?, descricao = ?, preco = ?, id_categoria = ? WHERE id_prato = ?';
    db.query(sql, [dados.nome, dados.descricao, dados.preco, dados.id_categoria, id], (err, result) => {
        if (err) return res.status(500).json({ erro: 'Erro ao atualizar prato.' });
        if (result.affectedRows === 0) return res.status(404).json({ erro: 'Prato não encontrado.' });
        res.json({ id_prato: id, ...dados });
    });
});

app.delete('/pratos/:id', (req, res) => {
    const id = Number(req.params.id);
    if (!Number.isInteger(id) || id <= 0) {
        return res.status(400).json({ erro: 'ID inválido.' });
    }

    db.query('DELETE FROM pedido_prato WHERE id_prato = ?', [id], (errVinculo) => {
        if (errVinculo) return res.status(500).json({ erro: 'Erro ao excluir prato.' });

        db.query('DELETE FROM prato WHERE id_prato = ?', [id], (err, result) => {
            if (err) return res.status(500).json({ erro: 'Erro ao excluir prato.' });
            if (result.affectedRows === 0) return res.status(404).json({ erro: 'Prato não encontrado.' });
            res.json({ removido: true });
        });
    });
});

initDb((err) => {
    if (err) {
        console.error('Erro ao conectar no MySQL (verifique se o MySQL/XAMPP está ativo):', err.message);
        process.exit(1);
    }
    app.listen(PORT, () => {
        console.log(`Servidor rodando em http://localhost:${PORT}`);
    });
});
