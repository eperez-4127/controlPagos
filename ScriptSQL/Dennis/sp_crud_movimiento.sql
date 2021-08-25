USE [DBCONTROL]
GO
/****** Object:  StoredProcedure [dbo].[sp_crud_movimiento]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_crud_movimiento]
	--====================
	--VARIABLES
	--====================
	@i_accion					varchar(3),					--VARIABLE DE TIPO DE ACCION A EJECUTAR
	@i_Id_movimiento		    int      = null,			--id del movimiento
	@i_descripcion				varchar(45) = null			--descripcion del movimiento
	
AS
BEGIN
-- ==============================================================================================
-- PROPOSITO: REGISTRO, MODIFICACION Y ELIMINACION DE CLASIFICACION
--
-- MODIFICACIONES:
-- FECHA       QUIEN       MOTIVO
-- ----------  ----------- ----------------------------------------------------------------------
-- 18/08/2021  DENNIS     CREACION DEL SP PARA EL CRUD DE MOVIMIENTO
--
-- ----------------------------------------------------------------------------------------------
-- DESCRIPCION
-- ------ ---------------------------------------------------------------------------------------
-- ADD	  AGREGA UN MOVIMIENTO
-- LST    LISTA LOS MOVIMIENTOS AL INGRESAR EL ID
-- UPD	  MODIFICA LA DESCRIPCION DE UN MOVIMIENTO
-- DEL	  ACTUALIZA EL DEL MOVIMIENTO A 'ELIMINADO'
-- ==============================================================================================
		SET NOCOUNT ON
-- ==========================
-- INSERTA UN NUEVO MOVIMIENTO:
-- ==========================
	IF (@i_accion = 'ADD')
	BEGIN --ADD
		-- ---------------------------------
		-- VERIFICA QUE NO EXISTA EL MOVIMIENTO:
		-- ---------------------------------
		IF (
				SELECT COUNT(1)
				FROM MOVIMIENTO WITH (NOLOCK)
				WHERE ID_MOVIMIENTO = @i_Id_movimiento
					OR DESCRIPCION = @i_descripcion
				) = 0
		BEGIN --NO EXISTE
			INSERT INTO MOVIMIENTO (
                DESCRIPCION
				)
			VALUES (
                @i_descripcion
				)
		END --NO EXISTE
		ELSE
			SELECT 'El Id de movimiento ya existe' Mensaje

	END --ADD
	
-- ===================
-- LISTADO DE MOVIMIENTOS FILTRADO POR ID:
-- ===================
	IF (@i_accion = 'LST')
	BEGIN
                      
		SELECT a.ID_MOVIMIENTO,
			   a.DESCRIPCION
			FROM MOVIMIENTO a WITH (NOLOCK)
		WHERE a.ID_MOVIMIENTO = @i_Id_movimiento

	END --LST
		
-- =====================
-- MODIFICA UN MOVIMIENTO:
-- =====================
	IF (@i_accion = 'UPD')
	BEGIN --UPD
		-- -----------------------------------------------------------------
		-- VERIFICA QUE EL ID DE MOVIMIENTO A MODIFICAR NO EXISTA, 
		-- Y SEAN DIFERENTES AL ID SELECCIONADO:
		-- -----------------------------------------------------------------
		IF (SELECT COUNT(1)
				FROM MOVIMIENTO a WITH (NOLOCK)
				WHERE (a.ID_MOVIMIENTO = @i_Id_movimiento)
				) = 0
		BEGIN --No Existe
				SELECT 'El movimiento que desea modificar no existe' Mensaje
		END --No Existe
				-- -------------------
				-- EL USUARIO NO EXISTE:
				-- -------------------
		ELSE
		BEGIN
			UPDATE MOVIMIENTO
			SET DESCRIPCION = @i_descripcion
			WHERE ID_MOVIMIENTO = @i_Id_movimiento

			SELECT 'Descripcion modificada' Mensaje
		END

	END --UPD
		
-- ====================
-- ELIMINA UN REGISTRO:
-- ====================
	IF (@i_accion = 'DEL')

		BEGIN --DEL

			DELETE MOVIMIENTO
			 WHERE ID_MOVIMIENTO = @i_Id_movimiento	
			 
			 SELECT 'Movimiento eliminado correctamente' Mensaje
		END	--DEL

END

--------------------------------------------------------------------------------------------------------------

--TRIGGERS
--Trigger Insert
CREATE TRIGGER trTableProveedor_Insert 
 ON PROVEEDOR
AFTER INSERT
AS
     BEGIN
         SET NOCOUNT ON;
         INSERT INTO BITACORA
                SELECT 'PROVEEDOR',
                'INSERT',
                'DENNIS', 
                       GETDATE(), 
                       CONCAT(inserted.DESCRIPCION,',',inserted.ID_MOVIMIENTO)
                FROM inserted;
     END;

--Trigger Delete
CREATE TRIGGER trTableProveedor_Delete 
ON PROVEEDOR
AFTER DELETE
AS
     BEGIN
         SET NOCOUNT ON;
         INSERT INTO BITACORA
                SELECT 'PROVEEDOR',
                'DELETED',
                'DENNIS', 
                       GETDATE(), 
                       CONCAT(deleted.DESCRIPCION,',',deleted.ID_MOVIMIENTO)
                FROM deleted;
     END;
--Trigger Update
CREATE TRIGGER trTableProveedor_Update 
ON PROVEEDOR
AFTER UPDATE
AS
     BEGIN
         SET NOCOUNT ON;
         INSERT INTO BITACORA
                SELECT 'PROVEEDOR',
                'UPDATE BEFORE',
                'DENNIS', 
                       GETDATE(), 
                       CONCAT('Antes de la actualización ',deleted.DESCRIPCION,',',deleted.ID_MOVIMIENTO)
                FROM deleted;
         INSERT INTO BITACORA
                SELECT 'PROVEEDOR',
                'UPDATE AFTER',
                'DENNIS', 
                       GETDATE(), 
                       CONCAT('Despues de la actualización ',inserted.DESCRIPCION,',',inserted.ID_MOVIMIENTO)
                FROM inserted;
     END;
GO