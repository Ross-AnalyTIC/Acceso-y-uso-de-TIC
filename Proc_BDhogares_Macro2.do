*==============================================================
* RESULTADOS DE LA ENCUESTA A HOGARES - PROYECTO MACROREGIONAL 2
*==============================================================
clear all
global bases "Descargas"

cd "$bases"

*============================================
* UNIÓN DE BASE DE DATOS (HOGARES Y POBLACIÓN)
*============================================

/*
use "Base_hogares_Macro2_FX",clear 
merge 1:m interview__key using Base_poblacion_Macro2_FX
drop _merge 
save "BaseTotal_Macro2",replace
*/

*================================================
* DATOS GENERALES DE LA POBLACIÓN Y LOS HOGARES
*================================================

*** Cantidad total de hogares
u "Base_hogares_Macro2_FX",clear 
tab Estrato 
tab Estrato Departamento [iw= Factor_exp_hogares], row

*** Cantidad total de personas
u "BaseTotal_Macro2",clear
tab Estrato
tab Estrato Departamento [iw= factor_exp_pob], col

*-----------------
* Demografía
*-----------------

*** Ubicación geográfica
tab Departamento [iw= factor_exp_pob]
tab Provincia [iw= factor_exp_pob]

*** Grupos de edad
sum mod1_103
fre mod1_103
recode mod1_103 (0/5=1 "<6") (6/14=2 "6-14") (15/44=3 "15-44") (45/59=4 "45-59") (60/97=5 ">=60"), gen(gedad1)
tab gedad1 [iw= factor_exp_pob]

*** Género (según grupos de edad)
tab gedad1 mod1_104 [iw= factor_exp_pob], row

*** Idioma que más usa
tab mod1_107 [iw= factor_exp_pob]
tab mod1_107_10 [iw= factor_exp_pob]


*-----------------
* Educación
*-----------------

*** Sabe leer y escribir por grupo de edad
recode mod1_103 (15/19=1 "15-19") (20/29=2 "20-29") (30/39=3 "30-39") (40/49=4 "40-49") (50/59=5 "50-59") (60/97=6 ">=60") if mod1_103>=15, gen(gedad2)

tab mod1_109 [iw= factor_exp_pob] if mod1_103>=15
tab gedad2 [iw= factor_exp_pob] if mod1_103>=15 & mod1_109==2

*** Nivel educativo 
tab mod1_110 [iw= factor_exp_pob] if mod1_103>=15

*-----------------
* Empleo
*-----------------

*****************
recode mod1_103 (14/24=1 "14-24") (25/44=2 "25-44") (45/64=3 "45-64") (65/97=4 ">=65") if mod1_103>=14, gen(gedad3)

*** Con empleo
tab mod2_201 [iw= factor_exp_pob] if mod1_103>=14

*** Actividad económica
tab mod2_203 [iw= factor_exp_pob] if mod1_103>=14
tab mod2_203 [iw= factor_exp_pob] if mod1_103>=14

save BaseTotal_Macro2_perfiles, replace

*-----------------
* Vivienda
*-----------------

use "Base_hogares_Macro2_FX",clear 

*** Electricidad
tab mod3_307 [iw= Factor_exp_hogares]
tab mod3_309 [iw= Factor_exp_hogares]
tab mod3_308 [iw= Factor_exp_hogares]


*===============================
* ACCESO A LAS TIC EN EL HOGAR
*===============================

*---------------------
* Acceso a bienes TIC
*---------------------

*** TV
tab mod4_401_1 [iw= Factor_exp_hogares]
*** Radio
tab mod4_401_2 [iw= Factor_exp_hogares]
*** PC
tab mod4_401_3 [iw= Factor_exp_hogares]
*** Laptop
tab mod4_401_4 [iw= Factor_exp_hogares]
*** Tablet
tab mod4_401_5 [iw= Factor_exp_hogares]
*** Teléfono celular
tab mod4_401_6 [iw= Factor_exp_hogares]

*** Hogares con acceso a equipos de cómputo (PC, Laptop O Tablet)
gen pc=2
replace pc=1 if mod4_401_3==1
replace pc=1 if mod4_401_4==1
replace pc=1 if mod4_401_5==1
label def pc 1 "Con PC" 2 "Sin PC"
label val pc pc

tab pc [iw= Factor_exp_hogares]

*** Hogares sin PC-Laptop-Tablet (razones)
tab mod4_403 [iw= Factor_exp_hogares]
tab mod4_403_6_otro [iw= Factor_exp_hogares]

*** Interés por adquirir PC-Laptop-Tablet
tab mod4_404__1 [iw= Factor_exp_hogares] if mod4_404__4==0
tab mod4_404__2 [iw= Factor_exp_hogares] if mod4_404__4==0
tab mod4_404__3 [iw= Factor_exp_hogares] if mod4_404__4==0
tab mod4_404__4 [iw= Factor_exp_hogares]

*-----------------------
* Acceso a servicios TIC
*-----------------------

*** Telefonia pública
tab mod4_402_1 [iw= Factor_exp_hogares]
*** Telefonía fija
tab mod4_402_2 [iw= Factor_exp_hogares]
*** Telefonia movil
tab mod4_402_3 [iw= Factor_exp_hogares]
*** Internet fijo
tab mod4_402_4 [iw= Factor_exp_hogares]
*** Internet móvil
tab mod4_402_5 [iw= Factor_exp_hogares]
*** Radio
tab mod4_402_6 [iw= Factor_exp_hogares]
*** Señal de TV peru
tab mod4_402_7 [iw= Factor_exp_hogares]
*** TV cable
tab mod4_402_8 [iw= Factor_exp_hogares]

*-------------------------------
* Hogares con acceso a Internet
*-------------------------------

tab mod4_413 [iw= Factor_exp_hogares]

*** Hogar con PC + Internet
g inter=pc
replace inter=0 if pc==1 & mod4_413==1
label def inter 0 "con PC y Internet" 1 "con PC, sin Internet" 2 "Sin PC ni Internet" 
label val  inter inter

tab inter [iw= Factor_exp_hogares]

*----------------------------------------------------------
* Dada la poca representatividad de la muestra (6 hogares con acceso a Internet), no se podría caracterízar adecuadamente a los hogares con acceso a Internet

/*
*** Velocidad de Internet fijo
tab mod4_426 Departamento [iw= Factor_exp_hogares], col

*** Tipo de contrato
tab mod4_422 Departamento [iw= Factor_exp_hogares], col

*** Razones de contratacion
tab mod4_424__1  [iw= Factor_exp_hogares]
tab mod4_424__2	 [iw= Factor_exp_hogares]
tab mod4_424__3	[iw= Factor_exp_hogares]
tab mod4_424__4	 [iw= Factor_exp_hogares]
tab mod4_424__5	 [iw= Factor_exp_hogares]
tab mod4_424__6	 [iw= Factor_exp_hogares]
tab mod4_424__7	 [iw= Factor_exp_hogares]
tab mod4_424__8	 [iw= Factor_exp_hogares]
tab mod4_424__9	 [iw= Factor_exp_hogares]
tab mod4_424__10  [iw= Factor_exp_hogares]

*** Tiempo de servicio
tab mod4_427 [iw= Factor_exp_hogares]

*** Calidad de servicio
tab mod4_423 [iw= Factor_exp_hogares]

recode mod4_423 (0/2=1 "Insatisfecho") (4/5=2 "Satisfecho") (3/3=3 "Ni satisfecho/Ni insatisfecho"), gen(calidad)

tab calidad [iw= Factor_exp_hogares]

*** Cambiarían de proveedor
tab mod4_428 [iw= Factor_exp_hogares]

*/

*-------------------------------------------------
* Hogares que suspendieron su conexión a Internet
*-------------------------------------------------

*** Hogares con equipo de cómputo sin Internet fijo, pero que anteriormente tenía contratado Internet fijo

tab mod4_414 [iw= Factor_exp_hogares]

*** Razones de suspensión
tab mod4_416__1 [iw= Factor_exp_hogares]
tab mod4_416__2  [iw= Factor_exp_hogares]

*-------------------------------
* Hogares sin acceso a Internet
*-------------------------------

*** Razones por las que no tiene Internet fijo
tab mod4_417__1	 [iw= Factor_exp_hogares]
tab mod4_417__2	 [iw= Factor_exp_hogares]
tab mod4_417__3	 [iw= Factor_exp_hogares]
tab mod4_417__4	 [iw= Factor_exp_hogares]
tab mod4_417__5	 [iw= Factor_exp_hogares]
tab mod4_417__6	 [iw= Factor_exp_hogares]
tab mod4_417__7	 [iw= Factor_exp_hogares]
tab mod4_417__9	 [iw= Factor_exp_hogares]
tab mod4_417_9_otro  [iw= Factor_exp_hogares]

*** Interés por contratar Internet fijo
tab mod4_411 [iw= Factor_exp_hogares]

*** Razones por las cuales contrataría Internet fijo
tab mod4_418__1	 [iw= Factor_exp_hogares]
tab mod4_418__2	 [iw= Factor_exp_hogares]
tab mod4_418__3	 [iw= Factor_exp_hogares]
tab mod4_418__4	 [iw= Factor_exp_hogares]
tab mod4_418__5	 [iw= Factor_exp_hogares]
tab mod4_418__6	 [iw= Factor_exp_hogares]
tab mod4_418__7	 [iw= Factor_exp_hogares]
tab mod4_418__8	 [iw= Factor_exp_hogares]
tab mod4_418__9	 [iw= Factor_exp_hogares]
tab mod4_418_9_otro  [iw= Factor_exp_hogares]

*** Razones por las que no tiene interés en contratar Internet fijo
tab mod4_412__1	 [iw= Factor_exp_hogares]
tab mod4_412__2	 [iw= Factor_exp_hogares]
tab mod4_412__4	 [iw= Factor_exp_hogares]
tab mod4_412__5	 [iw= Factor_exp_hogares]
tab mod4_412__6	 [iw= Factor_exp_hogares]
tab mod4_412__7	 [iw= Factor_exp_hogares]
tab mod4_412__8	 [iw= Factor_exp_hogares]
tab mod4_412_8_otro  [iw= Factor_exp_hogares]

*===============================
* USO DE LAS TIC EN EL HOGAR
*===============================

u "BaseTotal_Macro2_perfiles",clear

*-------------------------------
* Uso de PC o laptop
*-------------------------------

tab mod5_501  [iw= factor_exp_pob]

*** Según sexo
tab mod1_104 mod5_501  [iw= factor_exp_pob], col

*** Según nivel educativo alcanzado por la población de 6 a más años de edad
recode mod1_110 (1/4=1 "Primaria") (5/6=2 "Secundaria") (7/8=3 "Sup.NoUniversitaria") (9/10=4 "Sup.Universitaria") if mod1_103>=6, gen(niveduc)

tab niveduc mod5_501 [iw= factor_exp_pob], col

*** Tareas que realiza independientemente
tab mod5_502__1  [iw= factor_exp_pob]
tab mod5_502__2  [iw= factor_exp_pob]
tab mod5_502__3  [iw= factor_exp_pob]
tab mod5_502__4  [iw= factor_exp_pob]
tab mod5_502__5  [iw= factor_exp_pob]
tab mod5_502__6  [iw= factor_exp_pob]
tab mod5_502__7  [iw= factor_exp_pob]
tab mod5_502__8  [iw= factor_exp_pob]
tab mod5_502_9_otro  [iw= factor_exp_pob]

*** Lugar de uso PC o Laptop
tab mod5_503__1 [iw= factor_exp_pob]
tab mod5_503__2 [iw= factor_exp_pob]
tab mod5_503__3 [iw= factor_exp_pob]
tab mod5_503__4 [iw= factor_exp_pob]
tab mod5_503__5 [iw= factor_exp_pob]
tab mod5_503__6 [iw= factor_exp_pob]
tab mod5_503__7 [iw= factor_exp_pob]

*** según sexo
tab mod1_104 mod5_503__1 [iw= factor_exp_pob], row nofreq
tab mod1_104 mod5_503__2 [iw= factor_exp_pob], row nofreq
tab mod1_104 mod5_503__3 [iw= factor_exp_pob], row nofreq
tab mod1_104 mod5_503__4 [iw= factor_exp_pob], row nofreq
tab mod1_104 mod5_503__5 [iw= factor_exp_pob], row nofreq
tab mod1_104 mod5_503__6 [iw= factor_exp_pob], row nofreq
tab mod1_104 mod5_503__7 [iw= factor_exp_pob], row nofreq

*** Razon de no uso
tab mod5_504 [iw= factor_exp_pob]

*-------------------------------
* Uso de tablet
*-------------------------------

*** Sabe usar un tablet
tab mod5_505 [iw= factor_exp_pob]

*** Según grupo etario
tab gedad1 mod5_505 [iw= factor_exp_pob], row nofreq

*** Tiene tablet
tab mod5_506 [iw= factor_exp_pob]


*-------------------------------
* Uso de teléfono móvil
*-------------------------------

*** Sabe usar un teléfono móvil
tab mod5_507 [iw= factor_exp_pob]

*** Según grupo etario
tab gedad1 mod5_507 [iw= factor_exp_pob], row nofreq

*** Según nivel educativo
tab niveduc mod5_507 [iw= factor_exp_pob], row nofreq

*** Tiene teléfono móvil
tab mod5_508 [iw= factor_exp_pob]

***Segun PET
tab mod5_508 mod2_201 [iw= factor_exp_pob] if mod1_103>=14, row nofreq


*=======================================================================
* ACCESO Y USO DEL SERVICIO DE INTERNET CON EQUIPO DE CÓMPUTO O TELÉFONO MÓVIL
*=======================================================================

*-------------------------------
* Uso de Internet
*-------------------------------

tab mod6_601 [iw= factor_exp_pob]

*** Uso Internet según sexo
tab mod1_104 mod6_601 [iw= factor_exp_pob], row nofreq

*** Uso Internet según edad
tab gedad1 mod6_601 [iw= factor_exp_pob], row nofreq

*** Frecuencia de uso
tab mod6_602 [iw= factor_exp_pob]

*** Tiempo de conexion
gen t_conexHr=mod6_608_1_hor + mod6_608_2_min/60
tab t_conexHr
tabstat t_conexHr [aw= factor_exp_pob], s(n mean sd p50 cv max) //corregido
tabstat t_conexHr [aw= factor_exp_pob] if t_conexHr>0&t_conexHr<1, s(n mean sd p50 cv max)

*** Desde que dispositivo se conecta a Internet
tab mod6_603__1 [iw= factor_exp_pob]
tab mod6_603__2 [iw= factor_exp_pob]
tab mod6_603__3 [iw= factor_exp_pob]
tab mod6_603__4 [iw= factor_exp_pob]


*-------------------------------
* Demanda - Adicional
*-------------------------------

*** Acceso a Internet fuera del centro poblado
tab mod6_612 [iw= factor_exp_pob]

*** veces de traslado a otro C.P
tab mod6_613 [iw= factor_exp_pob]
tabstat mod6_613 [aw= factor_exp_pob], s(n mean sd p50 cv max) 

*** Gasto de traslados a otro C.P
tab mod6_614 [iw= factor_exp_pob]
tabstat mod6_614 [aw= factor_exp_pob], s(n mean sd p50 cv max) 

*** Gasto en hospedaje y adicional
tab mod6_616 [iw= factor_exp_pob]
tabstat mod6_616 [aw= factor_exp_pob], s(n mean sd p50 cv max) 



*** En los ultimos 3 meses ha usado?
tab mod6_604 [iw= factor_exp_pob]

*** Razones de no uso Internet
tab mod6_605__1	 [iw= factor_exp_pob] 
tab mod6_605__2	 [iw= factor_exp_pob]
tab mod6_605__3	 [iw= factor_exp_pob]
tab mod6_605__4	 [iw= factor_exp_pob]
tab mod6_605__5	 [iw= factor_exp_pob]
tab mod6_605__6	 [iw= factor_exp_pob]
tab mod6_605__7	 [iw= factor_exp_pob]
tab mod6_605_7_otro	 [iw= factor_exp_pob]

*** Lugar de uso Internet
tab mod6_606__1 [iw= factor_exp_pob]
tab mod6_606__2 [iw= factor_exp_pob]
tab mod6_606__3 [iw= factor_exp_pob]
tab mod6_606__4 [iw= factor_exp_pob]
tab mod6_606__5 [iw= factor_exp_pob]
tab mod6_606__6 [iw= factor_exp_pob]
tab mod6_606__7 [iw= factor_exp_pob]
tab mod6_606__8 [iw= factor_exp_pob]
tab mod6_606_8_otro


*** Finalidad de uso Internet
tab mod6_607__1  [iw= factor_exp_pob]
tab mod6_607__2  [iw= factor_exp_pob]
tab mod6_607__3  [iw= factor_exp_pob]
tab mod6_607__4  [iw= factor_exp_pob]
tab mod6_607__5  [iw= factor_exp_pob]
tab mod6_607__6  [iw= factor_exp_pob]
tab mod6_607__7  [iw= factor_exp_pob]
tab mod6_607__8  [iw= factor_exp_pob]
tab mod6_607__9  [iw= factor_exp_pob]
tab mod6_607__10  [iw= factor_exp_pob]
tab mod6_607_10_otro  [iw= factor_exp_pob]

*** Tareas de Internet
tab mod6_611__1  [iw= factor_exp_pob]
tab mod6_611__2  [iw= factor_exp_pob]
tab mod6_611__3  [iw= factor_exp_pob]
tab mod6_611__4  [iw= factor_exp_pob]
tab mod6_611__5  [iw= factor_exp_pob]
tab mod6_611__6  [iw= factor_exp_pob]
tab mod6_611__7  [iw= factor_exp_pob]
tab mod6_611__8  [iw= factor_exp_pob]
tab mod6_611__9  [iw= factor_exp_pob]
tab mod6_611__10  [iw= factor_exp_pob]
tab mod6_611_10_otro  [iw= factor_exp_pob]

*** Satisfaccion
tab mod6_609 [iw= factor_exp_pob]
tab mod6_610 [iw= factor_exp_pob]

*===================================================
* EPAD 
*===================================================

** Interés
tab gedad1 mod7_701  [iw= factor_exp_pob], row nofreq
tab mod7_705  [iw= factor_exp_pob]
tab mod7_706  [iw= factor_exp_pob]

**Frecuencia de uso
tab mod7_707  [iw= factor_exp_pob]
tab mod7_708  [iw= factor_exp_pob]


********************************************************
* CAD
********************************************************

** Interés
tab mod8_801  [iw= factor_exp_pob]
tab gedad1 mod8_801  [iw= factor_exp_pob], row nofreq
tab mod8_808  [iw= factor_exp_pob]

** Frecuencia acceso
tab mod8_802  [iw= factor_exp_pob]
tab mod8_803  [iw= factor_exp_pob]

** Frecuencia capacitación
tab mod8_806  [iw= factor_exp_pob]

tab mod8_807__1  [iw= factor_exp_pob]
tab mod8_807__2  [iw= factor_exp_pob]
tab mod8_807__3  [iw= factor_exp_pob]
tab mod8_807__4  [iw= factor_exp_pob]
tab mod8_807__5  [iw= factor_exp_pob]
tab mod8_807__6  [iw= factor_exp_pob]
tab mod8_807__7  [iw= factor_exp_pob]
tab mod8_807__8  [iw= factor_exp_pob]

/*
*** Demanda del curso de Alfabetización Digital del CAD
tabstat mod8_804 [aw= Factor_exp_hogares], s(n mean sd p50 cv max) by(mod1_104)
tabstat mod8_804 [aw= Factor_exp_hogares] if mod8_804<10, s(n mean sd p50 cv) by(mod1_104)

*** Media aritmética, geométrica y armónica
**********************************************************************
means mod8_804 [aw= Factor_exp_hogares] 
*/

*** Temas de interés
tab mod8_805__1  [iw= factor_exp_pob] 
tab mod8_805__2  [iw= factor_exp_pob] 
tab mod8_805__3  [iw= factor_exp_pob] 
tab mod8_805__4  [iw= factor_exp_pob] 
tab mod8_805__5  [iw= factor_exp_pob] 
tab mod8_805__6  [iw= factor_exp_pob] 
tab mod8_805__7  [iw= factor_exp_pob] 
tab mod8_805__8  [iw= factor_exp_pob] 
tab mod8_805__9  [iw= factor_exp_pob] 
tab mod8_805__10  [iw= factor_exp_pob] 
tab mod8_805__11  [iw= factor_exp_pob]


*******************************
* EPAD Y/O CAD
*******************************
tab mod9_901__1  [iw= factor_exp_pob] 
tab mod9_901__2  [iw= factor_exp_pob] 
tab mod9_901__3  [iw= factor_exp_pob] 
tab mod9_901__4  [iw= factor_exp_pob] 
tab mod9_901__5  [iw= factor_exp_pob] 
tab mod9_901__6  [iw= factor_exp_pob] 
tab mod9_901__7  [iw= factor_exp_pob] 
tab mod9_901__8  [iw= factor_exp_pob] 
tab mod9_901__9  [iw= factor_exp_pob] 

tab mod9_902  [iw= factor_exp_pob]

tab gedad1 mod9_902  [iw= factor_exp_pob], nofreq row

/*
*******************************
*MODULO 10
*******************************
tab mod10_1001_a  [iw= factor_exp_pob] 
tab mod10_1001_b  [iw= factor_exp_pob] 
tab mod10_1001_d  [iw= factor_exp_pob] 
tab mod10_1001_e  [iw= factor_exp_pob] 

tab mod10_1002  [iw= factor_exp_pob]
*/

*==============================================
* MATRIZ DE INDICADORES - 2024
*==============================================

u "Base_hogares_Macro2_FX",clear 

*-------------------------------
* Indicadores de adopcion de TIC
*-------------------------------

** CELULAR
tab mod4_401_6 [iw=Factor_exp_hogares]
** RADIO
tab mod4_401_2  [iw=Factor_exp_hogares]
** PC
tab mod4_401_3  [iw=Factor_exp_hogares]
** LAPTOP
tab mod4_401_4  [iw=Factor_exp_hogares]
*TABLET
tab mod4_401_5  [iw=Factor_exp_hogares]
** INTERNET
tab inter [iw=Factor_exp_hogares]

*-------------------------------
* Indicadores de acceso a TIC
*-------------------------------

** Hogares con acceso a telefonía pública en su Centro Poblado
tab mod4_402_1  [iw=Factor_exp_hogares]
** Hogares con acceso a telefonía fija en su Centro Poblado
tab mod4_402_2  [iw=Factor_exp_hogares]
** Hogares con acceso a telefonía móvil en su Centro Poblado
tab mod4_402_3  [iw=Factor_exp_hogares]
** Hogares con acceso a Internet en su Centro Poblado
tab mod4_402_4  [iw=Factor_exp_hogares]
** Hogares con acceso a radio en su Centro Poblado
tab mod4_402_5  [iw=Factor_exp_hogares]
** Hogares con acceso a Televisión de paga (TV cable) en su Centro Poblado
tab mod4_402_6  [iw=Factor_exp_hogares]
** Hogares con acceso a señal de TV Perú en su Centro Poblado
tab mod4_402_7  [iw=Factor_exp_hogares]
