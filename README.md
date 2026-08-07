# Sistema de Gestão de RH em MySQL

Este projeto consiste na modelagem e implementação de um banco de dados relacional em MySQL para gerenciamento de estrutura organizacional e Recursos Humanos.

## Tecnologias Utilizadas
- **SGBD:** MySQL 8.0
- **Ferramenta de Gerenciamento:** MySQL Workbench

## Estrutura e Destaques do Script
- **Modelagem Relacional (DDL):** Criação de tabelas para `funcionários`, `departamentos`, `cidades`, `funções` e `locais`, garantindo a integridade referencial através de Chaves Estrangeiras (`FOREIGN KEY`).
- **Visões (Views):** Criação da `vw_detalhes_funcionarios` para simplificação de consultas complexas com múltiplos `JOINs`.
- **Procedimentos Armazenados (Procedures):** `sp_reajustar_salario_departamento` para reajustes salariais percentuais automatizados.
- **Consultas Analíticas:** Utilização de `GROUP BY`, `HAVING`, subconsultas e funções temporais (`TIMESTAMPDIFF`, `DATE_ADD`) para geração de dados estatísticos da empresa.

## Como executar
1. Baixe o arquivo `bd_empresa.sql`.
2. Abra o MySQL Workbench e conecte-se ao seu servidor local.
3. Abra o arquivo no editor e execute o script completo (`Ctrl + Shift + Enter`).
