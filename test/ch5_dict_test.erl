-module(ch5_dict_test).

-include_lib("proper/include/proper.hrl").

% proper:quickcheck(ch5_dict_test:prop_x()).
prop_x() ->
  ?FORALL(D, dict_x(), some_failing_property(D)).

dict_x() ->
  ?LAZY(
     oneof([dict:new(),
            ?LET(D, dict_x(), dict:store(int(), int(), D))])).

% proper:quickcheck(ch5_dict_test:prop_y()).
prop_y() ->
  ?FORALL(D, dict_y(), some_failing_property(eval(D))).

dict_y() ->
  ?LAZY(
    oneof([{call, dict, new, []},
           {call, dict, store, [int(), int(), dict_y()]}])).

some_failing_property(Dict) ->
  dict:size(Dict) < 5.
