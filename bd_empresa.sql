-- ============================================================
-- PROJETO: Sistema de Gestão de RH e Estrutura Organizacional
-- SGBD: MySQL 8.0+
-- DESCRIÇÃO: Script DDL/DML com modelagem relacional, views, 
--            procedures e queries analíticas de negócio.
-- ============================================================

CREATE DATABASE IF NOT EXISTS empresa_db;
USE empresa_db;

-- ------------------------------------------------------------
-- 1. ESTRUTURA DO BANCO DE DADOS (DDL)
-- ------------------------------------------------------------

DROP TABLE IF EXISTS tb_funcionario;
DROP TABLE IF EXISTS tb_departamento;
DROP TABLE IF EXISTS tb_local;
DROP TABLE IF EXISTS tb_funcao;
DROP TABLE IF EXISTS tb_cidade;

CREATE TABLE tb_cidade (
    id_cidade INT AUTO_INCREMENT PRIMARY KEY,
    nome_cidade VARCHAR(50) NOT NULL,
    uf CHAR(2) NOT NULL
);

CREATE TABLE tb_funcao (
    id_funcao INT AUTO_INCREMENT PRIMARY KEY,
    nome_funcao VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE tb_local (
    id_local INT AUTO_INCREMENT PRIMARY KEY,
    nome_local VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE tb_departamento (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nome_departamento VARCHAR(50) UNIQUE NOT NULL,
    id_local INT NOT NULL,
    CONSTRAINT fk_dept_local FOREIGN KEY (id_local) REFERENCES tb_local(id_local)
);

CREATE TABLE tb_funcionario (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome_funcionario VARCHAR(100) NOT NULL,
    dt_admissao DATE NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    id_departamento INT NOT NULL,
    id_cidade INT NOT NULL,
    id_funcao INT NOT NULL,
    CONSTRAINT fk_func_dept FOREIGN KEY (id_departamento) REFERENCES tb_departamento(id_departamento),
    CONSTRAINT fk_func_cidade FOREIGN KEY (id_cidade) REFERENCES tb_cidade(id_cidade),
    CONSTRAINT fk_func_funcao FOREIGN KEY (id_funcao) REFERENCES tb_funcao(id_funcao)
);

-- ------------------------------------------------------------
-- 2. POPULAÇÃO DE DADOS (DML)
-- ------------------------------------------------------------

INSERT INTO tb_cidade (id_cidade, nome_cidade, uf) VALUES
(1, 'São Paulo', 'SP'),
(2, 'Rio de Janeiro', 'RJ'),
(3, 'Belo Horizonte', 'MG'),
(4, 'Curitiba', 'PR'),
(5, 'Porto Alegre', 'RS'),
(6, 'Florianópolis', 'SC'),
(7, 'Salvador', 'BA'),
(8, 'Recife', 'PE'),
(9, 'Fortaleza', 'CE'),
(10, 'Manaus', 'AM');

INSERT INTO tb_funcao (nome_funcao) VALUES
('Desenvolvedor Jr'),
('Desenvolvedor Pleno'),
('Desenvolvedor Sênior'),
('Analista de Sistemas'),
('Testador de Software'),
('Gerente de Projetos');

INSERT INTO tb_local (nome_local) VALUES
('1º ANDAR'),
('2º ANDAR'),
('3º ANDAR'),
('TÉRREO'),
('SUBSOLO');

INSERT INTO tb_departamento (nome_departamento, id_local) VALUES
('Desenvolvimento', 1),
('Qualidade', 2),
('Infraestrutura', 3),
('Administrativo', 4);

INSERT INTO tb_funcionario 
(nome_funcionario, dt_admissao, cpf, salario, id_departamento, id_cidade, id_funcao) 
VALUES
('Ana Silva', '2022-01-10', '12345678901', 3500.00, 1, 1, 1),
('Bruno Costa', '2021-03-15', '23456789012', 4200.00, 1, 2, 2),
('Carla Mendes', '2020-06-20', '34567890123', 6500.00, 1, 3, 3),
('Daniel Rocha', '2019-08-05', '45678901234', 4800.00, 2, 4, 4),
('Eduarda Lima', '2023-02-01', '56789012345', 3200.00, 2, 5, 5),
('Felipe Nunes', '2021-11-12', '67890123456', 7000.00, 3, 6, 3),
('Gabriela Souza', '2020-04-18', '78901234567', 5200.00, 3, 7, 2),
('Henrique Alves', '2018-09-30', '89012345678', 8000.00, 3, 8, 6),
('Isabela Torres', '2022-07-25', '90123456789', 3600.00, 4, 9, 1),
('João Pereira', '2019-12-10', '11223344556', 4100.00, 4, 10, 2),
('Karen Ribeiro', '2021-05-14', '22334455667', 5400.00, 1, 1, 4),
('Lucas Martins', '2020-10-09', '33445566778', 6000.00, 2, 2, 3),
('Marina Lopes', '2023-01-16', '44556677889', 3300.00, 2, 3, 5),
('Nicolas Freitas', '2018-02-22', '55667788990', 7500.00, 3, 4, 6),
('Paula Azevedo', '2022-09-01', '66778899001', 3900.00, 4, 5, 1);

-- ------------------------------------------------------------
-- 3. VISÕES (VIEWS)
-- ------------------------------------------------------------

-- View para consulta rápida e unificada da ficha dos funcionários
CREATE OR REPLACE VIEW vw_detalhes_funcionarios AS
SELECT 
    f.id_funcionario,
    f.nome_funcionario,
    f.cpf,
    f.salario,
    f.dt_admissao,
    fn.nome_funcao,
    d.nome_departamento,
    l.nome_local,
    c.nome_cidade,
    c.uf
FROM tb_funcionario f
INNER JOIN tb_funcao fn ON f.id_funcao = fn.id_funcao
INNER JOIN tb_departamento d ON f.id_departamento = d.id_departamento
INNER JOIN tb_local l ON d.id_local = l.id_local
INNER JOIN tb_cidade c ON f.id_cidade = c.id_cidade;

-- ------------------------------------------------------------
-- 4. PROCEDURES (REGRAS DE NEGÓCIO)
-- ------------------------------------------------------------

-- Procedure para reajuste salarial percentual por departamento
DELIMITER //
CREATE PROCEDURE sp_reajustar_salario_departamento(
    IN p_id_departamento INT,
    IN p_percentual DECIMAL(5,2)
)
BEGIN
    UPDATE tb_funcionario
    SET salario = salario * (1 + (p_percentual / 100))
    WHERE id_departamento = p_id_departamento;
END //
DELIMITER ;

-- ------------------------------------------------------------
-- 5. CONSULTAS ANALÍTICAS E DE NEGÓCIO (QUERIES)
-- ------------------------------------------------------------

-- 5.1. Consulta completa simplificada via View
SELECT * FROM vw_detalhes_funcionarios ORDER BY nome_funcionario;

-- 5.2. Média salarial e folha de pagamento total por departamento
SELECT 
    d.nome_departamento,
    COUNT(f.id_funcionario) AS total_funcionarios,
    SUM(f.salario) AS folha_pagamento_total,
    ROUND(AVG(f.salario), 2) AS media_salarial
FROM tb_departamento d
INNER JOIN tb_funcionario f ON d.id_departamento = f.id_departamento
GROUP BY d.id_departamento, d.nome_departamento
ORDER BY folha_pagamento_total DESC;

-- 5.3. Funcionários com salário acima da média geral da empresa (Subquery)
SELECT 
    nome_funcionario,
    salario,
    dt_admissao
FROM tb_funcionario
WHERE salario > (SELECT AVG(salario) FROM tb_funcionario)
ORDER BY salario DESC;

-- 5.4. Tempo de casa dos funcionários e projeção de quinquênio (Funções de Data)
SELECT 
    nome_funcionario,
    dt_admissao,
    TIMESTAMPDIFF(YEAR, dt_admissao, CURDATE()) AS anos_de_empresa,
    DATE_ADD(dt_admissao, INTERVAL 5 YEAR) AS data_proximo_quinquenio
FROM tb_funcionario
ORDER BY anos_de_empresa DESC;