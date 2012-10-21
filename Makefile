all:
	jekyll

update: 
	echo `date`." - Fetching updates..." >> logs
	rake social

deploy:
	jekyll ../public
