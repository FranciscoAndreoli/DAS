/* 1. PROVINCIAS */
CREATE TABLE Provincias (
    cod_provincia      INT           NOT NULL,
    nom_provincia      VARCHAR(100)  NOT NULL,
    CONSTRAINT PK_Provincias PRIMARY KEY (cod_provincia)
);

/* 2. LOCALIDADES */
CREATE TABLE Localidades (
    nro_localidad  INT           NOT NULL,
    nom_localidad  VARCHAR(120)  NOT NULL,
    cod_provincia  INT           NOT NULL,
    CONSTRAINT PK_Localidades PRIMARY KEY (nro_localidad),
    -- AK1.1 + AK1.2: una localidad no se repite dentro de la misma provincia
    CONSTRAINT UQ_Localidades_Prov_Loc UNIQUE (cod_provincia, nom_localidad),
    CONSTRAINT FK_Localidades_Provincias
        FOREIGN KEY (cod_provincia) REFERENCES Provincias(cod_provincia)
);

/* 3. RESTAURANTES */
CREATE TABLE Restaurantes (
    nro_restaurante  INT           NOT NULL,
    razon_social     VARCHAR(150)  NOT NULL,
    cuit             VARCHAR(20)   NOT NULL,
    CONSTRAINT PK_Restaurantes PRIMARY KEY (nro_restaurante),
    CONSTRAINT UQ_Restaurantes_CUIT UNIQUE (cuit)
);

/* 4. CATEGORIAS_PRECIOS */
CREATE TABLE Categorias_Precios (
    nro_categoria  INT           NOT NULL,
    nom_categoria  VARCHAR(100)  NOT NULL,
    CONSTRAINT PK_Categorias_Precios PRIMARY KEY (nro_categoria)
);

/* 5. SUCURSALES */
CREATE TABLE Sucursales (
    nro_restaurante   INT           NOT NULL,
    nro_sucursal      INT           NOT NULL,
    nom_sucursal      VARCHAR(150)  NOT NULL,
    calle             VARCHAR(150)  NULL,
    nro_calle         INT           NULL,
    barrio            VARCHAR(100)  NULL,
    nro_localidad     INT           NOT NULL,
    cod_postal        VARCHAR(15)   NULL,
    telefonos         VARCHAR(100)  NULL,
    total_comensales  INT           NULL,
    min_tolerencia_reserva INT      NULL,
    nro_categoria     INT           NOT NULL,
    CONSTRAINT PK_Sucursales PRIMARY KEY (nro_restaurante, nro_sucursal),
    CONSTRAINT FK_Sucursales_Restaurantes
        FOREIGN KEY (nro_restaurante) REFERENCES Restaurantes(nro_restaurante),
    CONSTRAINT FK_Sucursales_Localidades
        FOREIGN KEY (nro_localidad) REFERENCES Localidades(nro_localidad),
    CONSTRAINT FK_Sucursales_Categorias
        FOREIGN KEY (nro_categoria) REFERENCES Categorias_Precios(nro_categoria)
);

/* 6. ZONAS */
CREATE TABLE Zonas (
    cod_zona     INT           NOT NULL,
    nom_zona     VARCHAR(100)  NOT NULL,
    CONSTRAINT PK_Zonas PRIMARY KEY (cod_zona)
);

/* 7. ZONAS_SUCURSALES */
CREATE TABLE Zonas_Sucursales (
    nro_restaurante  INT  NOT NULL,
    nro_sucursal     INT  NOT NULL,
    cod_zona         INT  NOT NULL,
    cant_comensales  INT  NULL,
    permite_menores  BIT  NULL,
    habilitada       BIT  NULL,
    CONSTRAINT PK_Zonas_Sucursales PRIMARY KEY (nro_restaurante, nro_sucursal, cod_zona),
    CONSTRAINT FK_ZS_Sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES Sucursales(nro_restaurante, nro_sucursal),
    CONSTRAINT FK_ZS_Zonas
        FOREIGN KEY (cod_zona) REFERENCES Zonas(cod_zona)
);

/* 8. TURNOS_SUCURSALES */
CREATE TABLE Turnos_Sucursales (
    nro_restaurante  INT       NOT NULL,
    nro_sucursal     INT       NOT NULL,
    hora_desde       TIME(0)   NOT NULL,
    hora_hasta       TIME(0)   NOT NULL,
    habilitado       BIT       NULL,
    CONSTRAINT PK_Turnos_Sucursales PRIMARY KEY (nro_restaurante, nro_sucursal, hora_desde),
    CONSTRAINT FK_TS_Sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES Sucursales(nro_restaurante, nro_sucursal)
);

/* 9. ZONAS_TURNOS_SUCURSALES */
CREATE TABLE Zonas_Turnos_Sucursales (
    nro_restaurante  INT     NOT NULL,
    nro_sucursal     INT     NOT NULL,
    cod_zona         INT     NOT NULL,
    hora_desde       TIME(0) NOT NULL,
    permite_menores  BIT     NULL,
    CONSTRAINT PK_Zonas_Turnos_Sucursales PRIMARY KEY
        (nro_restaurante, nro_sucursal, cod_zona, hora_desde),
    CONSTRAINT FK_ZTS_Zonas_Sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal, cod_zona)
        REFERENCES Zonas_Sucursales(nro_restaurante, nro_sucursal, cod_zona),
    CONSTRAINT FK_ZTS_Turnos_Sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal, hora_desde)
        REFERENCES Turnos_Sucursales(nro_restaurante, nro_sucursal, hora_desde)
);

/* 10. TIPOS_COMIDAS */
CREATE TABLE Tipos_Comidas (
    nro_tipo_comida  INT           NOT NULL,
    nom_tipo_comida  VARCHAR(100)  NOT NULL,
    CONSTRAINT PK_Tipos_Comidas PRIMARY KEY (nro_tipo_comida)
);

/* 11. TIPOS_COMIDAS_SUCURSALES */
CREATE TABLE Tipos_Comidas_Sucursales (
    nro_restaurante  INT  NOT NULL,
    nro_sucursal     INT  NOT NULL,
    nro_tipo_comida  INT  NOT NULL,
    habilitado       BIT  NULL,
    CONSTRAINT PK_Tipos_Comidas_Sucursales PRIMARY KEY
        (nro_restaurante, nro_sucursal, nro_tipo_comida),
    CONSTRAINT FK_TCS_Sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES Sucursales(nro_restaurante, nro_sucursal),
    CONSTRAINT FK_TCS_Tipos_Comidas
        FOREIGN KEY (nro_tipo_comida) REFERENCES Tipos_Comidas(nro_tipo_comida)
);

/* 12. ESPECIALIDADES_ALIMENTARIAS */
CREATE TABLE Especialidades_Alimentarias (
    nro_restriccion  INT           NOT NULL,
    nom_restriccion  VARCHAR(100)  NOT NULL,
    CONSTRAINT PK_Especialidades PRIMARY KEY (nro_restriccion)
);

/* 13. ESPECIALIDADES_ALIMENTARIAS_SUCURSALES */
CREATE TABLE Especialidades_Alimentarias_Sucursales (
    nro_restaurante  INT  NOT NULL,
    nro_sucursal     INT  NOT NULL,
    nro_restriccion  INT  NOT NULL,
    habilitada       BIT  NULL,
    CONSTRAINT PK_EA_Sucursales PRIMARY KEY
        (nro_restaurante, nro_sucursal, nro_restriccion),
    CONSTRAINT FK_EAS_Sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES Sucursales(nro_restaurante, nro_sucursal),
    CONSTRAINT FK_EAS_Especialidades
        FOREIGN KEY (nro_restriccion)
        REFERENCES Especialidades_Alimentarias(nro_restriccion)
);

/* 14. ESTILOS */
CREATE TABLE Estilos (
    nro_estilo  INT           NOT NULL,
    nom_estilo  VARCHAR(100)  NOT NULL,
    CONSTRAINT PK_Estilos PRIMARY KEY (nro_estilo)
);

/* 15. ESTILOS_SUCURSALES */
CREATE TABLE Estilos_Sucursales (
    nro_restaurante  INT  NOT NULL,
    nro_sucursal     INT  NOT NULL,
    nro_estilo       INT  NOT NULL,
    habilitado       BIT  NULL,
    CONSTRAINT PK_Estilos_Sucursales PRIMARY KEY
        (nro_restaurante, nro_sucursal, nro_estilo),
    CONSTRAINT FK_ES_Sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES Sucursales(nro_restaurante, nro_sucursal),
    CONSTRAINT FK_ES_Estilos
        FOREIGN KEY (nro_estilo) REFERENCES Estilos(nro_estilo)
);

/* 16. CLIENTES */
CREATE TABLE Clientes (
    nro_cliente  INT           NOT NULL,
    apellido     VARCHAR(100)  NOT NULL,
    nombre       VARCHAR(100)  NOT NULL,
    correo       VARCHAR(150)  NOT NULL,
    telefonos    VARCHAR(100)  NULL,
    CONSTRAINT PK_Clientes PRIMARY KEY (nro_cliente),
    CONSTRAINT UQ_Clientes_Correo UNIQUE (correo)
);

/* 17. CONTENIDOS */
CREATE TABLE Contenidos (
    nro_restaurante     INT            NOT NULL,
    nro_contenido       INT            NOT NULL,
    contenido_a_publicar VARCHAR(500)  NOT NULL,
    imagen_a_publicar    VARCHAR(300)  NULL,
    publicado            BIT           NULL,
    costo_click          DECIMAL(10,2) NULL,
    nro_sucursal         INT           NULL,
    CONSTRAINT PK_Contenidos PRIMARY KEY (nro_restaurante, nro_contenido),
    CONSTRAINT FK_Contenidos_Restaurantes
        FOREIGN KEY (nro_restaurante) REFERENCES Restaurantes(nro_restaurante),
    CONSTRAINT FK_Contenidos_Sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES Sucursales(nro_restaurante, nro_sucursal)
);

/* 18. RESERVAS_SUCURSALES */
CREATE TABLE Reservas_Sucursales (
    cod_reserva        INT        NOT NULL,
    fecha_hora_registro DATETIME  NOT NULL,
    nro_cliente        INT        NOT NULL,
    fecha_reserva      DATE       NOT NULL,
    nro_restaurante    INT        NOT NULL,
    nro_sucursal       INT        NOT NULL,
    cod_zona           INT        NOT NULL,
    hora_reserva       TIME(0)    NOT NULL,
    cant_adultos       INT        NOT NULL,
    cant_menores       INT        NULL,
    costo_reserva      DECIMAL(10,2) NULL,
    cancelada          BIT        NULL,
    fecha_cancelacion  DATETIME   NULL,
    CONSTRAINT PK_Reservas_Sucursales PRIMARY KEY (cod_reserva),
    CONSTRAINT FK_RS_Clientes
        FOREIGN KEY (nro_cliente) REFERENCES Clientes(nro_cliente),
    CONSTRAINT FK_RS_Sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal)
        REFERENCES Sucursales(nro_restaurante, nro_sucursal),
    CONSTRAINT FK_RS_Zonas
        FOREIGN KEY (cod_zona) REFERENCES Zonas(cod_zona),
    -- relación con turno específico de esa sucursal
    CONSTRAINT FK_RS_Turnos_Sucursales
        FOREIGN KEY (nro_restaurante, nro_sucursal, hora_reserva)
        REFERENCES Turnos_Sucursales(nro_restaurante, nro_sucursal, hora_desde)
);

/* 19. CLICKS_CONTENIDOS */
CREATE TABLE Clicks_Contenidos (
    nro_restaurante  INT        NOT NULL,
    nro_contenido    INT        NOT NULL,
    nro_click        INT        NOT NULL,
    fecha_hora_registro DATETIME NOT NULL,
    nro_cliente      INT        NULL,
    costo_click      DECIMAL(10,2) NULL,
    CONSTRAINT PK_Clicks_Contenidos PRIMARY KEY
        (nro_restaurante, nro_contenido, nro_click),
    CONSTRAINT FK_CC_Contenidos
        FOREIGN KEY (nro_restaurante, nro_contenido)
        REFERENCES Contenidos(nro_restaurante, nro_contenido),
    CONSTRAINT FK_CC_Clientes
        FOREIGN KEY (nro_cliente) REFERENCES Clientes(nro_cliente)
);

/* =========================
   1) PROVINCIAS (todas)
   ========================= */
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

/* =========================
   2) LOCALIDADES
   una por provincia
   ========================= */
INSERT INTO Localidades (nro_localidad, nom_localidad, cod_provincia) VALUES
(1,  'La Plata',                                 1),  -- Buenos Aires
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

/* =========================
   3) RESTAURANTES
   ========================= */
INSERT INTO Restaurantes (nro_restaurante, razon_social, cuit)
VALUES (1, 'Resto Bar', '30-12345678-9');

/* =========================
   4) CATEGORIAS_PRECIOS
   ========================= */
INSERT INTO Categorias_Precios (nro_categoria, nom_categoria) VALUES
(1, 'Económica'),
(2, 'Media'),
(3, 'Premium');

/* =========================
   5) SUCURSALES (2)
   sucursal 1 en CABA (localidad 24)
   sucursal 2 en Buenos Aires (localidad 1)
   ========================= */
INSERT INTO Sucursales (
    nro_restaurante, nro_sucursal, nom_sucursal,
    calle, nro_calle, barrio, nro_localidad,
    cod_postal, telefonos, total_comensales,
    min_tolerencia_reserva, nro_categoria
) VALUES
(1, 1, 'Resto Bar Centro', 'Av. Principal', 100, 'Microcentro', 24,
 '1000', '11-1234-5678', 80, 15, 2),
(1, 2, 'Resto Bar Provincia', 'Calle 50', 500, 'La Plata', 1,
 '1900', '221-444-5555', 60, 15, 2);

/* =========================
   6) ZONAS
   ========================= */
INSERT INTO Zonas (cod_zona, nom_zona) VALUES
(1, 'Salón'),
(2, 'Terraza');

/* =========================
   7) ZONAS_SUCURSALES
   ========================= */
INSERT INTO Zonas_Sucursales (
    nro_restaurante, nro_sucursal, cod_zona,
    cant_comensales, permite_menores, habilitada
) VALUES
(1, 1, 1, 50, 1, 1),  -- sucursal 1, salón
(1, 1, 2, 30, 1, 1),  -- sucursal 1, terraza
(1, 2, 1, 60, 1, 1);  -- sucursal 2, salón

/* =========================
   8) TURNOS_SUCURSALES
   (dos turnos para sucursal 1 y uno para sucursal 2)
   ========================= */
INSERT INTO Turnos_Sucursales (
    nro_restaurante, nro_sucursal, hora_desde, hora_hasta, habilitado
) VALUES
(1, 1, '12:00', '15:00', 1),
(1, 1, '20:00', '23:00', 1),
(1, 2, '12:00', '15:00', 1);

/* =========================
   9) ZONAS_TURNOS_SUCURSALES
   vinculamos las zonas anteriores con los turnos
   ========================= */
INSERT INTO Zonas_Turnos_Sucursales (
    nro_restaurante, nro_sucursal, cod_zona, hora_desde, permite_menores
) VALUES
(1, 1, 1, '12:00', 1),
(1, 1, 1, '20:00', 1),
(1, 1, 2, '20:00', 1),
(1, 2, 1, '12:00', 1);

/* =========================
   10) TIPOS_COMIDAS
   ========================= */
INSERT INTO Tipos_Comidas (nro_tipo_comida, nom_tipo_comida) VALUES
(1, 'Parrilla'),
(2, 'Pastas'),
(3, 'Vegano');

/* =========================
   11) TIPOS_COMIDAS_SUCURSALES
   ========================= */
INSERT INTO Tipos_Comidas_Sucursales (
    nro_restaurante, nro_sucursal, nro_tipo_comida, habilitado
) VALUES
(1, 1, 1, 1),
(1, 1, 2, 1),
(1, 1, 3, 1),
(1, 2, 1, 1);

/* =========================
   12) ESPECIALIDADES_ALIMENTARIAS
   ========================= */
INSERT INTO Especialidades_Alimentarias (nro_restriccion, nom_restriccion) VALUES
(1, 'Celíacos'),
(2, 'Vegetarianos');

/* =========================
   13) ESPECIALIDADES_ALIMENTARIAS_SUCURSALES
   ========================= */
INSERT INTO Especialidades_Alimentarias_Sucursales (
    nro_restaurante, nro_sucursal, nro_restriccion, habilitada
) VALUES
(1, 1, 1, 1),
(1, 1, 2, 1),
(1, 2, 1, 1);

/* =========================
   14) ESTILOS
   ========================= */
INSERT INTO Estilos (nro_estilo, nom_estilo) VALUES
(1, 'Casual'),
(2, 'Gourmet');

/* =========================
   15) ESTILOS_SUCURSALES
   ========================= */
INSERT INTO Estilos_Sucursales (
    nro_restaurante, nro_sucursal, nro_estilo, habilitado
) VALUES
(1, 1, 1, 1),
(1, 2, 1, 1);

/* =========================
   16) CLIENTES
   (queda vacío)
   ========================= */

/* =========================
   17) CONTENIDOS
   dos promociones del restaurante 1
   ========================= */
INSERT INTO Contenidos (
    nro_restaurante, nro_contenido,
    contenido_a_publicar, imagen_a_publicar,
    publicado, costo_click, nro_sucursal
) VALUES
(1, 1,
 'Promo almuerzo ejecutivo $9.900',
 'https://www.pexels.com/es-es/foto/comida-cena-almuerzo-filete-7613568/',
 1, 10.00, 1),
(1, 2,
 '2x1 en tragos de 19 a 21 hs',
 'https://www.pexels.com/es-es/foto/comida-vegetales-verduras-madera-7772201/',
 1, 10.00, 1);

/* =========================
   18) RESERVAS_SUCURSALES
   (lo dejamos vacío)
   ========================= */
/* =========================
   19) CLICKS_CONTENIDOS
   (vacía)
   ========================= */

