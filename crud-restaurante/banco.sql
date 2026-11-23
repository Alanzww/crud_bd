CREATE TABLE IF NOT EXISTS cliente (
    id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    telefone TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS mesa (
    id_mesa INTEGER PRIMARY KEY AUTOINCREMENT,
    numero INTEGER NOT NULL UNIQUE,
    capacidade INTEGER NOT NULL,
    status TEXT NOT NULL DEFAULT 'Livre'
);

CREATE TABLE IF NOT EXISTS prato (
    id_prato INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    categoria TEXT NOT NULL,
    preco REAL NOT NULL,
    disponivel INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS pedido (
    id_pedido INTEGER PRIMARY KEY AUTOINCREMENT,
    id_cliente INTEGER NOT NULL,
    id_mesa INTEGER NOT NULL,
    data_hora TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status TEXT NOT NULL DEFAULT 'Aberto',
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_mesa) REFERENCES mesa(id_mesa)
);

CREATE TABLE IF NOT EXISTS item_pedido (
    id_item INTEGER PRIMARY KEY AUTOINCREMENT,
    id_pedido INTEGER NOT NULL,
    id_prato INTEGER NOT NULL,
    quantidade INTEGER NOT NULL DEFAULT 1,
    observacao TEXT,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_prato) REFERENCES prato(id_prato)
);

INSERT INTO prato (nome, categoria, preco, disponivel) VALUES
    ('Baião de Dois', 'Prato Principal', 38.50, 1),
    ('Carne de Sol com Macaxeira', 'Prato Principal', 54.90, 1),
    ('Pudim de Leite', 'Sobremesa', 14.00, 1),
    ('Suco de Caju 500ml', 'Bebida', 9.50, 1);
