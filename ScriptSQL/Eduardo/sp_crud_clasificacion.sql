USE [DBCONTROL]
GO
/****** Object:  StoredProcedure [dbo].[sp_crud_clasificacion]    Script Date: 17/8/2021 21:09:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_crud_clasificacion]
	--====================
	--VARIABLES
	--====================
	@i_accion					varchar(3),					--VARIABLE DE TIPO DE ACCION A EJECUTAR
	@i_id_clasificacion		    int      = null,		--id para actualizar el usuario del usuario
	@i_descripcion				varchar(4) = null
	
AS
BEGIN
	-- ==============================================================================================
-- PROPOSITO: REGISTRO, MODIFICACION Y ELIMINACION DE CLASIFICACION
--
-- MODIFICACIONES:
-- FECHA       QUIEN       MOTIVO
-- ----------  ----------- ----------------------------------------------------------------------
-- 16/08/2021  EDUARDO     CREACION DEL SP PARA EL CRUD DE CLASIFICACION
--
-- ----------------------------------------------------------------------------------------------
-- DESCRIPCIÓN
-- ------ ---------------------------------------------------------------------------------------
-- ADD	  AGREGA UNA NUEVA PERSONA
-- LST    LISTA EL USUARIO AL RECIBIR EL PARAMETRO NOMBRE
-- UPD	  MODIFICA A UNA PERSONA ESPECIFICA
-- DEL	  ACTUALIZA EL ESTADO DE LA PERSONA A 'ELIMINADO'
-- ==============================================================================================
		SET NOCOUNT ON
	-- ==========================
	-- INSERTA UN NUEVO REGISTRO:
	-- ==========================
	IF (@i_accion = 'ADD')
	BEGIN --ADD
		-- ---------------------------------
		-- VERIFICA QUE NO EXISTA EL USUARIO:
		-- ---------------------------------
		IF (
				SELECT COUNT(1)
				FROM CLASIFICACION WITH (NOLOCK)
				WHERE ID_CLASIFICACION = @i_id_clasificacion
					OR DESCRIPCION = @i_descripcion
				) = 0
		BEGIN --NO EXISTE
			INSERT INTO CLASIFICACION (
				DESCRIPCION
			)
			VALUES
			(
				@i_descripcion
			)
		END --NO EXISTE
		ELSE
			SELECT 'La clasificación que se intenta agregar ya existe' Mensaje

	END --ADD
		
	-- ===================
	-- LISTADO DE USUARIOS FILTRADO POR USUARIO:
	-- ===================
	IF (@i_accion = 'LST')
	BEGIN
	      
		SELECT a.ID_CLASIFICACION,
			a.DESCRIPCION
		FROM CLASIFICACION a WITH (NOLOCK)
		WHERE a.ID_CLASIFICACION = @i_id_clasificacion

	END --LST
		
	-- =====================
	-- MODIFICA UN REGISTRO:
	-- =====================
	IF (@i_accion = 'UPD')
	BEGIN --UPD
		-- -----------------------------------------------------------------
		-- VERIFICA QUE EL CODIGO NOMBRE DE USUARIO A MODIFICAR NO EXISTAN, 
		-- Y SEAN DIFERENTES AL ID SELECCIONADO:
		-- -----------------------------------------------------------------
		IF (SELECT COUNT(1)
				FROM CLASIFICACION a WITH (NOLOCK)
				WHERE (a.ID_CLASIFICACION = @i_id_clasificacion)
				) = 0
		BEGIN --No Existe
				SELECT 'La clasificación que intenta modificar no existe' Mensaje
		END --No Existe
				-- -------------------
				-- EL USUARIO NO EXISTE:
				-- -------------------
		ELSE
		BEGIN
			UPDATE CLASIFICACION
			SET DESCRIPCION = @i_descripcion
			WHERE ID_CLASIFICACION = @i_id_clasificacion

			SELECT 'Clasificación Modificado' Mensaje
		END

	END --UPD
		
	-- ====================
	-- ELIMINA UN REGISTRO:
	-- ====================
	IF (@i_accion = 'DEL')

		BEGIN --DEL

			DELETE CLASIFICACION
			 WHERE ID_CLASIFICACION = @i_id_clasificacion	
			 
			 SELECT 'Clasificación eliminado correctamente' Mensaje
		END	--DEL

END

--Trigger Insert
CREATE TRIGGER trTableClasificacion_Insert
ON CLASIFICACION
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO BITACORA
        SELECT 'CLASIFICACION',
        'INSERT',
        'EDUARDO', 
                GETDATE(), 
                CONCAT(inserted.DESCRIPCION,',',inserted.ID_CLASIFICACION)
        FROM inserted;
END;

--Trigger Delete
CREATE TRIGGER trTableClasificacion_Delete 
ON CLASIFICACION
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO BITACORA
        SELECT 'CLASIFICACION',
        'DELETED',
        'EDUARDO', 
                GETDATE(), 
                CONCAT(deleted.DESCRIPCION,',',deleted.ID_CLASIFICACION)
        FROM deleted;
END;


--Trigger Update
CREATE TRIGGER trTableClasificacion_Update 
ON CLASIFICACION
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO BITACORA
        SELECT 'CLASIFICACION',
        'UPDATE BEFORE',
        'EDUARDO', 
                GETDATE(), 
                CONCAT('Antes de la actualización ',deleted.DESCRIPCION,',',deleted.ID_CLASIFICACION)
        FROM deleted;
    INSERT INTO BITACORA
        SELECT 'CLASIFICACION',
        'UPDATE AFTER',
        'EDUARDO', 
                GETDATE(), 
                CONCAT('Despues de la actualización ',inserted.DESCRIPCION,',',inserted.ID_CLASIFICACION)
        FROM inserted;
END;
GO