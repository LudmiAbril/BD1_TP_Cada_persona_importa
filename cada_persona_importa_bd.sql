/*
i. Top 10 de tratamientos con más de 10 efectos adversos. LISTO NO DA 
ii. Cantidad de personas con algún tratamiento diagnóstico que no haya confirmado el
diagnóstico. LISTO
iii. ¿Cuántas personas ha habido que hayan tenido la mayor cantidad de efectos
adversos de algún tratamiento de vacunación? LISTO
iv. ¿Cuántas muertes ocurrieron relacionadas con vacunas, agrupando por vacuna,
durante los años 2021 al 2023?
v. ¿Cuántas muertes de recién nacidos se pueden relacionar a medicamentos
administrados a la madre? Si el modelo realizado no permite contestar esta
pregunta, modificarlo para poder hacerlo. LISTO
vi. Formulen una consulta que permita a un profesional médico descartar un
tratamiento en niños por ser el riesgo mayor al beneficio. ¿Qué otra información
guardarían para realizar esta comparación? Incluirla en el modelo completo.
vii. Mostrar todos los tratamientos de bajo riesgo practicados a personas con al menos 2
(dos) patologías preexistentes y que sean adultos mayores. NO DA
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
    f_nac date,
    CONSTRAINT Persona_PK PRIMARY KEY (CUIL , DNI)
);

create table Es_hijo_de (
CUIL BIGINT,
DNI BIGINT,
CUIL_P bigint,
DNI_P bigint,
constraint Es_hijo_de_PK primary key (CUIL, DNI, CUIL_P, DNI_P),
constraint Es_hijo_de_FK foreign key (CUIL_P, DNI_P) references Persona (CUIL, DNI),
constraint e_hijo_de_FK foreign key (CUIL, DNI) references Persona (CUIL, DNI)
);

INSERT INTO Persona (CUIL, DNI, f_nac)
VALUES 
    (111111111, 111111111, '1995-05-10'),
    (222222222, 222222222, '1980-12-03'),
    (333333333, 333333333, '1961-07-15'),
    (444444444, 444444444, '1946-09-22'),
    (555555555, 555555555, '1930-02-28'),
    (666666666, 666666666, '1987-11-17'),
    (777777777, 777777777, '2003-06-12'),
    (888888888, 888888888, '1995-04-07'),
    (999999999, 999999999, '1983-08-25'),
    (123456789, 987654321, '1979-03-19'),
    (234567890, 876543210, '2023-10-06'),
    (345678901, 765432109, '1988-07-02'),
    (456789012, 654321098, '2020-12-14'),
    (567890123, 543210987, '2013-09-30'),
    (678901234, 432109876, '2010-06-24');

INSERT INTO Persona (CUIL, DNI)
VALUES (20345678902, 50123456),
       (20456789013, 60123456),
       (20567890124, 70123456),
       (20678901235, 80123456),
       (20789012346, 90123456),
       (20890123457, 10012345),
       (20901234568, 11012345),
       (21012345679, 12012345),
       (21123456780, 13012345),
       (21234567891, 14012345);

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
INSERT INTO Profesional (nombre, apellido, email, celular, dir_postal, mat_nacional, mat_provincial)
VALUES ('Juan', 'Pérez', 'juan@example.com', 1234567890, 'Calle Principal 123', 987654321, 111111111),
('María', 'González', 'maria@example.com', 9876543210, 'Avenida Central 456', 222222222, 222222222);


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
descripcion varchar(30)
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
    
  CONSTRAINT Recibe_pk PRIMARY KEY (CUIL, DNI, mat_nacional, mat_provincial, cod_nomenclador),
    
    CONSTRAINT CUIL_DNI_fk_recibe FOREIGN KEY (CUIL, DNI)
        REFERENCES Persona (CUIL, DNI),
        
    CONSTRAINT mat_nacional_mat_provincial_fk_recibe FOREIGN KEY (mat_nacional , mat_provincial)
        REFERENCES Profesional (mat_nacional , mat_provincial),
        
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
constraint cod_nomenclador_FK_produce foreign key (cod_nomenclador) references Tratamiento (cod_nomenclador),
constraint cod_FK_produce foreign key (cod) references Efecto_adverso(cod)
);

-- Se_realizan.cod_nomneclador -> Tratamiento.cod_nomneclador
-- Se_realizan.nro -> Centro_salud.nro

-- Se_realizan(cod_nomenclador, nro)
create table Se_realizan (
cod_nomenclador INT,
nro INT,
constraint cod_nomenclador_nro_PK_Se_realizan primary key (cod_nomenclador, nro),
constraint cod_nomenclador_FK_Se_realizan foreign key (cod_nomenclador) references Tratamiento (cod_nomenclador),
constraint nro_FK_Se_realizan foreign key (nro) references Centro_salud (nro)

 );
    
    create table Efectos_esperados ( 
    cod int primary key, 
nombre varchar(35),
f_ocurrencia date);

CREATE TABLE Trat_produce_efec_esperado (
    cod_nomenclador INT,
    cod INT,
    CONSTRAINT Trat_produce_efec_esperado_PK PRIMARY KEY (cod_nomenclador , cod),
    CONSTRAINT Trat_produce_efec_esperado_FK FOREIGN KEY (cod_nomenclador)
        REFERENCES Tratamiento (cod_nomenclador),
    CONSTRAINT Trat_produce_efec_esperado_cod_FK FOREIGN KEY (cod)
        REFERENCES Efectos_esperados (cod)
);

/*





C O N S U L T A S





*/

/*i. Top 10 de tratamientos con más de 10 efectos adversos. */

select t.cod_nomenclador, t.descripcion, COUNT(t.cod_nomenclador) AS cantidad_efectos 
FROM Tratamiento t
        JOIN produce p ON t.cod_nomenclador = p.cod_nomenclador
GROUP BY t.cod_nomenclador
having COUNT(t.cod_nomenclador) > 10
ORDER BY COUNT(t.cod_nomenclador) DESC;

-- /*ii. Cantidad de personas con algún tratamiento diagnóstico que no haya confirmado el diagnóstico. */ 
  
SELECT 
    COUNT(P.CUIL) as cant_personas
FROM
    Persona P
Where exists( select 
            1
        FROM
            Recibe R
                JOIN
            Tratamiento T ON R.cod_nomenclador = T.cod_nomenclador
                JOIN
            Prac_diag pd ON pd.cod_nomenclador = T.cod_nomenclador
        WHERE
            pd.confirmacion_diag_presuntivo is false
                AND R.CUIL = P.CUIL
                AND R.dni = P.dni);


/* iii. ¿Cuántas personas ha habido que hayan tenido la mayor cantidad de efectos
adversos de algún tratamiento de vacunación? */

SELECT 
    a.DNI, COUNT(a.DNI) AS cantidad_efectos_que_tuvo
FROM
    (SELECT 
        P.DNI, P.CUIL
    FROM
        Persona P
    JOIN Recibe R ON R.CUIL = P.CUIL AND R.DNI = P.DNI
    JOIN Tratamiento T ON T.cod_nomenclador = R.cod_nomenclador
    JOIN Produce PR ON T.cod_nomenclador = PR.cod_nomenclador
    WHERE
        T.descripcion LIKE 'Vacuna%') a
GROUP BY (a.dni)
HAVING COUNT(a.DNI) = (SELECT 
        MAX(b.cantidad)
    FROM
        (SELECT 
            COUNT(T.cod_nomenclador) AS cantidad
        FROM
            Tratamiento T
        JOIN Produce PR ON T.cod_nomenclador = PR.cod_nomenclador
        WHERE
            T.descripcion LIKE 'Vacuna%') b); 

/* iv. ¿Cuántas muertes ocurrieron relacionadas con vacunas, agrupando por vacuna,
durante los años 2021 al 2023? */

select T.descripcion, count(T.cod_nomenclador) as Cantidad_de_muertes_desde_2021_a_2023
from Tratamiento T join Produce P on T.cod_nomenclador = P.cod_nomenclador join Efecto_adverso E on P.cod = E.cod
where T.descripcion like 'Vacuna%' and E.f_ocurrencia between '2021-01-01' and '2023-12-31'
group by T.descripcion
order by t.descripcion;

-- vii. Mostrar todos los tratamientos de bajo riesgo practicados a personas con al menos 2 (dos) patologías preexistentes y que sean adultos mayores.

SELECT DISTINCT
    t.cod_nomenclador, t.descripcion
FROM
    Tratamiento t
        INNER JOIN
   recibe r ON t.cod_nomenclador = r.cod_nomenclador
        INNER JOIN
    persona p ON p.dni = r.dni AND p.cuil = .cuil
        INNER JOIN
    tiene_PDA tpda ON p.dni = tpda.dni AND p.cuil = tpda.cuil
WHERE
    t.es_invasivo = FALSE
        AND YEAR(CURRENT_DATE()) - YEAR(p.f_nac) >= 18
GROUP BY t.cod_nomenclador , t.descripcion
HAVING COUNT(tpda.cod_uni) >= 2; -- Al menos 2 patologías preexistentes


/* ix. Destacar aquellos tratamientos letales, por causar efectos severos, por rango etario,
considerando 0 años, 1-5 años, 6-12 años, 13-17 años, 18 a 25 años, 26-40 años, 41-
50 años, 51-70 años, 71-90 años, 91 o más años.
 */
 
select T.cod_nomenclador, T.descripcion, YEAR(CURRENT_DATE()) - YEAR(p.f_nac) as edad
from Persona P join Recibe R on P.CUIL = R.CUIL and P.DNI = R.DNI join Tratamiento T 
on R.cod_nomenclador = T.cod_nomenclador
where exists( select 1
from Produce P join Efecto_adverso E on P.cod=E.cod join Tipo_efecto TE on E.nro_tipo = TE.nro
where P.cod_nomenclador = T.cod_nomenclador and TE.nombre like 'severo')
and ( year(P.f_nac) = '2023' or year(P.f_nac) between '2022' and '2018'
 or year(P.f_nac) between '2017' and '2011' or year(P.f_nac) between '2010' and '2006'
 or year(P.f_nac) between '2007' and '1998' or year(P.f_nac) between '1996' and '1983'
 or year(P.f_nac) between '1984' and '1973' or year(P.f_nac) between '1974' and '1953'
 or year(P.f_nac) between '1954' and '1933' or year(P.f_nac) >= '1934'
 )
  group by t.cod_nomenclador, p.f_nac
 order by p.f_nac desc;
 
-- insertado
INSERT INTO Diag (cod_uni, descripcion)
VALUES (1, 'Patología 1'), (2, 'Patología 2');

-- insertado
insert into Antecedente(cod,descripcion )
value
(1, 'Dolor de cabeza'), (2, 'Mareos');

-- insertado
INSERT INTO tiene_PDA (CUIL, DNI, cod_uni, cod_ante)
VALUES (111111111, 111111111, 1, 1), (111111111, 111111111, 2, 2);

-- insertado
insert into Efectos_esperados(cod, nombre, f_ocurrencia)
values
(1, 'Mejora la vision', '2023-05-07'),
(2, 'Reduccion del uso de lentes', '2023-05-13');

-- insertado
insert into Tipo_efecto (nro, nombre)
values
(1, 'Leve'), (2, 'Moderado'), (3, 'Severo'), (4, 'Muerte');

-- insertado
INSERT INTO Trat_produce_efec_esperado (cod_nomenclador, cod)
VALUES (6, 1), (6, 2);

-- insertado
insert into Efecto_adverso (cod, nombre, f_ocurrencia, nro_tipo)
values
(1, 'Disminucion de la vista',  '2023-05-07',1);

-- insertado
insert into Produce (cod_nomenclador, cod)
value (6, 1);

-- insertado
insert into Efectos_esperados(cod, nombre, f_ocurrencia)
values
(3, 'Reducción de la fiebre', '2023-05-07'),
(4, 'Alivio del dolor', '2023-05-13');

-- insertado
insert into Efecto_adverso (cod, nombre, f_ocurrencia, nro_tipo)
values
(2, 'Sangrado gastrointestinal',  '2023-05-07', 1);

-- insertado
insert into Produce (cod_nomenclador, cod)
value (1, 2);

-- insertado
INSERT INTO Trat_produce_efec_esperado (cod_nomenclador, cod)
VALUES (1, 1), (1, 2);

INSERT INTO Trat_produce_efec_esperado (cod_nomenclador, cod)
VALUES (1, 3), (1, 4);

-- insertado
INSERT INTO Trat_produce_efec_esperado (cod_nomenclador, cod)
VALUES (6, 1), (6, 2);

-- insertado
INSERT INTO Recibe (CUIL, DNI, mat_nacional, mat_provincial, cod_nomenclador, tiene_profesional)
VALUES (111111111, 111111111, 987654321, 111111111, 1, true);

/* V. consulta que hicimos en grupo
SELECT t.descripcion
from Tratamiento t join Recibe r on t.cod_nomenclador = r.cod_nomenclador
join Persona p on p.CUIL =r.CUIL  and p.DNI =r.DNI 
join Tiene ti on ti.CUIL = p.CUIL and ti.DNI = p.DNI 

where year(p.f_nac)='2005' 
group by ti.cod
having count (ti.cod)>=2;*/

/*vi. Formulen una consulta que permita a un profesional médico descartar un
tratamiento en niños por ser el riesgo mayor al beneficio. ¿Qué otra información
guardarían para realizar esta comparación? Incluirla en el modelo completo.*/
SELECT R.cod_nomenclador, t.descripcion AS "tratamiento", YEAR(p.f_nac)
FROM Persona P JOIN Recibe R on P.CUIL = R.CUIL




/*

vi. Formulen una consulta que permita a un profesional médico descartar un
tratamiento en niños por ser el riesgo mayor al beneficio. ¿Qué otra información
guardarían para realizar esta comparación? Incluirla en el modelo completo */

SELECT R.cod_nomenclador, T.descripcion AS "tratamiento", YEAR(p.f_nac)
FROM Persona P JOIN Recibe R on P.CUIL = R.CUIL 
join Tratamiento T on T.cod_nomenclador= R.cod_nomenclador
AND p.f_nac >"2013-01-01"
WHERE R.cod_nomenclador IN( SELECT T.cod_nomenclador
							FROM Tratamiento t JOIN Produce p on t.cod_nomenclador=p.cod_nomenclador
                            JOIN Efecto_Adverso EF on EF.cod=p.cod
                            WHERE (SELECT COUNT(*)
                                   FROM Efecto_Adverso E
                                   GROUP BY E.cod
                                   having count(E.cod)> 5 ));
                                   
-- viii. Formular una consulta que Uds. Le harían a la app para saber si se realizó un tratamiento.
select *
from tratamiento t 
where exists 
(select 1 
from recibe r join persona p on r.dni = p.dni and r.cuil = p.cuil
where r.cod_nomenclador = t.cod_nomenclador);

-- Formular una consulta que Uds. Le harían a la app para saber si se realizarían un tratamiento.

select t.descripcion, t.es_invasivo, t.parte_cuerpo_aplicacion
from tratamiento t;

/*Probando*/
alter table Evento add column  f_ocurrencia DATE;
-- Inserción 1

/* consulta numero 5*/
insert into Persona(CUIL, DNI, f_nac)
values
(35666772222, 899000000, '1998-06-09'),
(3234555555, 99999999999, '2023-07-01');

insert into Es_hijo_de(CUIL, DNI, CUIL_P, DNI_P)
VALUES
(3234555555, 99999999999, 35666772222, 899000000);

INSERT INTO Recibe (CUIL, DNI, cod_nomenclador,   mat_nacional , mat_provincial ,tiene_profesional)
values
(35666772222, 899000000, 3, 987654321, 111111111, true);

INSERT INTO Evento (cod, descripcion, f_ocurrencia)
VALUES (1, 'Muerte', '2023-01-01'); 

INSERT INTO Padece (CUIL, DNI, cod)
values
(3234555555, 99999999999,1);



select count(*) AS total_muertes
from Persona h
join es_hijo_de esd on h.cuil= esd.cuil and h.dni=esd.dni
join Persona m on esd.cuil_p = m.cuil and esd.dni_p = m.dni
where datediff(current_date(), h.f_nac) * 365 <30 and exists (
select 1
from Recibe r 
where r.dni = m.dni and r.cuil = m.cuil
) and exists (
select 1
from Padece p join Evento e on e.cod= p.cod
where p.cuil= h.cuil and p.dni =h.dni
and E.descripcion like 'Muerte'
);

