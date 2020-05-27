/****************************************
BASE
****************************************/

/*
  CICLOS
  * CONSTRAINT PK_CICLOS
    Llave primaria compuesta por NOMBRE y ANIO
*/
CREATE TABLE CICLOS(
  NOMBRE VARCHAR(255) NOT NULL,
  ANIO INT NOT NULL,
  F_INICIO DATE,
  F_FIN DATE
);
GO

/*
  CONSTRAINT PK_CICLOS
  Llave primaria de la tabla CICLOS
*/
ALTER TABLE CICLOS ADD CONSTRAINT PK_CICLOS PRIMARY KEY(NOMBRE, ANIO);
GO

/*
  CONSTRAINT CK_CICLOS_FECHAS
  La F_FIN no puede ser menor a F_INICIO
*/
ALTER TABLE CICLOS ADD CONSTRAINT CK_CICLOS_FECHAS CHECK(F_FIN > F_INICIO);
GO

/*
  ABONOS
  * CONSTRAINT FK_ABONOS_CICLOS_NOMBRE
    Llave foranea que hace referencia a la relacion con CICLOS
  * CONSTRAINT FK_ABONOS_CICLOS_ANIO
    Llave foranea que hace referencia a la relacion con CICLOS
*/
CREATE TABLE ABONOS(
  COD_A VARCHAR(100) NOT NULL PRIMARY KEY,
  DESCRIPCION TEXT NOT NULL,
  N_DIAS INT,
  COSTO FLOAT,
  CICLO VARCHAR(255) NOT NULL,
  ANIO INT NOT NULL,
  CONSTRAINT FK_ABONOS_CICLOS_NOMBRE FOREIGN KEY(CICLO, ANIO) REFERENCES CICLOS(NOMBRE, ANIO)
);
GO

/*
  BANDAS
  * CONSTRAINT FK_BANDAS_PELICULAS
    Llave foranea que hace referencia a la relacion con PELICULAS
  * CONSTRAINT FK_BANDAS_SOPORTE
    Llave foranea que hace referencia a la relacion con SOPORTE
*/
CREATE TABLE BANDAS(
  CODS_BS VARCHAR(255) NOT NULL PRIMARY KEY,
  TITULO VARCHAR(255) NOT NULL,
  TIPO VARCHAR(100),
  PELICULAS BIGINT NOT NULL,
  SOPORTE BIGINT NOT NULL,
  CONSTRAINT FK_BANDAS_PELICULAS FOREIGN KEY(PELICULAS) REFERENCES PELICULAS(NUM_PEL),
  CONSTRAINT FK_BANDAS_SOPORTE FOREIGN KEY(SOPORTE) REFERENCES SOPORTE(CODS)
);
GO

/*
  EMITE
  * CONSTRAINT FK_EMITE_PELICULA
    Llave foranea que hace referencia a la relacion con PELICULAS
  * CONSTRAINT FK_EMITE_CICLO_NOMBRE
    Llave foranea que hace referencia a la relacion con CICLOS
  * CONSTRAINT FK_EMITE_CICLO_ANIO
    Llave foranea que hace referencia a la relacion con CICLOS
*/
CREATE TABLE EMITE(
  PELICULA BIGINT NOT NULL,
  CICLO VARCHAR(255) NOT NULL,
  ANIO INT NOT NULL,
  DIA INT,
  HORA DATETIME,
  CONSTRAINT FK_EMITE_PELICULA FOREIGN KEY(PELICULA) REFERENCES PELICULAS(NUM_PEL),
  CONSTRAINT FK_EMITE_CICLO_NOMBRE FOREIGN KEY(CICLO, ANIO) REFERENCES CICLOS(NOMBRE, ANIO)
);
GO

/*
  ADQUIERE
  * CONSTRAINT FK_ALQUILA_B_BANDA
    Llave foranea que hace referencia a la relacion con BANDAS
  * CONSTRAINT FK_ALQUILA_ABONO
    Llave foranea que hace referencia a la relacion con ABONOS
*/
CREATE TABLE ADQUIERE(
  SOCIO VARCHAR(100) NOT NULL,
  ABONO VARCHAR(100) NOT NULL,
  CONSTRAINT FK_ADQUIERE_SOCIO FOREIGN KEY(SOCIO) REFERENCES SOCIOS(DNI),
  CONSTRAINT FK_ADQUIERE_ABONO FOREIGN KEY(ABONO) REFERENCES ABONOS(COD_A)
);
GO

/*
  ALQUILA_B
  * CONSTRAINT FK_ALQUILA_B_BANDAS
    Llave foranea que hace referencia a la relacion con BANDAS
  * CONSTRAINT FK_ALQUILA_B_SOCIO
    Llave foranea que hace referencia a la relacion con SOCIOS
*/
CREATE TABLE ALQUILA_B(
  B_SONORA VARCHAR(255) NOT NULL,
  SOCIO VARCHAR(100) NOT NULL,
  CONSTRAINT FK_ALQUILA_B_BANDA FOREIGN KEY(B_SONORA) REFERENCES BANDAS(CODS_BS),
  CONSTRAINT FK_ALQUILA_B_SOCIO FOREIGN KEY(SOCIO) REFERENCES SOCIOS(DNI)
);
GO

/*
  ALQUILA_P
  Tabla GENERADA a partir de PELICULAS
  * Se agrega la columna para el SOCIO
  * CONSTRAINT FK_ALQUILA_P_PELICULA
    Llave foranea que hace referencia a la relacion con PELICULAS
  * CONSTRAINT FK_ALQUILA_P_SOCIO
    Llave foranea que hace referencia a la relacion con SOCIOS
*/
SELECT NUM_PEL AS NUM_PEL INTO ALQUILA_P FROM PELICULAS;
GO
ALTER TABLE ALQUILA_P ADD SOCIO VARCHAR(100);
GO
ALTER TABLE ALQUILA_P ADD CONSTRAINT FK_ALQUILA_P_PELICULA FOREIGN KEY(NUM_PEL) REFERENCES PELICULAS(NUM_PEL);
GO
ALTER TABLE ALQUILA_P ADD CONSTRAINT FK_ALQUILA_P_SOCIO FOREIGN KEY(SOCIO) REFERENCES SOCIOS(DNI);
GO



/****************************************
INDICES
****************************************/
USE FILMOTECA;
GO

/*
  INDICE NO AGRUPADO en la tabla PELICULAS
*/
CREATE NONCLUSTERED INDEX IN_PELICULAS ON PELICULAS(NUM_PEL);
GO

/*
  Eliminar el INDICE de llave primaria que se encuentre en la tabla PELICULAS
*/
DROP INDEX PK__PELICULA__D5E3D09E07020F21 ON PELICULAS;
GO




/****************************************
DATOS
****************************************/
USE FILMOTECA;
GO

-- PARTICIPANTES
INSERT INTO PARTICIPANTES VALUES
  ('WVS84DTQ1YS','Ryan S. Bowman','Philippines','2020/11/07',10,9,'Sales and Marketing'),
  ('PVM73HRJ2ZL','Kamal W. Barnes','Liechtenstein','2020/03/02',6,34,'Payroll'),
  ('OJK27PBR2XY','Nathan I. Johnston','Congo (Brazzaville)','2019/07/09',10,6,'Customer Service'),
  ('ZRZ21RLK2BW','Avye Berger','Sudan','2019/12/03',5,12,'Media Relations'),
  ('XHA86TUJ7DK','Illana Q. Roth','Germany','2020/01/07',3,24,'Sales and Marketing'),
  ('ZMH10WXU1PI','Juliet Huber','Equatorial Guinea','2019/06/07',4,31,'Human Resources'),
  ('NEA40KXZ4KG','Keith Langley','American Samoa','2020/08/05',7,31,'Tech Support'),
  ('YQG73OYI8GE','Noel B. Goff','El Salvador','2019/08/11',5,4,'Research and Development'),
  ('VSO38OMJ5YQ','Frances M. Duke','Marshall Islands','2021/01/30',5,15,'Research and Development'),
  ('UNZ05SWS1WB','Fritz H. Ray','Slovenia','2020/08/07',8,22,'Customer Service'),
  ('MIF35XBD4WD','Rudyard Gonzalez','Costa Rica','2020/03/03',4,3,'Human Resources'),
  ('IPI31HOR6WY','Boris Mckay','Armenia','2020/02/25',3,10,'Research and Development'),
  ('SZC68YSO2GG','Dennis L. Vasquez','Sierra Leone','2019/09/01',10,3,'Sales and Marketing'),
  ('MGW97QVP1ED','Brent A. Bell','Aruba','2019/08/05',3,6,'Customer Service'),
  ('RBW79EVT3PD','Joseph West','Switzerland','2019/12/24',7,29,'Finances'),
  ('HNQ52RZK4NU','Chiquita Owen','Qatar','2020/11/12',3,18,'Sales and Marketing'),
  ('IOA23JZW1KN','Isabella N. Gallagher','Estonia','2019/06/17',5,15,'Human Resources'),
  ('XXS41LJN7TG','Lucy Ward','Saint Martin','2019/06/30',4,39,'Customer Service'),
  ('MMZ11VIN9QC','Owen Schmidt','Tuvalu','2020/02/22',1,35,'Sales and Marketing'),
  ('IHH20QGT3XC','Rigel T. Gentry','Cuba','2020/12/18',8,34,'Finances');

-- SOPORTE
INSERT INTO SOPORTE VALUES
  (2009,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.'),
  (6568,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus. Ut nec urna et arcu imperdiet ullamcorper.'),
  (9150,'Lorem ipsum dolor sit amet, consectetuer adipiscing'),
  (4155,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus. Ut nec urna et arcu imperdiet ullamcorper. Duis at lacus. Quisque purus sapien, gravida non, sollicitudin a, malesuada id, erat. Etiam vestibulum massa rutrum'),(9669,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus.'),
  (9133,'Lorem'),
  (3627,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer'),
  (7187,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus'),
  (8403,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor.'),
  (9675,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus. Ut nec urna et arcu imperdiet ullamcorper. Duis at'),
  (8871,'Lorem ipsum dolor sit'),
  (5549,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus. Ut nec urna et arcu imperdiet ullamcorper. Duis at lacus. Quisque purus sapien, gravida non, sollicitudin a, malesuada id, erat.'),
  (3940,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus. Ut nec urna et arcu imperdiet ullamcorper.'),
  (3493,'Lorem ipsum dolor sit amet,'),
  (3988,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus.'),
  (4239,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus. Ut nec urna et arcu imperdiet ullamcorper. Duis at lacus. Quisque purus sapien,'),
  (189,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus. Ut nec urna et arcu imperdiet ullamcorper.'),
  (6658,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus. Ut nec urna'),
  (9937,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus. Ut nec urna et arcu imperdiet ullamcorper. Duis'),
  (2993,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Curabitur sed tortor. Integer aliquam adipiscing lacus. Ut nec urna et arcu imperdiet ullamcorper. Duis at lacus. Quisque purus sapien, gravida non, sollicitudin a, malesuada id,');

-- SOCIOS
INSERT INTO SOCIOS VALUES
  ('OAN94KSF2IX','Bird','Yvette','Ap #353-3207 Sit Road',13),
  ('APJ14MTX4VP','Johnson','Jescie','Ap #317-8040 Suspendisse Avenue',67),
  ('GGB64EOB3YH','Davidson','Josephine','1014 Elit, Rd.',50),
  ('OHO29QQI5OX','Mayo','Griffin','P.O. Box 250, 229 Est. Ave',24),
  ('VMF81VFV9VQ','Lucas','Hyacinth','9581 Tempus, Rd.',79),
  ('TGX35AST0ZV','Campbell','Kuame','778 Turpis Rd.',43),
  ('DNC15YPT1UO','Bartlett','Gabriel','1781 Facilisis. Road',67),
  ('XEH61WOF1AI','Shepherd','Palmer','1256 Mollis. Street',70),
  ('ITW78MAR7NA','Wilkinson','Ora','1910 Vestibulum, St.',22),
  ('MPT84JXH1LY','Noble','Mercedes','P.O. Box 150, 8514 Duis Rd.',64),
  ('CQE29JAD8KX','Aguilar','Rashad','Ap #451-3417 Sed Street',60),
  ('QCP74LZK8LM','Battle','Leah','P.O. Box 264, 3010 Malesuada Ave',30),
  ('LWL82WXU0OB','Crosby','Emi','809-1026 Ac, Ave',24),
  ('JGK69VJG0CL','Humphrey','Rana','580-5417 Lorem Avenue',30),
  ('SRZ19VKH0RC','Hood','Slade','P.O. Box 273, 2333 Malesuada Avenue',59),
  ('JHR39CJI8LN','Cotton','Stacey','P.O. Box 621, 1039 Tellus Ave',77),
  ('MEF43NSE0ML','Ware','Kyle','Ap #278-2771 Phasellus Ave',69),
  ('SFY64YRW9CY','Vance','Wendy','P.O. Box 539, 2597 Nullam Rd.',76),
  ('YVF79ZKN5YL','Wilkins','Baker','459-6096 Parturient Ave',55),
  ('QIB49GYN3RF','Gibbs','Moana','1194 Ipsum Ave',50);

-- CICLOS
INSERT INTO CICLOS VALUES
  ('Primer semestre 2010',2010,'2010-01-01','2010-06-30'),
  ('Segundo semestre 2012',2012,'2012-07-01','2012-12-31'),
  ('Primer semestre 2020',2020,'2020-01-01','2020-06-30');

-- PELICULAS
INSERT INTO PELICULAS VALUES
  (1,'LOS PROFESORES DE SAINT-DENIS','LOS PROFESORES DE SAINT-DENIS',2020,'Terror','02:20:01.00000000',2500230.00,4.5,'OJK27PBR2XY',9669),
  (2,'SELAH AND THE SPADES','SELAH AND THE SPADES',2020,'Ciencia Ficción','02:02:02.00000000',2540230.00,7.5,'MIF35XBD4WD',3627),
  (3,'EX LIBRIS','EX LIBRIS',2020,'Biografía','02:03:03.00000000',2560230.00,9.0,'MGW97QVP1ED',9669),
  (4,'Onward','Onward',2020,'Animación','01:03:00.00000000',2570230.00,0.0,'MMZ11VIN9QC',7187),
  (5,'VIVARIUM','VIVARIUM',2020,'Terror','02:20:00.00000000',2590230.00,7.5,'IHH20QGT3XC',8403);

-- DIRIGE
INSERT INTO DIRIGE VALUES
  ('SZC68YSO2GG',1),
  ('MGW97QVP1ED',2),
  ('RBW79EVT3PD',3),
  ('HNQ52RZK4NU',4),
  ('IOA23JZW1KN',5);

-- PROTAGONIZA
INSERT INTO PROTAGONIZA VALUES
  ('WVS84DTQ1YS',1,'INDEPENDIENTE'),
  ('PVM73HRJ2ZL',2,'INDEPENDIENTE'),
  ('OJK27PBR2XY',3,'INDEPENDIENTE'),
  ('ZRZ21RLK2BW',4,'INDEPENDIENTE'),
  ('XHA86TUJ7DK',5,'INDEPENDIENTE');

-- PRODUCE
INSERT INTO PRODUCE VALUES
  ('SZC68YSO2GG',5,88.00),
  ('MGW97QVP1ED',3,90.00),
  ('RBW79EVT3PD',2,23.00),
  ('HNQ52RZK4NU',4,10.00),
  ('IOA23JZW1KN',1,1.00);

-- EMITE
INSERT INTO EMITE VALUES
  (3,'Primer semestre 2010',2010,13,CURRENT_TIMESTAMP),
  (4,'Segundo semestre 2012',2012,22,CURRENT_TIMESTAMP),
  (1,'Primer semestre 2020',2020,23,CURRENT_TIMESTAMP);

-- BANDAS
INSERT INTO BANDAS([CODS_BS],[TITULO],[TIPO],[PELICULAS],[SOPORTE]) VALUES
  ('UMW78NIW5YL','Dolor Elit Foundation','Adipiscing Foundation',2,9133),
  ('TIU63MOO7RF','Diam Duis Mi Corporation','Senectus Et Corporation',3,3627),
  ('ZKZ39CPZ5FE','Velit Aliquam LLC','Dictum Eu Eleifend Industries',4,7187),
  ('LJE72DAE0OF','Placerat Orci Inc.','Penatibus Associates',5,8403),
  ('NVU88EOR2KF','In LLP','Nisl Quisque Associates',1,9675);

-- ABONOS
INSERT INTO ABONOS VALUES
  ('CCC62IYQ2HL','ultrices a, auctor non, feugiat nec,',9,70.0,'Primer semestre 2010',2010),
  ('HKK84OZU2YE','ac urna. Ut tincidunt vehicula risus. Nulla eget metus eu erat semper rutrum. Fusce dolor quam,',1,50.0,'Primer semestre 2010',2010),
  ('TWY48MYM7SI','ullamcorper, nisl arcu iaculis enim, sit amet ornare lectus justo eu arcu. Morbi sit amet massa. Quisque porttitor eros nec',2,100.0,'Primer semestre 2020',2020),
  ('OBU82MFF7WH','quam. Curabitur vel lectus. Cum',7,170.0,'Primer semestre 2020',2020),
  ('YGT01IRP6RN','lectus convallis est, vitae sodales',3,30.0,'Primer semestre 2020',2020),
  ('XZB90CPR4XM','at, velit. Pellentesque ultricies dignissim lacus. Aliquam rutrum lorem ac risus. Morbi metus. Vivamus euismod urna.',2,20.0,'Primer semestre 2020',2020),
  ('KNO70QKG1HW','fringilla est. Mauris eu turpis. Nulla aliquet. Proin velit.',9,70.0,'Primer semestre 2020',2020),
  ('LIK42VGL7LL','Vivamus nibh dolor, nonummy ac, feugiat non, lobortis quis, pede. Suspendisse dui.',8,700.0,'Primer semestre 2020',2020);

-- ALQUILA_P
INSERT INTO ALQUILA_P VALUES
  (1,'TGX35AST0ZV'),
  (2,'DNC15YPT1UO'),
  (3,'XEH61WOF1AI'),
  (3,'ITW78MAR7NA');

-- ALQUILA_B
INSERT INTO ALQUILA_B VALUES
  ('UMW78NIW5YL','MPT84JXH1LY'),
  ('ZKZ39CPZ5FE','CQE29JAD8KX'),
  ('TIU63MOO7RF','QCP74LZK8LM'),
  ('LJE72DAE0OF','LWL82WXU0OB');

-- ADQUIERE
INSERT INTO ADQUIERE VALUES
  ('MPT84JXH1LY','XZB90CPR4XM'),
  ('CQE29JAD8KX','OBU82MFF7WH'),
  ('QCP74LZK8LM','YGT01IRP6RN'),
  ('LWL82WXU0OB','OBU82MFF7WH');

/*
  MODIFICACION
*/
UPDATE ADQUIERE SET ABONO = 'LIK42VGL7LL' WHERE SOCIO = 'MPT84JXH1LY';



/****************************************
USUARIOS
****************************************/
/*
  *** NOTA: se debe activar la autenticacion con inicio de sesion
  con Windows y SQL Server
*/

/*
  Crear para USUARIO ADMIN_FILMOTECA
*/
USE master
GO
CREATE LOGIN ADMIN_FILMOTECA WITH PASSWORD=N'123', DEFAULT_DATABASE=FILMOTECA, CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE FILMOTECA
GO
CREATE USER ADMIN_FILMOTECA FOR LOGIN ADMIN_FILMOTECA
GO
USE FILMOTECA
GO
EXEC sp_addrolemember N'db_accessadmin', N'ADMIN_FILMOTECA'
GO
USE FILMOTECA
GO
EXEC sp_addrolemember N'db_datareader', N'ADMIN_FILMOTECA'
GO
USE FILMOTECA
GO
EXEC sp_addrolemember N'db_datawriter', N'ADMIN_FILMOTECA'
GO
USE FILMOTECA
GO
EXEC sp_addrolemember N'db_owner', N'ADMIN_FILMOTECA'
GO

-- PERMISOS
USE FILMOTECA
GO
GRANT ALTER ON [dbo].[VW_TOTAL_ABONOS_SOCIOS] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[VW_TOTAL_ABONOS_SOCIOS] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[VW_TOTAL_ABONOS_SOCIOS] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[VW_TOTAL_ABONOS_SOCIOS] TO [ADMIN_FILMOTECA]
GO
GRANT ALTER ON [dbo].[VW_PELICULAS] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[VW_PELICULAS] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[VW_PELICULAS] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[VW_PELICULAS] TO [ADMIN_FILMOTECA]
GO
GRANT DELETE ON [dbo].[ALQUILA_B] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[ALQUILA_B] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[ALQUILA_B] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[ALQUILA_B] TO [ADMIN_FILMOTECA]
GO
GRANT DELETE ON [dbo].[ABONOS] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[ABONOS] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[ABONOS] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[ABONOS] TO [ADMIN_FILMOTECA]
GO
GRANT DELETE ON [dbo].[PARTICIPANTES] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[PARTICIPANTES] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[PARTICIPANTES] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[PARTICIPANTES] TO [ADMIN_FILMOTECA]
GO
GRANT DELETE ON [dbo].[EMITE] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[EMITE] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[EMITE] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[EMITE] TO [ADMIN_FILMOTECA]
GO
GRANT DELETE ON [dbo].[SOPORTE] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[SOPORTE] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[SOPORTE] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[SOPORTE] TO [ADMIN_FILMOTECA]
GO
GRANT EXECUTE ON [dbo].[SP_DELETE_PELICULA] TO [ADMIN_FILMOTECA]
GO
GRANT DELETE ON [dbo].[ALQUILA_P] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[ALQUILA_P] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[ALQUILA_P] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[ALQUILA_P] TO [ADMIN_FILMOTECA]
GO
GRANT ALTER ON [dbo].[VW_PELICULAS_ALQUILADAS] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[VW_PELICULAS_ALQUILADAS] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[VW_PELICULAS_ALQUILADAS] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[VW_PELICULAS_ALQUILADAS] TO [ADMIN_FILMOTECA]
GO
GRANT EXECUTE ON [dbo].[SP_INSERT_ALQUILA_P] TO [ADMIN_FILMOTECA]
GO
GRANT DELETE ON [dbo].[DIRIGE] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[DIRIGE] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[DIRIGE] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[DIRIGE] TO ADMIN_FILMOTECA
GO
GRANT ALTER ON [dbo].[VW_ABONOS_ADQUIRIDOS_POR_SOCIOS] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[VW_ABONOS_ADQUIRIDOS_POR_SOCIOS] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[VW_ABONOS_ADQUIRIDOS_POR_SOCIOS] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[VW_ABONOS_ADQUIRIDOS_POR_SOCIOS] TO [ADMIN_FILMOTECA]
GO
GRANT EXECUTE ON [dbo].[SP_INSERT_PELICULA] TO [ADMIN_FILMOTECA]
GO
GRANT EXECUTE ON [dbo].[SP_MODIFICAR_SOCIO] TO [ADMIN_FILMOTECA]
GO
GRANT DELETE ON [dbo].[SOCIOS] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[SOCIOS] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[SOCIOS] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[SOCIOS] TO [ADMIN_FILMOTECA]
GO
GRANT EXECUTE ON [dbo].[SP_INSERT_ALQUILA_B] TO [ADMIN_FILMOTECA]
GO
GRANT DELETE ON [dbo].[ADQUIERE] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[ADQUIERE] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[ADQUIERE] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[ADQUIERE] TO [ADMIN_FILMOTECA]
GO
GRANT DELETE ON [dbo].[BANDAS] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[BANDAS] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[BANDAS] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[BANDAS] TO [ADMIN_FILMOTECA]
GO
GRANT DELETE ON [dbo].[PROTAGONIZA] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[PROTAGONIZA] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[PROTAGONIZA] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[PROTAGONIZA] TO [ADMIN_FILMOTECA]
GO
GRANT EXECUTE ON [dbo].[SP_UPDATE_PELICULA] TO [ADMIN_FILMOTECA]
GO
GRANT EXECUTE ON [dbo].[SP_ADQUIRIR_ABONOS] TO [ADMIN_FILMOTECA]
GO
GRANT DELETE ON [dbo].[CICLOS] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[CICLOS] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[CICLOS] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[CICLOS] TO [ADMIN_FILMOTECA]
GO
GRANT DELETE ON [dbo].[PRODUCE] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[PRODUCE] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[PRODUCE] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[PRODUCE] TO [ADMIN_FILMOTECA]
GO
GRANT DELETE ON [dbo].[PELICULAS] TO [ADMIN_FILMOTECA]
GO
GRANT INSERT ON [dbo].[PELICULAS] TO [ADMIN_FILMOTECA]
GO
GRANT SELECT ON [dbo].[PELICULAS] TO [ADMIN_FILMOTECA]
GO
GRANT UPDATE ON [dbo].[PELICULAS] TO ADMIN_FILMOTECA
GO

/*
  Crear USUARIO CLIENTE_FILMOTECA
*/
USE [master]
GO
CREATE LOGIN [CLIENTE_FILMOTECA] WITH PASSWORD=N'123', DEFAULT_DATABASE=[FILMOTECA], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE [FILMOTECA]
GO
CREATE USER [CLIENTE_FILMOTECA] FOR LOGIN [CLIENTE_FILMOTECA]
GO
USE [FILMOTECA]
GO
EXEC sp_addrolemember N'db_datareader', N'CLIENTE_FILMOTECA'
GO
USE [FILMOTECA]
GO
EXEC sp_addrolemember N'db_datawriter', N'CLIENTE_FILMOTECA'
GO

-- PERMISOS
use FILMOTECA
GO
GRANT ALTER ON [dbo].[SP_MODIFICAR_SOCIO] TO [CLIENTE_FILMOTECA]
GO
GRANT CONTROL ON [dbo].[SP_MODIFICAR_SOCIO] TO [CLIENTE_FILMOTECA]
GO
GRANT SELECT ON [dbo].[BANDAS] TO [CLIENTE_FILMOTECA]
GO
DENY ALTER ON [dbo].[BANDAS] TO [CLIENTE_FILMOTECA]
GO
DENY DELETE ON [dbo].[BANDAS] TO [CLIENTE_FILMOTECA]
GO
DENY INSERT ON [dbo].[BANDAS] TO [CLIENTE_FILMOTECA]
GO
DENY UPDATE ON [dbo].[BANDAS] TO [CLIENTE_FILMOTECA]
GO
GRANT SELECT ON [dbo].[PELICULAS] TO [CLIENTE_FILMOTECA]
GO
DENY ALTER ON [dbo].[PELICULAS] TO [CLIENTE_FILMOTECA]
GO
DENY DELETE ON [dbo].[PELICULAS] TO [CLIENTE_FILMOTECA]
GO
DENY INSERT ON [dbo].[PELICULAS] TO [CLIENTE_FILMOTECA]
GO
DENY UPDATE ON [dbo].[PELICULAS] TO [CLIENTE_FILMOTECA]
GO
GRANT SELECT ON [dbo].[VW_PELICULAS] TO [CLIENTE_FILMOTECA]
GO



/****************************************
VISTAS
****************************************/
USE FILMOTECA;
GO

/*
  VW_PELICULAS_ALQUILADAS
  Muestra las PELICULAS que han sido ALQUILADAS
  por todos los SOCIOS
*/
CREATE VIEW VW_PELICULAS_ALQUILADAS AS
  SELECT
    AP.SOCIO, S.NOMBRE, S.APELLIDOS,
    P.T_ORIGINAL, P.T_TRADUCIDO, P.ANIO_EDICION
  FROM SOCIOS AS S INNER JOIN ALQUILA_P AS AP
    ON S.DNI = AP.SOCIO
    INNER JOIN PELICULAS AS P
    ON P.NUM_PEL = AP.NUM_PEL
;
GO

/*
  VW_ABONOS_ADQUIRIDOS_POR_SOCIOS
  Muestra todos los ABONOS ADQUIRIDOS por los SOCIOS en el actual ANIO
*/
CREATE VIEW VW_ABONOS_ADQUIRIDOS_POR_SOCIOS AS
  SELECT
    AD.SOCIO,  S.NOMBRE, S.APELLIDOS,
    AD.ABONO, A.DESCRIPCION, A.N_DIAS, A.COSTO, A.CICLO, A.ANIO
  FROM ABONOS AS A INNER JOIN ADQUIERE AS AD
    ON A.COD_A = AD.ABONO
    INNER JOIN SOCIOS AS S
    ON AD.SOCIO = S.DNI
  WHERE A.ANIO = YEAR(GETDATE())
;
GO

/*
  VISTA VW_PELICULAS
  Todas las PELICULAS registradas
*/
CREATE VIEW VW_PELICULAS AS
  SELECT
    P.T_ORIGINAL, P.T_TRADUCIDO, PD.NOMBRE,
    P.ANIO_EDICION, P.CATEGORIA, P.DURACION, P.CALIFICACION
  FROM PELICULAS P INNER JOIN DIRIGE D
    ON P.NUM_PEL = D.NPEL
    INNER JOIN PARTICIPANTES AS PD
    ON PD.CODIGO = D.DIRECTOR
;
GO

/*
  VISTA VW_TOTAL_ABONOS_SOCIOS
  Muestra la CANTIDAD TOTAL que los SOCIOS han ADQUIRIDO en ABONOS
*/
CREATE VIEW VW_TOTAL_ABONOS_SOCIOS AS
  SELECT
	S.NOMBRE, SUM(A.COSTO) AS TOTAL_SOCIO
  FROM SOCIOS AS S INNER JOIN ADQUIERE AD
	ON S.DNI = AD.SOCIO
	INNER JOIN ABONOS A
	ON A.COD_A = AD.ABONO
  GROUP BY S.NOMBRE
;
GO



/****************************************
CONCURRENCIA
****************************************/
USE FILMOTECA;
GO

/*
  Todos los SOCIOS cuya EDAD este en el rango 20-25 recibiran una PELICULA
  ALQUILADA gratis, dicha PELICULA sera la 1
  TRANSACCION de tipo EXPLICITA
*/
DECLARE @ERROR INT -- guardar un posible error
BEGIN TRANSACTION
WHILE (@ERROR<>0)
BEGIN
  UPDATE ALQUILA_P
    SET NUM_PEL = 1,
      SOCIO = (
        SELECT DNI FROM SOCIOS WHERE EDAD >= 20 AND EDAD <= 25
      )
  SET @ERROR=@@ERROR -- si ocurre un error, guardalo
  IF (@ERROR<>0) GOTO TRATAR_ERROR -- si ocurre un error, ve y tratalo
END
COMMIT TRANSACTION

TRATAR_ERROR:
IF @@ERROR<>0
  BEGIN
  PRINT 'Ha ocurrido un error en la transacción'
  ROLLBACK TRANSACTION
  END

/*
  Eliminar todos los ABONOS del SOCIO 1
  TRANSACCION de tipo IMPLICITA
*/
SET IMPLICIT_TRANSACTIONS ON
DELETE FROM ADQUIERE WHERE SOCIO = 'MPT84JXH1LY'
ROLLBACK TRANSACTION
SET IMPLICIT_TRANSACTIONS OFF

/*
  Aumentar el COSTO por el doble al ABONO que tenga por N_DIAS = 1
  TRANSACCION de tipo AUTOCOMMIT usando TIPO DE AISLAMIENTO: READ COMMITTED
  Se permiten las lecturas sucias con este nivel de aislamiento, ya que
  permite leer todas las transacciones, aun si no han sido confirmadas por
  otras transacciones
*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SET IMPLICIT_TRANSACTIONS OFF
UPDATE ABONOS SET COSTO = COSTO * 2 WHERE N_DIAS = 1



/****************************************
PROCEDIMIENTOS
****************************************/
USE FILMOTECA;
GO

/*
  PROCEDIMIENTO ALMACENADO SP_INSERT_PELICULA
  Insertar PELICULA, recibe los parametros:
  NUM_PEL, T_ORIGINAL, T_TRADUCIDO, ANIO_EDICION, CATEGORIA,
  DURACION, PRESUPUESTO, CALIFICACION, GUIONISTA, SOPORTE
*/
CREATE PROCEDURE SP_INSERT_PELICULA
@NUM_PEL BIGINT,
@T_ORIGINAL VARCHAR(255),
@T_TRADUCIDO VARCHAR(255),
@ANIO_EDICION INT,
@CATEGORIA VARCHAR(100),
@DURACION TIME,
@PRESUPUESTO FLOAT,
@CALIFICACION FLOAT,
@GUIONISTA VARCHAR(255),
@SOPORTE BIGINT
AS
  INSERT INTO PELICULAS VALUES(
    @NUM_PEL, @T_ORIGINAL, @T_TRADUCIDO, @ANIO_EDICION,
    @CATEGORIA, @DURACION, @PRESUPUESTO, @CALIFICACION, @GUIONISTA, @SOPORTE
  )
GO

/*
  PROCEDIMIENTO ALMACENADO SP_UPDATE_PELICULA
  Actualizar PELICULA, recibe los parametros:
  NUM_PEL, T_ORIGINAL, T_TRADUCIDO, ANIO_EDICION, CATEGORIA,
  DURACION, PRESUPUESTO, CALIFICACION, GUIONISTA, SOPORTE
*/
CREATE PROCEDURE SP_UPDATE_PELICULA
@NUM_PEL BIGINT,
@T_ORIGINAL VARCHAR(255),
@T_TRADUCIDO VARCHAR(255),
@ANIO_EDICION INT,
@CATEGORIA VARCHAR(100),
@DURACION TIME,
@PRESUPUESTO FLOAT,
@CALIFICACION FLOAT,
@GUIONISTA VARCHAR(255),
@SOPORTE BIGINT
AS
  UPDATE PELICULAS
  SET
    T_ORIGINAL = @T_ORIGINAL,
    T_TRADUCIDO = @T_TRADUCIDO,
    ANIO_EDICION = @ANIO_EDICION,
    CATEGORIA = @CATEGORIA,
    DURACION = @DURACION,
    PRESUPUESTO = @PRESUPUESTO,
	CALIFICACION = @CALIFICACION,
    GUIONISTA = @GUIONISTA,
    SOPORTE = @SOPORTE
  WHERE NUM_PEL = @NUM_PEL
GO

/*
  PROCEDIMIENTO ALMACENADO SP_DELETE_PELICULA
  ELIMINAR PELICULA, recibe el parametro NUM_PEL
*/
CREATE PROCEDURE SP_DELETE_PELICULA
@NUM_PEL BIGINT
AS
  DELETE FROM PELICULAS WHERE NUM_PEL = @NUM_PEL
GO

/*
  PROCEDIMIENTO ALMACENADO SP_INSERT_ALQUILA_P
  Insertar ALQUILA_P Recibe dos parametros de entrada, NUM_PEL y SOCIO
*/
CREATE PROCEDURE SP_INSERT_ALQUILA_P
@NUM_PEL BIGINT, @SOCIO VARCHAR(100)
AS
  INSERT INTO ALQUILA_P VALUES(@NUM_PEL, @SOCIO)
GO

/*
  PROCEDIMIENTO ALMACENADO SP_INSERT_ALQUILA_B
  Insertar ALQUILA_B Recibe dos parametros de entrada, B_SONORA, SOCIO
*/
CREATE PROCEDURE SP_INSERT_ALQUILA_B
@B_SONORA VARCHAR(255), @SOCIO VARCHAR(100)
AS
  INSERT INTO ALQUILA_B VALUES(@B_SONORA, @SOCIO)
GO

/*
  PROCEDIMIENTO ALMACENADO SP_MODIFICAR_SOCIO
  Modificar SOCIO
*/
CREATE PROCEDURE SP_MODIFICAR_SOCIO
@DNI VARCHAR(100),
@APELLIDOS VARCHAR(255),
@NOMBRE VARCHAR(100),
@DIRECCION VARCHAR(255),
@EDAD INT
AS
  UPDATE SOCIOS
  SET DNI = @DNI,
    APELLIDOS = @APELLIDOS,
    NOMBRE = @NOMBRE,
    DIRECCION = @DIRECCION,
    EDAD = @EDAD
  WHERE DNI = @DNI
GO

/*
  PROCEDIMIENTO ALMACENADO SP_ADQUIRIR_ABONOS
  ADQUIRIR ABONOS recibe dos parametros: SOCIO, ABONO
*/
CREATE PROCEDURE SP_ADQUIRIR_ABONOS
@SOCIO VARCHAR(100),
@ABONO VARCHAR(100)
AS
  INSERT INTO ADQUIERE VALUES(@SOCIO, @ABONO)
GO

/*
  TRIGGER TG_REVISAR_NOMBRE_SOCIO
  Regalar una ALQUILACION de PELICULA a todos los nuevos SOCIOS
  que tengan NOMBRE = Benita
*/
CREATE TRIGGER TG_REVISAR_NOMBRE_SOCIO
ON SOCIOS
AFTER INSERT, UPDATE
AS
  DECLARE
	@NOMBRE VARCHAR(100),
	@DNI VARCHAR(255)
  SELECT @NOMBRE = ins.NOMBRE FROM inserted ins;
  SELECT @DNI = ins.DNI FROM inserted ins;
  IF (@NOMBRE = 'Benita')
	INSERT INTO ALQUILA_P VALUES(1, @DNI)
GO

/*
  TRIGGER TG_REVISAR_ABONOS
  Evita que se inserten ABONOS duplicados
*/
CREATE TRIGGER TG_REVISAR_ABONOS
ON ABONOS
INSTEAD OF INSERT, UPDATE
AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO ABONOS(COD_A, DESCRIPCION, N_DIAS, COSTO, CICLO, ANIO)
  SELECT COD_A, DESCRIPCION, N_DIAS, COSTO, CICLO, ANIO
  FROM inserted ins
  WHERE
	ins.COD_A NOT IN(SELECT COD_A FROM ABONOS) AND
	ins.DESCRIPCION LIKE (SELECT DESCRIPCION FROM ABONOS) AND
	ins.N_DIAS NOT IN(SELECT N_DIAS FROM ABONOS) AND
	ins.COSTO NOT IN(SELECT COSTO FROM ABONOS) AND
	ins.CICLO NOT IN(SELECT CICLO FROM ABONOS) AND
	ins.ANIO NOT IN(SELECT ANIO FROM ABONOS);
END
GO


