-module(echo_server).

-export([start/0, loop/1]).

% Старт эхо-сервера
start() ->
    socket_server:start(?MODULE, 7001, {?MODULE, loop}).

loop(Socket) ->
    case gen_tcp:recv(Socket, 0) of
        {ok, Data} ->
            gen_tcp:send(Socket, Data),
            loop(Socket);
        {error, closed} ->
            ok
    end.