% server.pl
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_error)).
:- use_module(library(http/http_header)).

:- consult('red_criminal.pl').

% ========= CORS ==========
cors_headers :-
    format('Access-Control-Allow-Origin: *~n'),
    format('Access-Control-Allow-Methods: GET, POST, OPTIONS~n'),
    format('Access-Control-Allow-Headers: Content-Type~n').

wrap_cors(Handler, Request) :-
    member(method(options), Request), !,
    cors_headers,
    format('Content-type: application/json~n~n'),
    reply_json(_{message: "Preflight OK"}).

wrap_cors(Handler, Request) :-
    cors_headers,
    catch(
        call(Handler, Request),
        Error,
        (
            cors_headers,
            format('Content-type: application/json~n~n'),
            reply_json(_{error: Error})
        )
    ).

% ========= RUTAS =========
:- http_handler(root(mismo_jefe),             wrap_cors(handler_mismo_jefe), []).
:- http_handler(root(mismo_cartel),           wrap_cors(handler_mismo_cartel), []).
:- http_handler(root(subordinados_juan),      wrap_cors(handler_subordinados_juan), []).
:- http_handler(root(peligrosos),             wrap_cors(handler_peligrosos), []).
:- http_handler(root(complices_multiples),    wrap_cors(handler_complices_multiples), []).
:- http_handler(root(conexion_juan),          wrap_cors(handler_conexion_juan), []).
:- http_handler(root(jefes_sin_crimen),       wrap_cors(handler_jefes_sin_crimen), []).
:- http_handler(root(multiples_crimenes),     wrap_cors(handler_multiples_crimenes), []).
:- http_handler(root(sospechosos),            wrap_cors(handler_sospechosos), []).
:- http_handler(root(no_arrestados),          wrap_cors(handler_no_arrestados), []).
:- http_handler(root(rivales),                wrap_cors(handler_rivales), []).
:- http_handler(root(subordinados_pedro),     wrap_cors(handler_subordinados_pedro), []).
:- http_handler(root(lista_jefes),            wrap_cors(handler_lista_jefes), []).

% ========= SERVIDOR =========
:- initialization(iniciar_servidor).
iniciar_servidor :- http_server(http_dispatch, [port(8080)]).

% ========= HANDLERS =========

handler_mismo_jefe(_) :-
    findall(Jefe-Miembro, jefe(Jefe, Miembro), Pairs),
    group_pairs_by_key(Pairs, Agrupados),  % Agrupa por jefe
    findall(Grupo, (
        member(_-Lista, Agrupados),
        sort(Lista, Grupo),          % Ordena para consistencia
        length(Grupo, L), L >= 2     % Solo si hay al menos 2 miembros
    ), Resultado),
    reply_json(Resultado).


handler_mismo_cartel(_) :-
    findall(X, miembro(X, cartel_norte), NorteRaw),
    findall(Y, miembro(Y, cartel_sur), SurRaw),
    sort(NorteRaw, Norte),
    sort(SurRaw, Sur),
    emparejar_listas(Norte, Sur, Pares),
    reply_json(Pares).

% Empareja elementos de dos listas en pares [A, B] para tabla de 2 columnas
emparejar_listas([], [], []).
emparejar_listas([X|Xs], [], [[X, ""]|Rest]) :-
    emparejar_listas(Xs, [], Rest).
emparejar_listas([], [Y|Ys], [["", Y]|Rest]) :-
    emparejar_listas([], Ys, Rest).
emparejar_listas([X|Xs], [Y|Ys], [[X, Y]|Rest]) :-
    emparejar_listas(Xs, Ys, Rest).


handler_subordinados_juan(_) :-
    findall(X, subordinado(X, juan), R),
    reply_json(R).

handler_peligrosos(_) :-
    findall(X, peligroso(X), R),
    list_to_set(R, L),
    reply_json(L).

handler_complices_multiples(_) :-
    current_predicate(complice/2), !,
    findall(X, (
        complice(X,_),
        findall(Y, complice(X,Y), L1),
        length(L1, N),
        N > 1
    ), Reps),
    list_to_set(Reps, L),
    reply_json(L).
handler_complices_multiples(_) :-
    reply_json(_{error: "Predicado complice/2 no está definido"}).

handler_conexion_juan(_) :-
    findall(X, (conexion_indirecta(juan, X), X \= juan), R),
    list_to_set(R, L),
    reply_json(L).

handler_jefes_sin_crimen(_) :-
    findall(X, (jefe(X, _), \+ actividad(X, _)), L1),
    list_to_set(L1, L),
    reply_json(L).

handler_multiples_crimenes(_) :-
    findall(X, (actividad(X, A1), actividad(X, A2), A1 \= A2), R),
    list_to_set(R, L),
    reply_json(L).

handler_sospechosos(_) :-
    findall(X, sospechoso(X), L1),
    list_to_set(L1, L),
    reply_json(L).

handler_no_arrestados(_) :-
    findall(X, (actividad(X, _), \+ arrestado(X)), L1),
    list_to_set(L1, L),
    reply_json(L).

handler_rivales(_) :-
    findall(P, (
        rival(X, Y),
        X @< Y,  % evita repeticiones como (luis, marco) y (marco, luis)
        P = [X, Y]
    ), Unicos),
    reply_json(Unicos).


handler_subordinados_pedro(_) :-
    findall(X, subordinado(X, pedro), R),
    list_to_set(R, L),
    reply_json(L).

handler_lista_jefes(_) :-
    findall(X, jefe(X, _), L1),
    list_to_set(L1, L),
    reply_json(L).

