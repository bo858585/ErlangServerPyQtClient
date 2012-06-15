% Неблокирующий (асинхронный) сервер

-module(socket_server).
-behavior(gen_server).

-export([init/1, code_change/3, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).
-export([accept_loop/1]).
-export([start/3]).
-export([stop/0]).


-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}]).

-record(server_state, {
        port,
        loop,
        ip=any,
        lsocket=null}).

start(Name, Port, Loop) ->
    State = #server_state{port = Port, loop = Loop},
    gen_server:start_link({local, Name}, ?MODULE, State, []).

stop() ->
   gen_server:cast(socket_server, stop).

init(State = #server_state{port=Port}) ->
    % Слушаем порт
    case gen_tcp:listen(Port, ?TCP_OPTIONS) of
        {ok, LSocket} ->
            NewState = State#server_state{lsocket = LSocket},
            {ok, accept(NewState)};
        {error, Reason} ->
            {stop, Reason}
    end.

handle_cast({accepted, _Pid}, State=#server_state{}) ->
    {noreply, accept(State)}.

accept_loop({Server, LSocket, {M, F}}) ->
    {ok, Socket} = gen_tcp:accept(LSocket),
    % Просим главный процесс создать нового "слушателя" и вызываем цикл обработки данных,
    % чтобы избежать блокировки  
    gen_server:cast(Server, {accepted, self()}),
    % Запускаем цикл приема-передачи сообщений
    M:F(Socket).
    
% Для большей безопасности мы должны использовать spawn_link и обрабатывать ошибки
accept(State = #server_state{lsocket=LSocket, loop = Loop}) ->
    proc_lib:spawn(?MODULE, accept_loop, [{self(), LSocket, Loop}]),
    State.

% Это здесь только для того чтобы скрыть предупреждения
handle_call(_Msg, _Caller, State) -> {noreply, State}.
handle_info(_Msg, Library) -> {noreply, Library}.
terminate(_Reason, _Library) -> 
    io:format("Stop server~n",[]), 
    exit("Client said stop."), 
    io:format("Stop2 server~n",[]), 
    stop(),
    io:format("Stop server3~n",[]).

code_change(_OldVersion, Library, _Extra) -> {ok, Library}.
