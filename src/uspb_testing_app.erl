%%%-------------------------------------------------------------------
%% @doc uspb_testing public API
%% @end
%%%-------------------------------------------------------------------

-module(uspb_testing_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    uspb_testing_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
