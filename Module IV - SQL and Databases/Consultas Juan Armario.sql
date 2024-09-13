-- Diseño fisico
CREATE TABLE IF NOT EXISTS `tareaDatabase`.`merchants` (
  `merchant_id` VARCHAR(45) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`merchant_id`));

CREATE TABLE IF NOT EXISTS `tareaDatabase`.`orders` (
  `order_id` VARCHAR(45) NOT NULL,
  `created_at` DATETIME NOT NULL,
  `status` VARCHAR(15) NOT NULL,
  `amount` DOUBLE NOT NULL,
  `merchant_id` VARCHAR(45) NOT NULL,
  `country` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `merchant_id` (`merchant_id` ASC) VISIBLE,
  CONSTRAINT `orders_ibfk_1`
    FOREIGN KEY (`merchant_id`)
    REFERENCES `tareaDatabase`.`merchants` (`merchant_id`));

CREATE TABLE IF NOT EXISTS `tareaDatabase`.`refunds` (
  `order_id` VARCHAR(45) NOT NULL,
  `refunded_at` DATETIME NOT NULL,
  `amount` DOUBLE NOT NULL,
  INDEX `order_id` (`order_id` ASC) VISIBLE,
  CONSTRAINT `refunds_ibfk_1`
    FOREIGN KEY (`order_id`)
    REFERENCES `tareaDatabase`.`orders` (`order_id`));
    
-- Ejercicio 2.1
SELECT DISTINCT `country`, `status`,
	COUNT(`order_id`) AS total_operaciones,
	ROUND(AVG(`amount`), 2) AS importe_promedio
FROM `orders`
WHERE created_at >= '2015-07-01' AND
	`country` IN ('Espana', 'Portugal', 'Francia') AND
	`amount` BETWEEN 100 AND 1500
GROUP BY `country`, `status`
ORDER BY importe_promedio DESC;

-- Ejercicio 2.2
SELECT DISTINCT `country`,
	COUNT(`order_id`) AS total_operaciones,
    ROUND(MAX(`amount`), 2) AS importe_maximo,
    ROUND(MIN(`amount`), 2) AS importe_minimo
FROM `orders`
WHERE 
	`status` NOT IN ('Delinquent', 'Cancelled') AND
	`amount` >= 100
GROUP BY `country`
ORDER BY total_operaciones DESC
LIMIT 3;

-- Ejercicio 3.1
SELECT DISTINCT m.`name`, m.`merchant_id`, o.`country`,
    COUNT(o.`order_id`) AS total_operaciones,
	ROUND(AVG(o.`amount`), 2) AS importe_promedio,
    COUNT(r.`order_id`) AS total_devoluciones,
CASE
	WHEN 'total_devoluciones' > 0 THEN 'Si'
    ELSE 'No'
END AS 'acepta_devoluciones'

FROM `merchants` AS m
INNER JOIN `orders` AS o ON m.`merchant_id` =  o.`merchant_id`
LEFT JOIN `refunds` AS r ON o.`order_id` =  r.`order_id`
WHERE 
	o.`country` IN ('Espana', 'Portugal', 'Italia', 'Marruecos')
GROUP BY m.`name`, m.`merchant_id`, o.`country`
HAVING total_operaciones > 10
ORDER BY total_operaciones ASC;

-- Ejercicio 3.2
CREATE VIEW orders_view AS
SELECT o.`order_id`, o.`created_at`, o.`status`, o.`amount`, o.`country`, m.*, r.`conteo_devoluciones`, r.`importe_devoluciones`
FROM `orders` AS o
INNER JOIN `merchants` AS m ON m.`merchant_id` =  o.`merchant_id`
INNER JOIN (
	SELECT r.`order_id`,
		COUNT(*) AS conteo_devoluciones,
		ROUND(SUM(r.`amount`), 2) AS importe_devoluciones
	FROM `refunds` AS r
	GROUP BY `order_id`)
 AS r ON r.`order_id` =  o.`order_id`;

-- Ejercicio 4
-- Consulta plataformas de vídeo
SELECT DISTINCT m.`name`, o.`country`,
    COUNT(o.`order_id`) AS total_operaciones,
    ROUND(SUM(o.`amount`), 2) AS importe_total,
	ROUND(AVG(o.`amount`), 2) AS importe_promedio
FROM `orders` AS o
INNER JOIN `merchants` AS m ON m.`merchant_id` =  o.`merchant_id`
WHERE 
	m.`name` IN ('Netflix', 'HBO', 'Filmin', 'Disney +', 'Amazon prime')
GROUP BY m.`name`, o.`country`;

-- Consulta plataformas de audio
SELECT DISTINCT m.`name`, o.`country`,
    COUNT(o.`order_id`) AS total_operaciones,
    ROUND(SUM(o.`amount`), 2) AS importe_total,
	ROUND(AVG(o.`amount`), 2) AS importe_promedio
FROM `orders` AS o
INNER JOIN `merchants` AS m ON m.`merchant_id` =  o.`merchant_id`
WHERE 
	m.`name` IN ('Spotify', 'Apple music', 'Tidal', 'YouTube music')
GROUP BY m.`name`, o.`country`;

SELECT DISTINCT m.`name`, o.`country`, o.`status`,
    COUNT(o.`order_id`) AS total_operaciones,
    ROUND(SUM(o.`amount`), 2) AS importe_total,
	ROUND(AVG(o.`amount`), 2) AS importe_promedio
FROM `orders` AS o
INNER JOIN `merchants` AS m ON m.`merchant_id` =  o.`merchant_id`
WHERE 
	m.`name` IN ('Netflix', 'HBO', 'Filmin', 'Disney +', 'Amazon prime', 'Spotify', 'Apple music', 'Tidal', 'YouTube music') AND
    o.`status` IN ('DELINQUENT', 'CANCELLED')
GROUP BY m.`name`, o.`country`, o.`status`;

SELECT DISTINCT m.`name`, o.`country`,
    COUNT(o.`order_id`) AS total_operaciones,
    ROUND(SUM(o.`amount`), 2) AS importe_total,
	ROUND(AVG(o.`amount`), 2) AS importe_promedio,
    COUNT(r.`order_id`) AS total_devoluciones,
    ROUND(SUM(r.`amount`), 2) AS importe_total_devoluciones,
	ROUND(AVG(r.`amount`), 2) AS importe_promedio_devoluciones
FROM `orders` AS o
INNER JOIN `merchants` AS m ON m.`merchant_id` =  o.`merchant_id`
LEFT JOIN `refunds` AS r ON r.`order_id` =  o.`order_id`
WHERE 
	m.`name` IN ('Netflix', 'HBO', 'Filmin', 'Disney +', 'Amazon prime', 'Spotify', 'Apple music', 'Tidal', 'YouTube music') 
GROUP BY m.`name`, o.`country`
HAVING importe_total > 4000;