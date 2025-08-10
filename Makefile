.PHONY: checks
checks:
	bash ./checks.sh

.PHONY: start
start: checks
	bash ./start.sh

.PHONY: stop
stop: checks
	bash ./stop.sh

.PHONY: restart
restart:
	bash ./stop.sh
	bash ./start.sh