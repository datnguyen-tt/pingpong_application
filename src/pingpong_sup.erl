-module(pingpong_sup).
-behavior(supervisor).

-export([start_link/0]).
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    {ok, _} = supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    SupFlags = #{strategy => one_for_one,
                 intensity => 1,
                 period => 5},

    Achild = #{id => achildId,
                start => {pingpongA, start_link, []},
                restart => permanent,
                shutdown => 5000,
                type => worker,
                modules => [pingpongA]},

    Bchild = #{id => bchildId,
               start => {pingpongB, start_link, []},
               restart => permanent,
               shutdown => 5000,
               type => worker,
               modules => [pingpongB]},

    {ok, {SupFlags, [Achild, Bchild]}}.
