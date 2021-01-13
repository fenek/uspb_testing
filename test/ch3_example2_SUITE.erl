-module(ch3_example2_SUITE).

-include_lib("common_test/include/ct.hrl").

-export([all/0, init_per_testcase/2, end_per_testcase/2]).

-export([ets_tests/1]).

all() -> [ets_tests].

init_per_testcase(ets_tests, Config) ->
    TabId = ets:new(test, [ordered_set, public]),
    ets:insert(TabId, {alison, 10}),
    ets:insert(TabId, {fred, 12}),
    ets:insert(TabId, {mark, 65}),
    [{table,TabId} | Config].

end_per_testcase(ets_tests, Config) ->
    ets:delete(?config(table, Config)).

ets_tests(Config) ->
    TabId = ?config(table, Config),
    [{alison, 10}] = ets:lookup(TabId, alison),
    mark = ets:last(TabId),
    true = ets:insert(TabId, {zachary, 99}),
    zachary = ets:last(TabId).
