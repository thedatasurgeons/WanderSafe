CREATE DATABASE 'WanderSafe';
USE WanderSafe;
CREATE TABLE MeshBlocks (id INT NOT NULL PRIMARY KEY, shapefile MEDIUMTEXT);

load data local infile 'output.wkt' into table MeshBlocks FIELDS TERMINATED BY '\t' IGNORE 1 LINES;
COMMIT;

CREATE USER 'govhack2017'@'localhost' IDENTIFIED BY 'govhack2017';
GRANT ALL PRIVILEGES ON * . * TO 'govhack2017'@'localhost';

FLUSH PRIVILEGES;
