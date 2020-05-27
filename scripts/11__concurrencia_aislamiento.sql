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

-- comprobar
SELECT * FROM ALQUILA_P;

/*
  Eliminar todos los ABONOS del SOCIO 1
  TRANSACCION de tipo IMPLICITA
*/
SET IMPLICIT_TRANSACTIONS ON
DELETE FROM ADQUIERE WHERE SOCIO = 'MPT84JXH1LY'
ROLLBACK TRANSACTION
SET IMPLICIT_TRANSACTIONS OFF

-- comprobar
SELECT * FROM ADQUIERE;

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

-- comprobar
SELECT * FROM ABONOS WHERE N_DIAS = 1;
