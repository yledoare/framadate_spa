for count in 7 # 1 2 3 4 5 6 7
do
  DAY=$(($count * 86400))
  echo $DAY
  mysql -h mysql -u framadate -pframadatepasswd framadate -e "INSERT INTO fd_slot(id,poll_id,title,moments) SELECT MAX( id ) + 1, 'G5fe5WaWSB5wbkUj',  UNIX_TIMESTAMP() + $DAY + 86400, '14,16' FROM fd_slot"
  mysql -h mysql -u framadate -pframadatepasswd framadate -e "INSERT INTO fd_slot(id,poll_id,title,moments) SELECT MAX( id ) + 1, '4tHX6pHNQG99ttZ2',  UNIX_TIMESTAMP() + $DAY + 86400, '14,16' FROM fd_slot"
done
