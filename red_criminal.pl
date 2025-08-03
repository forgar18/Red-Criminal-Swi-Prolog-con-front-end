% Relación jerárquica (jefe, subordinado)
jefe(juan, pedro).
jefe(juan, marco).
jefe(pedro, luis).
jefe(marco, andres).
jefe(sofia, pedro).  

% Afiliación a carteles
miembro(luis, cartel_norte).
miembro(pedro, cartel_norte).
miembro(marco, cartel_sur).
miembro(juan, cartel_sur).
miembro(andres, cartel_sur).

% Actividades criminales
actividad(luis, trafico_drogas).
actividad(luis, corrupcion).        
actividad(pedro, lavado_dinero).
actividad(marco, extorsion).
actividad(marco, lavado_dinero).   

% Relaciones de complicidad
complice(luis, pedro).
complice(luis, marco).             
complice(marco, juan).
complice(andres, luis).
complice(juan, pedro).              

% Arrestados
arrestado(pedro).

% Rivalidades 
rival(luis, marco).



% REGLAS DE INFERENCIA

% Subordinado directo o indirecto
subordinado(X, Y) :- jefe(Y, X).
subordinado(X, Y) :- jefe(Z, X), subordinado(Z, Y).

% Personas que pertenecen al mismo cartel (sin repetirse)
mismo_cartel(X, Y) :- 
    miembro(X, C),
    miembro(Y, C),
    X \= Y.

% Persona peligrosa
peligroso(X) :- actividad(X, _), jefe(X, _).
peligroso(X) :- actividad(X, A1), actividad(X, A2), A1 \= A2.

% Conexión indirecta entre criminales
conexion_indirecta(X, Y) :- complice(X, Y).
conexion_indirecta(X, Y) :- complice(X, Z), conexion_indirecta(Z, Y).

% Sospechoso por conexión con alguien arrestado
sospechoso(X) :-
    conexion_indirecta(X, Y),
    arrestado(Y).
