

# user targets
.PHONY: doc
doc: 
	make build/docs.timestamp

# rebuild docs
build/docs.timestamp: mkdocs.yml $(shell find docs -type f)
	mkdir -p build
	mkdocs build
	touch build/docs.timestamp
