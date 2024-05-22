DB_HOST=$(grep DB_HOST /var/www/framadate/app/inc/config.php | cut -d"'" -f2)
DB_NAME=$(grep DB_NAME /var/www/framadate/app/inc/config.php | cut -d"'" -f2)
DB_USER=$(grep DB_USER /var/www/framadate/app/inc/config.php | cut -d"'" -f2)
DB_PASSWORD=$(grep DB_PASSWORD /var/www/framadate/app/inc/config.php | cut -d"'" -f2)

CHOICE="14,16"

for poll in poll-name
do
  NEXT=$((7 * 86400))
  DAY=`date +'%u'`
  [ "$DAY" = 2 ] && continue
  [ "$DAY" = 7 ] && continue

   mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "select count(*) from fd_slot where title < (UNIX_TIMESTAMP() - 172800) and poll_id='$poll'" | grep 0 || mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "update fd_vote set choices=substring(choices,2,100)"
   mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "delete from fd_slot where title <  (UNIX_TIMESTAMP() -  172800) and poll_id='$poll'"
   mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "INSERT INTO fd_slot(id,poll_id,title,moments) SELECT MAX( id ) + 1, '$poll',  UNIX_TIMESTAMP() + $NEXT, '$CHOICE' FROM fd_slot"
done
