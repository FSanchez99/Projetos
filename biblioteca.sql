-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema biblioteca
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema biblioteca
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `biblioteca` DEFAULT CHARACTER SET utf8mb4 ;
USE `biblioteca` ;

-- -----------------------------------------------------
-- Table `biblioteca`.`autor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `biblioteca`.`autor` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `sobrenome` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `biblioteca`.`autor_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `biblioteca`.`autor_log` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `autor_id` INT(11) NULL DEFAULT NULL,
  `nome` VARCHAR(100) NULL DEFAULT NULL,
  `sobrenome` VARCHAR(100) NULL DEFAULT NULL,
  `data_insercao` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `biblioteca`.`livro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `biblioteca`.`livro` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(255) NOT NULL,
  `data_publicacao` DATE NULL DEFAULT NULL,
  `autor_id` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `autor_id` (`autor_id` ASC) VISIBLE,
  CONSTRAINT `livro_ibfk_1`
    FOREIGN KEY (`autor_id`)
    REFERENCES `biblioteca`.`autor` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `biblioteca`.`livro_autor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `biblioteca`.`livro_autor` (
  `livro_id` INT(11) NOT NULL,
  `autor_id` INT(11) NOT NULL,
  PRIMARY KEY (`livro_id`, `autor_id`),
  INDEX `autor_id` (`autor_id` ASC) VISIBLE,
  CONSTRAINT `livro_autor_ibfk_1`
    FOREIGN KEY (`livro_id`)
    REFERENCES `biblioteca`.`livro` (`id`),
  CONSTRAINT `livro_autor_ibfk_2`
    FOREIGN KEY (`autor_id`)
    REFERENCES `biblioteca`.`autor` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `biblioteca`.`livro_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `biblioteca`.`livro_log` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `livro_id` INT(11) NULL DEFAULT NULL,
  `titulo` VARCHAR(255) NULL DEFAULT NULL,
  `data_publicacao` DATE NULL DEFAULT NULL,
  `data_insercao` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `biblioteca`.`reserva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `biblioteca`.`reserva` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `livro_id` INT(11) NULL DEFAULT NULL,
  `data_reserva` DATE NOT NULL,
  `data_devolucao` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `livro_id` (`livro_id` ASC) VISIBLE,
  CONSTRAINT `reserva_ibfk_1`
    FOREIGN KEY (`livro_id`)
    REFERENCES `biblioteca`.`livro` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

USE `biblioteca`;

DELIMITER $$
USE `biblioteca`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `biblioteca`.`after_autor_insert`
AFTER INSERT ON `biblioteca`.`autor`
FOR EACH ROW
BEGIN
    INSERT INTO autor_log (autor_id, nome, sobrenome)
    VALUES (NEW.id, NEW.nome, NEW.sobrenome);
END$$

USE `biblioteca`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `biblioteca`.`after_livro_insert`
AFTER INSERT ON `biblioteca`.`livro`
FOR EACH ROW
BEGIN
    INSERT INTO livro_log (livro_id, titulo, data_publicacao)
    VALUES (NEW.id, NEW.titulo, NEW.data_publicacao);
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
