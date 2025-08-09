.PHONY: start
start:
	bash ./start.sh

.PHONY: stop
stop:
	bash ./stop.sh

.PHONY: restart
restart:
	bash ./stop.sh
	bash ./start.sh