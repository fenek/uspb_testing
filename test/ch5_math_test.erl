-module(ch5_math_test).

-include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").

proper_test() ->
    proper:module(?MODULE).

prop_returns_number() ->
    ?FORALL(Operation, operation(), is_number(ch2_math_solution:eval(Operation))).

prop_verify_outer() ->
    ?FORALL(Operation, operation(), verify(Operation, ch2_math_solution:eval(Operation))).

verify({add, X, Y}, Result) ->
    ch2_math_solution:eval({sub, Result, Y}) == ch2_math_solution:eval(X);
verify({sub, X, Y}, Result) ->
    ch2_math_solution:eval({add, Result, Y}) == ch2_math_solution:eval(X);
verify({mul, X, Y}, Result) ->
    ch2_math_solution:eval({'div', Result, X}) == ch2_math_solution:eval(Y);
verify({'div', X, Y}, Result) ->
    Z = ch2_math_solution:eval({mul, Y, Result}),
    Z =< ch2_math_solution:eval(X) andalso Z > ch2_math_solution:eval({mul, Y, Result - 1});
verify(Num, Result) when is_number(Num) ->
    Num == Result.

operation() ->
    ?LAZY(frequency([{10, add()}, {10, sub()}, {10, mul()}, {10, 'div'()}, {100, int()}])).

add() ->
    ?LAZY(?LET({Op1, Op2}, {operation(), operation()}, {add, Op1, Op2})).

sub() ->
    ?LAZY(?LET({Op1, Op2}, {operation(), operation()}, {sub, Op1, Op2})).

mul() ->
    ?LAZY(?LET({Op1, Op2}, {pos_int(), pos_int()}, {mul, Op1, Op2})).

'div'() ->
    ?LAZY(?LET({Op1, Op2}, {pos_int(), pos_int()}, {'div', Op1, Op2})).

pos_int() ->
    ?SUCHTHAT(I, int(), I > 0).
