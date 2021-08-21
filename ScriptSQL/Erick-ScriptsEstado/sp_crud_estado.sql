
USE DBCONTROL
GO
/****** Object:  StoredProcedure [dbo].[sp_crud_estado]    Script Date: 26/07/2021 07:51:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_crud_estado]
	--====================
	--VARIABLES
	--====================
	@i_accion					varchar(3),				--VARIABLE DE TIPO DE ACCION A EJECUTAR
	@i_Id_estado				int = null,				--id para actualizar el estado
	@i_descripcion				varchar(45) = null		--descripcion del estado
	
AS

BEGIN
-- ==============================================================================================
-- PROPOSITO: REGISTRO, MODIFICACION Y ELIMINACION DE USUARIOS ROBOT BANTRAB
--
-- MODIFICACIONES:
-- FECHA       QUIEN       MOTIVO
-- ----------  ----------- ----------------------------------------------------------------------
-- 15/07/2021  EVENTURA     CREACION DEL SP PARA LA ADMINISTRACION DE ROBOT BANTRAB
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
				FROM ESTADO WITH (NOLOCK)
				WHERE ID_ESTADO = @i_Id_estado
					OR DESCRIPCION = @i_descripcion
				) = 0
		BEGIN --NO EXISTE
			INSERT INTO ESTADO(
				DESCRIPCION
				)
			VALUES (
				@i_descripcion
				)
		END --NO EXISTE
		ELSE
			SELECT 'El estado no es valido' Mensaje

	END --ADD
		
	-- ===================
	-- LISTADO DE ESTADOS POR ID:
	-- ===================
	IF (@i_accion = 'LST')
	BEGIN
	                    
		SELECT a.ID_ESTADO,
			a.DESCRIPCION
		FROM ESTADO a WITH (NOLOCK)
		WHERE a.ID_ESTADO = @i_Id_estado

	END --LST
		
	-- =====================
	-- MODIFICA UN ESTADO:
	-- =====================
	IF (@i_accion = 'UPD')
	BEGIN --UPD
		-- -----------------------------------------------------------------
		-- VERIFICA QUE EL CODIGO NOMBRE DE USUARIO A MODIFICAR NO EXISTAN, 
		-- Y SEAN DIFERENTES AL ID SELECCIONADO:
		-- -----------------------------------------------------------------
		IF (SELECT COUNT(1)
				FROM ESTADO a WITH (NOLOCK)
				WHERE (a.ID_ESTADO = @i_Id_estado)
				) = 0
		BEGIN --No Existe
				SELECT 'El estado no existe' Mensaje
		END --No Existe
				-- -------------------
				-- EL USUARIO NO EXISTE:
				-- -------------------
		ELSE
		BEGIN
			UPDATE ESTADO
			SET DESCRIPCION = @i_descripcion
			WHERE ID_ESTADO = @i_Id_estado

			SELECT 'Estado actualizado' Mensaje
		END

	END --UPD
		
	-- ====================
	-- ELIMINA UN REGISTRO:
	-- ====================
	IF (@i_accion = 'DEL')

		BEGIN --DEL

			DELETE ESTADO
			 WHERE ID_ESTADO = @i_Id_estado	
			 
			 SELECT 'Estado Eliminado' Mensaje
		END	--DEL
END
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
