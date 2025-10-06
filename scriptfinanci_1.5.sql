DROP TABLE IF EXISTS tab_terceros;
DROP TABLE IF EXISTS tab_restricciones;
DROP TABLE IF EXISTS tab_cat_terceros;
DROP TABLE IF EXISTS tab_val_ind;
DROP TABLE IF EXISTS tab_indicadores;
DROP TABLE IF EXISTS tab_activos_fijos;
DROP TABLE IF EXISTS tab_proyectos;
DROP TABLE IF EXISTS tab_presupuesto;
DROP TABLE IF EXISTS tab_inversores;
DROP TABLE IF EXISTS tab_ciudades;
DROP TABLE IF EXISTS tab_deptos;
DROP TABLE IF EXISTS tab_pmtros_financieros;
DROP TABLE IF EXISTS tab_pmtros_generales;
DROP TYPE  IF EXISTS audit_trail;

--*************************
--** TYPE PARA AUDITORÍA **
--*************************
CREATE TYPE audit_trail AS
(
    usr_insert  VARCHAR,                       --Usuario que insertó el registro.
    fec_insert  TIMESTAMP WITHOUT TIME ZONE,   --Fecha y hora de creación del registro.
    usr_update  VARCHAR,                       --Usuario que actualizó el registro.
    fec_update  TIMESTAMP WITHOUT TIME ZONE    --Fecha y hora de la última actualización.
);

--************************************
--** TABLA DE PARÁMERTROS GENERALES **
--************************************

CREATE TABLE IF NOT EXISTS tab_pmtros_generales
(
    id_empresa	       DECIMAL  (10,0)	    NOT NULL             CHECK   (id_empresa = 10),                                              --identificación empresa
    nom_empresa	       VARCHAR              NOT NULL             CHECK   (LENGTH(nom_empresa) >= 5 AND LENGTH(nom_empresa) <= 60),       --nombre de la empresa
    dir_empresa	       VARCHAR	            NOT NULL,                                                                                    --dirección de la empresa
    tel_empresa        DECIMAL  (10,0)      NOT NULL             CHECK   (tel_empresa >= 0),                                             --teléfono de la empresa
    email_empresa	   VARCHAR	            NOT NULL,                                                                                    --correo electrónico de la empresa
    nom_replegal	   VARCHAR	            NOT NULL             CHECK   (LENGTH(nom_replegal) >= 5 AND LENGTH(nom_replegal) <= 60),     --nombre del representante legal
    val_poriva	       DECIMAL  (2,0)	    NOT NULL             CHECK   (val_poriva   >= 0   AND val_poriva   < 100) DEFAULT 0,         --valor del porcentaje del IVA
    val_pordesc	       DECIMAL  (2,0)	    NOT NULL             CHECK   (val_pordesc   >= 0  AND val_pordesc   < 100) DEFAULT 0,        --valor del porcentaje de descuento
    val_porrete	       DECIMAL  (2,0)	    NOT NULL             CHECK   (val_porrete  >= 0   AND val_porrete  < 100) DEFAULT 0,         --valor del porcentaje retefuente
    val_reteica	       DECIMAL  (2,0)	    NOT NULL             CHECK   (val_reteica  >= 0   AND val_reteica  < 100) DEFAULT 0,         --valor del porcentaje reteica
    val_porutil	       DECIMAL  (3,0)	    NOT NULL             CHECK   (val_porutil  >= 0   AND val_porutil  <= 100) DEFAULT 0,        --valor del procentaje de utilidad
    val_lat            DECIMAL	(9,6)       NOT NULL             CHECK   (val_lat  BETWEEN -4 AND 12),                                   --valor de la latitud 
    val_long           DECIMAL	(9,6)       NOT NULL             CHECK   (val_long BETWEEN -80   AND -67),                               --valor de la longitud
    val_color_letra    VARCHAR              NOT NULL             CHECK   (LENGTH(val_color_letra) = 7),                                  --valor del color de la letra
    val_color_logo     VARCHAR              NOT NULL             CHECK   (LENGTH(val_color_logo) = 7),                                   --valor del color del logo
    val_color_fondo    VARCHAR              NOT NULL             CHECK   (LENGTH(val_color_fondo) = 7),                                  --valor del color del fondo
    anio_fiscal        DECIMAL  (4,0)       NOT NULL,                                                                                    --año fiscal
    mes_fiscal         DECIMAL  (2,0)       NOT NULL,                                                                                    --mes fiscal
    ind_autorete       BOOLEAN	            NOT NULL,            --TRUE = autorete / FALSE = no autorete                                 --indicador del autorretenedor
    PRIMARY KEY(id_empresa),
    CONSTRAINT verificar_anio           CHECK(anio_fiscal = EXTRACT (YEAR FROM CURRENT_DATE)), 
    CONSTRAINT verificar_mes            CHECK(mes_fiscal = EXTRACT (MONTH FROM CURRENT_DATE)) 

);

--************************************
--**TABLA DE PARÁMETROS FINANCIEROS **
--************************************

CREATE TABLE IF NOT EXISTS tab_pmtros_financieros
( 
    id_pmtro_financiero   VARCHAR                       NOT NULL         CHECK  (LENGTH (id_pmtro_financiero) >0  AND LENGTH(id_pmtro_financiero) <=20),  --Identificador del parámetro financiero.
	pasivos_corrientes    DECIMAL   (18,2)              NOT NULL         CHECK  (pasivos_corrientes >0),                                                  --Obligaciones a corto plazo de la empresa.
	activos_corrientes    DECIMAL   (18,2)              NOT NULL         CHECK  (activos_corrientes >0),                                                  --Bienes y derechos liquidos en menos de un año.
	inventario            DECIMAL   (18,2)              NOT NULL         CHECK  (inventario >0),                                                          --Valor total de existencias disponibles.
	efectivo              DECIMAL   (18,2)              NOT NULL         CHECK  (efectivo >0),                                                            --Dinero en caja y bancos.
	equiv_efectivo        DECIMAL   (18,2)              NOT NULL         CHECK  (equiv_efectivo >0),                                                      --Inversiones de alta liquidez equivalentes al efectivo.
	patrimonio            DECIMAL   (18,2)              NOT NULL         CHECK  (patrimonio >0),                                                          --Valor residual de los activos después de los pasivos.
	interes               DECIMAL   (18,2)              NOT NULL         CHECK  (interes >0),                                                             --Gastos por intereses financieros.
	utilidad_neta         DECIMAL   (18,2)              NOT NULL         CHECK  (utilidad_neta >0),                                                       --Resultado final después de impuestos.
	utilidad_operativa    DECIMAL   (18,2)              NOT NULL         CHECK  (utilidad_operativa >0),                                                  --Beneficio antes de intereses e impuestos.
	ventas                DECIMAL   (18,2)              NOT NULL         CHECK  (ventas >0),                                                              --Ingresos por ventas netas.
	costo_de_ventas       DECIMAL   (18,2)              NOT NULL         CHECK  (costo_de_ventas >0),                                                     --Costos directos de producción de ventas.
	capital_invertido     DECIMAL   (18,2)              NOT NULL         CHECK  (capital_invertido >0),                                                   --Recursos invertidos por los accionistas.
	equivalentes          DECIMAL   (18,2)              NOT NULL         CHECK  (equivalentes >0),                                                        --Otros activos liquidos.
	pasivo_financiero     DECIMAL   (18,2)              NOT NULL         CHECK  (pasivo_financiero >0),                                                   --Deudas financieras con terceros.
	cxc_promedio          DECIMAL   (18,2)              NOT NULL         CHECK  (cxc_promedio >0),                                                        --promedio de cuentas por cobrar.
	ventas_credito        DECIMAL   (18,2)              NOT NULL         CHECK  (ventas_credito >0),                                                      --Ventas realizadas a crédito.
	inv_promedio          DECIMAL   (18,2)              NOT NULL         CHECK  (inv_promedio >0),                                                        --Promedio de inventarios del periodo.
	compras_credito       DECIMAL   (18,2)              NOT NULL         CHECK  (compras_credito >0),                                                     --Compras financiadas a crédito.
	cxp_promedio          DECIMAL   (18,2)              NOT NULL         CHECK  (cxp_promedio >0),                                                        --Promedio de cuentas por pagar.
    PRIMARY KEY (id_pmtro_financiero)
);

--*****************************
--** TABLA DE DEPARTAMENTOS  **
--*****************************

CREATE TABLE IF NOT EXISTS tab_deptos
(
    id_depto       		  VARCHAR                       NOT NULL    CHECK   (LENGTH(id_depto)=2),       --identificación del departamento
    nom_depto      		  VARCHAR                       NOT NULL    CHECK   (LENGTH(nom_depto) <=30),   --nombre del departamento
    datos_audit           AUDIT_TRAIL,                                                                  --pista de auditoría
    PRIMARY KEY (id_depto)
);

--***********************
--** TABLA DE CIUDADES **
--***********************

CREATE TABLE IF NOT EXISTS tab_ciudades
(
    id_ciudad             VARCHAR                       NOT NULL    CHECK   (LENGTH (id_ciudad) =5),               --identificación de la ciudad
    id_depto       		  VARCHAR                       NOT NULL    CHECK   (LENGTH(id_depto)=2),                  --identificación del departamento
	nom_ciudad            VARCHAR                       NOT NULL    CHECK   (LENGTH (nom_ciudad) <=30),            --nombre de la ciudad
    ind_capital           BOOLEAN                       NOT NULL,    --TRUE = es capital / FALSE = no es capital   --idicador capital
    cod_postal            VARCHAR                       NOT NULL    CHECK   (LENGTH (cod_postal) =6),              --codigo postal
    val_lat         	  DECIMAL	(9,6)               NOT NULL    CHECK (val_lat  BETWEEN -4 AND 12),            --valor de la latitud 
    val_long              DECIMAL	(9,6)               NOT NULL    CHECK (val_long BETWEEN -80   AND -67),        --valor de la longitud
    datos_audit           AUDIT_TRAIL,                                                                             --pista de auditoría
    PRIMARY KEY (id_ciudad),
	FOREIGN KEY (id_depto) REFERENCES tab_deptos(id_depto)
);

--*************************
--** TABLA DE INVERSORES **
--*************************

CREATE TABLE IF NOT EXISTS tab_inversores
(
    id_inversor           VARCHAR                       NOT NULL    CHECK   (LENGTH (id_inversor) =10),                                  --identificación del inversor     
    id_ciudad             VARCHAR                       NOT NULL    CHECK   (LENGTH (id_ciudad) =5),                                     --identificación de la ciudad
	nom_inversor          VARCHAR                       NOT NULL    CHECK   (LENGTH(nom_inversor) >=5  AND LENGTH(nom_inversor) <=60),   --nombre del inversor
    tipo_inversor         BOOLEAN                       NOT NULL,   --true = Natural / false = Jurdíco                                   --tipo de inversor
    tel_inversor          DECIMAL   (10,0)              NOT NULL    CHECK   (tel_inversor >=0),                                          --teléfono del inversor
    email_inversor        VARCHAR                       NOT NULL    CHECK   (LENGTH (email_inversor) <=120),                             --correo electrónico del inversor
    por_participacion     DECIMAL   (3,1)               NOT NULL    CHECK   (por_participacion BETWEEN 0 AND 100),                       --porcentaje de participación del inversor
    dir_inversor          VARCHAR                       NOT NULL    CHECK   (LENGTH (dir_inversor) <255),                                --dirección del inversor
    val_lat         	  DECIMAL	(9,6)               NOT NULL    CHECK   (val_lat  BETWEEN -4 AND 12),                                --valor de la latitud
    val_long        	  DECIMAL	(9,6)               NOT NULL    CHECK   (val_long BETWEEN -80   AND -67),                            --valor de la longitud
    datos_audit           AUDIT_TRAIL,                                                                                                   --pista de auditoría
    PRIMARY KEY (id_inversor),
	FOREIGN KEY (id_ciudad) REFERENCES tab_ciudades(id_ciudad)
);

--**************************
--** TABLA DE PRESUPUESTO **
--**************************

CREATE TABLE IF NOT EXISTS tab_presupuesto
(
    id_presupuesto        VARCHAR                       NOT NULL     CHECK  (LENGTH (id_presupuesto) >=1        AND LENGTH (id_presupuesto) <=10),    --identificador del presupuesto
    nom_presupuesto       VARCHAR                       NOT NULL     CHECK  (LENGTH (nom_presupuesto) <255),                                          --nombre del presupuesto
    monto_presupuesto     DECIMAL   (8,0)               NOT NULL     CHECK  (monto_presupuesto >= 0),                                                 --monto del presupuesto
    fec_inicio            DATE                          NOT NULL     CHECK  (fec_inicio >  '2025/01/1' 	    AND   fec_inicio < '2025/12/31'),         --fecha de inicio del presupuesto
    fec_fin               DATE                          NOT NULL     CHECK  (fec_fin    <  '2025/12/31' 	AND   fec_fin	 > '2025/01/1'),          --fecha final del presupuesto
    descripcion           TEXT                          NOT NULL,                                                                                     --descripción del presupuesto
    datos_audit           AUDIT_TRAIL,                                                                                                                --pista de auditoría
    PRIMARY KEY (id_presupuesto)
);

--************************
--** TABLA DE PROYECTOS **
--************************

CREATE TABLE IF NOT EXISTS tab_proyectos
(
    id_proyecto	            VARCHAR                       NOT NULL      CHECK  (LENGTH (id_proyecto) >=1         AND LENGTH(id_proyecto) <=10),          -- identificador del proyecto
    id_inversor         	VARCHAR                       NOT NULL      CHECK  (LENGTH (id_inversor) =10),                                               --identificación del inversor que ´participa en el proyecto
    id_presupuesto      	VARCHAR                       NOT NULL      CHECK  (LENGTH (id_presupuesto) >=1     	AND LENGTH (id_presupuesto) <=10),   --identificador del presupuesto
    nom_proyecto	        VARCHAR                       NOT NULL      CHECK  (LENGTH (nom_proyecto) <255),                                             --nombre del proyecto
    descripcion	            TEXT                          NOT NULL,     --CHECK  (),                                                                     --descripción del proyecto
    fec_inicio              DATE                          NOT NULL      CHECK  (fec_inicio >  '2025/01/1' 	    AND   fec_inicio < '2025/12/31'),        --fecha de inicio del proyecto
    fec_fin                 DATE                          NOT NULL      CHECK  (fec_fin    <  '2025/12/31' 	    AND   fec_fin	 > '2025/01/1'),         --fecha de finalización del proyecto
    presupuesto_asignado	DECIMAL(8,0)                  NOT NULL      CHECK  (presupuesto_asignado BETWEEN 0  AND  99999999),                          --presupuesto asignado al proyecto
    resp_proyecto	        VARCHAR                       NOT NULL      CHECK  (LENGTH(resp_proyecto) >=5       AND LENGTH(resp_proyecto) <=60),         --rresponsable del proyecto
    datos_audit           AUDIT_TRAIL,                                                                                                                   --pista de auditoría
    PRIMARY KEY (id_proyecto),
    FOREIGN KEY (id_inversor)    REFERENCES tab_inversores(id_inversor),
    FOREIGN KEY (id_presupuesto) REFERENCES tab_presupuesto(id_presupuesto)
);

--****************************
--** TABLA DE ACTIVOS FIJOS **
--****************************

CREATE TABLE IF NOT EXISTS tab_activos_fijos
(
    id_activo	            VARCHAR                       NOT NULL       CHECK (LENGTH (id_activo) >=0 AND LENGTH (id_activo) <=100),        -- identificador del activo    
    nom_activo	            VARCHAR                       NOT NULL       CHECK (LENGTH(nom_activo) <255),                                    --nombre de el activo
    tip_activo	            BOOLEAN                       NOT NULL,      -- True = tangible     AND     false = intangible                   --tipo de activo 
    val_inicial         	DECIMAL   (8,0)               NOT NULL       CHECK (val_inicial >=0  AND val_inicial <=99999999),                --valor inicial del activo
    val_contable	        DECIMAL   (8,0)               NOT NULL       CHECK (val_contable >=0  AND val_contable <=99999999),              --valor contable del activo
    val_residual	        DECIMAL   (8,0)               NOT NULL       CHECK (val_residual >=0  AND val_residual <=99999999),              --valor residual del activo
    ubicacion	            VARCHAR                       NOT NULL       CHECK (LENGTH (ubicacion) <=100),                                   --ubicación de el activo
    datos_audit           AUDIT_TRAIL,                                                                                                       --pista de auditoría
    PRIMARY KEY (id_activo)
);

--**************************
--** TABLA DE INDICADORES **
--**************************

CREATE TABLE IF NOT EXISTS tab_indicadores
(
    id_ind	                VARCHAR                       NOT NULL       CHECK (LENGTH (id_ind) <=50),                                              --identificador del indicador
    id_activo	            VARCHAR                       NOT NULL       CHECK (LENGTH (id_activo) >=0 AND LENGTH (id_activo) <=100),               --identificador del activo
    descripcion	            TEXT                          NOT NULL,                                                                                 --descripción del activo
    tipo	                VARCHAR                       NOT NULL       CHECK (tipo IN ('Rentabilidad','Liquidez','Endeudamiento','Rotación')),    --tipo de activo
    formula	                VARCHAR                       NOT NULL       CHECK (LENGTH(formula) <=255),                                             --formula para calcular el activo
    lim_alerta	            DECIMAL(2,0)                  NOT NULL       CHECK (lim_alerta BETWEEN 0 AND 99),                                       --limite de alerta del activo
    datos_audit           AUDIT_TRAIL,                                                                                                              --pista de auditoría
    PRIMARY KEY (id_ind),
    FOREIGN KEY (id_activo)    REFERENCES tab_activos_fijos(id_activo)
);

-- ********************************************************
--** TABLA GENERAL DE CATEGORÍAS DE TERCEROS DEL SISTEMA **
--*********************************************************

-- ESTA TABLA PERMITE LA CARACTERIZACIÓN DE LOS TERCEROS EN TODO EL SISTEMA.	
		
CREATE TABLE IF NOT EXISTS  tab_cat_terceros			
(			
 id_cat_tercero     DECIMAL  (2,0)  NOT NULL,	                                       --identificador de la caracterización del terrcero	
 nom_cat_tercero    VARCHAR         NOT NULL,			                               --nombre de la caracterización del tercero
 datos_audit        audit_trail,			                                           --pista de auditoría
 PRIMARY KEY(id_cat_tercero)			
);			
--INSERT INTO tab_cat_terceros VALUES(1,'CLIENTE');			
--INSERT INTO tab_cat_terceros VALUES(2,'VENDEDOR');			
--INSERT INTO tab_cat_terceros VALUES(3,'EMPLEADO');			
--INSERT INTO tab_cat_terceros VALUES(4,'LEAD');			
--INSERT INTO tab_cat_terceros VALUES(5,'PROVEDOR');	


--******************************************************************************
--** TABLA DE RESTRICCIONES DE LOS TERCEROS, QUE IMPIDEN SU ACCESO AL SISTEMA **
--******************************************************************************			
	
CREATE TABLE IF NOT EXISTS tab_restricciones			
(			
  id_restriccion      DECIMAL (2,0)     NOT NULL,	                                   --identificador de la restricción
  nom_restriccion     VARCHAR           NOT NULL,			                           --nombre de la restricción
  datos_audit         audit_trail,			                                           --pista de auditoría
  PRIMARY KEY(id_restriccion)			
);			
--INSERT INTO tab_restricciones VALUES(1,'Finalización Contrato Mutuo Acuerdo');			
--INSERT INTO tab_restricciones VALUES(2,'Vacaciones Colectivas');			
--INSERT INTO tab_restricciones VALUES(3,'Inhabilidad Legal');			
--INSERT INTO tab_restricciones VALUES(4,'Restricción Día Festivo');	


--***********************
--** TABLA DE TERCEROS **
--***********************

CREATE TABLE IF NOT EXISTS tab_terceros
(
    id_tercero	            VARCHAR                        NOT NULL       CHECK (LENGTH (id_tercero) =10),                                        --identificación del tecero
    id_cat_tercero          DECIMAL  (2,0)                 NOT NULL,                                                                              --identificador de la caracterización del tercero
    id_restriccion          DECIMAL  (2,0)                 NOT NULL,                                                                              --identificador de la restricción del tercero
    id_ciudad               VARCHAR                        NOT NULL       CHECK   (LENGTH (id_ciudad) =5),                                        --identificación de la ciudad
    ind_tipo_tercero        BOOLEAN                        NOT NULL,      --TRUE:Jurídica / FALSE:Natural	                                      --indicador del tipo de tercero
    fec_nacimiento	        DATE                           NOT NULL,                                                                              --fecha de nacimiento del tercero
    nom_tercero	            VARCHAR                        NOT NULL       CHECK (LENGTH (nom_tercero) >=30  AND LENGTH(nom_tercero) <=60),        --nombre de el tercero
    tel_tercero	            DECIMAL  (10,0)                NOT NULL       CHECK (tel_tercero >=0 ),                                               --telefono de el tercero
    mail_tercero	        VARCHAR                        NOT NULL       CHECK (LENGTH(mail_tercero)<=100),                                      --correo electrónico del tercero
    direc_tercero	        VARCHAR                        NOT NULL       CHECK (LENGTH(direc_tercero) >=4  AND LENGTH(direc_tercero) <=80),      --dirección del tercero
    val_lat         	    DECIMAL	 (9,6)                 NOT NULL       CHECK (val_lat  BETWEEN -4 AND 12),                                     --valor de la latitud del tercero
    val_long        	    DECIMAL	 (9,6)                 NOT NULL       CHECK (val_long BETWEEN -80   AND -67),                                 --valor de la longitud del tercero
    datos_audit             AUDIT_TRAIL,                                                                                                          --pista de auditoría
    PRIMARY KEY (id_tercero),
    FOREIGN KEY(id_ciudad)          REFERENCES tab_ciudades(id_ciudad),			
    FOREIGN KEY(id_cat_tercero)     REFERENCES tab_cat_terceros(id_cat_tercero),			
    FOREIGN KEY(id_restriccion)     REFERENCES tab_restricciones(id_restriccion)

);

--**********************************
--** TABLA DE VALOR DEL INDICADOR **
--**********************************

CREATE TABLE IF NOT EXISTS tab_val_ind
(
    id_val_ind	            VARCHAR                        NOT NULL       CHECK (LENGTH (id_val_ind) >=0            AND     LENGTH (id_val_ind) <=100 ) ,        --identificador del valor del indicador
    id_pmtro_financiero	    VARCHAR                        NOT NULL       CHECK (LENGTH(id_pmtro_financiero)>=0     AND     LENGTH(id_pmtro_financiero)<=20),    --identificador del parámetro financiero
    id_ind	                VARCHAR                        NOT NULL       CHECK (LENGTH (id_ind) <=50),                                                          --identificador del indicador
    val_calculado	        DECIMAL  (10,2)                NOT NULL       CHECK (val_calculado >=0),                                                             --valor calculado del indicador
    fec_calculo	            DATE                           NOT NULL,      --CHECK ( <> NOW()),                                                                   --fecha del calculo del indicador
    datos_audit           AUDIT_TRAIL,                                                                                                                           --pista de auditoría
    PRIMARY KEY (id_val_ind),
    FOREIGN KEY (id_pmtro_financiero)     REFERENCES tab_pmtros_financieros(id_pmtro_financiero),
    FOREIGN KEY (id_ind)                  REFERENCES tab_indicadores(id_ind)
);
