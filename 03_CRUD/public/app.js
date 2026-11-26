const form = document.getElementById('form-prato');
const formTitulo = document.getElementById('form-titulo');
const inputId = document.getElementById('id_prato');
const inputNome = document.getElementById('nome');
const inputDescricao = document.getElementById('descricao');
const inputCategoria = document.getElementById('id_categoria');
const inputPreco = document.getElementById('preco');
const btnCancelar = document.getElementById('btn-cancelar');
const tabela = document.getElementById('tabela-pratos');

let listaPratos = [];

function limparFormulario() {
    inputId.value = '';
    form.reset();
    inputCategoria.value = '2';
    formTitulo.textContent = 'Novo Prato';
    btnCancelar.hidden = true;
}

function editarPrato(id) {
    const prato = listaPratos.find(p => p.id_prato === id);
    if (!prato) return;

    inputId.value = prato.id_prato;
    inputNome.value = prato.nome;
    inputDescricao.value = prato.descricao || '';
    inputCategoria.value = prato.id_categoria;
    inputPreco.value = prato.preco;
    formTitulo.textContent = 'Editar Prato #' + prato.id_prato;
    btnCancelar.hidden = false;
}

async function carregarPratos() {
    const res = await fetch('/pratos');
    listaPratos = await res.json();

    tabela.innerHTML = '';

    for (const prato of listaPratos) {
        const precoFormatado = Number(prato.preco).toFixed(2).replace('.', ',');
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${prato.id_prato}</td>
            <td>${prato.nome}</td>
            <td>${prato.descricao || '-'}</td>
            <td>${prato.categoria}</td>
            <td>R$ ${precoFormatado}</td>
            <td class="acoes">
                <button type="button" class="btn-editar" onclick="editarPrato(${prato.id_prato})">Editar</button>
                <button type="button" class="btn-excluir" onclick="excluirPrato(${prato.id_prato})">Excluir</button>
            </td>
        `;
        tabela.appendChild(tr);
    }
}

async function excluirPrato(id) {
    if (!confirm('Deseja excluir este prato?')) return;

    await fetch('/pratos/' + id, { method: 'DELETE' });
    if (Number(inputId.value) === id) {
        limparFormulario();
    }
    carregarPratos();
}

form.addEventListener('submit', async (e) => {
    e.preventDefault();

    const id = inputId.value;
    const dados = {
        nome: inputNome.value,
        descricao: inputDescricao.value,
        id_categoria: Number(inputCategoria.value),
        preco: Number(inputPreco.value)
    };

    const url = id ? '/pratos/' + id : '/pratos';
    const metodo = id ? 'PUT' : 'POST';

    await fetch(url, {
        method: metodo,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(dados)
    });

    limparFormulario();
    carregarPratos();
});

btnCancelar.addEventListener('click', limparFormulario);

carregarPratos();
