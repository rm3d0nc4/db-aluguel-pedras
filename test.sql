SELECT * FROM cadastrar_analista('ANA', '47371024079', 'RUA DO MEIO, COPACABANA', 6500.00, 3, '2024-06-20', 'aninha', '123456')
SELECT * FROM cadastrar_analista('SAMILLA', '10324633335', 'RUA DO BREJO, DIRCEU', 1500.00, 1, '2023-06-20', 'samilla', '123456');


SELECT * FROM cadastrar_parceiro('RAMOS', '51993229700050', '86999971736', 'romeromendonca22@gmail.com', 'rua das tulipas, verde la', 2)
SELECT * FROM cadastrar_parceiro('MENDES CASTRO', '90334541069', '86999971736', 'romeromendonca22@gmail.com', 'rua das tulipas, verde la', 1)


SELECT * FROM ver_pedras_disponiveis('2023-06-04', '2023-06-06')


select * from pedido

select * from lista_pedras_pedido

select * from add_item(1, '2023-06-07', '2023-06-10', 4)

SELECT * FROM remover_item(4, 1)

SELECT * FROM atualizar_data_pedra(4, 1, '2023-06-12', '2023-06-13');


SELECT * FROM faturar_pedra(4, 2, 100)


select * from lista_pedras_pedido

SELECT * FROM atualizar_data_pedra(4, 2, '2023-06-10', '2023-06-11');

SELECT * FROM add_item(1, '2023-06-08', '2023-06-11', 4)
SELECT * FROM remover_item(4, 1)
SELECT * FROM faturar_pedra(4, 2, 100.00)


select * from lista_pedras_pedido

SELECT * FROM atualizar_data_pedra(4, 2, '2023-06-10', '2023-06-11');

SELECT * FROM add_item(1, '2023-06-08', '2023-06-11', 4);
SELECT * FROM remover_item(4, 2)

SELECT * FROM faturar_pedra(4, 3, 267.00)

SELECT * FROM PEDIDO;

SELECT * FROM PAGAR_PEDIDO(4, 1)


SELECT * FROM CANCELAR_PEDIDO(4);

SELECT * FROM MULTAR_PEDIDO(23, 150.0, 'DESRESPEITO', )

SELECT * FROM MULTAR_PEDIDO(4, 150.0, 'DESRESPEITO', 3)

select * from tipo_multa

SELECT * FROM verificar_multas('10030812313')

SELECT * FROM add_item(5,  '2023-06-09',  '2023-06-10', NULL, '10030812313')

SELECT * FROM cancelar_pedido(5)

SELECT * FROM PEDIDO

SELECT * FROM pagar_multa(1)



SELECT * FROM MULTAR_PEDIDO(4, 150.0, 'DESRESPEITO', 3)

select * from tipo_multa

SELECT * FROM verificar_multas('10030812313')

SELECT * FROM add_item(5,  '2023-06-09',  '2023-06-10', 6)

SELECT * FROM cancelar_pedido(5)

SELECT * FROM PEDIDO

SELECT * FROM pagar_multa(1)

SELECT * FROM add_item(8, '2023-06-14', '2023-06-14', 8)
SELECT * FROM remover_item(8, 9)

SELECT ID_ANALISTA  FROM PEDIDO WHERE ID_PEDIDO = 8
SELECT ID_ANALISTA FROM ANALISTA WHERE USERNAME = CURRENT_USER::TEXT


SELECT ID_ANALISTA  FROM PEDIDO WHERE ID_PEDIDO = 8
SELECT ID_ANALISTA FROM ANALISTA WHERE USERNAME = CURRENT_USER


SELECT * FROM add_item(8, '2023-06-24', '2023-06-24', NULL, '10030812313')
SELECT * FROM add_item(6, '2023-06-24', '2023-06-24', 8)


SELECT (SELECT ID_ANALISTA  FROM PEDIDO WHERE ID_PEDIDO = 8) 
!= (SELECT ID_ANALISTA FROM ANALISTA WHERE USERNAME = CURRENT_USER)

SELECT CURRENT_USER != 'postgres'


SELECT * FROM PEDIDO

SELECT * FROM pagar_multa(1)

SELECT * FROM add_item(6, '2023-06-24', '2023-06-24', 9)
SELECT * FROM remover_item(9, 6)

SELECT ID_ANALISTA  FROM PEDIDO WHERE ID_PEDIDO = 8
SELECT ID_ANALISTA FROM ANALISTA WHERE USERNAME = CURRENT_USER::TEXT

SELECT CURRENT_USER != 'postgres'