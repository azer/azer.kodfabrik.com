PROJECT_PATH=/home/azer/projects/homepage
TARGET_PATH=/home/azer/www/azer.kodfabrik.com/public/

cd $PROJECT_PATH
rake social
jekyll
cp -rf _site/* $TARGET_PATH/.
