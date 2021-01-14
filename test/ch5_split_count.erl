-module(ch5_split_count).

-include_lib("proper/include/proper.hrl").

prop_split() ->
  ?FORALL({C,S}, {char(), non_empty(list(char()))},
          length(string:tokens(S,[C])) == count(C,S)).

count(Char, [Char]) -> 0; %% Only delimiter
count(Char, String) -> count(Char, String, {Char, 1}).

count(_, [], {_Prev,N}) -> N; %% Base
count(C, [C], {_Prev,N}) -> N; %% Ends in delimiter
count(C, [C|T], {C,N}) -> count(C, T, {C,N}); %% CC
count(C, [C|T], {_Prev,N}) -> count(C, T, {C, N+1});
count(C, [New|T], {_Old,N}) -> count(C, T, {New, N}).
