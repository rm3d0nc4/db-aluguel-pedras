

-- Validar CPF ou CNPJ, TELEFONE e EMAIL
-- Função para realizar pagamento de um pedido (id_pedido) e gerar data de vencimento de pagamento da comissao
-- Funcao para pagar comissao (id_pedido)
-- Trigger para verificar se o parceiro possui multas
-- Trigger para gerar uma multa caso a comissão não tenha sido paga
-- chamar função aplicar multa
-- Funcao aplicar multa
-- Funcao pagar multa
-- Funcao para adicionar pedra ao pedido (id do pedido, id da pedra, data inicial, data final, metodo_pgto)
-- -- Funcao para atualizar o faturamento da pedra (id da pedra, id do pedido, valor)
-- -- Funcao para remover pedra do pedido (id da pedra, id do pedido)
-- -- Funcao para atualizar datas de uma pedra (id do pedra, id do pedido, data inicial, data final)
-- -- Trigger para atualizar o valor da comissão
-- -- Trigger para impedir adição de pedra em pedido já pago
-- -- 
-- Funcao para verificar status da pedra (id da pedra, data inicial, data final)


-- SELECT * FROM PEDRA FULL JOIN (SELECT * FROM LISTA_PEDRAS_PEDIDO PP WHERE DATA_INICIAL >= '2023-03-29' OR DATA_FINAL >= '2023-03-30') AS DIS  
-- 			   ON DIS.ID_PEDRA = PEDRA.ID_PEDRA


-- CREATE OR REPLACE FUNCTION VER_STATUS_PEDRA(_ID_PEDRA, _DATA_INICAL, _DATA_FINAL) 
-- RETURNS ROW AS $$

-- 	BEGIN


-- $$