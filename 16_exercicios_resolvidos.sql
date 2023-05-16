--Alunos: Fernando Cardoso e Kayo Kawam

--1.1 Escreva um cursor que exiba as variáveis rank e youtuber de toda tupla que tiver
--video_count pelo menos igual a 1000 e cuja category seja igual a Sports ou Music.

--Exemplo 1 - Sem Tupla

DO $$
DECLARE
	cur_rank_youtuber CURSOR FOR
	SELECT rank, youtuber
	FROM tb_top_youtubers
	WHERE video_count >= 1000 AND category = 'Sports' OR category = 'Music'
	ORDER BY rank ASC;
	rank INTEGER;
	youtuber VARCHAR(200);
	

BEGIN
	OPEN cur_rank_youtuber;
	LOOP
		FETCH FROM cur_rank_youtuber INTO rank, youtuber;
		EXIT WHEN NOT FOUND;
		RAISE NOTICE 'O youtuber é %, seu rank é %', youtuber, rank;
	END LOOP;
	CLOSE cur_rank_youtuber;
END;
$$





--EXEMPLO 2 - COM TUPLA


DO $$
DECLARE
	cur_rank_e_youtuber CURSOR FOR 
		SELECT rank, youtuber, video_count FROM tb_top_youtubers
		WHERE video_count >= 1000
		AND (category LIKE '%Music' OR category LIKE '%Sports');
	tupla RECORD;
	resultado TEXT DEFAULT '';
BEGIN
	OPEN cur_rank_e_youtuber;
	FETCH NEXT FROM cur_rank_e_youtuber INTO tupla;

	WHILE FOUND LOOP
		resultado := resultado || tupla.rank || ': ' || tupla.youtuber || ', ' || tupla.video_count || E'\n';
		FETCH NEXT FROM cur_rank_e_youtuber INTO tupla;
	END LOOP;

	CLOSE cur_rank_e_youtuber;
	RAISE NOTICE '%', resultado;
END; 
$$





-- 1.2 Escreva um cursor que exibe todos os nomes dos youtubers em ordem reversa. Para tal
-- - O SELECT deverá ordenar em ordem não reversa
-- - O Cursor deverá ser movido para a última tupla
-- - Os dados deverão ser exibidos de baixo para cima

DO $$
DECLARE
	cur_youtuber_reverse CURSOR FOR
		SELECT youtuber FROM tb_top_youtubers
		ORDER BY youtuber DESC;
	tupla RECORD;
	resultado TEXT DEFAULT '';
BEGIN
	OPEN cur_youtuber_reverse;
	FETCH LAST FROM cur_youtuber_reverse INTO tupla;

	WHILE FOUND LOOP
		resultado := resultado || tupla.youtuber || ' , ' || E'\n';
		FETCH PRIOR FROM cur_youtuber_reverse INTO tupla;
		IF NOT FOUND THEN
			EXIT;
		END IF;
	END LOOP;

	CLOSE cur_youtuber_reverse;
	RAISE NOTICE '%', resultado;
END;
$$