-module(ch4_inet_server_utils).

-export([ request/2
        ]).

request(Url, Timeout) ->
  Headers = [{"User-Agent", "Erlang httpc"}],
  Request = {Url, Headers},
  HTTPOptions = [{timeout, Timeout * 1000}],
  Options = [{full_result, false}],
  case httpc:request(get, Request, HTTPOptions, Options) of
    {ok, {200, Body}} -> {ok, Body};
    {ok, Else} -> {error, Else};
    Else -> Else
  end.
