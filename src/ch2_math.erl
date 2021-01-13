-module(ch2_math).

-export([eval/1]).

eval(N) when is_number(N) -> N;
eval({add, N1, N2}) -> eval(N1) + eval(N2);
eval({sub, N1, N2}) -> eval(N1) - eval(N2);
eval({mul, N1, N2}) -> eval(N1) * eval(N2);
eval({'div', N1, N2}) -> eval(N1) div eval(N2);
eval({pow, _N1, _N2}) -> 1.

