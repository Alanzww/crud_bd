CREATE DATABASE IF NOT EXISTS restaurant;
USE restaurant;

CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE mesa (
    id_mesa INT AUTO_INCREMENT PRIMARY KEY,
    numero INT NOT NULL UNIQUE,
    capacidade INT NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'Livre'
);

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20)
);

CREATE TABLE funcionario (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    cargo VARCHAR(60) NOT NULL,
    salario DECIMAL(10, 2) NOT NULL
);

CREATE TABLE prato (
    id_prato INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    preco DECIMAL(10, 2) NOT NULL,
    id_categoria INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

CREATE TABLE pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL DEFAULT 'Aberto',
    valor_total DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    id_mesa INT NOT NULL,
    id_cliente INT NOT NULL,
    id_funcionario INT NOT NULL,
    FOREIGN KEY (id_mesa) REFERENCES mesa(id_mesa),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
);

CREATE TABLE pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    data_pagamento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor DECIMAL(10, 2) NOT NULL,
    forma VARCHAR(40) NOT NULL,
    id_pedido INT NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
);

CREATE TABLE pedido_prato (
    id_pedido INT NOT NULL,
    id_prato INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    observacao VARCHAR(200),
    PRIMARY KEY (id_pedido, id_prato),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_prato) REFERENCES prato(id_prato)
);

-- Alter e Drop
ALTER TABLE cliente ADD COLUMN email VARCHAR(120);
ALTER TABLE cliente MODIFY COLUMN email VARCHAR(150);
ALTER TABLE cliente DROP COLUMN email;

CREATE TABLE log_temporario (
    id INT PRIMARY KEY,
    descricao VARCHAR(50)
);
DROP TABLE log_temporario;
