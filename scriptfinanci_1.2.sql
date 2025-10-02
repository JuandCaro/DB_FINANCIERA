 
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
    id_empresa     VARCHAR         NOT NULL              CHECK  (id_empresa = 10),             
    nom_empresa    VARCHAR         NOT NULL              CHECK  (LENGTH(nom_empresa) >=5 AND LENGTH(nom_empresa) <=60),
    dir_empresa    VARCHAR         NOT NULL,             
    tel_empresa    DECIMAL (10,0)  NOT NULL              CHECK  (tel_empresa >=0),
    email_empresa  VARCHAR         NOT NULL,  
    val_poriva     DECIMAL (2,0)   NOT NULL DEFAULT 0    CHECK  (val_poriva   >=0    AND val_poriva    < 100),
    val_porrete    DECIMAL (2,0)   NOT NULL DEFAULT 0    CHECK  (val_porrete  >=0    AND val_porrete   < 100),
    val_reteica    DECIMAL (2,0)   NOT NULL DEFAULT 0    CHECK  (val_reteica  >=0    AND val_reteica   < 100),
    val_porutil    DECIMAL (3,0)   NOT NULL DEFAULT 0    CHECK  (val_porutil  >=0    AND val_porutil   < 1000),
    val_longitud   DECIMAL (12,10) NOT NULL              CHECK  (val_longitud >=-4   AND val_longitud  <=80),
    val_latitud    DECIMAL (12,10) NOT NULL              CHECK  (val_latitud  >=-80  AND val_latitud   <=-50),
    ind_autorrete  BOOLEAN         NOT NULL,             --TRUE = autorrete / FALSE = no autorrete
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
	usr_update            VARCHAR                           NULL,
	fec_update            TIMESTAMP WITHOUT TIME ZONE       NULL,
    PRIMARY KEY (id_pmtro_financiero)

);
 
--TABLA DE DEPARTAMENTOS

CREATE TABLE IF NOT EXISTS tab_departamentos
(
    id_departamento       VARCHAR                       NOT NULL    CHECK   (id_departamento=2),
    nom_departamento      VARCHAR                       NOT NULL    CHECK   (LENGTH(nom_departamento) <=30,
    usr_insert            VARCHAR                       NOT NULL, 
    fec_insert            TIMESTAMP WITHOUT TIME ZONE   NOT NULL,  
	usr_update            VARCHAR                           NULL,
	fec_update            TIMESTAMP WITHOUT TIME ZONE       NULL,
    PRIMARY KEY (id_departamento)
);

--TABLA DE CIUDADES

CREATE TABLE IF NOT EXISTS tab_ciudades
(
    id_ciudad             VARCHAR                       NOT NULL    CHECK   (id_ciudad =5),
    nom_ciudad            VARCHAR                       NOT NULL    CHECK   (nom_ciudad <=30),
    ind_capital           BOOLEAN                       NOT NULL,    --TRUE = es capital / FALSE = no es capital
    cod_postal            VARCHAR                       NOT NULL    CHECK   (cod_postal =6),
    val_longitud          DECIMAL   (12,10)             NOT NULL    CHECK   (val_longitud >=-4              AND val_longitud  <=80),
    val_latitud           DECIMAL   (12,10)             NOT NULL    CHECK   (val_latitud  >=-80             AND val_latitud   <=-50),
    usr_insert            VARCHAR                       NOT NULL,
    fec_insert            TIMESTAMP WITHOUT TIME ZONE   NOT NULL,  
	usr_update            VARCHAR                           NULL,
	fec_update            TIMESTAMP WITHOUT TIME ZONE       NULL,
    PRIMARY KEY (id_factura,id_prod),
	FOREIGN KEY (id_departamento) REFERENCES tab_departamentos(id_departamento)
);

--TABLA DE INVERSORES

CREATE TABLE IF NOT EXISTS tab_inversores
(
    id_inversor           VARCHAR                       NOT NULL    CHECK   (id_inversor =10),
    nom_inversor          VARCHAR                       NOT NULL    CHECK   (LENGTH(nom_inversor) >=5           AND LENGTH(nom_inversor) <=60),
    tipo_inversor         BOOLEAN                       NOT NULL,   --true = Natural / false = Jurdíco 
    tel_inversor          DECIMAL   (10,0)              NOT NULL    CHECK   (tel_inversor >=0),
    email_inversor        VARCHAR                       NOT NULL    CHECK   (email_inversor <=120),   
    por_participacion     DECIMAL   (2,0)               NOT NULL    CHECK   (LENGTH (por_participacion) >=0     AND LENGTH(por_participacion)<=100),   
    dir_inversor          VARCHAR                       NOT NULL    CHECK   (dir_inversor <255),
    val_longitud          DECIMAL   (12,10)             NOT NULL    CHECK   (val_longitud >=-4                  AND val_longitud  <=80),
    val_latitud           DECIMAL   (12,10)             NOT NULL    CHECK   (val_latitud  >=-80                 AND val_latitud   <=-50),      
    usr_insert            VARCHAR                       NOT NULL,
    fec_insert            TIMESTAMP WITHOUT TIME ZONE   NOT NULL,  
	usr_update            VARCHAR                           NULL,
	fec_update            TIMESTAMP WITHOUT TIME ZONE       NULL,
    PRIMARY KEY (id_inversor),
	FOREIGN KEY (id_ciudad) REFERENCES tab_ciudades(id_ciudad)
);

--TABLA DE PRESUPUESTO

CREATE TABLE IF NOT EXISTS tab_presupuesto
(
    id_presupuesto        VARCHAR                       NOT NULL     CHECK  (LENGTH (id_presupuesto) >=1        AND LENGTH (id_presupuesto) <=10),
    nom_presupuesto       VARCHAR                       NOT NULL     CHECK  (nom_presupuesto <255),
    monto_presupuesto     DECIMAL   (8,0)               NOT NULL     CHECK  (LENGTH (monto_presupuesto) >=0     AND LENGTH(monto_presupuesto)<=100),
    fec_inicio            DATE                          NOT NULL     CHECK  (fec_inicio < '1/01/2025'),
    fec_fin               DATE                          NOT NULL     CHECK  (fec_inicio < '31/12/2025'),
    descripcion           TEXT                          NOT NULL,
    usr_insert            VARCHAR                       NOT NULL,
    fec_insert            TIMESTAMP WITHOUT TIME ZONE   NOT NULL, 
	usr_update            VARCHAR                           NULL,
	fec_update            TIMESTAMP WITHOUT TIME ZONE       NULL,
    PRIMARY KEY (id_presupuesto)
);

--TABLA DE PROYECTOS
 
CREATE TABLE IF NOT EXISTS tab_proyectos
(
    id_proyecto	            VARCHAR                       NOT NULL      CHECK  (LENGTH(id_proyecto) >=1         AND LENGTH(id_proyecto) <=10),
    id_inversor         	VARCHAR                       NOT NULL      CHECK  (id_inversor =10),
    id_presupuesto      	VARCHAR                       NOT NULL      CHECK  (LENGTH (id_presupuesto) >=1     AND LENGTH (id_presupuesto) <=10),
    nom_proyecto	        VARCHAR                       NOT NULL      CHECK  (nom_presupuesto <255),
    descripcion	            TEXT                          NOT NULL,     --CHECK  (),
    fec_inicio	            DATE                          NOT NULL      CHECK  (fec_inicio < '1/01/2025'),
    fec_fin	                DATE                          NOT NULL      CHECK  (fec_fin    < '31/12/2025'),
    presupuesto_asignado	DECIMAL(8,0)                  NOT NULL      CHECK  (presupuesto_asignado >=0        AND presupuesto_asignado <=99999999),
    resp_proyecto	        VARCHAR                       NOT NULL      CHECK  (LENGTH(resp_proyecto) >=5       AND LENGTH(resp_proyecto) <=60),
    usr_insert              VARCHAR                       NOT NULL, 
    fec_insert              TIMESTAMP WITHOUT TIME ZONE   NOT NULL,  
	usr_update              VARCHAR                           NULL,
	fec_update              TIMESTAMP WITHOUT TIME ZONE       NULL,
    PRIMARY KEY (id_proyecto),
    FOREIGN KEY (id_inversor)    REFERENCES tab_inversores(id_inversor),
    FOREIGN KEY (id_presupuesto) REFERENCES tab_presupuesto(id_presupuesto)
);

--TABLA DE INDICADORES

CREATE TABLE IF NOT EXISTS tab_indicadores
(
    id_ind	                VARCHAR                       NOT NULL       CHECK (id_ind <=50),
    id_activo	            VARCHAR                       NOT NULL       CHECK (LENGTH (id_activo) >=0 AND LENGTH (id_activo) <=100),
    descripción	            TEXT                          NOT NULL       CHECK (),
    tipo	                VARCHAR                       NOT NULL       CHECK (LENGTH(tipo) = 'Rentabilidad' OR LENGTH(tipo) = 'Liquidez' OR LENGTH(tipo) = 'Endeudamiento' OR LENGTH(tipo) = 'Rotación'),
    formula	                VARCHAR                       NOT NULL       CHECK (LENGTH(formula) <=255),
    lim_alerta	            DECIMAL(2,0)                  NOT NULL       CHECK (lim_alerta >=0 AND lim_alerta <=99),  
    usr_insert              VARCHAR                       NOT NULL,
    fec_insert              TIMESTAMP WITHOUT TIME ZONE   NOT NULL,  
	usr_update              VARCHAR                           NULL,
	fec_update              TIMESTAMP WITHOUT TIME ZONE       NULL,
    PRIMARY KEY (id_ind),
    FOREIGN KEY (id_activo)    REFERENCES tab_activos_fijos(id_activo)
);

--TABLA DE ACTIVOS FIJOS

CREATE TABLE IF NOT EXISTS tab_activos_fijos
(
    id_activo	            VARCHAR                       NOT NULL       CHECK (LENGTH (id_activo) >=0 AND LENGTH (id_activo) <=100),       
    nom_activo	            VARCHAR                       NOT NULL       CHECK (nom_activo LENGTH(<255)),
    tip_activo	            BOOLEAN                       NOT NULL,      -- True = tangible     AND     false = intangible
    val_inicial         	DECIMAL   (8,0)               NOT NULL       CHECK (val_inicial >=0  AND val_inicial <=99999999),     
    val_contable	        DECIMAL   (8,0)               NOT NULL       CHECK (val_contable >=0  AND val_contable <=99999999),
    val_residual	        DECIMAL   (8,0)               NOT NULL       CHECK (val_residual >=0  AND val_residual <=99999999),
    ubicación	            VARCHAR                       NOT NULL       CHECK (ubicación <=100),
    usr_insert              VARCHAR                       NOT NULL,
    fec_insert              TIMESTAMP WITHOUT TIME ZONE   NOT NULL,  
	usr_update              VARCHAR                           NULL,
	fec_update              TIMESTAMP WITHOUT TIME ZONE       NULL,
    PRIMARY KEY (id_activo)
);

--TABLA DE TERCEROS

CREATE TABLE IF NOT EXISTS tab_terceros
(
    id_tercero	            VARCHAR                        NOT NULL       CHECK (LENGTH (id_inversor) =10),
    fec_nacimiento	        DATE                           NOT NULL       CHECK (),
    nom_tercero	            VARCHAR                        NOT NULL       CHECK (LENGTH (nom_tercero) >=30  AND LENGTH(nom_tercero) <=60),
    tel_tercero	            DECIMAL(10,0)                  NOT NULL       CHECK (tel_tercero >=0 ),
    mail_tercero	        VARCHAR                        NOT NULL       CHECK (LENGTH(mail_tercero)<=100),
    direc_tercero	        VARCHAR                        NOT NULL       CHECK (LENGTH(direc_tercero) <=4  AND LENGTH(direc_tercero) >=80),
    long_tercero        	DECIMAL(12,10)                 NOT NULL       CHECK (val_longitud >=-4   AND val_longitud  <=80),
    lat_tercero         	DECIMAL(12,10)                 NOT NULL       CHECK (val_latitud  >=-80  AND val_latitud   <=-50), 
    usr_insert              VARCHAR                        NOT NULL,
    fec_insert              TIMESTAMP WITHOUT TIME ZONE    NOT NULL,  
	usr_update              VARCHAR                            NULL,
	fec_update              TIMESTAMP WITHOUT TIME ZONE        NULL,
    PRIMARY KEY (id_tercero)
);

--TABLA DE VALOR DEL INDICADOR

CREATE TABLE IF NOT EXISTS tab_val_ind
(
    id_val_ind	            VARCHAR                        NOT NULL       CHECK (LENGTH (id_val_ind) >=0            AND     LENGTH (id_val_ind) <=100 ) ,
    id_pmtro_financiero	    VARCHAR                        NOT NULL       CHECK (LENGTH(id_pmtro_financiero)>=0     AND     LENGTH(id_pmtro_financiero)<=20),
    id_ind	                VARCHAR                        NOT NULL       CHECK (LENGTH (id_ind) <=50),
    val_calculado	        DECIMAL  (10,2)                NOT NULL       CHECK (val_calculado >=0),
    fec_calculo	            DATE                           NOT NULL       CHECK ( <> NOW()),
    usr_insert              VARCHAR                        NOT NULL,
    fec_insert              TIMESTAMP WITHOUT TIME ZONE    NOT NULL,  
	usr_update              VARCHAR                            NULL,
	fec_update              TIMESTAMP WITHOUT TIME ZONE        NULL,
    PRIMARY KEY (id_val_ind),
    FOREIGN KEY (id_pmtro_financiero)     REFERENCES tab_pmtros_financieros(id_pmtro_financiero),
    FOREIGN KEY (id_ind)                 REFERENCES tab_indicadores(id_ind)
);
