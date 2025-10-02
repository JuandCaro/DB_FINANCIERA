 
DROP TABLE IF EXISTS tab_pmtros_generales;
DROP TABLE IF EXISTS tab_pmtros_financieros;
DROP TABLE IF EXISTS tab_departamentos;
DROP TABLE IF EXISTS tab_ciudades;
DROP TABLE IF EXISTS tab_inversores;
DROP TABLE IF EXISTS tab_presupuesto;
DROP TABLE IF EXISTS tab_proyectos;
DROP TABLE IF EXISTS tab_indicadores;
DROP TABLE IF EXISTS tab_activos_fijos;
DROP TABLE IF EXISTS tab_terceros;
DROP TABLE IF EXISTS tab_val_ind;

--TABLA DE PARÁMERTROS GENERALES

CREATE TABLE IF NOT EXISTS tab_pmtros_generales
(
    id_empresa     VARCHAR         NOT NULL,             
    nom_empresa    VARCHAR         NOT NULL,                
    val_poriva     DECIMAL (2,0)   NOT NULL DEFAULT 0, 
    val_porrete    DECIMAL (2,0)   NOT NULL DEFAULT 0, 
    val_reteica    DECIMAL (2,0)   NOT NULL DEFAULT 0,
    val_porutil    DECIMAL (3,0)   NOT NULL DEFAULT 0,
    dir_empresa    VARCHAR         NOT NULL,
    tel_empresa    VARCHAR         NOT NULL,
    email_empresa  VARCHAR         NOT NULL,
    nom_replegal   VARCHAR         NOT NULL,
    val_longitud   DECIMAL (12,10) NOT NULL,
    val_latitud    DECIMAL (12,10) NOT NULL,
    ind_autorrete  BOOLEAN         NOT NULL,
    PRIMARY KEY (id_empresa)

);

--TABLA DE PARÁMETROS FINANCI

CREATE TABLE IF NOT EXISTS tab_pmtros_financieros
(   
    id_pmtro_financiero   VARCHAR                       NOT NULL,
	pasivos_corrientes    DECIMAL   (18,2)              NOT NULL,
	activos_corrientes    DECIMAL   (18,2)              NOT NULL,
	inventario            DECIMAL   (18,2)              NOT NULL,
	efectivo              DECIMAL   (18,2)              NOT NULL,
	equiv_efectivo        DECIMAL   (18,2)              NOT NULL,
	patrimonio            DECIMAL   (18,2)              NOT NULL,
	interes               DECIMAL   (18,2)              NOT NULL,
	utilidad_neta         DECIMAL   (18,2)              NOT NULL,
	utilidad_operativa    DECIMAL   (18,2)              NOT NULL,
	ventas                DECIMAL   (18,2)              NOT NULL,
	costo_de_ventas       DECIMAL   (18,2)              NOT NULL,
	capital_invertido     DECIMAL   (18,2)              NOT NULL,
	equivalentes          DECIMAL   (18,2)              NOT NULL,
	pasivo_financiero     DECIMAL   (18,2)              NOT NULL,
	cxc_promedio          DECIMAL   (18,2)              NOT NULL,
	ventas_credito        DECIMAL   (18,2)              NOT NULL,
	inv_promedio          DECIMAL   (18,2)              NOT NULL,
	compras_credito       DECIMAL   (18,2)              NOT NULL,
	cxp_promedio          DECIMAL   (18,2)              NOT NULL,
	usr_insert            VARCHAR                       NOT NULL,
    fec_insert            TIMESTAMP WITHOUT TIME ZONE   NOT NULL,  
	usr_update            VARCHAR                       NULL,
	fec_update            TIMESTAMP WITHOUT TIME ZONE   NULL,
    PRIMARY KEY (id_pmtro_financiero)

);
 
--TABLA DE DEPARTAMENTOS

CREATE TABLE IF NOT EXISTS tab_departamentos
(
    id_departamento       VARCHAR                       NOT NULL,
    nom_departamento      VARCHAR                       NOT NULL,
    usr_insert            VARCHAR                       NOT NULL,
    fec_insert            TIMESTAMP WITHOUT TIME ZONE   NOT NULL,  
	usr_update            VARCHAR                       NULL,
	fec_update            TIMESTAMP WITHOUT TIME ZONE   NULL,
    PRIMARY KEY (id_departamento)
);

--TABLA DE CIUDADES

CREATE TABLE IF NOT EXISTS tab_ciudades
(
    id_ciudad             VARCHAR                       NOT NULL, 
    nom_ciudad            VARCHAR                       NOT NULL, 
    ind_capital           BOOLEAN                       NOT NULL, 
    cod_postal            VARCHAR                       NOT NULL, 
    val_longitud          DECIMAL   (12,10)             NOT NULL,
    val_latitud           DECIMAL   (12,10)             NOT NULL,       
    usr_insert            VARCHAR                       NOT NULL,
    fec_insert            TIMESTAMP WITHOUT TIME ZONE   NOT NULL,  
	usr_update            VARCHAR                       NULL,
	fec_update            TIMESTAMP WITHOUT TIME ZONE   NULL,
    PRIMARY KEY (id_factura,id_prod),
	FOREIGN KEY (id_departamento) REFERENCES tab_departamentos(id_departamento)
);

--TABLA DE INVERSORES

CREATE TABLE IF NOT EXISTS tab_inversores
(
    id_inversor           VARCHAR                       NOT NULL,
    nom_inversor          VARCHAR                       NOT NULL,
    tipo_inversor         BOOLEAN                       NOT NULL,
    tel_inversor          DECIMAL   (10,0)              NOT NULL,
    email_inversor        VARCHAR                       NOT NULL,   
    por_participacion     DECIMAL   (3,1)               NOT NULL,
    dir_inversor          VARCHAR                       NOT NULL,
    val_longitud          DECIMAL   (12,10)             NOT NULL,
    val_latitud           DECIMAL   (12,10)             NOT NULL,       
    usr_insert            VARCHAR                       NOT NULL,
    fec_insert            TIMESTAMP WITHOUT TIME ZONE   NOT NULL,  
	usr_update            VARCHAR                       NULL,
	fec_update            TIMESTAMP WITHOUT TIME ZONE   NULL,
    PRIMARY KEY (id_inversor),
	FOREIGN KEY (id_ciudad) REFERENCES tab_ciudades(id_ciudad)
);

--TABLA DE PRESUPUESTO

CREATE TABLE IF NOT EXISTS tab_presupuesto
(
    id_presupuesto        VARCHAR                       NOT NULL,
    nom_presupuesto       VARCHAR                       NOT NULL,
    monto_presupuesto     DECIMAL   (8,0)               NOT NULL,
    fec_inicio            DATE                          NOT NULL,
    fec_fin               DATE                          NOT NULL,
    descripcion           VARCHAR                       NOT NULL,
    usr_insert            VARCHAR                       NOT NULL,
    fec_insert            TIMESTAMP WITHOUT TIME ZONE   NOT NULL,  
	usr_update            VARCHAR                       NULL,
	fec_update            TIMESTAMP WITHOUT TIME ZONE   NULL,
    PRIMARY KEY (id_presupuesto)
);

--TABLA DE PROYECTOS
 
CREATE TABLE IF NOT EXISTS tab_proyectos
(
    id_proyecto	            VARCHAR                       NOT NULL,
    id_inversor         	VARCHAR                       NOT NULL,
    id_presupuesto      	VARCHAR                       NOT NULL,
    nom_presupuesto	        VARCHAR                       NOT NULL,
    descripcion	            TEXT                          NOT NULL,
    fec_inicio	            DATE                          NOT NULL,
    fec_fin	                DATE                          NOT NULL,
    presupuesto_asignado	DECIMAL(8,0)                  NOT NULL,
    resp_proyecto	        VARCHAR                       NOT NULL,
    usr_insert              VARCHAR                       NOT NULL,
    fec_insert              TIMESTAMP WITHOUT TIME ZONE   NOT NULL,  
	usr_update              VARCHAR                       NULL,
	fec_update              TIMESTAMP WITHOUT TIME ZONE   NULL,
    PRIMARY KEY (id_proyecto),
    FOREIGN KEY (id_inversor)    REFERENCES tab_inversores(id_inversor),
    FOREIGN KEY (id_presupuesto) REFERENCES tab_presupuesto(id_presupuesto)
);

--TABLA DE INDICADORES

CREATE TABLE IF NOT EXISTS tab_indicadores
(
    id_ind	                VARCHAR                       NOT NULL
    id_activo	            VARCHAR                       NOT NULL,
    descripción	            TEXT                          NOT NULL,
    tipo	                VARCHAR                       NOT NULL,
    formula	                VARCHAR                       NOT NULL,
    lim_alerta	            DECIMAL(2,0)                  NOT NULL,
    usr_insert              VARCHAR                       NOT NULL,
    fec_insert              TIMESTAMP WITHOUT TIME ZONE   NOT NULL,  
	usr_update              VARCHAR                       NULL,
	fec_update              TIMESTAMP WITHOUT TIME ZONE   NULL,
    PRIMARY KEY (id_ind),
    FOREIGN KEY (id_activo)    REFERENCES tab_activos_fijos(id_activo),
);

--TABLA DE ACTIVOS FIJOS

CREATE TABLE IF NOT EXISTS tab_activos_fijos
(
    id_activo	            VARCHAR                       NOT NULL,
    nom_activo	            VARCHAR                       NOT NULL,
    tip_activo	            BOOLEAN                       NOT NULL,
    val_inicial         	DECIMAL   (10,2)              NOT NULL,
    val_contable	        DECIMAL   (10,2)              NOT NULL,
    val_residual	        DECIMAL   (10,2)              NOT NULL,
    ubicación	            VARCHAR                       NOT NULL,
    usr_insert              VARCHAR                       NOT NULL,
    fec_insert              TIMESTAMP WITHOUT TIME ZONE   NOT NULL,  
	usr_update              VARCHAR                       NULL,
	fec_update              TIMESTAMP WITHOUT TIME ZONE   NULL,
    PRIMARY KEY (id_activo)
);

--TABLA DE TERCEROS

CREATE TABLE IF NOT EXISTS tab_terceros
(
    id_tercero	            VARCHAR                        NOT NULL,
    fec_nacimiento	        DATE                           NOT NULL,
    nom_tercero	            VARCHAR                        NOT NULL,
    tel_tercero	            DECIMAL(10,0)                  NOT NULL,
    mail_tercero	        VARCHAR                        NOT NULL,
    direc_tercero	        VARCHAR                        NOT NULL,
    long_tercero        	DECIMAL(12,10)                 NOT NULL,
    lat_tercero         	DECIMAL(12,10)                 NOT NULL,
    usr_insert              VARCHAR                        NOT NULL,
    fec_insert              TIMESTAMP WITHOUT TIME ZONE    NOT NULL,  
	usr_update              VARCHAR                        NULL,
	fec_update              TIMESTAMP WITHOUT TIME ZONE    NULL,
    PRIMARY KEY (id_tercero)
);

--TABLA DE VALOR DEL INDICADOR

CREATE TABLE IF NOT EXISTS tab_val_ind
(
    id_val_ind	            VARCHAR                        NOT NULL,
    id_pmtro_financiero	    VARCHAR                        NOT NULL,
    id_ind	                VARCHAR                        NOT NULL,
    val_calculado	        DECIMAL  (10,2)                NOT NULL,
    fec_calculo	            DATE                           NOT NULL,
    usr_insert              VARCHAR                        NOT NULL,
    fec_insert              TIMESTAMP WITHOUT TIME ZONE    NOT NULL,  
	usr_update              VARCHAR                        NULL,
	fec_update              TIMESTAMP WITHOUT TIME ZONE    NULL,
    PRIMARY KEY (id_val_ind),
    FOREIGN KEY (id_pmtro_financiero)     REFERENCES tab_pmtros_financieros(id_pmtro_financiero),
    FOREIGN KEY (id_ind)                 REFERENCES tab_indicadores(id_ind)
);
