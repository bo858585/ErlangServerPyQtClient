-module(echo_server).

-export([start/1, loop/1]).

% Старт эхо-сервера
start(Port) ->
    socket_server:start(?MODULE, Port, {?MODULE, loop}).

loop(Socket) ->
    case gen_tcp:recv(Socket, 0) of
        {ok, Data} ->            
            io:format("Data ~p~n",[Data]),
            if 
                Data == <<"stop">> ->
                    io:format("Exit ~p~n",[Data]),
                    gen_tcp:close(Socket),
                    exit("Client said stop."),  
                    io:format("You don't  ~p~n",[Data]);
                true ->
                gen_tcp:send(Socket, Data),
	            io:format("Sended ~p~n",[Data]),
	            loop(Socket) 
            end;
        {error, closed} ->
            ok
    end.