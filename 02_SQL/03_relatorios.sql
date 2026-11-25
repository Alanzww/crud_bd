-- Comandos de relatório
USE restaurant;

-- Relatório 1: Busca de pratos (WHERE + LIKE)
SELECT
    id_prato,
    nome,
    descricao,
    preco
FROM prato
WHERE nome LIKE '%de%'
  AND preco >= 15.00
ORDER BY preco DESC;

-- Relatório 2: Resumo de preços do cardápio (COUNT, MIN, MAX)
SELECT
    COUNT(*) AS total_pratos,
    MIN(preco) AS menor_preco,
    MAX(preco) AS maior_preco
FROM prato;

-- Relatório 3: Pedidos finalizados detalhados (INNER JOIN + WHERE)
SELECT
    p.id_pedido,
    p.data_hora,
    c.nome AS cliente,
    m.numero AS numero_mesa,
    f.nome AS funcionario,
    p.status,
    p.valor_total
FROM pedido p
INNER JOIN cliente c ON p.id_cliente = c.id_cliente
INNER JOIN mesa m ON p.id_mesa = m.id_mesa
INNER JOIN funcionario f ON p.id_funcionario = f.id_funcionario
WHERE p.status = 'Finalizado';
