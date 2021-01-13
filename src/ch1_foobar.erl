-module(ch1_foobar).

-export([foobar/1]).

foobar(N) ->
    case N > 5 of
        true ->
            put(ticking_bomb, armed),
            io:format("foo", []);
        false ->
            put(ticking_bomb, defused)
    end,
    case N > 10 of
        true -> io:format("bar", []);
        false -> defused = get(ticking_bomb)
    end.
