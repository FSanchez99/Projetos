-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema teatro
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema teatro
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `teatro` DEFAULT CHARACTER SET utf8mb4 ;
-- -----------------------------------------------------
-- Schema halloween
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema halloween
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `halloween` DEFAULT CHARACTER SET utf8mb4 ;
USE `teatro` ;

-- -----------------------------------------------------
-- Table `teatro`.`pecas_teatro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `teatro`.`pecas_teatro` (
  `id_peca` INT(11) NOT NULL AUTO_INCREMENT,
  `nome_peca` VARCHAR(255) NOT NULL,
  `descricao` TEXT NULL DEFAULT NULL,
  `duracao` INT(11) NOT NULL,
  `data_hora` DATETIME NOT NULL,
  PRIMARY KEY (`id_peca`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4;

USE `halloween` ;

-- -----------------------------------------------------
-- Table `halloween`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `halloween`.`usuarios` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NULL DEFAULT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  `idade` INT(11) NULL DEFAULT NULL,
  `data_registro` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 10001
DEFAULT CHARACTER SET = utf8mb4;

USE `teatro` ;

-- -----------------------------------------------------
-- procedure agendar_peca
-- -----------------------------------------------------

DELIMITER $$
USE `teatro`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `agendar_peca`(
    IN nome_peca_input VARCHAR(255),
    IN descricao_input TEXT,
    IN duracao_input INT,
    IN data_hora_input DATETIME
)
BEGIN
    DECLARE disponibilidade BOOLEAN;
    DECLARE media_duracao DECIMAL(10, 2);
    
    -- Verificar a disponibilidade usando a função verificar_disponibilidade
    SET disponibilidade = verificar_disponibilidade(data_hora_input);
    
    IF disponibilidade = TRUE THEN
        -- Inserir a nova peça na tabela pecas_teatro
        INSERT INTO pecas_teatro (nome_peca, descricao, duracao, data_hora)
        VALUES (nome_peca_input, descricao_input, duracao_input, data_hora_input);
        
        -- Calcular a média da duração usando a função calcular_media_duracao
        SET media_duracao = calcular_media_duracao(LAST_INSERT_ID());
        
        -- Imprimir as informações sobre a peça agendada
        SELECT 'Peça agendada com sucesso!' AS mensagem,
               nome_peca_input AS nome_da_peca,
               duracao_input AS duracao_em_minutos,
               media_duracao AS media_duracao;
    ELSE
        -- Caso não esteja disponível
        SELECT 'Erro: já existe uma peça agendada para essa data e hora.' AS mensagem;
    END IF;
    
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function calcular_media_duracao
-- -----------------------------------------------------

DELIMITER $$
USE `teatro`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `calcular_media_duracao`(id_peca_input INT) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
    DECLARE media_duracao DECIMAL(10, 2);

    SELECT AVG(duracao)
    INTO media_duracao
    FROM pecas_teatro
    WHERE id_peca = id_peca_input;

    RETURN media_duracao;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function verificar_disponibilidade
-- -----------------------------------------------------

DELIMITER $$
USE `teatro`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `verificar_disponibilidade`(data_hora_input DATETIME) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    DECLARE disponibilidade BOOLEAN;

    -- Verifica se já existe uma peça agendada para essa data e hora
    IF EXISTS (
        SELECT 1
        FROM pecas_teatro
        WHERE data_hora = data_hora_input
    )
    THEN
        SET disponibilidade = FALSE; -- Não disponível
    ELSE
        SET disponibilidade = TRUE; -- Disponível
    END IF;

    RETURN disponibilidade;
END$$

DELIMITER ;
USE `halloween` ;

-- -----------------------------------------------------
-- procedure inserir_usuarios_aleatorios
-- -----------------------------------------------------

DELIMITER $$
USE `halloween`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `inserir_usuarios_aleatorios`()
BEGIN
    DECLARE i INT DEFAULT 0;
    WHILE i < 10000 DO
        INSERT INTO usuarios (nome, email, idade)
        VALUES (
            CONCAT('Usuario', i), -- Nome aleatório baseado no contador
            CONCAT('usuario', i, '@email.com'), -- Email aleatório baseado no contador
            FLOOR(18 + (RAND() * 60)) -- Idade aleatória entre 18 e 78
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
