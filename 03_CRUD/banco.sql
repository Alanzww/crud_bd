CREATE TABLE IF NOT EXISTS categoria (
    id_categoria INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS mesa (
    id_mesa INTEGER PRIMARY KEY AUTOINCREMENT,
    numero INTEGER NOT NULL UNIQUE,
    capacidade INTEGER NOT NULL,
    status TEXT NOT NULL DEFAULT 'Livre'
);

CREATE TABLE IF NOT EXISTS cliente (
    id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    cpf TEXT NOT NULL UNIQUE,
    telefone TEXT
);

CREATE TABLE IF NOT EXISTS funcionario (
    id_funcionario INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    cargo TEXT NOT NULL,
    salario REAL NOT NULL
);

CREATE TABLE IF NOT EXISTS prato (
    id_prato INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    descricao TEXT,
    preco REAL NOT NULL,
    id_categoria INTEGER NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

CREATE TABLE IF NOT EXISTS pedido (
    id_pedido INTEGER PRIMARY KEY AUTOINCREMENT,
    data_hora TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status TEXT NOT NULL DEFAULT 'Aberto',
    valor_total REAL NOT NULL DEFAULT 0.00,
    id_mesa INTEGER NOT NULL,
    id_cliente INTEGER NOT NULL,
    id_funcionario INTEGER NOT NULL,
    FOREIGN KEY (id_mesa) REFERENCES mesa(id_mesa),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
);

CREATE TABLE IF NOT EXISTS pagamento (
    id_pagamento INTEGER PRIMARY KEY AUTOINCREMENT,
    data_pagamento TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor REAL NOT NULL,
    forma TEXT NOT NULL,
    id_pedido INTEGER NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
);

CREATE TABLE IF NOT EXISTS pedido_prato (
    id_pedido INTEGER NOT NULL,
    id_prato INTEGER NOT NULL,
    quantidade INTEGER NOT NULL DEFAULT 1,
    observacao TEXT,
    PRIMARY KEY (id_pedido, id_prato),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_prato) REFERENCES prato(id_prato)
);

INSERT INTO categoria (nome) VALUES
    ('Entradas'),
    ('Pratos Principais'),
    ('Sobremesas'),
    ('Bebidas');

INSERT INTO mesa (numero, capacidade, status) VALUES
    (1, 4, 'Ocupada'),
    (2, 2, 'Livre'),
    (3, 6, 'Ocupada');

INSERT INTO cliente (nome, cpf, telefone) VALUES
    ('Ana Paula Souza', '111.222.333-44', '(88) 99999-1111'),
    ('Carlos Eduardo Lima', '222.333.444-55', '(88) 99999-2222'),
    ('Mariana Rocha', '333.444.555-66', '(88) 99999-3333');

INSERT INTO funcionario (nome, cargo, salario) VALUES
    ('Lucas Almeida', 'Garçom', 1850.00),
    ('Fernanda Costa', 'Garçom', 1850.00),
    ('Rafael Mendes', 'Chef de Cozinha', 4200.00);

INSERT INTO prato (nome, descricao, preco, id_categoria) VALUES
    ('Batata Frita Especial', 'Porção com cheddar e bacon', 28.90, 1),
    ('Filé à Parmegiana', 'Acompanha arroz branco e fritas', 54.00, 2),
    ('Pudim de Leite', 'Fatia tradicional com calda de caramelo', 16.50, 3),
    ('Suco de Cajá Natural', 'Jarra de 500ml', 12.00, 4);

INSERT INTO pedido (data_hora, status, valor_total, id_mesa, id_cliente, id_funcionario) VALUES
    ('2026-11-23 12:15:00', 'Em preparo', 82.90, 1, 1, 1),
    ('2026-11-23 12:30:00', 'Finalizado', 66.00, 3, 2, 2);

INSERT INTO pedido_prato (id_pedido, id_prato, quantidade, observacao) VALUES
    (1, 1, 1, 'Sem cebola'),
    (1, 2, 1, 'Ponto da carne ao ponto'),
    (2, 2, 1, NULL),
    (2, 4, 1, 'Pouco gelo');

INSERT INTO pagamento (data_pagamento, valor, forma, id_pedido) VALUES
    ('2026-11-23 13:10:00', 66.00, 'PIX', 2);
