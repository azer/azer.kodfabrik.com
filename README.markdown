This is a [Jekyll](http://github.com/mojombo/jekyll) project template that provides a Rake command to retrieve and
save recent social network activities as posts.

Usage Examples
==============
* [azer.kodfabrik.com](http://azer.kodfabrik.com)

First Steps
===========
```bash
$ git clone https://github.com/azer/jekyll-social-activities.git
$ cd jekyll-social-activities
$ vim config.yml # put your site info, usernames and ids into this file
$ jekyll --server 8080
$ $BROWSER localhost:8080
```

Update Automatically
====================
Since Jekyll is a static site generator, keeping the list of social network activities 
up-to-date requires us to create a cron job for it. `update.sh` can be used for this purpose, as shown below;

```bash
$ vim update.sh # edit the project path
$ crontab -e # add your cron jobs below line
0 * * * * /path/to/update.sh
~
~
```

Supported Feeds
===============
* Twitter
* Delicious
* Github
* Delicious
* LastFM
* Vimeo