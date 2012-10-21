all:
	echo `date`." - Building the site..." >> logs
	jekyll

update: 
	echo `date`." - Fetching updates..." >> logs
	rake social
