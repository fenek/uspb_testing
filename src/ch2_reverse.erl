-module(ch2_reverse).

-include_lib("eunit/include/eunit.hrl").

-export([reverse/1]).

reverse([]) -> [];
reverse([H|T]) ->
    [reverse(T)|H].

reverse_empty_test() ->
    [] = reverse([]).
reverse_one_test() ->
    [1] = reverse([1]).
reverse_many_test() ->
    [3,2,1] = reverse([1,2,3]).
reverse_nonlist_test() ->
    {'EXIT', {function_clause, _}} = (catch reverse(bazinga)).

