PROJECT_PATH=/home/azer/www/azer.kodfabrik.com/src
TARGET_PATH=/home/azer/www/azer.kodfabrik.com/public

all:
	jekyll

deploy: 
	cp -rf * /home/azer/www/azer.kodfabrik.com/src/.

up: 
	rake social
