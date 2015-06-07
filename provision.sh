#! /bin/bash
sudo apt-get update 
sudo apt-get upgrade 

# Nom utilisateur
user=vagrant
# Nom de domaine
nom_domaine=dev.com
# Mot de passe utilisateur
password=vagrant
# Mot de passe root de mysql
mdp_mysql_root = root
# Définit le répertoire de base de l'utilisateur
rep=/home/$user
# -----------------------------------------------------------------------------------------------------
#                                               Configuration d'apache
#-----------------------------------------------------------------------------------------------------

sudo apt-get install  -y apache2
mkdir /home/$user/public_html
sudo usermod -aG www-data $user
chmod -R 755 $rep

# 
# 		# Crée le fichier de configuration du répertoire virtuel
# sudo 		echo "
# <VirtualHost *>
# 
#         ServerAdmin postmaster@$nom_domaine
#         ServerName www.$nom_domaine
#         ServerAlias $nom_domaine *.$nom_domaine
# 
#         DocumentRoot /home/$user/public_html/
# 
#         <Directory /home/$user/public_html/>
#                 Options -Indexes FollowSymLinks MultiViews
#                 AllowOverride All
#         </Directory>
# 
#         ErrorLog /home/$user/logs/error.log
#         LogLevel warn
#         CustomLog /home/vagrant/logs/access.log combined
# 
#         ServerSignature Off
# 
# </VirtualHost>
# 
# 
# " >> /etc/apache2/sites-available/$nom_domaine
# sudo ln -s /etc/apache2/sites-available/$nom_domaine /etc/apache2/sites-enabled/$nom_domaine
# 	
 sudo /etc/init.d/apache2 restart
# 
# -----------------------------------------------------------------------------------------------------
#                                               Configuration de php
#-----------------------------------------------------------------------------------------------------


sudo apt-get install -y  php5 libapache2-mod-php5 php5-mysql php5-common php5-curl
sudo apt-get install -y php-apc


sudo apt-get install -y mysql-server 
sudo /etc/init.d/mysqld start
sudo /usr/bin/mysqladmin -u root password 'root'






