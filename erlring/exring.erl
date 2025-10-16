-module(exring).

-export([main/1,
         create_ring/1,
         process_node/1,
         run/2,
         start/1]).

-define(a2i(A), list_to_integer(atom_to_list(A))).

main([Nx, Mx]) ->
    N = ?a2i(Nx),
    M = ?a2i(Mx),
    {CreationTime, RunTime} = start({N, M}),
    io:format("~p ~p ~p ~p~n", [CreationTime, RunTime, N, M]).

-spec start({integer(), integer()}) -> {integer(), integer()}.
start({N, M}) ->
    {CreationTime, Ring} = timer:tc(?MODULE, create_ring, [N], millisecond),
    {RunTime, 0} = timer:tc(?MODULE, run, [Ring, M], millisecond),
    {CreationTime, RunTime}.

-spec create_ring(number()) -> pid().
create_ring(N) -> chain(self(), N).

-spec chain(pid(), number()) -> pid().
chain(Parent, 0) -> Parent;
chain(Parent, N) ->
    chain(node_spawn(Parent), N - 1).

-spec node_spawn(pid()) -> pid().
node_spawn(Dest) ->
    erlang:spawn(?MODULE, process_node, [Dest]).

process_node(Dest) ->
    receive
        Msg -> erlang:send(Dest, Msg + 1)
    end,
    process_node(Dest).

run(_Ring, 0) -> 0;
run(Ring, Step) ->
    erlang:send(Ring, 0),
    receive
        _ -> run(Ring, Step - 1)
    end.
