build:
	jekyll ../public

update: 
	echo `date`." - Fetching updates..." >> logs
	rake social

deploy:
	$(MAKE) build

setup:
	mkdir -p _posts
	$(MAKE) update
	$(MAKE) build

