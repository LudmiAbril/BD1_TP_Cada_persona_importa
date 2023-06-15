/*
i. Top 10 de tratamientos con más de 10 efectos adversos.
ii. Cantidad de personas con algún tratamiento diagnóstico que no haya confirmado el
diagnóstico.
iii. ¿Cuántas personas ha habido que hayan tenido la mayor cantidad de efectos
adversos de algún tratamiento de vacunación?
iv. ¿Cuántas muertes ocurrieron relacionadas con vacunas, agrupando por vacuna,
durante los años 2021 al 2023?
v. ¿Cuántas muertes de recién nacidos se pueden relacionar a medicamentos
administrados a la madre? Si el modelo realizado no permite contestar esta
pregunta, modificarlo para poder hacerlo.
vi. Formulen una consulta que permita a un profesional médico descartar un
tratamiento en niños por ser el riesgo mayor al beneficio. ¿Qué otra información
guardarían para realizar esta comparación? Incluirla en el modelo completo.
vii. Mostrar todos los tratamientos de bajo riesgo practicados a personas con al menos 2
(dos) patologías preexistentes y que sean adultos mayores.
viii. Formular una consulta que Uds. Le harían a la app para saber si realizarse un
tratamiento.
ix. Destacar aquellos tratamientos letales, por causar efectos severos, por rango etario,
considerando 0 años, 1-5 años, 6-12 años, 13-17 años, 18 a 25 años, 26-40 años, 41-
50 años, 51-70 años, 71-90 años, 91 o más años.
*/

-- Modelado

/*




Creacion de database





*/

create database if not exists cada_persona_importa_bd;
use cada_persona_importa_bd;

/*





Creacion de tablas e inserción de datos





*/

CREATE TABLE Persona (
    CUIL BIGINT,
    DNI BIGINT,
    CONSTRAINT Persona_PK PRIMARY KEY (CUIL , DNI)
);

CREATE TABLE Evento (
    cod INT PRIMARY KEY,
    descripcion VARCHAR(35)
);

CREATE TABLE Profesional (
    nombre VARCHAR(15),
    apellido VARCHAR(15),
    email VARCHAR(25),
    celular BIGINT,
    dir_postal VARCHAR(40),
    mat_nacional BIGINT,
    mat_provincial BIGINT,
    CONSTRAINT Profesional_PK PRIMARY KEY (mat_nacional , mat_provincial)
);

CREATE TABLE Tratamiento (
    cod_nomenclador INT PRIMARY KEY,
    descripcion VARCHAR(50),
    es_invasivo BOOLEAN,
    parte_cuerpo_aplicacion VARCHAR(30)
);

CREATE TABLE Centro_salud (
    nro INT PRIMARY KEY,
    nombre VARCHAR(15)
);

CREATE TABLE Diag (
    cod_uni INT PRIMARY KEY,
    descripcion VARCHAR(50)
);

CREATE TABLE Contraindicaciones (
    id INT PRIMARY KEY,
    descripcion VARCHAR(50)
);

CREATE TABLE Tipo_efecto (
    nro INT PRIMARY KEY,
    nombre VARCHAR(35)
);

CREATE TABLE Especialidad (
    cod INT PRIMARY KEY,
    descripcion VARCHAR(35),
    mat_nacional BIGINT,
    mat_provincial BIGINT,
    CONSTRAINT Profesional_PK FOREIGN KEY (mat_nacional , mat_provincial)
        REFERENCES Profesional (mat_nacional , mat_provincial)
);

CREATE TABLE Tipo_trat (
    nro INT PRIMARY KEY,
    nombre VARCHAR(35),
    cod_nomenclador INT,
    CONSTRAINT cod_nomenclador_fk FOREIGN KEY (cod_nomenclador)
        REFERENCES Tratamiento (cod_nomenclador)
);

CREATE TABLE Prac_quirurgica (
    cod_nomenclador INT PRIMARY KEY,
    fue_exitoso BOOLEAN,
    CONSTRAINT cod_nomenclador_fk_Prac_Qui FOREIGN KEY (cod_nomenclador)
        REFERENCES Tratamiento (cod_nomenclador)
);

CREATE TABLE Prac_diag (
    cod_nomenclador INT PRIMARY KEY,
    confirmacion_diag_presuntivo BOOLEAN,
    cod_uni INT,
    CONSTRAINT cod_uni_fk_Prac_diag FOREIGN KEY (cod_uni)
        REFERENCES Diag (cod_uni)
);

CREATE TABLE Comp_farma (
    cod_nomenclador INT PRIMARY KEY,
    es_natural BOOLEAN,
    composicion_cant INT,
    composicion_farmaco VARCHAR(35),
    f_vencimiento DATE,
    partida DATE,
    nro_lote INT,
    CONSTRAINT cod_nomenclador_fk_Comp_farma FOREIGN KEY (cod_nomenclador)
        REFERENCES Tratamiento (cod_nomenclador)
);

create table Fabricante (
id int, nombre varchar (25), cod_nomenclador INT PRIMARY KEY,
constraint cod_nomenclador_fk_fab foreign key (cod_nomenclador)
        REFERENCES Tratamiento (cod_nomenclador));
        
create table Antecedente(
cod int primary key,
descripcion varchar(30),
 cod_uni INT,
 constraint cod_uni_fk_Ant foreign key (cod_uni) references Diag (cod_uni)
);

create table Efecto_adverso(
cod int primary key, 
nombre varchar(35),
f_ocurrencia date, 
nro_tipo int,
constraint nro_fk_efec_adv foreign key(nro_tipo) references Tipo_efecto (nro)
);

-- ternaria entre persona, diag, antecedente
CREATE TABLE tiene_PDA (
    CUIL BIGINT,
    DNI BIGINT ,
    cod_uni INT,
    cod_ante INT,
    CONSTRAINT CUIL_DNI_cod_uni_cod_ante_pk_tiene_PDA PRIMARY KEY (CUIL, DNI, cod_uni, cod_ante),
    CONSTRAINT CUIL_DNI_fk_tiene_PDA FOREIGN KEY (CUIL , DNI)
        REFERENCES Persona (CUIL , DNI),
    CONSTRAINT cod_uni_fk_tiene_PDA FOREIGN KEY (cod_uni)
        REFERENCES Diag (cod_uni),
    CONSTRAINT cod_ante_fk_tiene_PDA FOREIGN KEY (cod_ante)
        REFERENCES Antecedente (cod)
);

CREATE table Recibe (
CUIL BIGINT,
    DNI BIGINT ,
    mat_nacional BIGINT,
    mat_provincial BIGINT,
    cod_nomenclador INT,
    tiene_profesional boolean,
    CONSTRAINT CUIL_DNI_mat_nacional_mat_provincial_cod_nomenclador_pk_recibe PRIMARY KEY (CUIL, DNI, mat_nacional, mat_provincial, cod_nomenclador),
     CONSTRAINT CUIL_DNI_fk_tiene_PDA FOREIGN KEY (CUIL , DNI)
        REFERENCES Persona (CUIL , DNI),
        CONSTRAINT mat_nacional_mat_provincial_fk_recibe FOREIGN KEY (CUIL , DNI)
        REFERENCES Persona (CUIL , DNI),
   
    );


-- Recibe(CUIL, DOC,  m_prov, m_nac, cod_nomneclador, tiene_profesional)




        

/*create table Tratamiento(
cod_nomenclador int primary key,
descripcion varchar(50),
es_invasivo boolean,
parte_cuerpo_aplicacion varchar(30));*/

/*CREATE TABLE Empleado(
nro_emp int PRIMARY KEY auto_increment, 
nombre char (15) not null, 
cod_esp INT NOT NULL,
nro_jefe int,
sueldo bigint not null, 
f_ingreso date not null,
CONSTRAINT cod_esp_fk FOREIGN KEY (cod_esp) REFERENCES Especialidad(cod_esp), 
constraint nro_jefe_fk foreign key (nro_jefe) references Empleado (nro_emp)
);*/



