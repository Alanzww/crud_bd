const form = document.getElementById('form-prato');
const formTitulo = document.getElementById('form-titulo');
const inputId = document.getElementById('id_prato');
const inputNome = document.getElementById('nome');
const inputDescricao = document.getElementById('descricao');
const inputCategoria = document.getElementById('id_categoria');
const inputPreco = document.getElementById('preco');
const btnCancelar = document.getElementById('btn-cancelar');
const tabela = document.getElementById('tabela-pratos');

function limparFormulario() {
    inputId.value = '';
    form.reset();
    inputCategoria.value = '2';
    formTitulo.textContent = 'Novo Prato';
    btnCancelar.hidden = true;
}

function preencherEdicao(prato) {
    inputId.value = prato.id_prato;
    inputNome.value = prato.nome;
    inputDescricao.value = prato.descricao || '';
    inputCategoria.value = String(prato.id_categoria);
    inputPreco.value = Number(prato.preco).toFixed(2);
    formTitulo.textContent = `Editando Prato #${prato.id_prato}`;
    btnCancelar.hidden = false;
    inputNome.focus();
}

function criarCelula(texto) {
    const td = document.createElement('td');
    td.textContent = texto;
    return td;
}

async function carregarPratos() {
    const resposta = await fetch('/pratos');
    const pratos = await resposta.json();

    tabela.innerHTML = '';

    if (pratos.length === 0) {
        const tr = document.createElement('tr');
        const td = document.createElement('td');
        td.colSpan = 6;
        td.textContent = 'Nenhum prato cadastrado.';
        tr.appendChild(td);
        tabela.appendChild(tr);
        return;
    }

    for (const prato of pratos) {
        const tr = document.createElement('tr');
        tr.appendChild(criarCelula(prato.id_prato));
        tr.appendChild(criarCelula(prato.nome));
        tr.appendChild(criarCelula(prato.descricao || '-'));
        tr.appendChild(criarCelula(prato.categoria));
        tr.appendChild(criarCelula(`R$ ${Number(prato.preco).toFixed(2).replace('.', ',')}`));

        const tdAcoes = document.createElement('td');
        tdAcoes.className = 'acoes';

        const btnEditar = document.createElement('button');
        btnEditar.type = 'button';
        btnEditar.className = 'btn-editar';
        btnEditar.textContent = 'Editar';
        btnEditar.addEventListener('click', () => preencherEdicao(prato));

        const btnExcluir = document.createElement('button');
        btnExcluir.type = 'button';
        btnExcluir.className = 'btn-excluir';
        btnExcluir.textContent = 'Excluir';
        btnExcluir.addEventListener('click', () => excluirPrato(prato.id_prato, prato.nome));

        tdAcoes.appendChild(btnEditar);
        tdAcoes.appendChild(btnExcluir);
        tr.appendChild(tdAcoes);
        tabela.appendChild(tr);
    }
}

async function excluirPrato(id, nome) {
    if (!confirm(`Deseja excluir o prato "${nome}"?`)) return;

    const resposta = await fetch(`/pratos/${id}`, { method: 'DELETE' });
    if (!resposta.ok) {
        alert('Não foi possível excluir o prato.');
        return;
    }

    if (Number(inputId.value) === id) {
        limparFormulario();
    }
    carregarPratos();
}

form.addEventListener('submit', async (event) => {
    event.preventDefault();

    const id = inputId.value;
    const dados = {
        nome: inputNome.value.trim(),
        descricao: inputDescricao.value.trim(),
        id_categoria: Number(inputCategoria.value),
        preco: Number(inputPreco.value)
    };

    const url = id ? `/pratos/${id}` : '/pratos';
    const metodo = id ? 'PUT' : 'POST';

    const resposta = await fetch(url, {
        method: metodo,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(dados)
    });

    if (!resposta.ok) {
        alert('Verifique os dados informados.');
        return;
    }

    limparFormulario();
    carregarPratos();
});

btnCancelar.addEventListener('click', limparFormulario);

carregarPratos();
