--Aula 02/05/2023
DO $$
DECLARE
--cursor bound (vinculado)
--1. declarando o cursor
	cur_nomes_e_inscritos CURSOR FOR
	SELECT youtuber, subscribers FROM
	tb_top_youtubers;
	tupla RECORD;
	resultado TEXT DEFAULT '';
BEGIN
--2. abrindo o cursor
	OPEN cur_nomes_e_inscritos
--3. manipular o cursor
	FETCH cur_nomes_e_inscritos INTO tupla;
	WHILE FOUND LOOP
	-- realizando a concatenação
		resultado := resultado || tupla.youtuber
		|| ': ' || tupla.subscribers || ', '
		--'fetch' usado pra continuar a leitura das linhas
		FETCH cur_nomes_e_inscritos INTO tupla;
	END LOOP;
	--4. fecha o cursor
	CLOSE cur_nomes_e_inscritos;
	RAISE NOTICE '%', resultado;
END;
$$





DO $$
DECLARE
--1. declaração (unbound)
	cur_nomes_a_partir_de REFCURSOR;
	v_youtuber VARCHAR(200);
	v_ano INT := 2008;
	v_nome_tabela VARCHAR(200) := 'tb_top_youtubers';
	
BEGIN
--2. abrir o cursor
	OPEN cur_nomes_a_partir_de FOR EXECUTE(
	format(
		'
		SELECT youtuber FROM %s 
		WHERE started >= $1	
		', 
		v_nome_tabela

	)
) USING v_ano;
LOOP
--3. obtém dados de interesse
	FETCH cur_nomes_a_partir_de INTO v_youtuber;
	EXIT WHEN NOT FOUND;
	RAISE NOTICE '%', v_youtuber;
END LOOP;
--4. fechar o cursor
CLOSE cur_nomes_a_partir_de;
END;
$$





DO $$
DECLARE
--1. declaração do cursor
--esse cursor é unbound (não vinculado)
--ele foi declarado sem que um comando fosse associado a ele

	cur_nomes_youtubers REFCURSOR;
	v_youtuber VARCHAR(200);
	
BEGIN
--2. abertura de cursor
	OPEN cur_nomes_youtubers FOR
		SELECT youtuber FROM tb_top_youtubers;
	LOOP
	--3. Recuperação dos dados de interesse
		FETCH cur_nomes_youtubers INTO v_youtuber;
		EXIT WHEN NOT FOUND;
		RAISE NOTICE '%', v_youtuber;
	END LOOP;
	--4. Fechar o cursor
	CLOSE cur_nomes_youtubers;
END;
$$


--DROP TABLE tb_top_youtubers;
CREATE TABLE tb_top_youtubers(
	cod_top_youtubers SERIAL PRIMARY KEY,
	rank INT,
	youtuber VARCHAR(200),
	subscribers VARCHAR(200),
	video_views VARCHAR(200),
	video_count VARCHAR(200),
	category VARCHAR(200),
	started INT
);