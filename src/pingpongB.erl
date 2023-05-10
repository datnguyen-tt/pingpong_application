-define(IO_TRACE_DEBUG, true).
-define(iotd(Fmt), erl_trace(Fmt, [?MODULE, ?FUNCTION_NAME, ?LINE], {io, simple})).
-define(iotd(Fmt, Args), erl_trace(Fmt, [?MODULE, ?FUNCTION_NAME, ?LINE] ++ Args, {io, simple})).
-define(iotdd(Fmt), erl_trace(Fmt, {io, [?MODULE, ?FUNCTION_NAME, ?LINE],complex})).
-define(iotdd(Fmt, Args), erl_trace(Fmt, [?MODULE, ?FUNCTION_NAME, ?LINE] ++ Args, {io, complex})).
-define(cttd(Fmt), erl_trace(Fmt, [?MODULE, ?FUNCTION_NAME, ?LINE], {ct, simple})).
-define(cttd(Fmt, Args), erl_trace(Fmt, [?MODULE, ?FUNCTION_NAME, ?LINE] ++ Args, {ct, simple})).
-define(cttdd(Fmt), erl_trace(Fmt, {ct, [?MODULE, ?FUNCTION_NAME, ?LINE],complex})).
-define(cttdd(Fmt, Args), erl_trace(Fmt, [?MODULE, ?FUNCTION_NAME, ?LINE] ++ Args, {ct, complex})).

%%%-------------------------------------------------------------------
%%% @author Dat Nguyen <datnguyen@DATNGUYEN-M1.local>
%%% @copyright (C) 2023, Dat Nguyen
%%% @doc
%%%
%%% @end
%%% Created : 10 May 2023 by Dat Nguyen <datnguyen@DATNGUYEN-M1.local>
%%%-------------------------------------------------------------------
-module(pingpongB).

-behaviour(gen_server).

-include_lib("kernel/include/logger.hrl").

%% API
-export([start_link/0]).
-export([stop/0]).
-export([create_map/2, get_queue/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3, format_status/2]).

-define(SERVER, ?MODULE).

-record(state, {}).


-define(RECUDE_LIMIT, 1000).
-define(STOP_LIMIT, 2000).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%% @end
%%--------------------------------------------------------------------
-spec start_link() -> {ok, Pid :: pid()} |
          {error, Error :: {already_started, pid()}} |
          {error, Error :: term()} |
          ignore.
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

stop() ->
    gen_server:cast(?MODULE, stop).

create_map(List1, List2) ->
    gen_server:call(?MODULE, {create_map, List1, List2}).

get_queue() ->
    gen_server:call(?MODULE, {cmd, get_queue}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%% @end
%%--------------------------------------------------------------------
-spec init(Args :: term()) -> {ok, State :: term()} |
          {ok, State :: term(), Timeout :: timeout()} |
          {ok, State :: term(), hibernate} |
          {stop, Reason :: term()} |
          ignore.
init([]) ->
    process_flag(trap_exit, true),
    {ok, #state{}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%% @end
%%--------------------------------------------------------------------
-spec handle_call(Request :: term(), From :: {pid(), term()}, State :: term()) ->
          {reply, Reply :: term(), NewState :: term()} |
          {reply, Reply :: term(), NewState :: term(), Timeout :: timeout()} |
          {reply, Reply :: term(), NewState :: term(), hibernate} |
          {noreply, NewState :: term()} |
          {noreply, NewState :: term(), Timeout :: timeout()} |
          {noreply, NewState :: term(), hibernate} |
          {stop, Reason :: term(), Reply :: term(), NewState :: term()} |
          {stop, Reason :: term(), NewState :: term()}.

handle_call({cmd, get_queue}, _From, State) ->
    Return = current_queue(),
    {reply, Return, State};
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%% @end
%%--------------------------------------------------------------------
-spec handle_cast(Request :: term(), State :: term()) ->
          {noreply, NewState :: term()} |
          {noreply, NewState :: term(), Timeout :: timeout()} |
          {noreply, NewState :: term(), hibernate} |
          {stop, Reason :: term(), NewState :: term()}.
handle_cast({cast_msg, List1, List2}, State) ->
    QueueCnt = current_queue(),
    ?LOG_DEBUG("~n A -> B(~p): ~p~p......QUEUE_B: ~p", [erl_trace_process_info(), List1, List2, QueueCnt]),
    case QueueCnt > ?STOP_LIMIT of
        true ->
            %% Stop sending out
            ok;
        false ->
            Map = do_create_map(List1, List2),
            ReMsg = {cast_msg, List1, List2, Map},
            case QueueCnt > ?RECUDE_LIMIT of
                true ->
                    gen_server:cast(pingpongA, ReMsg);
                false ->
                    gen_server:cast(pingpongA, ReMsg),
                    gen_server:cast(pingpongA, ReMsg)
            end
    end,
    {noreply, State};
handle_cast(stop, State) ->
    {stop, normal, State};
handle_cast(_Request, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%% @end
%%--------------------------------------------------------------------
-spec handle_info(Info :: timeout() | term(), State :: term()) ->
          {noreply, NewState :: term()} |
          {noreply, NewState :: term(), Timeout :: timeout()} |
          {noreply, NewState :: term(), hibernate} |
          {stop, Reason :: normal | term(), NewState :: term()}.
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%% @end
%%--------------------------------------------------------------------
-spec terminate(Reason :: normal | shutdown | {shutdown, term()} | term(),
                State :: term()) -> any().
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%% @end
%%--------------------------------------------------------------------
-spec code_change(OldVsn :: term() | {down, term()},
                  State :: term(),
                  Extra :: term()) -> {ok, NewState :: term()} |
          {error, Reason :: term()}.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called for changing the form and appearance
%% of gen_server status when it is returned from sys:get_status/1,2
%% or when it appears in termination error logs.
%% @end
%%--------------------------------------------------------------------
-spec format_status(Opt :: normal | terminate,
                    Status :: list()) -> Status :: term().
format_status(_Opt, Status) ->
    Status.

%%%===================================================================
%%% Internal functions
%%%===================================================================
current_queue() ->
    {message_queue_len, QueueCnt} = erlang:process_info(self(), message_queue_len),
    QueueCnt.

do_create_map(List1, List2) ->
    do_create_map(List1, List2, maps:new()).

do_create_map([], [], Map) ->
    Map;
do_create_map([Key | Keys], [Val | Vals], Map) ->
    NewMap = maps:put(Key, Val, Map),
    do_create_map(Keys, Vals, NewMap).

%% erl-trace support functions
-ifdef(IO_TRACE_DEBUG).
erl_trace(Fmt, Args, {Type, Level}) ->
    case ?IO_TRACE_DEBUG of
        true ->
            {FullFmt, FullArgs} =
                case Level of
                    simple -> {"~p:~p:~p "++Fmt, Args};
                    complex -> {"~p:~p:~s:~p:~p:~p: "++Fmt++"~n",
                                [erl_trace_process_info(),
                                 erl_trace_get_user(),
                                 erl_trace_timestamp()] ++ Args}
                end,
            case Type of
                io -> io:format(FullFmt, FullArgs);
                ct -> ct:pal(FullFmt, FullArgs)
            end;
        false -> ok
    end.

erl_trace_process_info() ->
    proplists:get_value(registered_name, process_info(self()), self()).

erl_trace_get_user() ->
    string:strip(os:cmd("id -F"), right, $\n).

erl_trace_timestamp() ->
    {MS, S, US} = os:timestamp(),
    {_, {Hour, Min, Sec}} = calendar:now_to_local_time({MS, S, US}),
    MSec = trunc(US/1000),
    lists:flatten(io_lib:format("~2.10.0B:~2.10.0B:~2.10.0B.~3.10.0B",
                                [Hour, Min, Sec, MSec])).
-endif.
