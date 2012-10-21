build:
	jekyll ../public

update: 
	echo `date`." - Fetching updates..." >> logs
	rake social

deploy:
	$(MAKE) build

setup:
	$(MAKE) update
	$(MAKE) build

