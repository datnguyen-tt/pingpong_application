all: clean build start

clean:
	rm -f ebin/*.beam

build:
	mkdir -p ebin
	cp -rf src/pingpong.app.src ebin/pingpong_app.app
	erlc -o ebin src/*.erl

start:
	erl -pa ebin -name test@local -setcookie mycookie
