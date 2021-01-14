-module(fake).
%% Just a helper for meck chapter

-export([f/0, do/1, y/0]).

f() ->
    throw(not_implemented).

do(_) ->
    throw(not_implemented).

y() ->
    throw(not_implemented).
