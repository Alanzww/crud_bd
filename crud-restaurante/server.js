const path = require('path');
const express = require('express');
const { db, initDb } = require('./db');

const app = express();
const PORT = 3000;

app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

function validarPrato(body) {
    const nome = typeof body.nome === 'string' ? body.nome.trim() : '';
    const categoria = typeof body.categoria === 'string' ? body.categoria.trim() : '';
    const preco = Number(body.preco);
    const disponivel = body.disponivel ? 1 : 0;

    if (!nome || !categoria || Number.isNaN(preco) || preco < 0) {
        return null;
    }
    return { nome, categoria, preco, disponivel };
}

app.get('/pratos', (req, res) => {
    db.all('SELECT * FROM prato ORDER BY id_prato DESC', (err, rows) => {
        if (err) return res.status(500).json({ erro: 'Erro ao listar pratos.' });
        res.json(rows);
    });
});

app.post('/pratos', (req, res) => {
    const dados = validarPrato(req.body);
    if (!dados) return res.status(400).json({ erro: 'Dados inválidos.' });

    const sql = 'INSERT INTO prato (nome, categoria, preco, disponivel) VALUES (?, ?, ?, ?)';
    db.run(sql, [dados.nome, dados.categoria, dados.preco, dados.disponivel], function (err) {
        if (err) return res.status(500).json({ erro: 'Erro ao cadastrar prato.' });
        res.status(201).json({ id_prato: this.lastID, ...dados });
    });
});

app.put('/pratos/:id', (req, res) => {
    const id = Number(req.params.id);
    const dados = validarPrato(req.body);
    if (!Number.isInteger(id) || id <= 0 || !dados) {
        return res.status(400).json({ erro: 'Dados inválidos.' });
    }

    const sql = 'UPDATE prato SET nome = ?, categoria = ?, preco = ?, disponivel = ? WHERE id_prato = ?';
    db.run(sql, [dados.nome, dados.categoria, dados.preco, dados.disponivel, id], function (err) {
        if (err) return res.status(500).json({ erro: 'Erro ao atualizar prato.' });
        if (this.changes === 0) return res.status(404).json({ erro: 'Prato não encontrado.' });
        res.json({ id_prato: id, ...dados });
    });
});

app.delete('/pratos/:id', (req, res) => {
    const id = Number(req.params.id);
    if (!Number.isInteger(id) || id <= 0) {
        return res.status(400).json({ erro: 'ID inválido.' });
    }

    db.run('DELETE FROM prato WHERE id_prato = ?', [id], function (err) {
        if (err) return res.status(500).json({ erro: 'Erro ao excluir prato.' });
        if (this.changes === 0) return res.status(404).json({ erro: 'Prato não encontrado.' });
        res.json({ removido: true });
    });
});

initDb((err) => {
    if (err) {
        console.error('Erro ao iniciar banco:', err.message);
        process.exit(1);
    }
    app.listen(PORT, () => {
        console.log(`Servidor rodando em http://localhost:${PORT}`);
    });
});
