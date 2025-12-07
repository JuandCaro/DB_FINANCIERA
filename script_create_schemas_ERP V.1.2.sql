-- --------------------------------------------------------
-- script_create_erp_schemas.sql
-- Script DDL para la creación de la estructura base 
-- modular de la Base de Datos del ERP ADSO en PostgreSQL.
-- Autor: Carlos Eduardo Perez & equipo de ADSO 3171727
-- --------------------------------------------------------

-- -------------------------------------------------------------------
-- 1. CONFIGURACIÓN INICIAL
-- Establecer que si algo falla, se detenga el script inmediatamente.
-- -------------------------------------------------------------------
SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

-- ----------------------------------------------
-- 2. BORRADO DE LOS ESQUEMAS DE MÓDULOS DEL ERP
-- Módulos Transaccionales
-- ----------------------------------------------

DROP SCHEMA IF EXISTS CONPRE;  -- Contabilidad y Presupuesto
DROP SCHEMA IF EXISTS GEHNOM;  -- Gestión Humana y Nómina
DROP SCHEMA IF EXISTS GEDCAL;  -- Gestión Documental y Calidad
DROP SCHEMA IF EXISTS SESATR;  -- Seguridad y Salud en el Trabajo
DROP SCHEMA IF EXISTS SECURE;  -- Seguridad
DROP SCHEMA IF EXISTS MARCOM;  -- Marketing y Comercial

-- ----------------------------------------------
-- 3. BORRADO DE TABLAS PARA INSTALACIÓN INICIAL
-- ----------------------------------------------
DROP TABLE IF EXISTS tab_terceros;
DROP TABLE IF EXISTS tab_cat_terceros;
DROP TABLE IF EXISTS tab_restricciones;
DROP TABLE IF EXISTS tab_ciudades;
DROP TABLE IF EXISTS tab_dptos;
DROP TABLE IF EXISTS tab_pmtros_grales;
DROP TABLE IF EXISTS tab_audit_trail;
DROP TYPE IF EXISTS DATOS_UBICACION;

-- ------------------------------------------------------------
-- 4. CREACIÓN DE TABLAS TRANSVERSALES (Esquema 'public')
-- Estas tablas son esenciales y usadas por todos los módulos.
-- Se colocan en 'public' para un acceso más sencillo.
-- ------------------------------------------------------------

--ESTRUCTURA DE DATOS DE UBICACIÓN DE LOS TERCEROS DEL SISTEMA
CREATE TYPE DATOS_UBICACION AS
(
	nom_corto			VARCHAR,
    direccion           VARCHAR,                                --direcion del tercero
    tel_fijo            DECIMAL(10,0),                          --telefono del tercero
    tel_movil           DECIMAL(10,0),                          --celular del tercero
    email               VARCHAR(255)
);

-- ------------------------------
-- 5. TABLA PARAMETROS GENERALES
-- ------------------------------
CREATE TABLE IF NOT EXISTS tab_pmtros_grales
(
    id_empresa	        DECIMAL(10,0)	NOT NULL CHECK(id_empresa >=10000000 AND id_empresa<=9999999999),               --identificador de la empresa
    nom_empresa	        VARCHAR          NOT NULL CHECK(LENGTH(nom_empresa) >= 5 AND LENGTH(nom_empresa) <= 60),         --nombre de la empresa
    datos_residencia    DATOS_UBICACION,
    nom_replegal        VARCHAR	        NOT NULL CHECK(LENGTH(nom_replegal) >= 5 AND LENGTH(nom_replegal) <= 60),       --nombre del representante legal
    val_poriva	        DECIMAL(2,0)	NOT NULL CHECK(val_poriva   >= 0   AND val_poriva   < 100) DEFAULT 0,           --valor porcentaje iva
    val_pordesc	        DECIMAL(2,0)	NOT NULL CHECK(val_pordesc   >= 0   AND val_pordesc   < 100) DEFAULT 0,         --valor porcentaje descuento
    val_porrete	        DECIMAL(2,0)	NOT NULL CHECK(val_porrete  >= 0   AND val_porrete  < 100) DEFAULT 0,           --valor porcentaje retencion
    val_reteica	        DECIMAL(2,0)	NOT NULL CHECK(val_reteica  >= 0   AND val_reteica  < 100) DEFAULT 0,           --valor porcentaje reteica
    val_porutil	        DECIMAL(3,0)	NOT NULL CHECK(val_porutil  >= 0   AND val_porutil  <= 100) DEFAULT 0,          --valor porcentaje utilidad
    val_latitud	        DECIMAL(12,10)	NOT NULL CHECK(val_latitud  >= -4  AND val_latitud  <= 80),	                    --valor latitud
    val_longitud	    DECIMAL(12,10)	NOT NULL CHECK(val_longitud >= -80 AND val_longitud <= -50),                    --valor longitud
    val_color_letra     VARCHAR         NOT NULL CHECK(LENGTH(val_color_letra) = 7),                                    --valor  del color de la letra
    val_color_logo      VARCHAR         NOT NULL CHECK(LENGTH(val_color_logo) = 7),                                     --valor del color del logo
    val_color_fondo     VARCHAR         NOT NULL CHECK(LENGTH(val_color_fondo) = 7),                                    --valor del color del fondo
    anio_fiscal         DECIMAL(4,0)    NOT NULL,                                                                       --Año fiscal en el estamos actualmente
    mes_fiscal          DECIMAL(2,0)    NOT NULL,                                                                       --mes fiscal en el que estamos actualmente
    ind_autoretenedor   BOOLEAN	        NOT NULL, --TRUE = autorete / FALSE = no autorete                               --indicador autoretenedor
    PRIMARY KEY(id_empresa),
    CONSTRAINT verificar_anio CHECK(anio_fiscal = EXTRACT (YEAR FROM CURRENT_DATE)), 
    CONSTRAINT verificar_mes  CHECK(mes_fiscal = EXTRACT (MONTH FROM CURRENT_DATE)) 
);
--------------------------------------
-- TABLA DEPARTAMENTOS  DE COLOMBIA --
--------------------------------------
CREATE TABLE IF NOT EXISTS tab_dptos
(
    id_dpto	            VARCHAR         NOT NULL CHECK(LENGTH(id_dpto) = 2),                                 --identificador del departamento
    nom_dpto	        VARCHAR	        NOT NULL CHECK(LENGTH(nom_dpto) >= 4 AND LENGTH(nom_dpto) <= 20),    --nombre del departamento
    PRIMARY KEY(id_dpto)
);

--------------------
-- TABLA CIUDADES --
--------------------
CREATE TABLE IF NOT EXISTS tab_ciudades
(
    id_ciudad	        VARCHAR	        NOT NULL CHECK(LENGTH(id_ciudad) = 5),										--identificador de la ciudad									
    nom_ciudad	        VARCHAR	        NOT NULL CHECK(LENGTH(nom_ciudad) >= 3 AND LENGTH(nom_ciudad) <= 30), 		--nombre de la ciudad
    id_dpto     	    VARCHAR	        NOT NULL CHECK(LENGTH(id_dpto) = 2),											--identidicador del departamento
    ind_capital	        BOOLEAN	        NOT NULL,   --True = capital / false = no capital							--indicador de la capital
    cod_postal	        VARCHAR	        NOT NULL CHECK(LENGTH(cod_postal) = 6),										--codigo postal
    val_latitud         DECIMAL(12,10)	NOT NULL CHECK(val_latitud >= -4    AND val_latitud <= 80), 					--valor latitud
    val_longitud        DECIMAL(12,10)  NOT NULL CHECK(val_longitud >= -80  AND val_longitud <= -50), 				--valor longitud
    PRIMARY KEY(id_ciudad),
    FOREIGN KEY (id_dpto) REFERENCES tab_dptos(id_dpto)
);

-----------------------------------------------------------
-- TABLA GENERAL DE CATEGORÍAS DE TERCEROS DEL SISTEMA	 --
-----------------------------------------------------------
-- ESTA TABLA PERMITE LA CARACTERIZACIÓN DE LOS TERCEROS EN TODO EL SISTEMA.			
CREATE TABLE IF NOT EXISTS tab_cat_terceros
(			
	id_cat_tercero 		DECIMAL(2,0)	NOT NULL,					--identificador de la categoria 
	nom_cat_tercero		VARCHAR			NOT NULL,					--Nombre de la categoria tercero
	PRIMARY KEY(id_cat_tercero)			
);			
INSERT INTO tab_cat_terceros VALUES(1,'CLIENTE');			
INSERT INTO tab_cat_terceros VALUES(2,'VENDEDOR');			
INSERT INTO tab_cat_terceros VALUES(3,'EMPLEADO');			
INSERT INTO tab_cat_terceros VALUES(4,'LEAD');			
INSERT INTO tab_cat_terceros VALUES(5,'PROVEDOR');			
			
-----------------------------------------------------------------------------------
-- TABLA DE RESTRICCIONES DE LOS TERCEROS, QUE IMPIDEN SU ACCESO AL SISTEMA	 --
-----------------------------------------------------------------------------------			
CREATE TABLE IF NOT EXISTS tab_restricciones			
(			
	id_restriccion		DECIMAL(2,0)	NOT NULL,				--identificador de la restrinción	
	nom_restriccion		VARCHAR			NOT NULL,				--Nombre de la restrinción
	PRIMARY KEY(id_restriccion)			
);			
INSERT INTO tab_restricciones VALUES(1,'Finalización Contrato Mutuo Acuerdo');			
INSERT INTO tab_restricciones VALUES(2,'Vacaciones Colectivas');			
INSERT INTO tab_restricciones VALUES(3,'Inhabilidad Legal');			
INSERT INTO tab_restricciones VALUES(4,'Restricción Día Festivo');			
			
-------------------------
-- TABLA DE TERCEROS.  --
------------------------- 
--ES TRANSVERSAL. TODA PERSONA DEBE ESTAR REGISTRADA EN ESTA TABLA.			
-- TIENE EXTENSIONES COMO CLIENTES, VENDEDORES, EMPLEADO, ETC. Y CADA EXTENSIÓN TIENE LOS DATOS PARTICULARES			
CREATE TABLE IF NOT EXISTS tab_terceros			
(			
	id_tercero			DECIMAL(10,0)	NOT NULL CHECK(id_tercero >=10000000 AND id_tercero<=9999999999),		--identificador de terceros		
	ind_tipo_tercero	BOOLEAN			NOT NULL, --TRUE:Jurídica / FALSE:Natural								--tipo de tercero si es persona natural o jurídica
	id_cat_tercero		DECIMAL(2,0)	NOT NULL,																--identifiador de la categoria 
	nom_tercero			VARCHAR			NOT NULL,																--nombre del tercero
	dir_tercero			DATOS_UBICACION,																		--Estructura de   datos de ubicación de terceros
	id_ciudad			VARCHAR			NOT NULL,																--identificador de ciudad
	id_restriccion		DECIMAL(2,0)	NOT NULL, -- Validado contra tabla de restricciones						--identificador de las restrincion
	ind_estado			BOOLEAN			NOT NULL, --TRUE:Activo ( FALSE:Inactivo)								--indicador de estado del tercero
	PRIMARY KEY(id_tercero),			
	FOREIGN KEY(id_ciudad)			REFERENCES tab_ciudades(id_ciudad),			
	FOREIGN KEY(id_cat_tercero)		REFERENCES tab_cat_terceros(id_cat_tercero),			
	FOREIGN KEY(id_restriccion)		REFERENCES tab_restricciones(id_restriccion)
);

-- ----------------------------------------------------------------
-- 6. CREACIÓN DE LOS ESQUEMAS MODULARES
-- Cada esquema encapsula la lógica y las tablas de un módulo.
-- Esto facilita la gestión de permisos y la organización lógica.
-- ----------------------------------------------------------------

-- Módulos Transaccionales
CREATE SCHEMA FACCAR;  -- Facturación y Cartera
CREATE SCHEMA COMPRO;  -- Compras y Proveedores
CREATE SCHEMA TESCXP;  -- Tesorería y Cuentas por Pagar
CREATE SCHEMA MARCOM;  -- Marketing y Comercial
CREATE SCHEMA CONPRE;  -- Contabilidad y Presupuesto
CREATE SCHEMA GEHNOM;  -- Gestión Humana y Nómina
CREATE SCHEMA GEDCAL;  -- Gestión Documental y Calidad
CREATE SCHEMA SESATR;  -- Seguridad y Salud en el Trabajo
CREATE SCHEMA SECURE;  -- Seguridad

-- ---------------------------------------------------
-- 7. CONFIGURACIÓN DEL SEARCH_PATH (Ruta de Búsqueda)
-- Esto permite que los módulos accedan a 'public' sin prefijo.
-- Se establece el path por defecto para que las consultas busquen 
-- primero en 'public' y luego en el esquema actual de la sesión.
-- (Aunque las aplicaciones siempre deberían usar el prefijo por seguridad, 
-- esta es una configuración común).
-- ---------------------------------------------------

-- Ejemplo de configuración para un usuario específico (opcional, pero recomendado 
-- si se crean roles específicos para cada módulo).
-- ALTER USER app_user SET search_path TO "$user", public;

-- Configuración general de la base de datos (para quien no tenga un path definido)
ALTER DATABASE db_erpadso SET search_path TO public, "$user";

-- ---------------------------------------------------------------------
-- 8. CREACIÓN DE TRIGGER DE AUDITORÍA PARA LAS TABLAS. ESTRCUTURA TYPE
------------------------------------------------------------------------

-- ---------------------------------------------------
-- 02_create_audit_trail.sql
-- Creación de la tabla de registros de auditoría 
-- y la función de trigger.
-- ---------------------------------------------------

-- ---------------------------------------------------
-- 9. CREAR LA TABLA CENTRAL DE REGISTROS DE AUDITORÍA
-- Ubicada en 'public' para un acceso sencillo desde todos los esquemas.
-- ---------------------------------------------------
CREATE TABLE public.tab_audit_trail
(
    id_registro         BIGSERIAL PRIMARY KEY, -- Identificador de la transacción/sesión de DB
    txid                BIGINT      NOT NULL DEFAULT txid_current(),
    nom_esquema         TEXT        NOT NULL,
    nom_tabla           TEXT        NOT NULL,
    ind_operacion       CHAR(1)     NOT NULL, -- I: Insert, U: Update, D: Delete
    usuario_db          TEXT NOT NULL DEFAULT CURRENT_USER,
    usuario_erp_id      INT, -- Si puedes obtener el ID del usuario logueado en la aplicación.    
    fec_registro        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
-- Los datos viejos (para UPDATE/DELETE) y los nuevos (para INSERT/UPDATE)
    datos_viejos JSONB, 
    datos_nuevos JSONB
);

-- Crear un índice compuesto para consultas rápidas de auditoría
CREATE INDEX idx_auditoria_tabla_fecha ON public.tab_audit_trail(nom_tabla,fec_registro DESC);

-- ---------------------------------------------------
-- 10. CREAR LA FUNCIÓN DE TRIGGER DE AUDITORÍA
-- La función debe usar el nombre completo de la tabla: public.auditoria_registros
-- ---------------------------------------------------
CREATE OR REPLACE FUNCTION public.fun_audit_trail() RETURNS TRIGGER AS $$
    DECLARE w_old_data JSONB;
    DECLARE w_new_data JSONB;
    BEGIN
-- Determinar qué datos guardar según la operación
    IF (TG_OP = 'UPDATE') THEN
        w_old_data := to_jsonb(OLD);
        w_new_data := to_jsonb(NEW);
    ELSIF (TG_OP = 'DELETE') THEN
        w_old_data := to_jsonb(OLD);
        w_new_data := NULL;
    ELSIF (TG_OP = 'INSERT') THEN
        w_old_data := NULL;
        w_new_data := to_jsonb(NEW);
    ELSE
-- No debería ocurrir
        RETURN NULL;
    END IF;
-- Insertar el registro de auditoría
    INSERT INTO public.tab_audit_trail (esquema_nombre,tabla_nombre,operacion,usuario_erp_id,datos_viejos,datos_nuevos)
    VALUES (TG_TABLE_SCHEMA, -- Obtiene el nombre del esquema
            TG_TABLE_NAME,   -- Obtiene el nombre de la tabla
            SUBSTR(TG_OP, 1, 1),NULL, -- !!OJO!!!, Aquí se debe integrar la lógica para obtener el ID del usuario ERP
            w_old_data,
            w_new_data);
-- Siempre retornar NEW para INSERT y UPDATE, o OLD para DELETE (aunque no se necesita aquí)
    IF (TG_OP = 'DELETE') THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
-- SECURITY DEFINER: Importante para asegurar que el trigger se ejecute 
-- con los permisos del creador (que tiene acceso a public.auditoria_registros)

-- ------------------------------------------------------------------
-- 11. EJEMPLO DE ASIGNACIÓN DEL TRIGGER A UNA TABLA MODULAR (public)
-- ------------------------------------------------------------------
-- Asumimos que esta tabla ya existe en el esquema public
-- CREATE TABLE IF NOT EXISTS public.tab_dptos; 
-- ------------------------------------------------------------------

CREATE OR REPLACE TRIGGER tri_audit_trail AFTER INSERT OR UPDATE OR DELETE ON public.tab_dptos
FOR EACH ROW EXECUTE FUNCTION public.fun_audit_trail();

CREATE OR REPLACE TRIGGER tri_audit_trail AFTER INSERT OR UPDATE OR DELETE ON public.tab_ciudades
FOR EACH ROW EXECUTE FUNCTION public.fun_audit_trail();

CREATE OR REPLACE TRIGGER tri_audit_trail AFTER INSERT OR UPDATE OR DELETE ON public.tab_cat_terceros
FOR EACH ROW EXECUTE FUNCTION public.fun_audit_trail();

CREATE OR REPLACE TRIGGER tri_audit_trail AFTER INSERT OR UPDATE OR DELETE ON public.tab_restricciones
FOR EACH ROW EXECUTE FUNCTION public.fun_audit_trail();

CREATE OR REPLACE TRIGGER tri_audit_trail AFTER INSERT OR UPDATE OR DELETE ON public.tab_terceros
FOR EACH ROW EXECUTE FUNCTION public.fun_audit_trail();

-- acá va la versión 1.1