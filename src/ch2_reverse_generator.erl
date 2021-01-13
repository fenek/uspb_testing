-module(ch2_reverse_generator).

-include_lib("eunit/include/eunit.hrl").

-export([reverse/1]).

%% This one most likely will be located in another module!
-export([reverse_nonlist/0]).

reverse([]) -> [];
reverse([H|T]) ->
    reverse(T) ++ [H].

reverse_nonlist() ->
    ?assertException(_, function_clause, reverse(bazinga)).

groundhog_day_test_() ->
    [
     [
      ?_assertEqual([], reverse([])),
      fun() -> ?assertEqual([1,2,3], reverse([3,2,1])) end
     ],
     {?MODULE, reverse_nonlist}
    ].
