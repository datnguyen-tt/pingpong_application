## Second commit
Example run:

* Compile and start
$ make all

```
$ make all
rm -f ebin/*.beam
cp -rf src/pmkingpong.app.src ebin/pingpong_app.app
erlc -o ebin src/*.erl
erl -pa ebin -name test@local -setcookie mycookie
Erlang/OTP 22 [erts-10.7.2.18] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [dtrace]

Eshell V10.7.2.18  (abort with ^G)
(test@local)1>
```

* Start app
```
(test@local)1> application:start(pingpong_app).
ok
```

* Send a `ping` message to pingpongA
```
pingpongA:message(ping).
```

* Result: Sequence of messages
```
 Starting pingpong...: [1,2,3,4,5] [a,b,c,d,e]
 A -> B: [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1
 A -> B: [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 0
 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 1ok

 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 2
 A -> B: [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1
 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 1
 A -> B: [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2(test@local)3>
 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 2
 A -> B: [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 3
 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 3
 A -> B: [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 4
 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 4
 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 5
 A -> B: [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 5
 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 4
 A -> B: [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 8
 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 5
 A -> B: [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 9
 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 6
 A -> B: [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 10
 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 7
 A -> B: [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 11
 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 8
 A -> B: [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 12
 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 9
 A -> B: [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 13
 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 10
 A -> B: [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 14
 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 11
 A -> B: [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 15
 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 12
 A -> B: [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 16
 B -> A: #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 13
 ....
 ```

* Explanation (Before BONUS) : `git checkout before_bonus`
. At begining, the queue of two servers increase quickly.
```
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 2
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 3
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 3
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 4
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 4
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 5
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 5
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 6
 ```

. When one server reach the RECUDE_LIMIT(1000) (B server for example), that server will send out message slower than the other one (A server)
```
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 951
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 952
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 997
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 951
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 952
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1000
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 951
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1003
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1002
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 953
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1003
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 953
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1004
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 953
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 953
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1007
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 952
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1008
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 952
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1009
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 952
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1010
 ```

. The behavior is the Queue of A server will keep around ~950 (less than 1000) and the Queue of B server keep increase (because A not reach REDUCE_LIMIT, so it keep send duplicated message to B)
```
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1028
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 952
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1029
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 952
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1030
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 952
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1031
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 952
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1032
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 952
 ```

. When B server reach STOP_LIMIT (2000), it stop push message to A, the Queue of A server start reduce. The Queue of B server will continue increase because A still keep send dupicated messages to B
 ```
  A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2009
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 909
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2010
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 908
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2011
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 907
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2012
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 906
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2013
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 905
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2014
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 904
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2015
 ```

. When the Queue of A server is 0, then Queue of B start reduce as B is dropping the message and no more message from A server
```
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 3
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 2
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 1
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 0
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 3003
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 3008
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 3007
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 3006
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 3005
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 3004
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 3003
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 3002
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 3001
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 3000
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2999
 ```

 . When Queue of B under STOP_LIMIT (2000). B now again send messages to A, A when receive ping message will send dupcated messagae to B.
 It will make Queue of B reach the STOP_LIMIT
 ```
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2004
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2003
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2002
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2001
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2000
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1999
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 0
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1998
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 0
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 1999
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 0
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2000
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 0
 A -> B(pingpongB): [1,2,3,4,5][a,b,c,d,e]......QUEUE_B: 2001
 B -> A(pingpongA): #{1 => a,2 => b,3 => c,4 => d,5 => e}......QUEUE_A: 0
 ```

. A and B servers keep repeat that behavior. The result is Queue of B server will keep ~2000 and Queue of A server ~0


## BONUS 1

Start sereral triggers after start application:
```
λ ~ make
rm -f ebin/*.beam
mkdir -p ebin
cp -rf src/pingpong.app.src ebin/pingpong_app.app
erlc -o ebin src/*.erl
erl -pa ebin -name test@local -setcookie mycookie
Erlang/OTP 22 [erts-10.7.2.18] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [dtrace]

Eshell V10.7.2.18  (abort with ^G)
(test@local)1> application:start(pingpong_app).
ok
(test@local)2> pingpongA:rand_trigger().

 Starting pingpong...PING MESSAGE: #{b => 8,c => 88,d => 13,g => 12,h => 9,
                                     j => 87,k => 66,l => 97,m => 48,n => 32,
                                     o => 40,r => 75,s => 5,t => 16,u => 55,
                                     v => 34,w => 75,x => 39,y => 34,z => 34,
                                     '{' => 95}ok
(test@local)3> pingpongA:rand_trigger().

 Starting pingpong...PING MESSAGE: #{c => 17,e => 18,i => 17,j => 24,k => 30,
                                     s => 53}ok
(test@local)4> pingpongA:rand_trigger().

 Starting pingpong...PING MESSAGE: #{b => 25,c => 30,d => 78,e => 55,f => 75,
                                     g => 35,j => 11,k => 27,l => 68,m => 63,
                                     n => 9,o => 12,p => 100,q => 4,r => 43,
                                     s => 91,t => 96,u => 18,v => 82,w => 92,
                                     x => 28,y => 50,'{' => 99}ok
(test@local)5> pingpongA:rand_trigger().

 Starting pingpong...PING MESSAGE: #{b => 61,c => 80,d => 68,e => 4,f => 55,
                                     g => 80,h => 46,i => 83,j => 30,k => 58,
                                     l => 6,m => 9,n => 1,o => 64,p => 78,
                                     q => 54,r => 5,s => 73,t => 56,u => 28,
                                     v => 74,w => 50,x => 91,y => 73,z => 93,
                                     '{' => 52}ok
```
This will generate random map as a PING message that send to A server.
More than one trigger with different length in lists can be created.

* Turn on log for A and B servers
```
(test@local)6> logger:set_module_level([pingpongA, pingpongB], debug).

(test@local)7> =DEBUG REPORT==== 10-May-2023::21:51:21.550692 ===

 B -> A(pingpongA): #{e => 28,f => 47,g => 97,h => 39,j => 32,k => 69,l => 24,
                      m => 96,n => 5,p => 55,s => 41,w => 89,x => 36,y => 91}......QUEUE_A: 29
=DEBUG REPORT==== 10-May-2023::21:51:21.550935 ===

 B -> A(pingpongA): #{e => 28,f => 47,g => 97,h => 39,j => 32,k => 69,l => 24,
                      m => 96,n => 5,p => 55,s => 41,w => 89,x => 36,y => 91}......QUEUE_A: 28
=DEBUG REPORT==== 10-May-2023::21:51:21.550987 ===

 B -> A(pingpongA): #{e => 28,f => 47,g => 97,h => 39,j => 32,k => 69,l => 24,
                      m => 96,n => 5,p => 55,s => 41,w => 89,x => 36,y => 91}......QUEUE_A: 27
=DEBUG REPORT==== 10-May-2023::21:51:21.551023 ===

 B -> A(pingpongA): #{e => 28,f => 47,g => 97,h => 39,j => 32,k => 69,l => 24,
                      m => 96,n => 5,p => 55,s => 41,w => 89,x => 36,y => 91}......QUEUE_A: 26
```
