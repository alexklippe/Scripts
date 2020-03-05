UHOME="/home"
USERSUSERS="$(ypcat passwd | cut -d: -f1)"
for u in $USERSUSERS
do
   _dir="${UHOME}/${u}/Desktop"
   if [ -d "$_dir" ]
   then
      #cp -v "$FILE" "$_dir"

      # CHANGE THE OWNER OF THE FILE TO THE USER YOU COPIED TO
      #chown $(id -un $u):users "$_dir/Госпитализация.desktop"
	ln -s /home/ОБЩАЯ $_dir/ОБЩАЯ
	echo $_dir/ОБЩАЯ
fi
   done

