-module(ch2_math_solution).

-include_lib("eunit/include/eunit.hrl").

-export([eval/1]).

eval(N) when is_number(N) -> N;
eval({add, N1, N2}) -> eval(N1) + eval(N2);
eval({sub, N1, N2}) -> eval(N1) - eval(N2);
eval({mul, N1, N2}) -> eval(N1) * eval(N2);
eval({'div', N1, N2}) -> eval(N1) div eval(N2);
eval({pow, Base, Exp}) -> pow(Base, Exp).

pow(_Base, 0) -> 1;
pow(Base, Exp) -> Base * pow(Base, Exp - 1).

number_test_() ->
    [ ?_assertEqual(N, eval(N)) || N <- lists:seq(1, 10) ].

add_test() ->
    ?assertEqual(20, eval({add, 5, 15})).

sub_test() ->
    ?assertEqual(15, eval({sub, 20, 5})).

mul_test() ->
    ?assertEqual(40, eval({mul, 4, 10})).

div_test() ->
    ?assertEqual(3, eval({'div', 27, 9})).

pow_test_() ->
    [ ?_assertEqual(trunc(math:pow(Base, Exp)), eval({pow, Base, Exp})) ||
      Base <- lists:seq(1, 10), Exp <- lists:seq(1, 4) ].

cant_divide_by_zero_test() ->
    ?assertError(badarith, eval({'div', 10, 0})).

