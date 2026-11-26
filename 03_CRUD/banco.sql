CREATE DATABASE IF NOT EXISTS restaurant;
USE restaurant;

CREATE TABLE IF NOT EXISTS categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS mesa (
    id_mesa INT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL UNIQUE,
    capacidade INT NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'Livre'
);

CREATE TABLE IF NOT EXISTS cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS funcionario (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    cargo VARCHAR(60) NOT NULL,
    salario DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS prato (
    id_prato INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    preco DECIMAL(10, 2) NOT NULL,
    id_categoria INT NOT NULL,
    CONSTRAINT fk_prato_categoria
        FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL DEFAULT 'Aberto',
    valor_total DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    id_mesa INT NOT NULL,
    id_cliente INT NOT NULL,
    id_funcionario INT NOT NULL,
    CONSTRAINT fk_pedido_mesa
        FOREIGN KEY (id_mesa) REFERENCES mesa(id_mesa)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pedido_funcionario
        FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    data_pagamento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor DECIMAL(10, 2) NOT NULL,
    forma VARCHAR(40) NOT NULL,
    id_pedido INT NOT NULL,
    CONSTRAINT fk_pagamento_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS pedido_prato (
    id_pedido INT NOT NULL,
    id_prato INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    observacao VARCHAR(200),
    PRIMARY KEY (id_pedido, id_prato),
    CONSTRAINT fk_pedido_prato_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_pedido_prato_prato
        FOREIGN KEY (id_prato) REFERENCES prato(id_prato)
        ON UPDATE CASCADE ON DELETE RESTRICT
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
