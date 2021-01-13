-module(ch3_example_SUITE).

-include_lib("common_test/include/ct.hrl").

-export([all/0]).            % CT callbacks
-export([test1/1, test2/1]). % Tests

all() -> [test1, test2].

test1(Config) ->
  1 = 1.

test2(_Config) ->
  A = 0,
  1/A.
