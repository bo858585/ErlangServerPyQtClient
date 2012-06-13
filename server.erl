-module(server).

-export([start/0, loop0/1, proc_client/1,stop/0]).

-define(PORTNO, 54400).

start() ->
start(?PORTNO).

start(Pno) ->
erlang:register(server,spawn(?MODULE, loop0, [Pno])).

stop()->
exit(erlang:whereis(server),user_reason).

loop0(Port) ->
case gen_tcp:listen(Port, [binary, {packet, 0}, {active, false}]) of
{ok, LSock} ->
io:format("Listen socket created ~n",[]),
loop(LSock);
Er ->
io:format("Error : ~p~n",[Er]),
stop
end.

loop(Listen) ->
case gen_tcp:accept(Listen) of
{ok, S} ->
io:format("Acepted~n",[]),
spawn(?MODULE, proc_client, [S]),
loop(Listen);
_ ->
loop(Listen)
end.

proc_client(Client) ->
case gen_tcp:recv(Client, 0) of
{ok, R_ret} ->
io:format("Server : Recieved ~p~n",[R_ret]),
gen_tcp:send(Client, R_ret),
proc_client(Client);
{error, _} ->
gen_tcp:close(Client)
end.