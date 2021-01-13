-module(ch3_math_server_solution_SUITE).

% Yes, we can use EUnit assertions!
-include_lib("eunit/include/eunit.hrl").
-include_lib("common_test/include/ct.hrl").

-export([all/0, groups/0]).
-export([init_per_testcase/2, end_per_testcase/2]).

-export([
         do_simple_math/1,
         do_complex_math/1,
         successes_are_counted/1,
         failures_are_counted/1
        ]).

all() ->
    [
     {group, math},
     {group, stats}
    ].

groups() ->
    [
     {math, [], [
                 do_simple_math,
                 do_complex_math
                ]},
     {stats, [], [
                  successes_are_counted,
                  failures_are_counted
                 ]}
    ].

init_per_testcase(_CN, Config) ->
    ch3_math_server:start_link(),
    % If it weren't a registered process, we would pass the pid through Config
    Config.

end_per_testcase(_CN, Config) ->
    Config.

do_simple_math(_Config) ->
    ?assertEqual({ok, 4}, ch3_math_server:eval({add, 2, 2})).

do_complex_math(_Config) ->
    ?assertEqual({ok, 8}, ch3_math_server:eval({mul, 2, {add, 2, 2}})).

successes_are_counted(_Config) ->
    {ok, #{ success := SuccessSnapshot1 }} = ch3_math_server:stats(),
    ch3_math_server:eval({add, 2, 2}),
    {ok, #{ success := SuccessSnapshot2 }} = ch3_math_server:stats(),
    ?assertEqual(SuccessSnapshot1 + 1, SuccessSnapshot2).

failures_are_counted(_Config) ->
    {ok, #{ fail := FailSnapshot1 }} = ch3_math_server:stats(),
    ?assertMatch({error, _}, ch3_math_server:eval({'div', 2, 0})),
    {ok, #{ fail := FailSnapshot2 }} = ch3_math_server:stats(),
    ?assertEqual(FailSnapshot1 + 1, FailSnapshot2).

