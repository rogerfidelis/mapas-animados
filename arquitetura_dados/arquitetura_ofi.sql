

CREATE TABLE core.empresas (
    id_empresa INTEGER GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(100) NOT NULL,
    
    CONSTRAINT pk_empresas
        PRIMARY KEY (id_empresa),
    
    CONSTRAINT uq_empresas_nome
        UNIQUE (nome)
);

SELECT *
FROM core.empresas;

INSERT INTO core.empresas (nome)
VALUES
    ('BRAM'),
    ('CBO'),
    ('STARNAV');

SELECT * 
FROM core.empresas
ORDER BY id_empresa;

SELECT * 
FROM core.embarcacoes
ORDER BY id_embarcacao;

CREATE TABLE core.embarcacoes(
	id_embarcacao INTEGER GENERATED ALWAYS AS IDENTITY,
	nome VARCHAR(100) NOT NULL,
	id_empresa INTEGER NOT NULL,

	CON
	)

CREATE TABLE core.ativos (
	id_ativo INTEGER GENERATED ALWAYS AS IDE
)

SELECT *
FROM core.ativos
ORDER BY id_ativo;

ALTER TABLE core.ativos
DROP COLUMN latitude,
DROP COLUMN longitude;

SELECT*
FROM core.ativos;

CREATE TABLE core.campos(
	id_campo INTEGER D
)

CREATE TABLE core.locais_fixos (
	id_local INTEGER GENERATED ALWAYS AS IDENTITY,
	nome VARCHAR (100) NOT NULL,
	tipo_local VARCHAR (50) NOT NULL,
	latitude NUMERIC (9,8) NOT NULL,
	longitude NUMERIC (9,8) NOT NULL,

	CONSTRAINT pk_locais_fixos
		PRIMARY KEY (id_local),

	CONSTRAINT uq_locais_fixos_nome
		UNIQUE (nome),

	CONSTRAINT ck_locais_fixos_tipo
		CHECK (tipo_local IN ('PORTO', 'ESTALEIRO'))
);

INSERT INTO core.locais_fixos
	(nome, tipo_local, latitude, longitude)
VALUES
	('Porto do Rio de Janeiro', 'PORTO', -22.895000, -43.180000),
    ('Porto de Santos', 'PORTO', -23.960000, -46.305000),
    ('Estaleiro Teste', 'ESTALEIRO', -22.750000, -43.150000);

SELECT*
FROM raw.posicoes_bram
ORDER BY id_posicao;

ALTER TABLE core.locais_fixos
RENAME COLUMN latitute TO latitude;

ALTER TABLE core.locais_fix
RENAME COLUMN latitute TO latitude;

ALTER TABLE core.locais_fixos
ALTER COLUMN latitude TYPE NUMERIC(10, 6);

CREATE TABLE raw.posicoes_bram (
    id_posicao BIGSERIAL PRIMARY KEY,
    id_embarcacao BIGINT,
    data_consulta TIMESTAMP,
    latitude NUMERIC(10,7),
    longitude NUMERIC(10,7),
    data_reportada TIMESTAMP,
    status VARCHAR(100)
);

CREATE TABLE raw.posicoes_cbo (
    id_posicao BIGSERIAL PRIMARY KEY,
    id_embarcacao BIGINT,
    data_consulta TIMESTAMP,
    latitude NUMERIC(10,7),
    longitude NUMERIC(10,7),
    data_reportada TIMESTAMP,
    status VARCHAR(100)
);

CREATE TABLE raw.posicoes_starnav (
    id_posicao BIGSERIAL PRIMARY KEY,
    id_embarcacao BIGINT,
    data_consulta TIMESTAMP,
    latitude NUMERIC(10,7),
    longitude NUMERIC(10,7),
    data_reportada TIMESTAMP,
    status VARCHAR(100)
);

SELECT COUNT(*) AS total
FROM raw.posicoes_bram;

-- 2. Quantidade por embarcação
SELECT
    id_embarcacao,
    COUNT(*) AS quantidade
FROM raw.posicoes_starnav
GROUP BY id_embarcacao
ORDER BY id_embarcacao;

-- 3. Verificar nulos
SELECT
    COUNT(*) FILTER (WHERE id_embarcacao IS NULL) AS embarcacao_nula,
    COUNT(*) FILTER (WHERE data_consulta IS NULL) AS consulta_nula,
    COUNT(*) FILTER (WHERE latitude IS NULL) AS latitude_nula,
    COUNT(*) FILTER (WHERE longitude IS NULL) AS longitude_nula,
    COUNT(*) FILTER (WHERE data_reportada IS NULL) AS reportada_nula,
    COUNT(*) FILTER (WHERE status IS NULL) AS status_nulo
FROM raw.posicoes_bram;

-- 4. Amostra real
SELECT *
FROM raw.posicoes_cbo
ORDER BY id_posicao
LIMIT 20;


SELECT
    id_embarcacao,
    data_consulta,
    latitude,
    longitude,
    data_reportada,
    status,
    COUNT(*) AS quantidade

DELETE FROM raw.posicoes_bram a
USING raw.posicoes_bram b
WHERE
    a.ctid > b.ctid
    AND a.id_embarcacao = b.id_embarcacao
    AND a.data_consulta = b.data_consulta
    AND a.latitude = b.latitude
    AND a.longitude = b.longitude
    AND a.data_reportada = b.data_reportada
    AND a.status = b.status;
FROM raw.posicoes_bram
GROUP BY
    id_embarcacao,
    data_consulta,
    latitude,
    longitude,
    data_reportada,
    status
HAVING COUNT(*) > 1
ORDER BY quantidade DESC;

ALTER TABLE raw.posicoes_starnav
ADD CONSTRAINT uq_posicoes_starnav
UNIQUE (
    id_embarcacao,
    data_consulta,
    latitude,
    longitude,
    data_reportada,
    status
);

CREATE TABLE core.campos (
    id_campo BIGSERIAL PRIMARY KEY,

    id_origem INTEGER,

    codigo_campo INTEGER NOT NULL,
    sigla VARCHAR(20),
    nome VARCHAR(150) NOT NULL,

    bacia VARCHAR(100),

    operadora_id BIGINT,

    area_km2 NUMERIC(12,3),

    numero_contrato VARCHAR(30),
    numero_rodada VARCHAR(30),

    data_assinatura DATE,
    data_termino DATE,
    data_descoberta DATE,
    data_inicio DATE,

    etapa VARCHAR(50),

    lamina_agua_m NUMERIC(10,2),

    fluido_principal VARCHAR(30),
    ambiente VARCHAR(20),

    geom geometry(MultiPolygon, 4674) NOT NULL,

    ativo BOOLEAN DEFAULT TRUE,

    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE EXTENSION IF NOT EXISTS postgis;
SELECT PostGIS_Version();

DROP TABLE core.campos;