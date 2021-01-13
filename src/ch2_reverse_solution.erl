-module(ch2_reverse_solution).

-include_lib("eunit/include/eunit.hrl").

-export([reverse/1]).

reverse([]) -> [];
reverse([H|T]) ->
    reverse(T) ++ [H].

reverse_empty_test() ->
    ?assertEqual([], reverse([])).
reverse_one_test() ->
    ?assertEqual([1], reverse([1])).
reverse_many_test() ->
    ?assertMatch([3,2,1], reverse([1,2,3])).
reverse_nonlist_test() ->
    ?assertException(_, function_clause, reverse(bazinga)).

