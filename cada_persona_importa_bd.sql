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

-- INSERCION DATOS A PERSONA




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

-- INSERCION DATOS A TRATAMIENTOS

INSERT INTO Tratamiento (cod_nomenclador,descripcion,es_invasivo,parte_cuerpo_Aplicacion)
VALUES
(1,"aspirina",false,"via oral"),
(2,"colocación de DIU, SIU Bajo Anestesia ",true,"utero"),
(3,"vacuna antigripal",true,"músculo deltoide"),
(4,"ibuprofeno",false,"via oral"),
(5,"vacuna para varicela",true,"músculo deltoide"),
(6,"cirugía cataratas",true,"ojos"),
(7,"paracetamol",false,"via oral"),
(8,"artroscopia",true,"articulaciones"),
(9,"metformina",false,"via oral"),
(10,"quimioterapia",true,"cavidad peritoneal"),
(11,"vacuna contra el virus del papiloma humano",false,"músculo deltoide"),
(12,"Desloratadina",false,"via oral");

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

CREATE TABLE Recibe (
    CUIL BIGINT,
    DNI BIGINT,
    mat_nacional BIGINT,
    mat_provincial BIGINT,
    cod_nomenclador INT,
    tiene_profesional BOOLEAN,
    
    PRIMARY KEY (CUIL, DNI, mat_nacional, mat_provincial, cod_nomenclador),
    
    CONSTRAINT CUIL_DNI_fk_tiene_PDA FOREIGN KEY (CUIL, DNI)
        REFERENCES Persona (CUIL, DNI),
        
    CONSTRAINT mat_nacional_mat_provincial_fk_recibe FOREIGN KEY (mat_nacional , mat_provincial)
        REFERENCES profesional (mat_provincial , mat_provincial),
        
    CONSTRAINT cod_nomenclador_fk_recibe FOREIGN KEY (cod_nomenclador)
        REFERENCES tratamiento (cod_nomenclador)
    
    
);

create table Padece (
CUIL BIGINT,
DNI BIGINT,
cod int, 
constraint CUIL_DNI_id_PK_Padece primary key (CUIL, DNI, cod),
constraint CUIL_DNI_FK_Padece foreign key (CUIL, DNI) references Persona (CUIL, DNI),
constraint cod_FK_Padece foreign key (cod) references Evento (cod)
);

create table Puede_Ser (
cod int,
cod_nomenclador int,
 constraint PRIMARY KEY (cod , cod_nomenclador),
 constraint FOREIGN KEY (cod) REFERENCES Evento (cod),
  FOREIGN KEY (cod_nomenclador) REFERENCES Tratamiento (cod_nomenclador)
);

create table Tiene (
id_contra int ,
cod_nomenclador int,
constraint PRIMARY KEY(id_contra, cod_nomenclador),
 constraint FOREIGN KEY (cod_nomenclador) REFERENCES Tratamiento (cod_nomenclador),
 constraint FOREIGN KEY (id_contra) REFERENCES Contraindicaciones (id)
);



create table Produce (
cod_nomenclador INT,
cod int,
constraint cod_nomenclador_cod_PK_produce primary key (cod_nomenclador, cod),
constraint cod_nomenclador_FK_produce foreign key (cod_nomenclador) references Tratamiento (cod_nomenclador)
);

-- Se_realizan.cod_nomneclador -> Tratamiento.cod_nomneclador
-- Se_realizan.nro -> Centro_salud.nro

-- Se_realizan(cod_nomenclador, nro)
create table Se_realizan (
cod_nomenclador INT,
nro INT,
constraint cod_nomenclador_nro_PK_Se_realizan primary key (cod_nomenclador, nro),
constraint cod_nomenclador_FK_Se_realizan foreign key (cod_nomenclador) references Tratamiento (cod_nomenclador),
constraint nro_FK_Se_realizan foreign key (nro) references Centro_salud (nro),

        CONSTRAINT mat_nacional_mat_provincial_fk_recibe FOREIGN KEY (CUIL , DNI)
        REFERENCES Persona (CUIL , DNI)
   
    );


-- Recibe(CUIL, DOC,  m_prov, m_nac, cod_nomneclador, tiene_profesional)


/*





C O N S U L T A S





*/


-- i.

select 
    t.cod_nomenclador,
    t.descripcion,
    count(t.cod_nomeclador) as cantidad_efectos
from
    Tratamiento t
        join
    produce p ON t.cod_nomenclador = p.cod_nomenclador
where
    count(t.cod_nomeclador) > 10
group by t.cod_nomenclador
order by count(t.cod_nomeclador) desc;

-- /*ii. Cantidad de personas con algún tratamiento diagnóstico que no haya confirmado el diagnóstico. */ 
  
SELECT 
    COUNT(P.CUIL)
FROM
    Persona P
Where
    NOT exists( select 
            1
        FROM
            Recibe R
                JOIN
            Tratamiento T ON R.cod_nomenclador = T.cod_nomenclador
                JOIN
            Prac_diag pd ON pd.cod_nomenclador = T.cod_nomenclador
        WHERE
            pd.confirmacion_diag_presuntivo is TRUE
                AND R.CUIL = P.CUIL
                AND R.CUIL = P.CUIL);


-- iii.

select 
    a.DNI, COUNT(a.DNI) as cantidad_efectos_que_tuvo
from
    (select 
        P.DNI, P.CUIL
    from
        Persona P
    join Recibe R ON R.CUIL = P.CUIL and R.DNI = P.DNI
    JOIN Tratamiento T ON T.cod_nomenclador = R.cod_nomenclador
    join Produce PR ON T.cod_nomenclador = PR.cod_nomenclador
    where
        T.descripcion like 'Vacuna%') a
where
    count(a.DNI) = (select 
            max(b.cantidad)
        from
            (select 
                count(T.cod_nomenclador) as cantidad
            from
                Tratamiento T
            join Produce PR ON T.cod_nomenclador = PR.cod_nomenclador
            where
                T.descripcion like 'Vacuna%') b); 

