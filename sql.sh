DB_HOST=$(grep DB_HOST /var/www/framadate/app/inc/config.php | cut -d"'" -f2)
DB_NAME=$(grep DB_NAME /var/www/framadate/app/inc/config.php | cut -d"'" -f2)
DB_USER=$(grep DB_USER /var/www/framadate/app/inc/config.php | cut -d"'" -f2)
DB_PASSWORD=$(grep DB_PASSWORD /var/www/framadate/app/inc/config.php | cut -d"'" -f2)

for poll in the-poll-name
do
  NEXT=$((7 * 86400))
  JOUR=`date +'%u'`
  choice="Entrainement"
  [ "$JOUR" = 1 ] && continue
  [ "$JOUR" = 3 ] && continue
  [ "$JOUR" = 4 ] && continue
  [ "$JOUR" = 6 ] && continue
  [ "$JOUR" = 7 ] && choice="Entrainement, course"

  mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "select count(*) from fd_slot where title < (UNIX_TIMESTAMP() - 86400) and poll_id='$poll'" | grep 0 || -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "update fd_vote set choices=substring(choices,2,100)"
  mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "delete from fd_slot where title <  (UNIX_TIMESTAMP() -  86400) and poll_id='$poll'"
    echo $NEXT
  mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "INSERT INTO fd_slot(id,poll_id,title,moments) SELECT MAX( id ) + 1, '$poll',  UNIX_TIMESTAMP() + $NEXT , '$choice' FROM fd_slot" || mysql -h $DB_HOST -u $DB_USER -pDB_PASSWORD $DB_NAME -e "INSERT INTO fd_slot(id,poll_id,title,moments) 1, '$poll',  UNIX_TIMESTAMP() + $NEXT , '$choice' FROM fd_slot"
done
