/*
========================================
||                                    ||
||      Trigger Validar Parceiro      ||
||                                    ||
========================================
*/


CREATE OR REPLACE FUNCTION T_VALIDACAO_PARCEIRO() 
RETURNS TRIGGER AS $$
	BEGIN
		PERFORM VALIDAR_EMAIL(NEW.EMAIL);
		PERFORM VALIDAR_TELEFONE(NEW.TELEFONE);

		IF(NEW.TIPO_PESSOA = 1) THEN
			PERFORM VALIDAR_CPF(NEW.CPF_CNPJ);
		ELSE
			PERFORM VALIDAR_CNPJ(NEW.CPF_CNPJ);
		END IF;
        RAISE NOTICE 'PARCEIRO CADASTRADO COM SUCESSO!';
		RETURN NEW;
	END;
$$ LANGUAGE 'plpgsql';


CREATE OR REPLACE TRIGGER TRIGGER_VALIDACAO_PARCEIRO BEFORE INSERT OR UPDATE ON PARCEIRO FOR EACH ROW EXECUTE PROCEDURE T_VALIDACAO_PARCEIRO();

/*
========================================
||                                    ||
||      Trigger Validar Parceiro      ||
||                                    ||
========================================
*/


CREATE OR REPLACE FUNCTION T_VALIDACAO_ANALISTA()
RETURNS TRIGGER AS $$
    BEGIN
        PERFORM VALIDAR_CPF(NEW.CPF_ANALISTA);
        RAISE NOTICE 'ANALISTA CADASTRADO COM SUCESSO!';
        RETURN NEW;
    END;

$$  LANGUAGE 'plpgsql';

CREATE OR REPLACE TRIGGER TRIGGER_VALIDACAO_ANALISTA BEFORE INSERT OR UPDATE ON ANALISTA FOR EACH ROW EXECUTE PROCEDURE T_VALIDACAO_ANALISTA();