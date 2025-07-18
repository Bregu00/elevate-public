CREATE TABLE `bn_crafting_players` (
    `identifier` VARCHAR(255) NOT NULL DEFAULT '' COLLATE 'utf8_general_ci',
    `xp` LONGTEXT NOT NULL COLLATE 'utf8_general_ci'
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;


CREATE TABLE `bn_crafting_tables` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL COLLATE 'utf8_general_ci',
    `prop` LONGTEXT NOT NULL COLLATE 'utf8mb4_bin',
    `recipes` LONGTEXT NOT NULL COLLATE 'utf8mb4_bin',
    `groups` LONGTEXT NOT NULL COLLATE 'utf8_general_ci',
    `levelXpRequirements` LONGTEXT NOT NULL COLLATE 'utf8_general_ci',
    PRIMARY KEY (`id`) USING BTREE,
    CONSTRAINT `recipes` CHECK (json_valid(`recipes`))
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=46
;