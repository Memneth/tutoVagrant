#! /usr/bin/env bash
 
# Variables
APPENV=local
DBHOST=localhost
DBNAME=dbname
DBUSER=dbuser
DBPASSWD=root
 
echo -e "\n--- Mkay, installing now... ---\n"
 
echo -e "\n--- Updating packages list ---\n"
sudo apt-get -qq update
 

 
echo -e "\n--- Install MySQL specific packages and settings ---\n"
echo "mysql-server mysql-server/root_password password $DBPASSWD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections
apt-get -y install mysql-server-5.5 phpmyadmin > /dev/null 2>&1
 
echo -e "\n--- Setting up our MySQL user and db ---\n"
mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME"
mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD'"
 
echo -e "\n--- Installing PHP-specific packages ---\n"
sudo apt-get -y install  apache2 > /dev/null 2>&1
sudo apt-get -y install libapache2-mod-php5 php5 php5-common php5-curl php5-dev php5-gd php-apc php5-idn php-pear php5-imagick php5-imap php5-json php5-mcrypt php5-memcache php5-mhash php5-ming php5-mysql php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl
echo -e "\n--- Enabling mod-rewrite ---\n"
sudo a2enmod rewrite > /dev/null 2>&1

sudo ln -s /etc/share/phpmyadmin /var/www/phpmyadmin
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf.d/phpmyadmin.conf

echo -e "\n--- Allowing Apache override to all ---\n"
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
 

 
echo -e "\n--- We definitly need to see the PHP errors, turning them on ---\n"
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
 
#echo -e "\n--- Turn off disabled pcntl functions so we can use Boris ---\n"
#sudo sed -i "s/disable_functions = .*//" /etc/php5/cli/php.ini
 
sudo sed  "/<Directory \/usr\/share\/phpmyadmin>/a\Order Allow,Deny \n Allow from All " /etc/apache2/conf.d/phpmyadmin.conf

sudo a2enmod userdir 
#TODO
sudo sed "/11,15/d" /etc/apache2/mods-available/php5.conf

sudo /etc/init.d/apache2 restart > /dev/null 2>&1

echo -e "\n--- Add environment variables locally for artisan ---\n"
#cat >> /home/vagrant/.bashrc <<EOF

# Set envvars
#export APP_ENV=$APPENV
#export DB_HOST=$DBHOST
#export DB_NAME=$DBNAME
#export DB_USER=$DBUSER
#export DB_PASS=$DBPASSWD
#EOF





