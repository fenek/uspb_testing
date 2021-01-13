-module(ch3_math_server).

-behaviour(gen_server).

-export([ start_link/0
          , eval/1
          , stats/0
        ]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-define(SERVER, ?MODULE).

%% API
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

eval(Math) ->
    gen_server:call(?SERVER, {eval, Math}).

stats() ->
    gen_server:call(?SERVER, stats).

%% gen_server callbacks
init([]) ->
    State =
    #{ fail => 0
       , success => 0
     },
    {ok, State}.

handle_call({eval, Math}, _From, State) ->
    #{ fail := Fail, success := Success } = State,
    {Response, NewState} =
    try ch2_math_solution:eval(Math) of
        Response0 -> {{ok, Response0}, State#{success => Success + 1}}
    catch
        C:R:S ->
            {{error, {C, R, S}}, State#{fail => Fail + 1}}
    end,
    {reply, Response, NewState};
handle_call(stats, _From, State) ->
    {reply, {ok, State}, State};
handle_call(_Request, _From, State) ->
    {reply, {error, bad_call}, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% Internal functions
