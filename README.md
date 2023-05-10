## Second commit
Example run:

* Compile and start
$ make all

```
$ make all
rm -f ebin/*.beam
cp -rf src/pingpong.app.src ebin/pingpong_app.app
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
* Explanation (Before BONUS) `git checkout before_bonus`

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
