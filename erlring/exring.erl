-file("lib/exring.ex", 1).

-module('Elixir.ExRing').

-compile([no_auto_import, native]).

-spec start({integer(), integer()}) -> {integer(),
                                        integer()}.

-spec node_spawn(pid()) -> pid().

-spec create_ring(number()) -> pid().

-spec chain(pid(), number()) -> pid().

-export(['__info__'/1,
         create_ring/1,
         process_node/1,
         run/2,
         start/1]).

-spec '__info__'(attributes |
                 compile |
                 functions |
                 macros |
                 md5 |
                 exports_md5 |
                 module |
                 deprecated |
                 struct) -> any().

'__info__'(module) -> 'Elixir.ExRing';
'__info__'(functions) ->
    [{create_ring, 1},
     {process_node, 1},
     {run, 2},
     {start, 1}];
'__info__'(macros) -> [];
'__info__'(struct) -> nil;
'__info__'(exports_md5) ->
    <<"YîL\003Á\236V.í¸\007Zr+\234">>;
'__info__'(Key = attributes) ->
    erlang:get_module_info('Elixir.ExRing', Key);
'__info__'(Key = compile) ->
    erlang:get_module_info('Elixir.ExRing', Key);
'__info__'(Key = md5) ->
    erlang:get_module_info('Elixir.ExRing', Key);
'__info__'(deprecated) ->
    [].

 chain(_parent@1, 0) -> _parent@1;
 chain(_parent@1, _n@1) ->
     chain(node_spawn(_parent@1), _n@1 - 1).

create_ring(_n@1) -> chain(erlang:self(), _n@1).

node_spawn(_dst@1) ->
    erlang:spawn('Elixir.ExRing', process_node, [_dst@1]).

process_node(_dst@1) ->
    receive _msg@1 -> erlang:send(_dst@1, _msg@1 + 1) end,
    process_node(_dst@1).

run(__ring@1, 0) -> 0;
run(_ring@1, _step@1) ->
    erlang:send(_ring@1, 0),
    receive _ -> run(_ring@1, _step@1 - 1) end.

start({_n@1, _m@1}) ->
    {_creation_time@1, _ring@1} = timer:tc('Elixir.ExRing', create_ring, [_n@1]),
    {_run_time@1, 0} = timer:tc('Elixir.ExRing', run, [_ring@1, _m@1]),
    {_creation_time@1, _run_time@1}.
