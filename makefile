DAYS = d_1 d_2 d_3 d_4 d_5 d_6 d_7

.PHONY: help
help:  # from https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: all
all: $(DAYS)

.PHONY: $(DAYS)
$(DAYS):
	dune build $@
	mkdir -p artifacts/$@
	cp $@/reference.txt $@/example.txt _build/default/$@/main.exe artifacts/$@/
	chmod u=rwx,g=rx,o=rx artifacts/$@/*

.PHONY: clean
clean:  
	dune clean

.PHONY: unit-test
unit-test: 
	dune runtest

.PHONY: format
format:  
	dune build @fmt --auto-promote

.PHONY: check-format
check-format:  
	dune build @fmt

.PHONY: check-lint
check-lint: 
	dune build @check @lint

.PHONY: check
check: unit-test check-format check-lint   
