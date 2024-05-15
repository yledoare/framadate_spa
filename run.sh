docker cp config.php framadate-php:/var/www/framadate/app/inc/config.php
docker cp sql.sh framadate-php:/root/
docker exec framadate-php bash /root/sql.sh
