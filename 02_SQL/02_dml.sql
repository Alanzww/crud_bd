USE restaurant;

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

SELECT * FROM cliente;
SELECT * FROM prato;
SELECT * FROM pedido;

UPDATE mesa SET status = 'Reservada' WHERE numero = 2;
UPDATE prato SET preco = 56.00 WHERE id_prato = 2;

DELETE FROM pedido_prato WHERE id_pedido = 1 AND id_prato = 1;
