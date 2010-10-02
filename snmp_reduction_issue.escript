#!/usr/bin/env escript
%% -*- erlang -*-
%%! -config app.config
main([StopAt]) ->
    run(list_to_integer(StopAt));
main([]) ->
    run(4294967295).

run(StopAt) ->
    application:start(mnesia),
    application:start(snmp),
    otp_mib:load(snmp_master_agent),
    compile:file(reds),
    code:load_file(reds),
    reds:reduce(StopAt),
    {value, OID} = snmpa:name_to_oid(erlNodeReductions),
    snmpa:get(snmp_master_agent, [OID ++ [1]]).
