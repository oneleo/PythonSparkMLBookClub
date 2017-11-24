#!/bin/bash
#「-f」：該『檔名』是否存在且為檔案（file）。「!」：反向。「exit 0」：程式正常結束且返回 $0 變數。「exit 1」：程式錯誤結束且返回 $1 變數。
[[ ! -f /opt/conf/hosts ]] && exit 1

# 取得 /opt/conf/hosts Cluster 設計圖位置。
CtnConf=/opt/conf/hosts

# 把 /opt/conf/hosts 內的 \r 字元刪除，避免取值時出現不必要的字元。「\r」：Linux 的換行字元為 \n，Windows 的換行字元為\r\n，需避免 Linux 將 \r 當作有效字元。「sed」：「's/A/B/g' C」：將 C 檔內的 A 字串置換成 B。「$」：在行尾才算符合。「-i」：直接將取代結果寫回至 C 檔內。
# 可以使用 $ cat $CtnConf | od -c 指令來查看檔案內是否有 \r 字元。
sed -i 's/\r$//g' $CtnConf

# 取得目前 Container 的 Hostname。
CtnName=$HOSTNAME

# IPv4 的正則表達式。「x{1,3}」：連續 1 個到 3 個 x 就符合。「\.」：因「.」在正則表達式是特殊字元（表示一個任意字元），前加斜線「\.」表示用一般的字元來解釋。
#「[1-9]」：表示 1 ~ 9 間的數字。「[1-9][0-9]」：10 ~ 99。「1[0-9][0-9]」：100 ~ 199。「2[0-4][0-9]」：200 ~ 249。「25[0-5]」：250 ~ 255。
RegIp='(2[0-4][0-9]|25[0-5]|1[0-9][0-9]|[1-9]?[0-9])(\.(2[0-4][0-9]|25[0-5]|1[0-9][0-9]|[1-9]?[0-9])){3}'

# Linux 目錄的正則表達式。「x?」：零個或 1 個 x 就符合。「^」：放在中括號外 ^[] 表示要緊連最前面，放在中括號內 [^] 表示符合此中括號內的條件都要排除。「x+」：x 至少要 1 個或多個才符合。
RegPath='(/[^/ ]*)+/?'

# 設置 Log 檔所在目錄位置。
LogDir=/opt/logs

# 設置 Log 檔路徑。
LogFile="$LogDir/$HOSTNAME-root.log"

# 若 $LogDir 目錄不存在就創建一個。「-d」：該『檔名』是否存在且為目錄。「mkdir」：建立目錄。「-p」：連同不存在的父目錄也一起建立。
# 「chmod」：更改使用權限。「-R」：所有子目錄、檔案也一起更改權限。「777」：Owner 權限 7，Group 權限 7、Others 權限 7。7 = 4 + 2 + 1，4 = r(read)、2 = w(write)、1 = x(execute)。
[[ ! -d "$LogDir" ]] && mkdir -p "$LogDir" && chmod 777 -R "$LogDir"
# 製作空的 $LogFile 檔，並設置此檔有寫入權限。
[[ ! -f "$LogFile" ]] && touch "$LogFile" && chmod 777 -R "$LogFile"

# 將 $LogFile、$LogDir 變數寫入 $LogFile 內。「$(date)」：當下的時間。「$HOSTNAME」：目前的主機名稱。
echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set LogFile = $LogFile" >> $LogFile 2>&1
echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set LogDir = $LogDir" >> $LogFile 2>&1

# 將取得的變數寫入 $LogFile 內。
echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set CtnName = $CtnName" >> $LogFile 2>&1

# 從 /opt/conf/hosts 設計圖中，將對映 Hostname 的 IP 取出。並將結果儲存至 $LogFile 檔內。
# 「grep」：「-E」：使用 Egrep 版正則表達式來解釋樣式。「-P」：使用 Perl 版正則表式示來解釋樣式，可分辨 \t（Tab）字元。「-o」：只要顯示找到的值而非顯示整列。「head -n N」：輸出矩陣前 N 個元素。「'」：二個單引號內的文字不會將變數置換。「"」：二個雙引號內的文字會將變數置換。
CtnIp=$(cat $CtnConf | grep -oP "^[ \t]*$RegIp[ \t]*$CtnName" | grep -oE "$RegIp" | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set CtnIp = $CtnIp" >> $LogFile 2>&1

# 從 /opt/conf/hosts 設計圖中，將對映的 Docker Netmask 值取出。
DkrNetmask=$(cat $CtnConf | grep -oP "^[ \t]*#[ \t]*netmask[ \t]*=[ \t\'\"]*$RegIp" | grep -oE "$RegIp" | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set DkrNetmask = $DkrNetmask" >> $LogFile 2>&1

# 從 /opt/conf/hosts 設計圖中，將對映的 Docker Gateway 值取出。
DkrGateway=$(cat $CtnConf | grep -oP "^[ \t]*#[ \t]*gateway[ \t]*=[ \t\'\"]*$RegIp" | grep -oE "$RegIp" | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set DkrGateway = $DkrGateway" >> $LogFile 2>&1

# 從 /opt/conf/hosts 設計圖中，將對映的 Docker Nameserver 值取出。
DkrNameserver=$(cat $CtnConf | grep -oP "^[ \t]*#[ \t]*nameserver[ \t]*=[ \t\'\"]*$RegIp" | grep -oE "$RegIp" | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set DkrNameserver = $DkrNameserver" >> $LogFile 2>&1

# 從 /opt/conf/hosts 設計圖中，將對映的 AppAdmin 值取出。在 Linux 裡使用者名稱不會超過 32 字元。
AppAdmin=$(cat $CtnConf | grep -oP "^[ \t]*#[ \t]*appadmin[ \t]*=[ \t]*[0-9a-zA-Z_.][0-9a-zA-Z_.-]{0,31}" | cut -d '=' -f 2 | grep -oE '[0-9a-zA-Z_.][0-9a-zA-Z_.-]{0,31}' | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set AppAdmin = $AppAdmin" >> $LogFile 2>&1

# 若 $CtnIp 不為空，且 $DkrGateway 也不為空，就用此二變數設置 Container 的網路。
if ( [ "$CtnIp" != "" ] && [ "$DkrGateway" != "" ] ); then
	# 若 $DkrNetmask 為空，就將之設置成 255.255.0.0。
	[[ "$DkrNetmask" == "" ]] && DkrNetmask="255.255.0.0"
	# 設置 Container 的網路。若執行成功將提示寫入至 $LogFile 內，以便於後續查詢。
	ifconfig eth0 $CtnIp netmask $DkrNetmask up \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Ifconfig setted, please check by \"\$ sudo docker exec -it $HOSTNAME ifconfig eth0\" command." >> $LogFile 2>&1
	# 設置 Container 的預設路由，所有的封包將預設往此 IP 送。
	route add default gw $DkrGateway \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Route setted, please check by \"\$ sudo docker exec -it $HOSTNAME route\" command." >> $LogFile 2>&1
	# 測試是否與 Gateway 可連線，並將測試結果丟棄。
	/bin/ping -c 2 $DkrGateway > /dev/null 2>&1
	# 若 $DkrNameserver 不為空，就將之設置成 Container 的 Nameserver，用做上網時可幫忙解析 Domain Name。
	[[ "$DkrNameserver" != "" ]] && echo "nameserver $DkrNameserver" > /etc/resolv.conf \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Nameserver setted, please check by \"\$ sudo docker exec -it $HOSTNAME cat /etc/resolv.conf\" command." >> $LogFile 2>&1
fi

# 將 /opt/conf/hosts 設計圖內容覆蓋至 Container 的 /etc/hosts，以查詢不同 Container Hostname 所對映的 IP。
cp -p "$CtnConf" "/etc/hosts" \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Hosts setted, please check by \"\$ sudo docker exec -it $HOSTNAME cat /etc/hosts\" command." >> $LogFile 2>&1

# 若 /home/$AppAdmin/hadoop 目錄存在就更改其擁有者及其使用權限，因目錄內可能己有不同權限資料，故不使用「-R」參數。「-d」：該『檔名』是否存在且為目錄。「775」：Owner、Group 有所有權限，Others 只能讀取及執行。
#[[ -d "/home/$AppAdmin/hadoop" ]] && chown "$AppAdmin":"$AppAdmin" "/home/$AppAdmin/hadoop" && chmod 775 "/home/$AppAdmin/hadoop" \
#&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Change /home/$AppAdmin/hadoop directory owner to $AppAdmin, and change it authority to 775." >> $LogFile 2>&1

# 若 /opt/bin/dkc.bash 及 $AppAdmin 變數不為空，且 $HADOOP_HOME 環境變數有被設置，則將 /opt/bin/dkc.bash 內的環境變數複製到 /home/ubuntu/.ssh/environment 檔內。
if ( [ -f "/opt/bin/dkc.bash" ] && [ "$AppAdmin" != "" ] ); then
	# 執行腳本方式：「<檔名>」：建立一子 shell 來執行，若含有環境變數設置，執行結束會隨著子 shell 消毀。「source <檔名>」=「. <檔名>」：使用目前的 shell 來執行，環境變數設置在程式結束後仍會在目前 shell 內保留。
	source /opt/bin/dkc.bash
	
	# 如果 $HADOOP_HOME 環境變數非空值，則將 /opt/bin/dkc.bash 內的環境變數複製到 /home/ubuntu/.ssh/environment 檔內。
	if ([ "$HADOOP_HOME" != "" ]); then
		# 建立一個空的暫存檔 /tmp/environment，若 /tmp 資料夾不存在就建立一個。
		[[ ! -d /tmp ]] && mkdir -p /tmp && chmod 777 -R /tmp
		echo "" > /tmp/environment
		# 將 /opt/bin/dkc.bash 內，export 開頭的環境變數名稱取出（不含 export 關鍵字及變數值）。
		Variables=$(cat /opt/bin/dkc.bash | grep -P '^[ \t]*export' | cut -d '=' -f 1 | awk -F ' ' '{print $2};')
		# 因 /home/ubuntu/.ssh/environment 只能辨識「VARIABLE="variable"」的環境變數，所以利用上面取得的變數名稱陣列，重新編排後再寫入暫存檔 /tmp/environment 內。
		for v in $Variables
		do
			# 因 $PATH 可能會有多列，所以除了 $PATH 變數外，先將其他有值的變數寫入暫存檔 /tmp/environment 內。
			if ( [ "$v" != "PATH" ] && [ "${!v}" != "" ] ); then
				echo "$v=${!v}" >> /tmp/environment
			fi
		done
		# 再把最新的 $PATH 寫入暫存檔 /tmp/environment 內。
		echo "PATH=$PATH" >> /tmp/environment
		# 最後把 /tmp/environment 覆寫至 /home/ubuntu/.ssh/environment 檔案中，當 ubuntu 使用者使用 SSH 登入此 Container 時，SSH Server 會根據此檔將環境變數設置好。
		cat '/tmp/environment' > "/home/$AppAdmin/.ssh/environment" \
		&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: SSH environment variables setted, please check by \"\$ sudo docker exec -it $HOSTNAME cat /home/$AppAdmin/.ssh/environment\" command." >> $LogFile 2>&1
	fi
fi

# 釋放相關變數
#unset CtnConf CtnName RegIp RegPath LogDir LogFile CtnIp DkrNetmask DkrGateway DkrNameserver AppAdmin ClusterConf SparkPython HadoopHome HBaseHome HiveHome PigHome ZookeeperHome FlumeHome KafkaHome SparkHome AnacondaHome

# 程式正確結束（$? = 0）。
exit 0
