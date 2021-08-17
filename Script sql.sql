-- ----------------------------------------------------------------------------------------------
-- DESCRIPCIÓN
-- ------ ---------------------------------------------------------------------------------------
-- ADD	  AGREGA UN MOVIMIENTO
-- LST    LISTA LOS MOVIMIENTOS AL INGRESAR EL ID
-- UPD	  MODIFICA AL DESCRIPCIÓN DE UN MOVIMIENTO
-- DEL	  ACTUALIZA EL DEL MOVIMIENTO A 'ELIMINADO'
-- ==============================================================================================

ALTER PROCEDURE [dbo].[DBCONTROL]
	--====================
	--VARIABLES
	--====================
	@i_accion					dmn_accion,					--VARIABLE DE TIPO DE ACCION A EJECUTAR
	@i_Id_movimiento		    dmn_int = null,		        --id del movimiento
	@i_descripcion			    dmn_descr_50 = null,		--descripcion del movimiento


-- ==========================
-- INSERTA UN NUEVO MOVIMIENTO:
-- ==========================
	IF (@i_accion = 'ADD')
	BEGIN --ADD
		-- ---------------------------------
		-- VERIFICA QUE NO EXISTA EL MOVIMIENTO:
		-- ---------------------------------
		IF (
				SELECT COUNT(*)
				FROM MOVIMIENTO WITH (NOLOCK)
				WHERE ID_MOVIMIENTO = @i_Id_movimiento
				) = 0
		BEGIN --NO EXISTE
			INSERT INTO MOVIMIENTO (
                Fecha_Inicio,
				ID_MOVIMIENTO,
                DESCRIPCIÓN
				)
			VALUES (
                GETDATE(),
				@i_Id_movimiento,
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
			a.ID_MOVIMIENTO AS movimiento,
			a.DESCRIPCIÓN AS descripcion,
			FROM MOVIMIENTO a WITH (NOLOCK)
		WHERE a.ID_MOVIMIENTO = @i_Id_movimiento

	END --LST

-- =====================
-- MODIFICA UN MOVIMIENTO:
-- =====================
	IF (@i_accion = 'UPD')
	BEGIN --UPD
		-- -----------------------------------------------------------------
		-- VERIFICA QUE EL CODIGO NOMBRE DE USUARIO A MODIFICAR NO EXISTAN, 
		-- Y SEAN DIFERENTES AL ID SELECCIONADO:
		-- -----------------------------------------------------------------
		IF (SELECT COUNT(*)
				FROM MOVIMIENTO a WITH (NOLOCK)
				WHERE a.ID_MOVIMIENTO = @i_Id_movimiento)
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
			SET descripcion = @i_descripcion
			WHERE ID_MOVIMIENTO = @i_Id_movimiento

			SELECT 'La Descripcion modificada' Mensaje
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