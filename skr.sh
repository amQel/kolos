#!/bin/bash
if [ $# -eq 2 ]; then

touch lab.conf

COUNT=1
until [ $COUNT -gt 2 ]; do
        echo making pc$COUNT.startup
        touch pc$COUNT.startup
        mkdir pc$COUNT
        
        echo pc$COUNT[0]=\"\" >> lab.conf
        echo pc$COUNT[1]=\"\" >> lab.conf
        
        echo "ifconfig eth0 $1 netmask 255.255.255.0 broadcast $1 up" >> pc$COUNT.startup  
		echo "ifconfig eth1 $1 netmask 255.255.255.0 broadcast $1 up" >> pc$COUNT.startup  
		echo "route add default gw $1" >> pc$COUNT.startup  
        let COUNT=COUNT+1
done

COUNT=1
until [ $COUNT -gt 5 ]; do
        echo making r$COUNT.startup
        touch r$COUNT.startup
        mkdir r$COUNT
        
        echo r$COUNT[0]=\"\" >> lab.conf
        echo r$COUNT[1]=\"\" >> lab.conf
        
        echo "ifconfig eth0 $1 netmask 255.255.255.252 broadcast $1 up" >> r$COUNT.startup  
		echo "ifconfig eth1 $1 netmask 255.255.255.252 broadcast $1 up" >> r$COUNT.startup  
        let COUNT=COUNT+1
done

COUNT=2
until [ $COUNT -gt 5 ]; do
        echo adding r$COUNT.startup zebra 
        mkdir r$COUNT/etc r$COUNT/etc/zebra
        touch r$COUNT/etc/zebra/deamons r$COUNT/etc/zebra/ripd.conf r$COUNT/etc/zebra/zebra.conf
        
        echo zebra=yes >> r$COUNT/etc/zebra/deamons
		echo bgpd=no >> r$COUNT/etc/zebra/deamons
		echo ospfd=no >> r$COUNT/etc/zebra/deamons
		echo ospf6d=no >> r$COUNT/etc/zebra/deamons
		echo ripd=yes >> r$COUNT/etc/zebra/deamons
		echo ripngd=no >> r$COUNT/etc/zebra/deamons
		
		 echo ! >> r$COUNT/etc/zebra/ripd.conf
		 echo hostname ripd >> r$COUNT/etc/zebra/ripd.conf
		 echo password zebra >> r$COUNT/etc/zebra/ripd.conf
		 echo enable password zebra >> r$COUNT/etc/zebra/ripd.conf
		 echo ! >> r$COUNT/etc/zebra/ripd.conf
		 echo router rip >> r$COUNT/etc/zebra/ripd.conf
		 echo redistribute connected >> r$COUNT/etc/zebra/ripd.conf
		 echo network $1/$2 >> r$COUNT/etc/zebra/ripd.conf
		 echo ! >> r$COUNT/etc/zebra/ripd.conf
		 echo log file /var/log/zebra/ripd.log >> r$COUNT/etc/zebra/ripd.conf
		 
		echo hostname zebra >> r$COUNT/etc/zebra/zebra.conf
		echo password zebra >> r$COUNT/etc/zebra/zebra.conf
		echo enable password zebra >> r$COUNT/etc/zebra/zebra.conf
		echo log file /var/log/zebra/zebra.log >> r$COUNT/etc/zebra/zebra.conf

         
		echo "/etc/init.d/zebra start" >> r$COUNT.startup  
        let COUNT=COUNT+1
done


geany lab.conf &
echo ok
geany *.startup &
firefox http://jakiemamip.pl/podzial-na-podsieci &
else 
echo poprawne wywolanie ./skr.sh [adres sieci] [maska sieci]
fi
