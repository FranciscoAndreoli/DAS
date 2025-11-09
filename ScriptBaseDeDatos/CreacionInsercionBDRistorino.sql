/* 1. PROVINCIAS */
CREATE TABLE Provincias (
    cod_provincia   INT          NOT NULL,
    nom_provincia   VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Provincias PRIMARY KEY (cod_provincia)
);

/* 2. LOCALIDADES */
CREATE TABLE Localidades (
    nro_localidad  INT           NOT NULL,
    nom_localidad  VARCHAR(120)  NOT NULL,
    cod_provincia  INT           NOT NULL,
    CONSTRAINT PK_Localidades PRIMARY KEY (nro_localidad),
    -- AK1: una localidad no se repite dentro de una provincia
    CONSTRAINT UQ_Localidades_Prov_Loc UNIQUE (cod_provincia, nom_localidad),
    CONSTRAINT FK_Localidades_Provincias
        FOREIGN KEY (cod_provincia) REFERENCES Provincias(cod_provincia)
);

/* 3. RESTAURANTES */
CREATE TABLE Restaurantes (
    nro_restaurante INT           NOT NULL,
    razon_social    VARCHAR(150)  NOT NULL,
    cuit            VARCHAR(20)   NOT NULL,
    CONSTRAINT PK_Restaurantes PRIMARY KEY (nro_restaurante),
    CONSTRAINT UQ_Restaurantes_CUIT UNIQUE (cuit)
);

/* 4. ATRIBUTOS (para configuracion_restaurantes) */
CREATE TABLE Atributos (
    cod_atributo  INT           NOT NULL,
    nom_atributo  VARCHAR(100)  NOT NULL,
    tipo_dato     VARCHAR(50)   NOT NULL,
    CONSTRAINT PK_Atributos PRIMARY KEY (cod_atributo)
);

/* 5. CONFIGURACION_RESTAURANTES */
CREATE TABLE Configuracion_Restaurantes (
    nro_restaurante INT          NOT NULL,
    cod_atributo    INT          NOT NULL,
    valor           VARCHAR(500) NULL,
    CONSTRAINT PK_Configuracion_Restaurantes PRIMARY KEY (nro_restaurante, cod_atributo),
    CONSTRAINT FK_CR_Restaurantes
        FOREIGN KEY (nro_restaurante) REFERENCES Restaurantes(nro_restaurante),
    CONSTRAINT FK_CR_Atributos
        FOREIGN KEY (cod_atributo) REFERENCES Atributos(cod_atributo)
);

/* 6. CATEGORIAS_PREFERENCIAS */
CREATE TABLE Categorias_Preferencias (
    cod_categoria  INT           NOT NULL,
    nom_categoria  VARCHAR(120)  NOT NULL,
    CONSTRAINT PK_Categorias_Preferencias PRIMARY KEY (cod_categoria)
);

/* 7. IDIOMAS */
CREATE TABLE Idiomas (
    nro_idioma  INT           NOT NULL,
    nom_idioma  VARCHAR(100)  NOT NULL,
    cod_idioma  VARCHAR(10)   NOT NULL,
    CONSTRAINT PK_Idiomas PRIMARY KEY (nro_idioma),
    CONSTRAINT UQ_Idiomas_Cod UNIQUE (cod_idioma)
);

/* 8. SUCURSALES_RESTAURANTES */
CREATE TABLE Sucursales_Restaurantes (
    nro_restaurante        INT           NOT NULL,
    nro_sucursal           INT           NOT NULL,
    nom_sucursal           VARCHAR(150)  NOT NULL,
    calle                  VARCHAR(150)  NULL,
    nro_calle              INT           NULL,
    barrio                 VARCHAR(100)  NULL,
    nro_localidad          INT           NOT NULL,
    cod_postal             VARCHAR(15)   NULL,
    telefonos              VARCHAR(100)  NULL,
    total_comensales       INT           NULL,
    min_tolerencia_reserva INT           NULL,
    cod_sucursal_restaurante VARCHAR(50) NULL,
    CONSTRAINT PK_Sucursales_Restaurantes PRIMARY KEY (nro_restaurante, nro_sucursal),
    -- AK mencionada en el DER: (nro_restaurante, cod_sucursal_restaurante)
    CONSTRAINT UQ_Sucursales_Rest_Cod UNIQUE (nro_restaurante, cod_sucursal_restaurante),
    CONSTRAINT FK_SR_Restaurantes
        FOREIGN KEY (nro_restaurante) REFERENCES Restaurantes(nro_restaurante),
    CONSTRAINT FK_SR_Localidades
        FOREIGN KEY (nro_localidad) REFERENCES Localidades(nro_localidad)
);

/* 9. IDIOMAS_CATEGORIAS_PREFERENCIAS */
CREATE TABLE Idiomas_Categorias_Preferencias (
    cod_categoria  INT           NOT NULL,
    nro_idioma     INT           NOT NULL,
    categoria      VARCHAR(120)  NULL,
    desc_categoria VARCHAR(300)  NULL,
    CONSTRAINT PK_Idiomas_Cat_Pref PRIMARY KEY (cod_categoria, nro_idioma),
    CONSTRAINT FK_ICP_Categorias
        FOREIGN KEY (cod_categoria) REFERENCES Categorias_Preferencias(cod_categoria),
    CONSTRAINT FK_ICP_Idiomas
        FOREIGN KEY (nro_idioma) REFERENCES Idiomas(nro_idioma)
);

/* 10. CLIENTES */
CREATE TABLE Clientes (
    nro_cliente   INT           NOT NULL,
    apellido      VARCHAR(100)  NOT NULL,
    nombre        VARCHAR(100)  NOT NULL,
    clave         VARCHAR(200)  NOT NULL,
    correo        VARCHAR(150)  NOT NULL,
    telefonos     VARCHAR(100)  NULL,
    nro_localidad INT           NOT NULL,
    habilitado    BIT           NOT NULL DEFAULT 1,
    CONSTRAINT PK_Clientes PRIMARY KEY (nro_cliente),
    CONSTRAINT UQ_Clientes_Correo UNIQUE (correo),
    CONSTRAINT FK_Clientes_Localidades
        FOREIGN KEY (nro_localidad) REFERENCES Localidades(nro_localidad)
);

/* 11. DOMINIO_CATEGORIAS_PREFERENCIAS */
CREATE TABLE Dominio_Categorias_Preferencias (
    cod_categoria     INT           NOT NULL,
    nro_valor_dominio INT           NOT NULL,
    nom_valor_dominio VARCHAR(150)  NOT NULL,
    CONSTRAINT PK_Dominio_Cat_Pref PRIMARY KEY (cod_categoria, nro_valor_dominio),
    CONSTRAINT FK_DCP_Categorias
        FOREIGN KEY (cod_categoria) REFERENCES Categorias_Preferencias(cod_categoria)
);

/* 12. IDIOMAS_DOMINIO_CAT_PREFERENCIAS */
CREATE TABLE Idiomas_Dominio_Cat_Preferencias (
    cod_categoria     INT           NOT NULL,
    nro_valor_dominio INT           NOT NULL,
    nro_idioma        INT           NOT NULL,
    valor_dominio     VARCHAR(150)  NULL,
    desc_valor_dominio VARCHAR(300) NULL,
    CONSTRAINT PK_Idiomas_Dominio PRIMARY KEY (cod_categoria, nro_valor_dominio, nro_idioma),
    CONSTRAINT FK_IDCP_Dominio
        FOREIGN KEY (cod_categoria, nro_valor_dominio)
        REFERENCES Dominio_Categorias_Preferencias(cod_categoria, nro_valor_dominio),
    CONSTRAINT FK_IDCP_Idiomas
        FOREIGN KEY (nro_idioma) REFERENCES Idiomas(nro_idioma)
);

/* 13. PREFERENCIAS_CLIENTES */
CREATE TABLE Preferencias_Clientes (
    nro_cliente       INT  NOT NULL,
    cod_categoria     INT  NOT NULL,
    nro_valor_dominio INT  NOT NULL,
    observaciones     VARCHAR(300) NULL,
    CONSTRAINT PK_Preferencias_Clientes PRIMARY KEY (nro_cliente, cod_categoria, nro_valor_dominio),
    CONSTRAINT FK_PC_Clientes
        FOREIGN KEY (nro_cliente) REFERENCES Clientes(nro_cliente),
    CONSTRAINT FK_PC_Categorias
        FOREIGN KEY (cod_categoria) REFERENCES Categorias_Preferencias(cod_categoria),
    CONSTRAINT FK_PC_Dominio
        FOREIGN KEY (cod_categoria, nro_valor_dominio)
        REFERENCES Dominio_Categorias_Preferencias(cod_categoria, nro_valor_dominio)
);

/* 14. PREFERENCIAS_RESTAURANTES */
CREATE TABLE Preferencias_Restaurantes (
    nro_restaurante   INT           NOT NULL,
    cod_categoria     INT           NOT NULL,
    nro_valor_dominio INT           NOT NULL,
    nro_preferencia   INT           NOT NULL,
    observaciones     VARCHAR(300)  NULL,
    nro_sucursal      INT           NULL,  -- el DER muestra FK a sucursal
    CONSTRAINT PK_Preferencias_Restaurantes PRIMARY KEY
        (nro_restaurante, cod_categoria, nro_valor_dominio, nro_preferencia),
    CONSTRAINT FK_PR_Restaurantes
        FOREIGN KEY (nro_restaurante) REFERENCES Restaurantes(nro_restaurante),
    CONSTRAINT FK_PR_Categorias
        FOREIGN KEY (cod_categoria) REFERENCES Categorias_Preferencias(cod_categoria),
    CONSTRAINT FK_PR_Dominio
        FOREIGN KEY (cod_categoria, nro_valor_dominio)
        REFERENCES Dominio_Categorias_Preferencias(cod_categoria, nro_valor_dominio),
    CONSTRAINT FK_PR_Sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES Sucursales_Restaurantes(nro_restaurante, nro_sucursal)
);

/* 15. CONTENIDOS_RESTAURANTES */
CREATE TABLE Contenidos_Restaurantes (
    nro_restaurante        INT            NOT NULL,
    nro_idioma             INT            NOT NULL,
    nro_contenido          INT            NOT NULL,
    nro_sucursal           INT            NULL,
    contenido_promocional  VARCHAR(500)   NULL,
    imagen_promocional     VARCHAR(300)   NULL,
    contenido_a_publicar   VARCHAR(500)   NULL,
    fecha_ini_vigencia     DATE           NULL,
    fecha_fin_vigencia     DATE           NULL,
    costo_click            DECIMAL(10,2)  NULL,
    cod_contenido_restaurante VARCHAR(50) NULL,
    CONSTRAINT PK_Contenidos_Restaurantes PRIMARY KEY
        (nro_restaurante, nro_idioma, nro_contenido),
    CONSTRAINT UQ_Contenidos_Cod UNIQUE (cod_contenido_restaurante),
    CONSTRAINT FK_ContRest_Restaurantes
        FOREIGN KEY (nro_restaurante) REFERENCES Restaurantes(nro_restaurante),
    CONSTRAINT FK_ContRest_Idiomas
        FOREIGN KEY (nro_idioma) REFERENCES Idiomas(nro_idioma),
    CONSTRAINT FK_ContRest_Sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES Sucursales_Restaurantes(nro_restaurante, nro_sucursal)
);

/* 16. TURNOS_SUCURSALES_RESTAURANTES */
CREATE TABLE Turnos_Sucursales_Restaurantes (
    nro_restaurante INT      NOT NULL,
    nro_sucursal    INT      NOT NULL,
    hora_desde      TIME(0)  NOT NULL,
    hora_hasta      TIME(0)  NOT NULL,
    habilitado      BIT      NULL,
    CONSTRAINT PK_Turnos_Sucursales_Rest PRIMARY KEY
        (nro_restaurante, nro_sucursal, hora_desde),
    CONSTRAINT FK_TSR_Sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES Sucursales_Restaurantes(nro_restaurante, nro_sucursal)
);

/* 17. ZONAS_SUCURSALES_RESTAURANTES */
CREATE TABLE Zonas_Sucursales_Restaurantes (
    nro_restaurante INT           NOT NULL,
    nro_sucursal    INT           NOT NULL,
    cod_zona        INT           NOT NULL,
    desc_zona       VARCHAR(200)  NULL,
    cant_comensales INT           NULL,
    permite_menores BIT           NULL,
    habilitada      BIT           NULL,
    CONSTRAINT PK_Zonas_Sucursales_Rest PRIMARY KEY
        (nro_restaurante, nro_sucursal, cod_zona),
    CONSTRAINT FK_ZSR_Sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES Sucursales_Restaurantes(nro_restaurante, nro_sucursal)
);

/* 18. IDIOMAS_ZONAS_SUC_RESTAURANTES */
CREATE TABLE Idiomas_Zonas_Suc_Restaurantes (
    nro_restaurante INT           NOT NULL,
    nro_sucursal    INT           NOT NULL,
    cod_zona        INT           NOT NULL,
    nro_idioma      INT           NOT NULL,
    zona            VARCHAR(150)  NULL,
    desc_zona       VARCHAR(300)  NULL,
    CONSTRAINT PK_Idiomas_Zonas_Suc PRIMARY KEY
        (nro_restaurante, nro_sucursal, cod_zona, nro_idioma),
    CONSTRAINT FK_IZSR_Zonas
        FOREIGN KEY (nro_restaurante, nro_sucursal, cod_zona)
        REFERENCES Zonas_Sucursales_Restaurantes(nro_restaurante, nro_sucursal, cod_zona),
    CONSTRAINT FK_IZSR_Idiomas
        FOREIGN KEY (nro_idioma) REFERENCES Idiomas(nro_idioma)
);

/* 19. ZONAS_TURNOS_SUCURSALES_RESTAURANTES */
CREATE TABLE Zonas_Turnos_Sucursales_Restaurantes (
    nro_restaurante INT      NOT NULL,
    nro_sucursal    INT      NOT NULL,
    cod_zona        INT      NOT NULL,
    hora_desde      TIME(0)  NOT NULL,
    permite_menores BIT      NULL,
    CONSTRAINT PK_Zonas_Turnos PRIMARY KEY
        (nro_restaurante, nro_sucursal, cod_zona, hora_desde),
    CONSTRAINT FK_ZTSR_Zonas
        FOREIGN KEY (nro_restaurante, nro_sucursal, cod_zona)
        REFERENCES Zonas_Sucursales_Restaurantes(nro_restaurante, nro_sucursal, cod_zona),
    CONSTRAINT FK_ZTSR_Turnos
        FOREIGN KEY (nro_restaurante, nro_sucursal, hora_desde)
        REFERENCES Turnos_Sucursales_Restaurantes(nro_restaurante, nro_sucursal, hora_desde)
);

/* 20. ESTADOS_RESERVAS */
CREATE TABLE Estados_Reservas (
    cod_estado  INT           NOT NULL,
    nom_estado  VARCHAR(100)  NOT NULL,
    CONSTRAINT PK_Estados_Reservas PRIMARY KEY (cod_estado)
);

/* 21. IDIOMAS_ESTADOS */
CREATE TABLE Idiomas_Estados (
    cod_estado  INT           NOT NULL,
    nro_idioma  INT           NOT NULL,
    estado      VARCHAR(100)  NULL,
    CONSTRAINT PK_Idiomas_Estados PRIMARY KEY (cod_estado, nro_idioma),
    CONSTRAINT FK_IE_Estados
        FOREIGN KEY (cod_estado) REFERENCES Estados_Reservas(cod_estado),
    CONSTRAINT FK_IE_Idiomas
        FOREIGN KEY (nro_idioma) REFERENCES Idiomas(nro_idioma)
);

/* 22. RESERVAS_RESTAURANTES */
CREATE TABLE Reservas_Restaurantes (
    nro_reserva        INT        NOT NULL,
    nro_cliente        INT        NOT NULL,
    fecha_hora_registro DATETIME  NOT NULL,
    fecha_reserva      DATE       NOT NULL,
    nro_restaurante    INT        NOT NULL,
    nro_sucursal       INT        NOT NULL,
    cod_zona           INT        NOT NULL,
    hora_reserva       TIME(0)    NOT NULL,
    cant_adultos       INT        NOT NULL,
    cant_menores       INT        NULL,
    cod_estado         INT        NOT NULL,
    fecha_cancelacion  DATETIME   NULL,
    costo_reserva      DECIMAL(10,2) NULL,
    cod_reserva_sucursal VARCHAR(50) NULL,
    CONSTRAINT PK_Reservas_Restaurantes PRIMARY KEY (nro_reserva),
    -- AK del DER
    CONSTRAINT UQ_Reservas_Cod_Res_Sucursal UNIQUE (cod_reserva_sucursal),
    CONSTRAINT FK_RR_Clientes
        FOREIGN KEY (nro_cliente) REFERENCES Clientes(nro_cliente),
    CONSTRAINT FK_RR_Sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES Sucursales_Restaurantes(nro_restaurante, nro_sucursal),
    CONSTRAINT FK_RR_Zonas
        FOREIGN KEY (nro_restaurante, nro_sucursal, cod_zona)
        REFERENCES Zonas_Sucursales_Restaurantes(nro_restaurante, nro_sucursal, cod_zona),
    CONSTRAINT FK_RR_Turnos
        FOREIGN KEY (nro_restaurante, nro_sucursal, hora_reserva)
        REFERENCES Turnos_Sucursales_Restaurantes(nro_restaurante, nro_sucursal, hora_desde),
    CONSTRAINT FK_RR_Estados
        FOREIGN KEY (cod_estado) REFERENCES Estados_Reservas(cod_estado)
);

/* 23. PREFERENCIAS_RESERVAS_RESTAURANTES */
CREATE TABLE Preferencias_Reservas_Restaurantes (
    nro_cliente        INT  NOT NULL,
    nro_reserva        INT  NOT NULL,
    nro_restaurante    INT  NOT NULL,
    cod_categoria      INT  NOT NULL,
    nro_valor_dominio  INT  NOT NULL,
    nro_preferencia    INT  NOT NULL,
    observaciones      VARCHAR(300) NULL,
    CONSTRAINT PK_Pref_Reservas_Restaurantes PRIMARY KEY
        (nro_cliente, nro_reserva, nro_restaurante,
         cod_categoria, nro_valor_dominio, nro_preferencia),
    CONSTRAINT FK_PRR_Clientes
        FOREIGN KEY (nro_cliente) REFERENCES Clientes(nro_cliente),
    CONSTRAINT FK_PRR_Reservas
        FOREIGN KEY (nro_reserva) REFERENCES Reservas_Restaurantes(nro_reserva),
    CONSTRAINT FK_PRR_Categorias
        FOREIGN KEY (cod_categoria) REFERENCES Categorias_Preferencias(cod_categoria),
    CONSTRAINT FK_PRR_Dominio
        FOREIGN KEY (cod_categoria, nro_valor_dominio)
        REFERENCES Dominio_Categorias_Preferencias(cod_categoria, nro_valor_dominio),
    CONSTRAINT FK_PRR_Restaurantes
        FOREIGN KEY (nro_restaurante) REFERENCES Restaurantes(nro_restaurante)
);

/* 24. COSTOS */
CREATE TABLE Costos (
    tipo_costo        VARCHAR(50)  NOT NULL,
    fecha_ini_vigencia DATE        NOT NULL,
    fecha_fin_vigencia DATE        NULL,
    monto             DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_Costos PRIMARY KEY (tipo_costo, fecha_ini_vigencia)
);

/* 25. CLICKS_CONTENIDOS_RESTAURANTES */
CREATE TABLE Clicks_Contenidos_Restaurantes (
    nro_restaurante   INT        NOT NULL,
    nro_idioma        INT        NOT NULL,
    nro_contenido     INT        NOT NULL,
    nro_click         INT        NOT NULL,
    fecha_hora_registro DATETIME NOT NULL,
    nro_cliente       INT        NULL,
    costo_click       DECIMAL(10,2) NULL,
    notificado        BIT        NULL,
    CONSTRAINT PK_Clicks_Contenidos_Restau PRIMARY KEY
        (nro_restaurante, nro_idioma, nro_contenido, nro_click),
    CONSTRAINT FK_CCR_Contenidos
        FOREIGN KEY (nro_restaurante, nro_idioma, nro_contenido)
        REFERENCES Contenidos_Restaurantes(nro_restaurante, nro_idioma, nro_contenido),
    CONSTRAINT FK_CCR_Clientes
        FOREIGN KEY (nro_cliente) REFERENCES Clientes(nro_cliente)
);

/* =========================================================
   1) PROVINCIAS (mismas que la BD anterior)
   ========================================================= */
INSERT INTO Provincias (cod_provincia, nom_provincia) VALUES
(1,  'Buenos Aires'),
(2,  'Catamarca'),
(3,  'Chaco'),
(4,  'Chubut'),
(5,  'Córdoba'),
(6,  'Corrientes'),
(7,  'Entre Ríos'),
(8,  'Formosa'),
(9,  'Jujuy'),
(10, 'La Pampa'),
(11, 'La Rioja'),
(12, 'Mendoza'),
(13, 'Misiones'),
(14, 'Neuquén'),
(15, 'Río Negro'),
(16, 'Salta'),
(17, 'San Juan'),
(18, 'San Luis'),
(19, 'Santa Cruz'),
(20, 'Santa Fe'),
(21, 'Santiago del Estero'),
(22, 'Tierra del Fuego, Antártida e Islas del Atlántico Sur'),
(23, 'Tucumán'),
(24, 'Ciudad Autónoma de Buenos Aires');

/* =========================================================
   2) LOCALIDADES (una por provincia, mismos IDs)
   ========================================================= */
INSERT INTO Localidades (nro_localidad, nom_localidad, cod_provincia) VALUES
(1,  'La Plata',                                 1),
(2,  'San Fernando del Valle de Catamarca',      2),
(3,  'Resistencia',                              3),
(4,  'Rawson',                                   4),
(5,  'Córdoba',                                  5),
(6,  'Corrientes',                               6),
(7,  'Paraná',                                   7),
(8,  'Formosa',                                  8),
(9,  'San Salvador de Jujuy',                    9),
(10, 'Santa Rosa',                               10),
(11, 'La Rioja',                                 11),
(12, 'Mendoza',                                  12),
(13, 'Posadas',                                  13),
(14, 'Neuquén',                                  14),
(15, 'Viedma',                                   15),
(16, 'Salta',                                    16),
(17, 'San Juan',                                 17),
(18, 'San Luis',                                 18),
(19, 'Río Gallegos',                             19),
(20, 'Santa Fe',                                 20),
(21, 'Santiago del Estero',                      21),
(22, 'Ushuaia',                                  22),
(23, 'San Miguel de Tucumán',                    23),
(24, 'Ciudad Autónoma de Buenos Aires',          24);

/* =========================================================
   3) RESTAURANTES (mismo que en la otra BD)
   ========================================================= */
INSERT INTO Restaurantes (nro_restaurante, razon_social, cuit)
VALUES (1, 'Resto Bar', '30-12345678-9');

/* =========================================================
   4) ATRIBUTOS (para configuración) - mínimos
   ========================================================= */
INSERT INTO Atributos (cod_atributo, nom_atributo, tipo_dato) VALUES
(1, 'TiempoMaximoReservaMin', 'INT'),
(2, 'MonedaPorDefecto', 'VARCHAR');

/* =========================================================
   5) CONFIGURACION_RESTAURANTES (para el Resto Bar)
   ========================================================= */
INSERT INTO Configuracion_Restaurantes (nro_restaurante, cod_atributo, valor) VALUES
(1, 1, '30'),        -- 30 minutos tolerancia
(1, 2, 'ARS');       -- pesos argentinos

/* =========================================================
   6) CATEGORIAS_PREFERENCIAS (al menos 2)
   ========================================================= */
INSERT INTO Categorias_Preferencias (cod_categoria, nom_categoria) VALUES
(1, 'Tipo de mesa'),
(2, 'Preferencia alimentaria');

/* =========================================================
   7) IDIOMAS (solo español e inglés)
   ========================================================= */
INSERT INTO Idiomas (nro_idioma, nom_idioma, cod_idioma) VALUES
(1, 'Español', 'es-AR'),
(2, 'Inglés',  'en-US');

/* =========================================================
   8) SUCURSALES_RESTAURANTES
   Deben reflejar las sucursales de la primera BD
   ========================================================= */
INSERT INTO Sucursales_Restaurantes (
    nro_restaurante, nro_sucursal, nom_sucursal,
    calle, nro_calle, barrio, nro_localidad,
    cod_postal, telefonos, total_comensales,
    min_tolerencia_reserva, cod_sucursal_restaurante
) VALUES
(1, 1, 'Resto Bar Centro', 'Av. Principal', 100, 'Microcentro', 24,
 '1000', '11-1234-5678', 80, 15, 'SR-001'),
(1, 2, 'Resto Bar Provincia', 'Calle 50', 500, 'La Plata', 1,
 '1900', '221-444-5555', 60, 15, 'SR-002');

/* =========================================================
   9) IDIOMAS_CATEGORIAS_PREFERENCIAS
   Etiquetas por idioma
   ========================================================= */
INSERT INTO Idiomas_Categorias_Preferencias (cod_categoria, nro_idioma, categoria, desc_categoria) VALUES
(1, 1, 'Tipo de mesa', 'Ubicación o zona preferida dentro del local'),
(1, 2, 'Table type',   'Preferred area or section inside the restaurant'),
(2, 1, 'Preferencia alimentaria', 'Restricciones o gustos del comensal'),
(2, 2, 'Food preference',          'Guest dietary restrictions or likes');

/* =========================================================
   10) DOMINIO_CATEGORIAS_PREFERENCIAS
   (valores concretos para cada categoría)
   ========================================================= */
INSERT INTO Dominio_Categorias_Preferencias (cod_categoria, nro_valor_dominio, nom_valor_dominio) VALUES
-- para Tipo de mesa
(1, 1, 'Salón'),
(1, 2, 'Terraza'),
-- para Preferencia alimentaria
(2, 1, 'Celíaco'),
(2, 2, 'Vegetariano');

/* =========================================================
   11) IDIOMAS_DOMINIO_CAT_PREFERENCIAS
   ========================================================= */
INSERT INTO Idiomas_Dominio_Cat_Preferencias (
    cod_categoria, nro_valor_dominio, nro_idioma,
    valor_dominio, desc_valor_dominio
) VALUES
-- cat 1: tipo de mesa
(1, 1, 1, 'Salón',   'Sector interno'),
(1, 1, 2, 'Dining room', 'Indoor area'),
(1, 2, 1, 'Terraza', 'Sector al aire libre'),
(1, 2, 2, 'Terrace', 'Outdoor area'),
-- cat 2: preferencia alimentaria
(2, 1, 1, 'Celíaco', 'Sin TACC'),
(2, 1, 2, 'Celiac',  'Gluten free'),
(2, 2, 1, 'Vegetariano', 'Sin carnes'),
(2, 2, 2, 'Vegetarian',  'No meat');

/* =========================================================
   12) PREFERENCIAS_RESTAURANTES
   El restaurante declara que ofrece algunas de esas
   ========================================================= */
INSERT INTO Preferencias_Restaurantes (
    nro_restaurante, cod_categoria, nro_valor_dominio,
    nro_preferencia, observaciones, nro_sucursal
) VALUES
-- Resto Bar Centro ofrece salón
(1, 1, 1, 1, 'Salón principal disponible', 1),
-- Resto Bar Centro ofrece terraza
(1, 1, 2, 1, 'Terraza abierta en verano', 1),
-- Resto Bar Provincia ofrece salón
(1, 1, 1, 2, 'Salón amplio', 2),
-- Preferencia alimentaria: celíaco
(1, 2, 1, 1, 'Menú apto celíacos bajo reserva', 1);

/* =========================================================
   13) CONTENIDOS_RESTAURANTES
   ========================================================= */
INSERT INTO Contenidos_Restaurantes (
    nro_restaurante, nro_idioma, nro_contenido, nro_sucursal,
    contenido_promocional, imagen_promocional,
    contenido_a_publicar, fecha_ini_vigencia, fecha_fin_vigencia,
    costo_click, cod_contenido_restaurante
) VALUES
-- Español
(1, 1, 1, 1,
 'Promo almuerzo ejecutivo $9.900',
 'https://www.pexels.com/es-es/foto/comida-cena-almuerzo-filete-7613568',
 'Promo almuerzo ejecutivo $9.900',
 GETDATE(), DATEADD(DAY, 30, GETDATE()),
 50.00, 'RB-ES-0001'),
(1, 1, 2, 1,
 '2x1 en tragos de 19 a 21 hs',
 'https://www.pexels.com/es-es/foto/comida-vegetales-verduras-madera-7772201/',
 '2x1 en tragos de 19 a 21 hs',
 GETDATE(), DATEADD(DAY, 30, GETDATE()),
 70.00, 'RB-ES-0002'),
(1, 2, 1, 1,
 'Executive lunch promo $9,900',
 'https://www.pexels.com/es-es/foto/comida-vegetales-verduras-madera-7772201/',
 'Executive lunch promo $9,900',
 GETDATE(), DATEADD(DAY, 30, GETDATE()),
 50.00, 'RB-EN-0001'),
(1, 2, 2, 1,
 '2x1 drinks from 7pm to 9pm',
 'https://www.pexels.com/es-es/foto/comida-vegetales-verduras-madera-7772201/',
 '2x1 drinks from 7pm to 9pm',
 GETDATE(), DATEADD(DAY, 30, GETDATE()),
 70.00, 'RB-EN-0002');

/* =========================================================
   14) TURNOS_SUCURSALES_RESTAURANTES
   ========================================================= */
INSERT INTO Turnos_Sucursales_Restaurantes (
    nro_restaurante, nro_sucursal, hora_desde, hora_hasta, habilitado
) VALUES
(1, 1, '12:00', '15:00', 1),
(1, 1, '20:00', '23:00', 1),
(1, 2, '12:00', '15:00', 1);

/* =========================================================
   15) ZONAS_SUCURSALES_RESTAURANTES
   ========================================================= */
INSERT INTO Zonas_Sucursales_Restaurantes (
    nro_restaurante, nro_sucursal, cod_zona,
    desc_zona, cant_comensales, permite_menores, habilitada
) VALUES
(1, 1, 1, 'Salón',   50, 1, 1),
(1, 1, 2, 'Terraza', 30, 1, 1),
(1, 2, 1, 'Salón',   60, 1, 1);

/* =========================================================
   16) IDIOMAS_ZONAS_SUC_RESTAURANTES
   etiquetas de zonas en los dos idiomas
   ========================================================= */
INSERT INTO Idiomas_Zonas_Suc_Restaurantes (
    nro_restaurante, nro_sucursal, cod_zona, nro_idioma,
    zona, desc_zona
) VALUES
(1, 1, 1, 1, 'Salón',   'Sector interno'),
(1, 1, 1, 2, 'Dining room', 'Indoor area'),
(1, 1, 2, 1, 'Terraza', 'Sector al aire libre'),
(1, 1, 2, 2, 'Terrace', 'Outdoor area'),
(1, 2, 1, 1, 'Salón',   'Sector interno'),
(1, 2, 1, 2, 'Dining room', 'Indoor area');

/* =========================================================
   17) ZONAS_TURNOS_SUCURSALES_RESTAURANTES
   combinamos zonas con los turnos anteriores
   ========================================================= */
INSERT INTO Zonas_Turnos_Sucursales_Restaurantes (
    nro_restaurante, nro_sucursal, cod_zona, hora_desde, permite_menores
) VALUES
(1, 1, 1, '12:00', 1),
(1, 1, 1, '20:00', 1),
(1, 1, 2, '20:00', 1),
(1, 2, 1, '12:00', 1);

/* =========================================================
   18) ESTADOS_RESERVAS
   (aunque reservas estarán vacías, cargamos catálogo)
   ========================================================= */
INSERT INTO Estados_Reservas (cod_estado, nom_estado) VALUES
(1, 'Pendiente'),
(2, 'Confirmada'),
(3, 'Cancelada');

/* =========================================================
   19) IDIOMAS_ESTADOS
   ========================================================= */
INSERT INTO Idiomas_Estados (cod_estado, nro_idioma, estado) VALUES
(1, 1, 'Pendiente'),
(1, 2, 'Pending'),
(2, 1, 'Confirmada'),
(2, 2, 'Confirmed'),
(3, 1, 'Cancelada'),
(3, 2, 'Canceled');

/* =========================================================
   20) COSTOS
   ========================================================= */
INSERT INTO Costos (tipo_costo, fecha_ini_vigencia, fecha_fin_vigencia, monto) VALUES
('CLICK_PROMO', CAST(GETDATE() AS DATE), NULL, 50.00),
('RESERVA',     CAST(GETDATE() AS DATE), NULL,  0.00);

/* =========================================================
   21) CLIENTES
   (queda vacío)

/* =========================================================
   22) RESERVAS_RESTAURANTES
   (queda vacío)

/* =========================================================
   23) CLICKS_CONTENIDOS_RESTAURANTES
   (queda vacío)

/* =========================================================
   24) PREFERENCIAS_CLIENTES
   (clientes está vacío)

/* =========================================================
   25) PREFERENCIAS_RESERVAS_RESTAURANTES
   (reservas vacía)

