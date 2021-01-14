-module(ch4_inet_server_solution_SUITE).

-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").

-export([all/0, groups/0]).
-export([init_per_suite/1, end_per_suite/1]).
-export([init_per_group/2, end_per_group/2]).
-export([init_per_testcase/2, end_per_testcase/2]).

-export([
         successful_request/1,
         success_recorded_in_stats/1,

         http_404_from_server/1,
         httpc_error/1,
         error_recorded_in_stats/1
        ]).

all() ->
    [
     {group, positive},
     {group, negative}
    ].

groups() ->
    [
     {positive, [sequence], [
                     successful_request,
                     success_recorded_in_stats
                    ]},
     {negative, [sequence], [
                     http_404_from_server,
                     httpc_error,
                     error_recorded_in_stats
                    ]}
    ].

init_per_suite(Config) ->
    application:ensure_all_started(uspb_testing),
    meck:new(httpc, [no_link, passthrough]),
    Config.

end_per_suite(Config) ->
    meck:unload(httpc),
    Config.

init_per_group(positive, Config) ->
    meck:expect(httpc, request, fun(get, _URLHeaders, _HTTPOpts, _Opts) ->
                                        {ok, {200, page_body()}}
                                end),
    Config;
init_per_group(_GN, Config) ->
    Config.

end_per_group(positive, Config) ->
    meck:delete(httpc, request, 4),
    Config;
end_per_group(_GN, Config) ->
    Config.

init_per_testcase(Case404, Config) when Case404 == http_404_from_server;
                                        Case404 == error_recorded_in_stats ->
    meck:expect(httpc, request, fun(get, _, _, _) -> {ok, 404} end),
    Config;
init_per_testcase(httpc_error, Config) ->
    meck:expect(httpc, request, fun(get, _, _, _) -> {error, nxdomain} end),
    Config;
init_per_testcase(_CN, Config) ->
    Config.

end_per_testcase(Negative, Config) when Negative == http_404_from_server;
                                        Negative == httpc_error;
                                        Negative == error_recorded_in_stats ->
    meck:delete(httpc, request, 4),
    Config;
end_per_testcase(_CN, Config) ->
    Config.

%% -------------- Test cases -----------------

successful_request(_Config) ->
    ?assertEqual({ok, page_body()}, ch4_inet_server:request(url())).

success_recorded_in_stats(_Config) ->
    with_stat_increment(success, fun() -> ch4_inet_server:request(url()) end).

http_404_from_server(_Config) ->
    ?assertEqual({error, 404}, ch4_inet_server:request(url())).

httpc_error(_Config) ->
    ?assertEqual({error, nxdomain}, ch4_inet_server:request(url())).

error_recorded_in_stats(_Config) ->
    with_stat_increment(fail, fun() -> ch4_inet_server:request(url()) end).

%% -------- Internal functions ------------

page_body() ->
    "TESTBODY".

url() ->
    "https://www.erlang-solutions.com".

with_stat_increment(Tag, Fun) ->
    {ok, Stats1} = ch4_inet_server:stats(),
    Snapshot1 = maps:get(Tag, Stats1),
    Fun(),
    {ok, Stats2} = ch4_inet_server:stats(),
    Snapshot2 = maps:get(Tag, Stats2),
    ?assertEqual(Snapshot1 + 1, Snapshot2).

