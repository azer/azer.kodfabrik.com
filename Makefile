all:
	echo `date`." - Building the site... - ".`ruby --version` >> logs
	jekyll

update: 
	echo `date`." - Fetching updates..." >> logs
	rake social
