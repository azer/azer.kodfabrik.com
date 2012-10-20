PROJECT_PATH=/home/azer/www/azer.kodfabrik.com/src
TARGET_PATH=/home/azer/www/azer.kodfabrik.com/public

cd $PROJECT_PATH; \
  rake social 
cd $PROJECT_PATH & jekyll 
cd $PROJECT_PATH & cp -rf _site/* $TARGET_PATH/. 
cd $PROJECT_PATH & echo $(date)."Scheduled Build" >> $PROJECT_PATH/logs
