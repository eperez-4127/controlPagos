USE DBCONTROL
GO

--TRIGGER

--Trigger Insert
CREATE TRIGGER trTableEstado_Insert
 ON ESTADO
AFTER INSERT
AS
     BEGIN
         SET NOCOUNT ON;
         INSERT INTO BITACORA
                SELECT 'ESTADO',
                'INSERT',
                'ERICK', 
                       GETDATE(), 
                       inserted.DESCRIPCION
                FROM inserted;
     END;
GO
--Trigger Delete
CREATE TRIGGER trTableEstado_Delete
ON ESTADO
AFTER DELETE
AS
     BEGIN
         SET NOCOUNT ON;
         INSERT INTO BITACORA
                SELECT 'ESTADO',
                'DELETED',
                'ERICK', 
                       GETDATE(), 
                       deleted.DESCRIPCION
                FROM deleted;
     END;
GO
--Trigger Update
CREATE TRIGGER trTableEstado_Update 
ON ESTADO
AFTER UPDATE
AS
     BEGIN
         SET NOCOUNT ON;
         INSERT INTO BITACORA
                SELECT 'ESTADO',
                'UPDATE BEFORE',
                'ERICK', 
                       GETDATE(), 
                       deleted.DESCRIPCION
                FROM deleted;

         INSERT INTO BITACORA
                SELECT 'ESTADO',
                'UPDATE AFTER',
                'ERICK', 
                       GETDATE(), 
                       CONCAT('Despues de la actualización ',inserted.DESCRIPCION)
                FROM inserted;
     END;
GO