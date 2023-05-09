SELECT * FROM tb_top_youtubers
WHERE video_count IS NULL;

DO $$
DECLARE
	cur_delete REFCURSOR;
	tupla RECORD;
BEGIN
	OPEN cur_delete SCROLL FOR
		SELECT * FROM tb_top_youtubers;
	
	LOOP
		--3. recuperar dados do cursor
		FETCH cur_delete INTO tupla;
		EXIT WHEN NOT FOUND;
		IF tupla.video_count IS NULL THEN
			DELETE FROM tb_top_youtubers
			WHERE CURRENT OF cur_delete;
		END IF;
	END LOOP;
	LOOP
		FETCH BACKWARD FROM cur_delete INTO tupla;
		EXIT WHEN NOT FOUND;
		RAISE NOTICE '%', tupla;
	END LOOP;

END;
$$




DO $$
DECLARE
	v_ano INT := 2010;
	v_inscritos INT := 60000000;
	cur_ano_inscritos CURSOR(
		ano INT,			
		inscritos INT
		) FOR SELECT youtuber FROM tb_top_youtubers
		WHERE 
			started >= v_ano 
				AND subscribers >= inscritos;
		v_youtuber VARCHAR(200);
BEGIN
--2 abrir o cursor
--passando parâmetros pela ordem
--só é possível um cursor de cada vez
	OPEN cur_ano_inscritos(v_ano, v_inscritos);
--passando parâmetros pelo nome
	OPEN cur_ano_inscritos(
	
		inscritos := v_inscritos,
		ano := v_ano
	);

END;
$$

SELECT * FROM tb_top_youtubers;


--REALIZANDO O TRATAMENTO DOS DADOS

-- UPDATE
-- 	tb_top_youtubers
-- SET
-- 	subscribers = REPLACE (subscribers, ',', '');

--UPDATE
--	tb_top_youtubers
--SET
--	video_views = REPLACE (video_views, ',', '');

-- UPDATE
-- 	tb_top_youtubers
-- SET
-- 	subscribers = REPLACE (subscribers, ',', '');


--ALTER TABLE tb_top_youtubers ALTER COLUMN
--	video_views TYPE BIGINT USING video_views:: BIGINT;

-- ALTER TABLE tb_top_youtubers ALTER COLUMN
-- 	video_count TYPE INTEGER USING video_count:: INT;

-- UPDATE
-- 	tb_top_youtubers
-- SET
-- 	video_count = REPLACE (video_count, ',', '');
