CREATE DATABASE notsmk;
USE notsmk;

CREATE TABLE areas(
    id INT PRIMARY KEY AUTO_INCREMENT,
    latitude DOUBLE NOT NULL,
    longitude DOUBLE NOT NULL,
    text VARCHAR(100) NOT NULL,
    image VARCHAR(500) DEFAULT NULL
) ENGINE=INNODB;

INSERT INTO areas VALUES(null, 36.1373717, 128.4111183, '만다린', 'https://firebasestorage.googleapis.com/v0/b/kakaologin-d9158.appspot.com/o/image%2Fimage_picker7830517587414686506.jpg?alt=media&token=3e41b9d3-9b2a-4d1c-8524-3d0d4b05be88');
INSERT INTO areas VALUES(null, 36.1373717, 128.4131183, 'test1234', 'https://firebasestorage.googleapis.com/v0/b/kakaologin-d9158.appspot.com/o/image%2Fimage_picker7830517587414686506.jpg?alt=media&token=3e41b9d3-9b2a-4d1c-8524-3d0d4b05be88');
SELECT * FROM areas;

alter table areas add image varchar(500);
alter table areas add text varchar(100);




리눅스 DB 접속
mysql -u root -p

비번: qwer

