#userid -- ORACLE username/password@IP:PUERTO/SID
#control -- control file name
#log -- log file name
#bad -- bad file name
sqlldr userid=DB1/123@localhost:1521/orcl control=ArchivoControl.ctl log=log/ArchivoControl.log bad=bad/ArchivoControl.bad
echo " "
echo -e "\e[96m  ENTER PARA CONTINUAR ... \e[0m"
read