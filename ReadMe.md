## Linnaeus plugins for ResourceSpace

Linnaeus uses ResourceSpace (RS; [https://www.resourcespace.com]()) to store multimedia. The link between both applications was established using plugins for the RS API. Unfortunately, the option to use API plugins was unceremoniously dumped in the RS v7.9 update. The link was re-established by a dedicated application that handles to communication between Linnaeus and RS, available at [https://github.com/naturalis/resourcespace_lng_api](). 

This docker image was created to install a recent version of RS (currently 8.6), plus the Linnaeus plugins. 


### Preparing migration

1. Create a dump of the RS MySQL database.
2. Backup the `filestore` directory and `include/config.php` file from the current RS installation.


### Migration

1. Download the ResourceSpace plugins for Linnaeus docker image. **More!**
2. cd to your docker directory and run `docker-compose up`. This installs a recent version of Apache/PHP and clean copies of ResourceSpace 8.6 and the plugins. See `Dockerfile` and `docker-entrypoint.sh` for what exactly is installed. Both the ResourceSpace and plugin web directories are mapped to the local file system (as `www`), simplifying migration.
3. Rename a copy of `env.template` to .env and copy the settings from the RS config.php **except** `MYSQL_HOST=db`. 
4. Copy files from the backed up `filestore` to `www/html/resourcespace/filestore` and make sure this directories is writable (`chmod 777` according to RS instructions). Apparently RS does not acknowledge a symbolic link as a valid directory...
5. Copy the RS `config.php` file to `www/html/resourcespace/include`. Line 12 should be changed to `$mysql_server = 'db';` (**not** localhost or 127.0.0.1!).
6. The plugins only work when they can access the RS `config.php` file. This path should be exposed through a `config.php` file for the plugins. In `resourcespace_lng_api.git/trunk`, rename a copy of `config.php.tpl` to `config.php` and make sure it includes the line `$rsConfigPath = '/var/www/html/resourcespace/include/config.php';`.
7. Import the database: copy the dump to `mysql/dump`. Run `docker-compose exec db bash`, long in to MySQL (the root password is set in the `.env` file) and import the data into the already existing resourcespace database. The dump path above is mapped to `/tmp` in the MySQL docker image, so: `mysql source /tmp/[your_dump.sql];`
8. Open the base path in `include/config.php` in your browser. After a successful login as admin, the database will be automatically updated.
9. Open http://[base_path]/plugins/api_upload_lng/ in your browser. If you are greeted with "error": "Error! No api key provided", your installation was successful!