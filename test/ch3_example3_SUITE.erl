-module(ch3_example3_SUITE).

-include_lib("common_test/include/ct.hrl").

-export([all/0, groups/0]).
-export([init_per_suite/1, end_per_suite/1]).
-export([init_per_group/2, end_per_group/2]).
-export([init_per_testcase/2, end_per_testcase/2]).

-export([test1/1, test2/1]).

all() ->
    [
     {group, group1},
     {group, group2}
    ].

groups() ->
    [
     {group1, [], [test1, test2]},
     {group2, [], [test1, test2]}
    ].

init_per_suite(Config) ->
    [{suite_pid, self()} | Config].

end_per_suite(Config) ->
    ct:pal("end_per_suite ~p", [self()]),
    Config.

init_per_group(Group, Config) ->
    [{group_pid, Group, self()} | Config].

end_per_group(_Group, Config) ->
    ct:pal("end_per_group ~p", [self()]),
    Config.

init_per_testcase(Case, Config) ->
    [{initcase_pid, Case, self()} | Config].

end_per_testcase(_Case, Config) ->
    ct:pal("end_per_testcase ~p", [self()]),
    Config.

test1(Config) ->
    ct:pal("test1: ~p", [sanitize([{case_pid, self()} | Config])]).

test2(Config) ->
    ct:pal("test2: ~p", [sanitize([{case_pid, self()} | Config])]).

sanitize(Config) ->
    lists:filter(fun(E) ->
                         Tag = element(1, E),
                         Tag == suite_pid orelse Tag == group_pid
                         orelse Tag == initcase_pid orelse Tag == case_pid
                 end, Config).

