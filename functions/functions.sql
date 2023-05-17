
-- Funções



/*
========================================
||                                    ||
||       Função para Realizar         ||
||              Pedido                ||
========================================
*/
CREATE OR REPLACE FUNCTION CRIAR_PEDIDO(
	_ID_METODO_PAGAMENTO INT, 
	_ID_PARCEIRO INT, 
	_ID_ANALISTA INT, 
	_DATA_VENCIMENTO_PAGAMENTO_COMISSAO DATE
) RETURNS INT AS $$
	DECLARE VAR_ID_PEDIDO INT;
	BEGIN
		INSERT INTO PEDIDO(ID_METODO_PGTO, ID_PARCEIRO, ID_ANALISTA, DATA_VENCIMENTO_PAGAMENTO_COMISSAO) 
		VALUES (_ID_METODO_PAGAMENTO, _ID_PARCEIRO, _ID_ANALISTA, _DATA_VENCIMENTO_PAGAMENTO_COMISSAO + 10)
		RETURNING ID_PEDIDO INTO VAR_ID_PEDIDO;
		RETURN VAR_ID_PEDIDO;
	END

$$ LANGUAGE 'plpgsql';



/*
========================================
||                                    ||
||       Função para Adicionar        ||
||          Pedra ao Pedido           ||
========================================
*/
CREATE OR REPLACE FUNCTION ADD_ITEM(
	_ID_PEDRA INT, 
	_DATA_INICIAL DATE, 
	_DATA_FINAL DATE,
	_ID_PEDIDO INT DEFAULT NULL,
	_CPF_CNPJ INT DEFAULT NULL, 
	_ID_METODO_PAGAMENTO INT DEFAULT NULL
	) RETURNS INT AS $$
	DECLARE
	VAR_ID_ANALISTA INT;
	VAR_ID_PARCEIRO INT;
	VAR_ID_PEDIDO INT := _ID_PEDIDO;
	BEGIN
	SELECT ID_ANALISTA INTO VAR_ID_ANALISTA FROM ANALISTA WHERE NOME = CURRENT_USER;
	SELECT ID_PARCEIRO INTO VAR_ID_PARCEIRO FROM PARCEIRO WHERE CPF_CNPJ = _CPF_CNPJ;

	IF _ID_PEDIDO = NULL THEN
		SELECT CRIAR_PEDIDO(ID_METODO_PAGAMENTO, ID_PARCEIRO, ID_ANALISTA, DATA_VENCIMENTO_PAGAMENTO_COMISSAO) INTO VAR_ID_PEDIDO;
		RAISE NOTICE 'PEDIDO Nº % FOI CADASTRADO COM SUCESSO', VAR_ID_PEDIDO;
	END IF;
	
	INSERT INTO LISTA_PEDRAS_PEDIDO VALUES (ID_PEDRA, VAR_ID_PEDIDO, _DATA_INICIAL, _DATA_FINAL);
	RAISE NOTICE 'PEDRA ADICIONADA AO PEDIDO Nº %', VAR_ID_PEDIDO;
	
	END;
$$ LANGUAGE 'plpgsql'



/*
========================================
||                                    ||
||      Função para Validar CPF       ||
||                                    ||
========================================
*/
CREATE OR REPLACE FUNCTION VALIDAR_CPF(CPF VARCHAR(11)) 
RETURNS VOID AS 
$$

DECLARE
	CPF_ARRAY INT[] := STRING_TO_ARRAY(CPF, NULL);
	VALOR_DIGITO_1 INT := 0;
	VALOR_DIGITO_2 INT := 0;

BEGIN
	IF LENGTH(CPF) != 11 THEN
		RAISE EXCEPTION 'CPF INVÁLIDO. O CAMPO DEVE POSSUIR 11 DÍGITOS!';
	END IF;
	
	FOR I IN 1..9 LOOP
		VALOR_DIGITO_1 := VALOR_DIGITO_1 + CPF_ARRAY[I] * (11 - I);
	END LOOP;
	
	VALOR_DIGITO_1 := 11 - (VALOR_DIGITO_1 % 11);
	
	IF VALOR_DIGITO_1 > 9 THEN
		VALOR_DIGITO_1 := 0;
	END IF;
		
	FOR I IN 1..10 LOOP
		VALOR_DIGITO_2 := VALOR_DIGITO_2 + CPF_ARRAY[I] * (12 - I);
	END LOOP;
	
	VALOR_DIGITO_2 := 11 - (VALOR_DIGITO_2 % 11);
	
	IF VALOR_DIGITO_2 > 9 THEN
		VALOR_DIGITO_2 = 0;
	END IF;
	
	IF VALOR_DIGITO_1 != CPF_ARRAY[10] OR VALOR_DIGITO_2 != CPF_ARRAY[11] THEN
		RAISE EXCEPTION 'CPF INVÁLIDO. DÍGITOS VERIFICADORES INVÁLIDOS!';
	END IF;
	
	RAISE LOG 'CERTO!';
	
END;

$$ LANGUAGE 'plpgsql';


/*
========================================
||                                    ||
||      Função para Validar CNPJ      ||
||                                    ||
========================================
*/

CREATE OR REPLACE FUNCTION VALIDAR_CNPJ(CNPJ VARCHAR(14))
  RETURNS VOID AS $$
DECLARE
  CNPJ_ARRAY INT[14] := STRING_TO_ARRAY(CNPJ, NULL);
  sum INT := 0;
  mod INT;
  SOMA_DIGITO_1 INT := 0;
  DIGITO_1 INT;
  SOMA_DIGITO_2 INT := 0;
  DIGITO_2 INT;
BEGIN
  IF LENGTH(CNPJ) != 14 THEN
    RAISE EXCEPTION 'CNPJ INVÁLIDO. CNPJ PRECISA CONTER 14 CARACTERES.';
    
  END IF;

  SOMA_DIGITO_1 := CNPJ_ARRAY[1]*5 + CNPJ_ARRAY[2]*4 + CNPJ_ARRAY[3]*3 + CNPJ_ARRAY[4]*2
        + CNPJ_ARRAY[5]*9 + CNPJ_ARRAY[6]*8 + CNPJ_ARRAY[7]*7 + CNPJ_ARRAY[8]*6
        + CNPJ_ARRAY[9]*5 + CNPJ_ARRAY[10]*4 + CNPJ_ARRAY[11]*3 + CNPJ_ARRAY[12]*2;
  DIGITO_1 := (SOMA_DIGITO_1 % 11);
  DIGITO_1 := CASE WHEN DIGITO_1 < 2 THEN 0 ELSE 11 - DIGITO_1 END;

  SOMA_DIGITO_2 := CNPJ_ARRAY[1]*6 + CNPJ_ARRAY[2]*5 + CNPJ_ARRAY[3]*4 + CNPJ_ARRAY[4]*3
         + CNPJ_ARRAY[5]*2 + CNPJ_ARRAY[6]*9 + CNPJ_ARRAY[7]*8 + CNPJ_ARRAY[8]*7
         + CNPJ_ARRAY[9]*6 + CNPJ_ARRAY[10]*5 + CNPJ_ARRAY[11]*4 + CNPJ_ARRAY[12]*3
         + CNPJ_ARRAY[13]*2;
  DIGITO_2 := (SOMA_DIGITO_2 % 11);
  DIGITO_2 := CASE WHEN DIGITO_2 < 2 THEN 0 ELSE 11 - DIGITO_2 END;

  IF CNPJ_ARRAY[13] != DIGITO_1 OR CNPJ_ARRAY[14] != DIGITO_2 THEN
    RAISE EXCEPTION 'CNPJ INVÁLIDO. DIGÍTOS VERIFICADORES INVÁLIDOS.';
  END IF;
END;
$$ LANGUAGE 'plpgsql';


-- CADASTRAR PARCEIRO ==========================

CREATE OR REPLACE FUNCTION CADASTRAR_PARCEIRO()

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