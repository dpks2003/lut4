.PHONY: server new-post

server:
	hugo server --buildFuture --buildDrafts

new-post:
	@YEAR=$$(date +%Y); \
	MONTH=$$(date +%m); \
	DAY=$$(date +%d); \
	POST_DIR="content/blog/$$YEAR/$$MONTH/$$DAY/dummy"; \
	mkdir -p "$$POST_DIR"; \
	echo "+++" > "$$POST_DIR/index.md"; \
	echo "title = \"Dummy Post\"" >> "$$POST_DIR/index.md"; \
	echo "date = $$(date +%Y-%m-%d)" >> "$$POST_DIR/index.md"; \
	echo "draft = false" >> "$$POST_DIR/index.md"; \
	echo "+++" >> "$$POST_DIR/index.md"; \
	echo "" >> "$$POST_DIR/index.md"; \
	echo "Content goes here" >> "$$POST_DIR/index.md"; \
	echo "Created new post at $$POST_DIR/index.md"
