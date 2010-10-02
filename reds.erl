-module(reds).
-compile([export_all]).

reduce(NumReds) ->
    {Total,_} = erlang:statistics(reductions),
    gen_reductions(Total+NumReds, 0).

gen_reductions(StopAt, Count) ->
    {Total,_} = erlang:statistics(reductions),
    case Total >= StopAt of
        true ->
            io:format("Reached ~p reductions\n", [StopAt]);
        false ->
            erlang:bump_reductions(StopAt),
            case Count of
                100000 ->
                    io:format("~p reductions < ~p stop\n", [Total, StopAt]),
                    gen_reductions(StopAt, 0);
                _ ->
                    gen_reductions(StopAt, Count + 1)
            end
    end.
