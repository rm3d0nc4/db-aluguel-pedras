
-- Funções

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


/*
============================================
||                                    	  ||
||      Função para Validar TELEFONE      ||
||                                        ||
============================================
*/

CREATE OR REPLACE FUNCTION VALIDAR_TELEFONE(_TELEFONE VARCHAR(11))
RETURNS VOID
AS $$
BEGIN
	IF LENGTH(_TELEFONE) != 11 THEN
		RAISE EXCEPTION 'INVALID PHONE';
	END IF;
END;
$$
LANGUAGE 'plpgsql';


-- SELECT * FROM VALIDAR_TELEFONE('86999717036')
/*
=========================================
||                                     ||
||      Função para Validar EMAIL      ||
||                                     ||
=========================================
*/

CREATE OR REPLACE FUNCTION VALIDAR_EMAIL(_EMAIL VARCHAR(100))
RETURNS VOID
AS $$
BEGIN
	IF NOT _EMAIL ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' THEN
		RAISE EXCEPTION 'EMAIL INVALIDO. %', _EMAIL;
	END IF;
END;
$$ LANGUAGE 'plpgsql';

-- SELECT * FROM VALIDAR_EMAIL('romeromendonca22@gmail.com')
/*
========================================
||                                    ||
||      Função Cadastrar Parceiro     ||
||                                    ||
========================================
*/
CREATE OR REPLACE FUNCTION CADASTRAR_PARCEIRO(_NOME TEXT, _CPF_CNPJ VARCHAR(14), _TELEFONE TEXT, _EMAIL TEXT, _ENDERECO TEXT, _TIPO_PESSOA INT ) 
RETURNS VOID AS $$
	BEGIN
		INSERT INTO PARCEIRO VALUES 
		(DEFAULT, _NOME, _CPF_CNPJ, _TELEFONE, _EMAIL, _ENDERECO, _TIPO_PESSOA);
	END;
$$ LANGUAGE 'plpgsql';

-- SELECT * FROM CADASTRAR_PARCEIRO('ROMERO ANTONIO', '10030812313', '86999971736', 'romeromendonca@22gmail.com', 'RUA DAS LESMAS', 1);

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
		INSERT INTO PEDIDO VALUES (
			DEFAULT, _ID_METODO_PAGAMENTO, 
			_ID_PARCEIRO, _ID_ANALISTA, 
			_DATA_VENCIMENTO_PAGAMENTO_COMISSAO + 10
		) RETURNING ID_PEDIDO INTO VAR_ID_PEDIDO;
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
$$ LANGUAGE 'plpgsql';


/*
=====================================================
||                                     			   ||
||      Função para Validar PAGAMENTO ALUGUEL      ||
||                                     			   ||
=====================================================
*/


CREATE OR REPLACE FUNCTION PAGAMENTO_PEDIDO(_ID_PEDIDO INT)
RETURNS VOID
$$
VALOR_DIARIA_VAR FLOAT := 0;
BEGIN
	FOR VALOR_DIARIA IN SELECT COUNT (VALOR_DIARIA) FROM PEDRA WHERE 
	SELECT VALOR_DIARIA INTO VALOR_DIARIA_VAR FROM PEDRA;

	UPDATE PEDIDO SET 
	VALOR_ALUGUEL = VALOR_DIARIO * DIAS + VALOR_VENDIDO,
	DATA_PAGAMENTO = CURRENT_DATE,
	WHERE ID_PEDIDO = _ID_PEDIDO
END;
$$
LANGUAGE 'plpgsql'

CREATE OR REPLACE FUNCTION TESTE()
RETURNS VOID
AS $$
BEGIN
END;
$$

SELECT * FROM TIPO_PESSOA

SELECT * FROM CADASTRAR_PARCEIRO('ROMERO MENDONÇA', '10030812323', '86999971736', 'romeromendonca22@gmailcom', 'Rua das Lesmas', 1)