-module(ch5_pdemo).

-include_lib("proper/include/proper.hrl").

prop_one() ->
    ?FORALL(_, int(), true).

prop_two() ->
    ?FORALL(N, choose(1,1000), N =/= 418).
