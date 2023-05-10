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
