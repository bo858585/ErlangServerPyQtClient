% Ќеблокирующий (асинхронный) сервер

-module(socket_server).
-behavior(gen_server).

-export([init/1, code_change/3, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).
-export([accept_loop/1]).
-export([start/3]).

-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}]).

-record(server_state, {
        port,
        loop,
        ip=any,
        lsocket=null}).

start(Name, Port, Loop) ->
    State = #server_state{port = Port, loop = Loop},
    gen_server:start_link({local, Name}, ?MODULE, State, []).

init(State = #server_state{port=Port}) ->
    % —лушаем порт
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
    % ѕросим главный процесс создать нового "слушател€" и вызываем цикл обработки данных,
    % чтобы избежать блокировки  
    gen_server:cast(Server, {accepted, self()}),
    M:F(Socket).
    
% ƒл€ большей безопасности мы должны использовать spawn_link и обрабатывать ошибки
accept(State = #server_state{lsocket=LSocket, loop = Loop}) ->
    proc_lib:spawn(?MODULE, accept_loop, [{self(), LSocket, Loop}]),
    State.

% Ёто здесь только дл€ того чтобы скрыть предупреждени€
handle_call(_Msg, _Caller, State) -> {noreply, State}.
handle_info(_Msg, Library) -> {noreply, Library}.
terminate(_Reason, _Library) -> ok.
code_change(_OldVersion, Library, _Extra) -> {ok, Library}.
