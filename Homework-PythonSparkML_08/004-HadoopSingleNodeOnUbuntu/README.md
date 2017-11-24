# Homework - Python Spark ML（八）：Hadoop 的安裝
# § 004 - Hadoop Single Node Cluster 安裝 §

## 【題目連結】
### [Python Spark ML（八）：Hadoop 的安裝](http://hemingwang.blogspot.tw/2017/10/python-spark-mlhadoop.html)
### [按此回上一頁](https://github.com/oneleo/PythonSparkMLBookClub/tree/master/Homework-PythonSparkML_08)

## 【My Answer】

> 因自身是機器學習初學者，此份作業參考各方資料並加入自己的理解，若有誤還請多指教（建立 Github Issue 來協助我修正），謝謝。

----------

### 01、設置 VMware Workstation Host-only DHCP Server

#### 01-001、在 Master-01 VM 開機前，我們先設置 DHCP Server，讓指定的 VM 可自動取得指定的 IP。首先查看 VM 的網路卡 MAC 位址。點選【Edit virtual machine settings】。
* 實際上，我們在大量部署（幾百臺或幾千臺 VM）時，會透過設置 DHCP Server，讓所有 VM 自動取得 IP，而非人工一個個進到 VM 做設定。因網路卡 MAC 位址理論上每個 VM 都不同，所以較簡單的方式就是將 IP 綁在 VM 的網路卡 MAC 位址上。
* 或是可跳過這邊「步驟 001」到「步驟 011」的 DHCP 設置動作，設置 IP 的部份請參考課本[01]方式。

![](./Images/004-001.png)

#### 01-002、點選左側的【Network Adapter 2 Host only】→點選右側的【Advanced...】。

![](./Images/004-002.png)

#### 01-003、將 Master-01 的網路卡「MAC Address」記下來，在這邊以【```00:0C:29:71:83:F9```】為例→點選【Cnacel】關閉視窗。

![](./Images/004-003.png)

#### 01-004、接著我們要查看 Host-only 設置在哪一個網段下，讓我們可以正確的設定要指定的 IP。點選上方【Edit】→【Virtual Network Editor...】。

![](./Images/004-004.png)

#### 01-005、將 VMnet1（Host-only）的「Subnet IP」記下來，在這邊以【```192.168.206.x```】為例→點選【Cancel】關閉視窗。

![](./Images/004-005.png)

#### 01-006、開始設置 VMware Workstation 的 DHCP Server 設定檔 vmnetdhcp.conf，預設是在隱藏的資料夾內：【C:\ProgramData\VMware\vmnetdhcp.conf】。

![](./Images/004-006.png)

#### 01-007、請使用系統管理員身份編輯此檔，請注意我們要加入的內容必要在「# Virtual ethernet segment 1」（VMnet1）範圍底下，「# End」之上。
* 建議使用 [Notepad++](https://notepad-plus-plus.org/zh/) 文字編輯軟體來編輯，它會自動切換系統管理員身份。
* 另一種使用系統管理員身份編輯方式就是，先將設定檔複製一份出來到桌面等目錄，編輯完後再覆蓋回原來的檔案，Windows 會詢問您是否使用系統管理員身份取代。

![](./Images/004-007.png)

#### 01-008、我們在「# End」上方【加入】以下內容→【儲存】→【關閉】。
* 「host」：VM 的名稱，我們可以自行定義，但不可以和其他名稱重複，這邊我們取作【master】。
* 「hardware ethernet」：要指定的 MAC 位址，在這邊我們就是採用剛才記下來的【```00:0C:29:71:83:F9```】。
* 「fixed-address」：我們要給這個 VM 什麼 IP，要注意這邊的 IP 要指定在我們剛才記下來的網域【```192.168.206.x```】底下，而在這邊就設置為【192.168.206.10】作為 Master-01 VM 的 IP。

> 	…（前略）
> 	host VMnet1 {
> 	    hardware ethernet 00:50:56:C0:00:01;
> 	    fixed-address 192.168.206.1;
> 	    option domain-name-servers 0.0.0.0;
> 	    option domain-name "";
> 	}
> 	host master {
> 	    hardware ethernet 00:0C:29:71:83:F9;
> 	    fixed-address 192.168.206.10;
> 	}
> 	# End
> 	…（後略）

![](./Images/004-008.png)

#### 01-009、接下來我們要重新啟動 VMware Workstation DHCP 服務，使設置生效。在左下角「Windows」符號上按滑鼠【右鍵】→【電腦管理(G)】。

![](./Images/004-009.png)

#### 01-010、點選左側【電腦管理 (本機)】→【服務與應用程式】→【服務】，在右側【VMware DHCP Service】上點選滑鼠【右鍵】→【重新啟動(E)】。

![](./Images/004-010.png)

#### 01-011、點選左側【電腦管理 (本機)】→【服務與應用程式】→【服務】，在右側【VMware NAT Service】上點選滑鼠【右鍵】→【重新啟動(E)】。

![](./Images/004-011.png)

#### 01-012、以上設置完 DHCP Server 後，點選【Power on this virtual machine】將 Master-01 VM 開機。

![](./Images/004-012.png)

#### 01-013、輸入 ubuntu 使用者密碼【ubuntu】→按下【Enter】鍵。

![](./Images/004-013.png)

#### 01-014、現在要執行終端機（Terminal）。在左上角「Search your computer」上點選滑鼠【右鍵】→【Applications】。

![](./Images/004-014.png)

#### 01-015、點選【Installed see xx more results】鈕。

![](./Images/004-015.png)

#### 01-016、往下找到並執行【Terminal】程式。

![](./Images/004-016.png)

#### 01-017、在 Terinal 內輸入【ifconfig】取得網路卡資訊，可以看到第二張 Host-only 網路卡「ens34」已取得我們剛才設置的【192.168.206.10】（接下來的操作步驟我們都將在「Terminal」內進行）。

```Bash
$ ifconfig
```

![](./Images/004-017.png)

----------

### 02、更新系統、設置 sudo 群組成員免輸入密碼及關閉防火牆

#### 02-001、進行更新。
* 未來我們將使用「$」符號表示使用一般使用者來進行指令輸入，使用「&lt;user&gt;@&lt;hostname&gt;:/$」符號表示我們已使用 &lt;user&gt; 使用者 SSH 遠端至 &lt;hostname&gt; 來進行指令操作，使用「#」符號表示使用最高權限管理者 root 來進行操作。
* 注意：若出現「could not get lock /var/lib/dpkg/lock」錯誤訊息，請執行指令：```$ sudo rm -rf /var/lib/apt/lists/lock /var/cache/apt/archives/lock /var/lib/dpkg/lock```
* 【sudo】：使用像是更新等操作需擁有管理者權限來進行，使用時預設需輸入密碼。
* 【apt-get】：Ubuntu 的包裝工具，可使用此來進行更新（update）、安裝套件（install）等動作。
* 【update】：更新套件資料庫。【upgrade】：進行更新。【dist-grade】：進行更新並將相依套件一同安裝。
* 【-y】參數：不再詢問是否需要安裝／更新，一律為 Yes。
* 【&&】符號：若前一個指令順利安裝完成（$? 變數為 0）則繼續執行下一個指令。

```Bash
$ sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y
[sudo] password for ubuntu: ubuntu
```

#### 02-002、目前可能尚無法將指令透過複製貼上的方式來輸入指令，所以首先先安裝 VMware 驅動程式 VMware Tools。
* 【install】：從網路上下載並安裝指定的最新套件。

```Bash
$ sudo apt-get install -y open-vm-tools open-vm-tools-desktop
```

#### 02-003、為了使驅動程式生效，接著要使用指令的方式來進行安全的重新開機。
* 【sync】：將未儲存的記憶體資料強制寫回入硬碟內。
* 【reboot】：重新開機。
* 注意：我們可以使用鍵盤的方向鍵【↑】來幫助我們輸入過去曾經執行過的指令。

```Bash
$ sudo sync; sudo sync; sudo sync; sudo sync; sudo sync; sudo sync; sudo sync; sudo reboot;
```

----------

### 03、安裝程式

#### 03-001、重新開機並登入後，開啟 Terminal 程式，接著我們要讓 sudo 的群組成員，在執行 ```sudo xxx``` 命令時，不再需要輸入密碼。
* 注意：當 VMware 驅動程式 VMware Tools 安裝好後，我們可以在 Terminal 上按滑鼠【右鍵】→【Paste】，或是使用快捷鍵【Ctrl】+【Shift】+【V】，貼上從 Windows 複製過來的文字。
* 【vim】：進階文字編輯軟體，若不熟悉 Vim，建議使用其他編輯器，如：Nano（```$ sudo nano /etc/sudoers```）或 Gedit（```$ sudo gedit /etc/sudoers```）等軟體取代。這邊以 Vim 作為主要編輯軟體。
* 【#xxx】：Shell Script 預設使用「#」符號作為註解，表示讓編譯器忽略後面的程式不要執行。
* 【%sudo】：表示 sudo 這一個具有管理者權限的群組。
* 【NOPASSWD:ALL】：此參數的意思為讓 sudo 群組成員在使用 sudo … 命令時，不會再被問輸入密碼。

```Bash
$ sudo vim /etc/sudoers
```

> 	…（前略）
> 	# Allow members of group sudo to execute any command
> 	%sudo   ALL=(ALL:ALL) ALL
> 
> 	# See sudoers(5) for more information on "#include" directives:
> 	…（後略）
> 
> ↑ 第 26 列修改成 ↓
> 
> 	…（前略）
> 	# Allow members of group sudo to execute any command
> 	#%sudo      ALL=(ALL:ALL) ALL
> 	%sudo      ALL=(ALL:ALL) NOPASSWD:ALL
> 	
> 	# See sudoers(5) for more information on "#include" directives:
> 	…（後略）

#### 03-002、安裝此 Ubuntu VM 所需的基本套件：包含 SSH 遠端程式、下載程式、文字編輯軟體、網路除錯工具、系統工具、Scala 語言、Python 語言。
* 【install】：從網路上下載並安裝指定的最新套件。

```Bash
$ sudo apt-get install -y ssh xrdp wget python-software-properties vim gedit nano deborphan net-tools iputils-ping traceroute curl dnsutils locales sudo man tree deborphan scala python python3
```

#### 03-003、安裝 Hadoop 所需的靜態資料庫（Native Library）

```Bash
$ sudo apt-get install -y libssl-dev libsnappy-dev libbz2-dev
```

#### 03-004、安裝語系清除工具 localepurge，可以讓使用者決定保留需要語系，並刪除其他用不到的語系，以保留磁盤空間。
* 注意：安裝時點選【OK】→【OK】→【Yes】
* 未來若要重新設置語系，請使用 ```$ sudo dpkg-reconfigure locales``` 指令。

```Bash
$ sudo apt-get install -y localepurge
```

#### 03-005、為了安裝 Oracle Java 語言，我們需使用 software-properties-common 工具，但使用此工具前要先裝 python-software-properties 套件，故沒有先和上述套件一起安裝。

```Bash
$ sudo apt-get install -y software-properties-common
```

#### 03-006、加入目前最新的 Java 版本到 Ubuntu 的 apt-get 倉庫 repository 內。```$ add-apt-repository``` 指令要在安裝 software-properties-common 套件後才可使用。
* 注意：安裝時請按下【Enter】鍵繼續安裝。

```Bash
$ sudo add-apt-repository ppa:webupd8team/java
```

----------

### 04、Java 語言相關設置

#### 04-001、更新套件資料庫後安裝 Hadoop 須用到的 Java 語言，在這邊我們先將 Java 8 與 Java 9 安裝起來。
* 注意：安裝過程中請按下【OK】→【Yes】。

``` Bash
$ sudo apt-get update && sudo apt-get install -y oracle-java9-installer oracle-java8-installer
```

#### 04-002、因剛才安裝了 Java 8 與 Java 9，所以要設置哪一個為預設值，在這邊以設置 Java 8 為預設語言。
* 未來若需使用到 Java 9，可使用 ```$ sudo apt-get install -y oracle-java9-set-default``` 指令來設置。

``` Bash
$ sudo apt-get install -y oracle-java8-set-default
```

#### 04-003、使用下面指令查看 Java 版本。

``` Bash
$ java -version
```

	java version "1.8.0_151"
	Java(TM) SE Runtime Environment (build 1.8.0_151-b12)
	Java HotSpot(TM) 64-Bit Server VM (build 25.151-b12, mixed mode)

#### 04-004、Java 8 預設安裝目錄在「/usr/lib/jvm/java-8-oracle」，為了保持彈性，建立捷徑。
* 目的：為了避免例如升級至 Java 9 後，所有關於 Java 目錄都要重新設置，所以將 _/usr/lib/jvm/java-8-oracle_ 建立捷徑到 _/usr/lib/jvm/java_，而當所有的 Java 目錄都指到 _/usr/lib/jvm/java_ 的話，就算升級到 Java 9，也只要重新指向捷徑，不需要更改所有設置。
* 【ln A B】：建立一個指到 A 目錄的捷徑 B。
* 【-s】參數：建立供目錄使用的軟性捷徑。
* 【-f】參數：若已存在則強制覆蓋不詢問。

``` Bash
$ sudo ln -sf "/usr/lib/jvm/java-8-oracle" "/usr/lib/jvm/java"
```

#### 04-005、查看剛建立的 Java 捷徑。
* 【ls A】：印出目錄 A 裡的內容。
* 【-a】參數：印出包含隱藏的內容。
* 【-l】參數：印出詳細資訊。

``` Bash
$ ls -al "/usr/lib/jvm"
```

	total 28
	drwxr-xr-x 1 root root  314 十一 13 22:00 .
	drwxr-xr-x 1 root root 3184 十一 13 21:32 ..
	lrwxrwxrwx 1 root root   24  二  26  2016 default-java -> java-1.8.0-openjdk-amd64
	lrwxrwxrwx 1 root root   26 十一 13 22:00 java -> /usr/lib/jvm/java-8-oracle
	lrwxrwxrwx 1 root root   20  十  28 06:51 java-1.8.0-openjdk-amd64 -> java-8-openjdk-amd64
	-rw-r--r-- 1 root root 2600  十  28 06:51 .java-1.8.0-openjdk-amd64.jinfo
	drwxr-xr-x 1 root root   26 十一 13 00:27 java-8-openjdk-amd64
	drwxr-xr-x 1 root root  300 十一 13 22:07 java-8-oracle
	-rw-r--r-- 1 root root 2643 十一 13 01:00 .java-8-oracle.jinfo

----------

### 05、Scala 語言相關設置

#### 05-001、按照同方法，我們也將 Scala 建立捷徑，首先查看目前 Scala 版本。
* 【O | I】：「|」為管線，意思是將前一個指令的輸出 O，當作是後面一個指令的輸入 I。
* 【grep A】：以列為單位，只顯示有包含 A 的列。在這邊就是將目錄列表出來的結果，將含有「scala」字串的那列印出。

``` Bash
$ ls -al /usr/share | grep 'scala'
```

	drwxr-xr-x 1 root root    18 十一 15 11:24 scala-2.11

#### 接著根據上方查看的 Scala 版本來建立 Scala 捷徑，這邊以「/usr/share/scala-2.11」為例，建立好後查看。

``` Bash
$ sudo ln -sf "/usr/share/scala-2.11" "/usr/share/scala"
$ ls -al /usr/share | grep 'scala'
```

	lrwxrwxrwx 1 root root    10 十二 22  2015 scala -> scala-2.11
	drwxr-xr-x 1 root root    18 十一 15 11:24 scala-2.11

----------

### 06、系統語系設置

#### 06-001、避免 Linux 顯示中文時為亂碼，使用下面指令來新增支援的語系。
* 【zh_TW】：正體中文語系。
* 【zh_TW.UTF-8】：正體中文語系使用 UTF-8 編碼。
* 【en_US】：英文語系。
* 【en_US.UTF-8】：英文語系使用 UTF-8 編碼。

``` Bash
$ sudo locale-gen zh_TW zh_TW.UTF-8 en_US en_US.UTF-8
```

#### 06-002、使用下面指令查看目前已安裝的語系。

``` Bash
$ locale -a
```

	C
	C.UTF-8
	en_AG
	en_AG.utf8
	en_AU.utf8
	en_BW.utf8
	en_CA.utf8
	en_DK.utf8
	en_GB.utf8
	en_HK.utf8
	en_IE.utf8
	en_IN
	en_IN.utf8
	en_NG
	en_NG.utf8
	en_NZ.utf8
	en_PH.utf8
	en_SG.utf8
	en_US
	en_US.iso88591
	en_US.utf8
	en_ZA.utf8
	en_ZM
	en_ZM.utf8
	en_ZW.utf8
	es_CU.utf8
	lzh_TW
	lzh_TW.utf8
	POSIX
	zh_TW
	zh_TW.big5

----------

### 07、SSH Server 程式設置與免密碼遠端登入

#### 07-001、接下來進行 SSH Server 設置，未來我們會將此 VM 做為模板複製成其他 VM，為了達到 SSH 遠端至其他 VM 不需輸入密碼，進行以下設置。首先編輯「/etc/ssh/sshd_config」檔。
* 【PermitRootLogin】：是否允許 SSH 遠端登入至最高權限管理者 root，這邊為【no】。
* 【PermitUserEnvironment】：是否允許透過 SSH 遠端直接下達指令，這邊為【yes】。
* 【UseDNS】：是否需要使用 DNS 解析遠端主機名稱（需花費較長時間），這邊為【no】。

``` Bash
$ sudo vim /etc/ssh/sshd_config
```

> 	…（上略）
> 	# Authentication:
> 	LoginGraceTime 120
> 	PermitRootLogin prohibit-password
> 	StrictModes yes
> 	…（中略）
> 	UsePAM yes
> 	
> ↑ 修改第 28 列，以及在文件最下方增加內容 ↓
> 
> 	…（上略）
> 	# Authentication:
> 	LoginGraceTime 120
> 	#PermitRootLogin prohibit-password
> 	PermitRootLogin no
> 	StrictModes yes
> 	…（中略）
> 	UsePAM yes
> 	
> 	PermitUserEnvironment yes
> 	UseDNS no

#### 07-002、接下來進行 SSH Client 設置，編輯「/etc/ssh/ssh_config」檔。
* 【StrictHostKeyChecking】：從其他裝置 SSH 遠端至本機器時，自動儲存憑證前是否詢問連入者，這邊為【no】。

``` Bash
$ sudo vim /etc/ssh/ssh_config
```

> 	…（前略）
> 	# StrictHostKeyChecking ask
> 	…（後略）
> 
> ↑ 第 35 列修改成 ↓
> 
> 	…（前略）
> 	# StrictHostKeyChecking ask
> 	StrictHostKeyChecking no
> 	…（後略）

#### 07-003、重新啟動（restart）SSH 服務，使其設定值立即生效，若設定有誤，則出現錯誤。
* 【systemctl】：Linux 系統與服務管理器。
* 【start】指令：啟動服務。
* 【stop】指令：停止服務。
* 【restart】指令：重新啟動服務。
* 【status】指令：查看服務狀態。
* 【enable】指令：設置服務隨開機自動啟動。
* 【disable】指令：設置服務不要隨開機時啟動。

``` Bash
$ sudo systemctl restart ssh
```

#### 07-004、設定開機時自動啟動 SSH 服務。

``` Bash
$ sudo systemctl enable ssh
```

#### 07-005、查看 SSH 服務狀態。
* 狀態查看完畢後，按下鍵盤【q】鍵離開。

``` Bash
$ sudo systemctl status ssh
```

	● ssh.service - OpenBSD Secure Shell server
	   Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enab
	   Active: active (running) since 三 2017-11-15 12:56:07 CST; 9s ago
	 Main PID: 11699 (sshd)
	   CGroup: /system.slice/ssh.service
	           └─11699 /usr/sbin/sshd -D
	
	十一 15 12:56:07 ubuntu-virtual-machine systemd[1]: Stopped OpenBSD Secure Shell
	十一 15 12:56:07 ubuntu-virtual-machine systemd[1]: Starting OpenBSD Secure Shel
	十一 15 12:56:07 ubuntu-virtual-machine sshd[11699]: Server listening on 0.0.0.0
	十一 15 12:56:07 ubuntu-virtual-machine sshd[11699]: Server listening on :: port
	十一 15 12:56:07 ubuntu-virtual-machine systemd[1]: Started OpenBSD Secure Shell

#### 07-006、建立 SSH 登入免密碼金鑰。
* 使用 SSH 遠端時可選擇使用密碼或金鑰登入，當連入者 Client 及 Server 均有成對的金鑰時，即可不需密碼完成連線。
* 注意：這邊並未使用 sudo 權限建立金鑰，故金鑰擁有者為目前使用者（ubuntu）。
* 【-t】參數：指定要創建的密鑰類型，這邊使用 RSA 金鑰。
* 【-P】參數：提供金鑰亂度種子。
* 【-f】參數：指定用來保存金鑰的文件名稱。
* 【~/】目鎑為目前使用者的家目錄，在這邊等同於「/home/ubuntu/」目錄。
* 【.】開頭的目錄或是檔案，在 Linux 視為隱藏檔，使用「ls」指令查看時，需增加參數：「ls -a」。

``` Bash
$ ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
```

#### 07-007、因未來複製此 VM 後，遠端時依然是 SSH 至相同的 VM 中，故將剛才製作好的公有金鑰複製成 SSH 認證金鑰，以達到遠端免密碼。
* 【cp A B】：複製 A 成為 B。
* 【-p】參數：保留原始檔案屬性。
* 【-R】參數：若是複製目錄，則連同子目錄也一同複製。
* 【-f】參數：若已存在則強制覆蓋不詢問。

``` Bash
$ cp -pRf ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys
```

#### 07-008、金鑰被規定權限只能由擁有者存取，故設定權限。
* 【chown】：改變目錄或檔案的擁有者及所屬群組。
* 【-R】參數：若是改變目錄的擁有者，則連同子目錄也一同設置。
* 【A:B】：此目錄或檔案的擁有者為 A 及所屬群組為 B。
* 【$USER】：凡使用「$」的字串稱之為變數，$USER 表示目前的使用者，請使用 ```$ echo $USER``` 指令查看就會知道。 
* 【chmod】：改變目錄的存取權限。
* 【700】：照順序對映：擁有者→所屬群組→其他人。
* 【7】的含義：4 + 2 + 1：若允許讀取（r）則加 4，若允許寫入（w）則加 2，若允許執行（x）則加 1。
* 舉例：「700」的含義：擁有者允許讀取、寫入、執行。所屬群組權限全被禁止。其他人權限全被禁止。
* 舉例：「754」的含義：擁有者允許讀取、寫入、執行。所屬群組僅允許讀取、執行，但不能寫入。其他人只允許讀取。

``` Bash
$ sudo chown -R "$USER":"$USER" ~/.ssh && sudo chmod -R 700 ~/.ssh
```

#### 07-009、查看剛建立的 ~/.ssh 目錄。

``` Bash
$ ls -al ~/.ssh
```

	total 12
	drwx------ 1 ubuntu ubuntu   62 十一 14 20:56 .
	drwxr-xr-x 1 ubuntu ubuntu  554 十一 14 20:56 ..
	-rwx------ 1 ubuntu ubuntu  411 十一 14 20:56 authorized_keys
	-rwx------ 1 ubuntu ubuntu 1679 十一 14 20:56 id_rsa
	-rwx------ 1 ubuntu ubuntu  411 十一 14 20:56 id_rsa.pub

----------

### 08、本地的名稱解析服務設置

#### 08-001、藉由編輯「/etc/hosts」，來設定本地的名稱解析服務。
* 名稱解析服務（DNS）最簡單的用法為將「網址」轉成「IP」，像是將「www.google.com」轉成「74.125.203.99」。而我們在這邊要將「master」轉成第二張 Host-only 網路卡的 IP「192.168.206.10」。

``` Bash
$ sudo vim /etc/hosts
```

> 	127.0.0.1       localhost
> 	127.0.1.1       ubuntu-virtual-machine
> 	
> 	# The following lines are desirable for IPv6 capable hosts
> 	::1     ip6-localhost ip6-loopback
> 	…（後略）
> 
> ↑ 第 3 列修改成 ↓
> 
> 	127.0.0.1       localhost
> 	127.0.1.1       ubuntu-virtual-machine
> 	192.168.206.10  master
> 	
> 	# The following lines are desirable for IPv6 capable hosts
> 	::1     ip6-localhost ip6-loopback
> 	…（後略）

#### 08-002、透過 SSH 遠端自己，來測試可正確將 master 解析至指定 IP，以及測試可以不需密碼進行 SSH 連線。測試無誤後使用 ```$ exit``` 指令退出。

``` Bash
$ ssh "$USER"@master
ubuntu@ubuntu-virtual-machine:~$ exit 
```

----------

### 09、安裝 Hadoop 與相關設置

#### 09-001、至 [Apache Hadoop](http://hadoop.apache.org/releases.html) 官網，點擊進入目前最新穩定版（2.9.0）binary 連結。

![](./Images/004-018.png)

#### 09-002、Apache Hadoop 官網會自動偵測最近的站點。請在站點上按滑鼠【右鍵】→【複製連結網址(E)】，並取代 ``` wget ``` 指令後方位址。
* 【cd A】：切換目前工作目錄至 A 目錄，在這邊是將 Hadoop 壓縮檔下載到 /tmp 目錄內。
* 【wget A】：下載檔案 A。

``` Bash
$ cd /tmp && wget "http://apache.stu.edu.tw/hadoop/common/hadoop-2.9.0/hadoop-2.9.0.tar.gz"
```

![](./Images/004-019.png)

#### 09-003、建立放置 Hadoop、Spark 及 Anaconda 原始檔的目錄「/opt」，建立好後設置權限。
* 【mkdir】：建立目錄。
* 【-p /A/B/C】：遞迴建立，建立 C 目錄時，若 A 及 B 目錄不存在則一同建置。

``` Bash
$ sudo mkdir -p /opt && sudo chown -R "$USER":"$USER" /opt && sudo chmod -R 775 /opt
```

#### 09-004、解壓縮剛才下載的 Hadoop 壓縮包（這裡為 hadoop-2.9.0.tar.gz 壓縮包）至 /opt 目錄。
* 【tar】：解壓縮或壓縮檔案，由後面的參數來決定。
* 【-z】參數：解壓縮或壓縮成 gzip 格式的檔案。
* 【-x】參數：進行解壓縮作業。
* 【-c】參數：進行壓縮作業。
* 【-v】參數：顯示解壓縮或壓縮作業的細節。
* 【-f A】參數：指定要解壓縮或壓縮的檔案 A 或目錄 A。
* 【-C】參數：指定解壓縮或壓縮的目的目錄。

``` Bash
$ tar -zxv -f "/tmp/hadoop-2.9.0.tar.gz" -C "/opt"
```

#### 09-005、為了保持彈性，建立 Hadoop 原始檔捷徑。

``` Bash
$ ln -sf "/opt/hadoop-2.9.0" "/opt/hadoop"
```

#### 09-006、查看剛建立的 Hadoop 捷徑。

``` Bash
$ ls -al /opt
```

	total 4
	drwxrwxr-x 1 ubuntu ubuntu  36 十一 15 13:06 .
	drwxr-xr-x 1 root   root   234 十一 15 10:54 ..
	lrwxrwxrwx 1 ubuntu ubuntu  17 十一 15 13:06 hadoop -> /opt/hadoop-2.9.0
	drwxr-xr-x 1 ubuntu ubuntu 126  十  20 05:11 hadoop-2.9.0

#### 09-007、下載敬翔自製的設定檔，解壓縮至「/opt」目錄，並設置權限。

``` Bash
$ cd /tmp && wget "https://drive.google.com/uc?authuser=0&id=1aLWevPkZ1Bo2zAGmI-boS67qaP_6s0os&export=download"
$ tar -zxv -f "hdopt17.11.23.tar.gz" -C "/"
$ sudo chown -R "$USER":"$USER" /opt && sudo chmod -R 775 /opt
```

#### 09-008、查看解壓縮結果。

``` Bash
$ ls -al /opt
```

	total 4
	drwxrwxr-x 1 ubuntu ubuntu 140 十一 15 13:08 .
	drwxr-xr-x 1 root   root   234 十一 15 10:54 ..
	drwxrwxr-x 1 ubuntu ubuntu  92 十一 11 11:59 bin
	drwxrwxr-x 1 ubuntu ubuntu  10 十一 11 11:59 conf
	lrwxrwxrwx 1 ubuntu ubuntu  17 十一 15 13:06 hadoop -> /opt/hadoop-2.9.0
	drwxr-xr-x 1 ubuntu ubuntu 126  十  20 05:11 hadoop-2.9.0
	drwxrwxr-x 1 ubuntu ubuntu 216 十一 11 11:59 hadoop.etc.hadoop.template
	drwxrwxr-x 1 ubuntu ubuntu  74 十一 11 11:59 spark.conf.template

#### 09-009、將敬翔已撰寫好的 Hadoop 設定檔複製到「/opt/hadoop/etc/hadoop」目錄內
* 設定檔分別為「[core-site.xml]()」、「[hdfs-site.xml]()」、「[mapred-site.xml]()」、「[yarn-site.xml]()」、「[slaves]()」、「[hdfs.include]()」、「[hdfs.exclude]()」、「[yarn.include]()」、「[yarn.exclude]()」，請點入連結察看設定說明。
* 「core-default.xml」所有的可用參數請參考：[官方網站](http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/core-default.xml)
* 「hdfs-default.xml」所有的可用參數請參考：[官方網站](http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)
* 「mapred-default.xml」所有的可用參數請參考：[官方網站](http://hadoop.apache.org/docs/current/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xml)
* 「yarn-default.xml」所有的可用參數請參考：[官方網站](http://hadoop.apache.org/docs/current/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)
* 新舊版本 Hadoop 參數對照請參考：[官網參數對照表](http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/DeprecatedProperties.html)

``` Bash
$ cp -pRf /opt/hadoop.etc.hadoop.template/* /opt/hadoop/etc/hadoop
```

#### 09-010、設置 Hadoop 儲存及運算的檔案存放目錄（請參考上述 core-site.xml 文件），並開通必要權限。

``` Bash
$ sudo mkdir -p "/home/$USER/hadoop" && sudo chown -R "$USER":"$USER" "/home/$USER/hadoop" && sudo chmod -R 777 "/home/$USER/hadoop"
```

#### 09-011、因本篇是 Single Node，故我們將自製設定檔「slaves」、「hdfs.include」、「yarn.include」內的資料以「master」覆蓋。
* 設定檔的作用請查看上述連結。
* 在這邊以「master」覆蓋的原因是，master 除了是 NameNode、SecondaryNameNode、ResourceManager 外，也同時是 DataNode 及 NodeManager 共五種角色。
* 【echo A】：將字串 A 或是變數 A 的內容輸出。
* 【A > B】：將前方的 A 輸出，***覆蓋***至後方的檔案 B 裡頭，在這邊是將空字串覆蓋至後方的設定檔。
* 【A >> B】：將前方的 A 輸出，***插入***至後方的檔案 B 裡的最後一列。

``` Bash
$ echo "master" > /opt/hadoop/etc/hadoop/slaves
$ echo "master" > /opt/hadoop/etc/hadoop/hdfs.include
$ echo "master" > /opt/hadoop/etc/hadoop/yarn.include
```

----------

### 10、系統環境變數與主機名稱設置

#### 10-001、設置環境變數，將下列內容加入到「/etc/bash.bashrc」檔裡的最後一列。
* 「/etc/bash.bashrc」檔將會在開機時（會執行 /bin/bash 使用者操作介面 Shell）時自動執行，且作用範圍會在所有的使用者帳號中生效。
* 注意，在 CentOS 中，此檔為「/etc/bashrc」。
* 【if [ A ]; then B fi】：Shell 程式的條件式：若 A 成立就執行 B。
* 【-f A】：A 檔案存在則回傳 True，不存在回傳 False[03]。在這邊是判斷檔案若存在就執行之。
* 【source A】：執行 A 程式，在這邊是若 /opt/bin/vm.bash 存在就執行。此執行指令和「exec」、「fork」類似，但會在目前的進程中執行。
* 【exec A】：執行 A 程式，但會在執行新的程式時將原來舊的進程關閉。
* 【fork A】：執行 A 程式，但是是建立一個新的子進程來執行。

``` Bash
$ sudo vim /etc/bash.bashrc
```

> 	…（前略）
> 	if [ -f /opt/bin/vm.boot ]; then
> 	    /opt/bin/vm.boot
> 	fi
> 	if [ -f /opt/bin/vm.bash ]; then
> 	    source /opt/bin/vm.bash
> 	fi

#### 10-002、上述有設置 vm.bash 及 vm.boot 檔，現在要針對此二檔進行撰寫。
* 「/opt/bin/vm.bash」檔的目的是設置環境變數，可以讓相關的軟體會根據變數的內容而有對映的動作。
* 「/opt/bin/vm.boot」檔是針對 Hadoop 及 Spark 而撰寫。
* 「#!/bin/bash」：宣告這個程式使用的使用者操作介面 Shell 名稱，類型為「Interactive Non-Login Shell」，所以會執行 /etc/bash.bashrc（或 CentOS 是 /etc/bashrc）檔，再執行 ~/.bashrc 檔。 
* 【export A=B】：設置 A 變數的內容為 B，且作用域會在所有的子 /bin/bash 內。換句話說所有的使用者及 Terminal 都看得到這個變數。

``` Bash
$ vim /opt/bin/vm.bash
```

>     #!/bin/bash
>     
>     export JAVA_HOME=/usr/lib/jvm/java
>     export JRE_HOME=$JAVA_HOME/jre
>     export PATH=$PATH:$JAVA_HOME/bin
>     
>     export SCALA_HOME=/usr/share/scala
>     export PATH=$PATH:$SCALA_HOME/bin
>     
>     export HADOOP_HOME=/opt/hadoop
>     export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
>     export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
>     export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native
>     export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
>     export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
>     export HADOOP_USER_CLASSPATH_FIRST=true
>     export HADOOP_LOG_DIR=/opt/logs/hadoop
>     export HDFS_LOG_DIR=/opt/logs/hdfs
>     export YARN_LOG_DIR=/opt/logs/yarn
>     export HADOOP_MAPRED_LOG_DIR=/opt/logs/mapred
>     export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

#### 10-003、上述有設置 vm.bash 及 vm.boot 檔，現在要針對此二檔進行撰寫。
* 「/opt/bin/vm.boot」檔是針對 Hadoop、Spark 而撰寫。Hadoop 或 Spark 會使用 ```$ ssh "$USER"@<Host Name> <Command>``` 這種「Non-Interactive Non-Login Shell」 [04][05] 來執行程式，此法並不會看到我們執行 ```$ source /opt/bin/vm.bash``` 所設置的環境變數。經過測試，Hadoop 會看到「/opt/hadoop/etc/hadoop/hadoop-env.sh」及「/home/$USER/.ssh/environment」（因為透過 SSH）所設置的變數。
* 「/home/$USER/.ssh/environment」檔內不能使用 export 設置變數，且等號右邊不能包含其他變數；例如 ```$ JRE_HOME=$JAVA_HOME/jre``` 是不合法的，是要 ```$ JRE_HOME=/usr/lib/jvm/java/jre``` 才合法。
* 「/opt/bin/vm.boot」檔會截取「/opt/bin/vm.bash」檔的內容，將 export 字串刪除，並且將等號右邊的變數還原回原來的字串，最後再將處理過後的變數設置寫入「/home/$USER/.ssh/environment」檔內，好讓 Hadoop 看到並可根據內容有相映的動作。
* 「Interactive Login Shell」：已登入且有互動的使用者操作介面。我們使用的 Terminal 即是此種 Shell。會先自動執行 /etc/profile 檔，執行完後依序去找 ~/.bash_profile、~/.bash_login、~/.profile 其中一個檔，找到後執行完就不會再執行其他檔案。
* 「Non-Interactive Login Shell」：已登入但沒有互動的使用者操作介面。在執行程式的時候，加入「--login」參數即是此種 Shell，如 ```$ /bin/bash --login script.sh```。此 Shell 下會自動執行的檔案和「Interactive Login Shell」一樣。
* 「Interactive Non-Login Shell」：無登入且有互動的使用者操作介面。我們在 Terminal 中再執行一次 ```$ /bin/bash``` 即是此種 Shell。會先執行 /etc/bash.bashrc（或 CentOS 是 /etc/bashrc）檔，再執行 ~/.bashrc 檔。
* 「Non-Interactive Non-Login Shell」：無登入且無互動的使用者操作介面。直接執行程式或透過 SSH 執行程式即是此種，如 ```$ /bin/bash script.sh```。一般來說會去執行 $BASH_ENV 變數指到的檔案。但在這邊 Hadoop 會透過 SSH 去執行程式，所以還會再執行「/home/$USER/.ssh/environment」檔。
* 「/opt/bin/vm.boot」程式說明請參考上方敬翔自製設定檔壓縮包內的「[/opt/bin/dkc.boot]()」檔。

``` Bash
$ vim /opt/bin/vm.boot
```

	#!/bin/bash
	
	if ( [ -f "/opt/bin/vm.bash" ] ); then
		source /opt/bin/vm.bash
		
		if ( [ "$HADOOP_HOME" != "" ] ); then
			[[ ! -d /tmp ]] && mkdir -p /tmp && chmod 777 -R /tmp
			echo "" > /tmp/environment
			Variables=$(cat /opt/bin/dkc.bash | grep -P '^[ \t]*export' | cut -d '=' -f 1 | awk -F ' ' '{print $2};')
			for v in $Variables
			do
				if ( [ "$v" != "PATH" ] && [ "${!v}" != "" ] ); then
					echo "$v=${!v}" >> /tmp/environment
				fi
			done
			echo "PATH=$PATH" >> /tmp/environment
			cat '/tmp/environment' > "/home/$USER/.ssh/environment"
		fi
	fi
	
	exit 0

#### 10-004、設置 Log 檔存放目錄，並開通權限。
* 因為我們在上述設置「/opt/bin/vm.bash」的環境變數中有使用到 Log 檔要存放到「/opt/logs」裡，故要預先建立起來。

``` Bash
$ sudo mkdir -p /opt/logs && sudo chown -R "$USER":"$USER" /opt && sudo chmod -R 775 /opt
```

#### 10-005、設置主機名稱（Host Name），這裡將主機名稱修改成「master」。
* 注意：「/opt/hadoop/etc/hadoop」目錄中「hdfs-site.xml」及「yarn-site.xml」有設置「hdfs.include」、「hdfs.exclude」、「yarn.include」、「yarn.exclude」四個檔案，裡頭的資訊是使用 VM 的 hostname，而非「/etc/hosts」的名稱解析。
* 【hostnamectl】：主機內容資訊相關設置。
* 【set-hostname】：設置目前的主機名稱。

``` Bash
$ sudo hostnamectl set-hostname 'master'
```

#### 10-006、執行新的 /bin/bash 使用者操作介面 Shell 使剛才設置的環境變數及主機名稱生效。
* 在這邊 exec 是再執行一個和目前一樣的 /bin/bash 使用者操作介面 Shell（此為 Interactive Non-Login 型 Shell ，所以會自動執行 /etc/bash.bashrc 檔，使設定生效）。

``` Bash
$ exec /bin/bash
```

#### 10-007、查看 PATH 變數。
* 可以看到 Java 語言執行檔目錄、Scala 語言執行檔目錄、Hadoop 執行檔目錄已包含在 PATH 環境變數中，表示我們已可以直接執行像是 ```$ java```、```$ hadoop```、```$ hdfs``` 等指令。
* 「ssh "$USER"@master <Command>」是在模擬 Hadoop 實際上執行程式的方式，藉此確認有正確執行 /home/$USER/.ssh/environment 檔。
* 注意：「ssh "$USER"@master <Command>」的 <Command> 建議使用單引號將指令包住，再傳送至遠端執行。若指令中含有變數且使用雙引號，如：```$ ssh "$USER"@master echo "$JAVA_HOME"```，本地端會將指令轉換成 ```$ ssh ubuntu@master echo /usr/lib/jvm/java ``` 而導致不可預期的錯誤結果。

``` Bash
$ echo "$PATH"
$ ssh "$USER"@master 'echo "$PATH"'
```

	/home/ubuntu/bin:/home/ubuntu/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/jvm/java/bin:/usr/share/scala/bin:/opt/hadoop/bin:/opt/hadoop/sbin:/usr/lib/jvm/java/bin:/usr/share/scala/bin:/opt/hadoop/bin:/opt/hadoop/sbin

#### 10-008、查看目前的 Host Name。
``` Bash
$ hostname
```

	master

----------

### 11、Hadoop 基本測試

#### 11-001、避免格式化前 /home/$USER/hadoop 有資料，先將之清空。
* 【rm A】：刪除 A 檔案。
* 【-r】參數：遞迴刪除，可用做刪除目錄。
* 【-f】參數：強制刪除不提示。

``` Bash
$ ssh "$USER"@master rm -rf /home/$USER/hadoop/*
```

#### 11-002、格式化 HDFS 檔案系統。
* 此時將會在 /home/$USER/hadoop 底下建立 dfs 目錄。

``` Bash
$ ssh "$USER"@master hdfs namenode -format
```

#### 11-003、啟動單機版 HDFS 儲存用 Java 程式。
* 出現的 Warning 是因為第一次 SSH 遠端連線至此 Server 而產生，當產生連線紀錄後（儲存在 ~/.ssh/known_hosts）就不會再出現此告警。

``` Bash
$ ssh "$USER"@master start-dfs.sh
```

	Warning: Permanently added 'master,192.168.206.10' (ECDSA) to the list of known hosts.
	Starting namenodes on [master]
	master: starting namenode, logging to /opt/logs/hadoop/hadoop-ubuntu-namenode-master.out
	master: starting datanode, logging to /opt/logs/hadoop/hadoop-ubuntu-datanode-master.out
	Starting secondary namenodes [master]
	master: starting secondarynamenode, logging to /opt/logs/hadoop/hadoop-ubuntu-secondarynamenode-master.out

#### 11-004、啟動單機版 Yarn 運算用 Java 程式。

``` Bash
$ ssh "$USER"@master start-yarn.sh
```

	starting yarn daemons
	starting resourcemanager, logging to /opt/logs/yarn/yarn-ubuntu-resourcemanager-master.out
	master: starting nodemanager, logging to /opt/logs/yarn/yarn-ubuntu-nodemanager-master.out

#### 11-005、查看目前啟動的 Hadoop Java 程式。

``` Bash
$ ssh "$USER"@master jps
```

	6531 DataNode
	6409 NameNode
	7145 Jps
	7036 NodeManager
	6733 SecondaryNameNode
	6927 ResourceManager

#### 11-006、為了可使用瀏覽器查看 HDFS 及 Yarn 的狀態，查看 NAT 網路卡位址，在這邊以 ens33 網路卡名稱為例。
* 注意：本地對於 master 的名稱解析 192.168.206.10 是基於第二張 Host-only 的網路卡 ens34。
* 第一張網路卡 IP 在這邊將以 192.168.133.139 為例。

``` Bash
$ ssh "$USER"@master ifconfig ens33
```

	ens33     Link encap:Ethernet  HWaddr 00:0c:29:71:83:ef  
	          inet addr:192.168.133.139  Bcast:192.168.133.255  Mask:255.255.255.0
	          inet6 addr: fe80::7aea:656e:f002:678f/64 Scope:Link
	          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
	          RX packets:37337 errors:0 dropped:0 overruns:0 frame:0
	          TX packets:14020 errors:0 dropped:0 overruns:0 carrier:0
	          collisions:0 txqueuelen:1000 
	          RX bytes:51983307 (51.9 MB)  TX bytes:877256 (877.2 KB)

#### 11-007、在 Windows 使用瀏覽器查看 Hadoop Yarn 服務：http://192.168.133.139:8088

![](./Images/004-020.png)

#### 11-008、在 Windows 使用瀏覽器查看 Hadoop HDFS 服務：http://192.168.133.139:50070

![](./Images/004-021.png)

#### 11-009、停止單機版 Yarn 運算用 Java 程式。

``` Bash
$ ssh "$USER"@master stop-yarn.sh
```

	stopping yarn daemons
	stopping resourcemanager
	resourcemanager did not stop gracefully after 5 seconds: killing with kill -9
	master: stopping nodemanager
	master: nodemanager did not stop gracefully after 5 seconds: killing with kill -9
	no proxyserver to stop

#### 11-010、停止單機版 HDFS 儲存用 Java 程式。

``` Bash
$ ssh "$USER"@master stop-dfs.sh
```

	Stopping namenodes on [master]
	master: stopping namenode
	master: stopping datanode
	Stopping secondary namenodes [master]
	master: stopping secondarynamenode
	master: secondarynamenode did not stop gracefully after 5 seconds: killing with kill -9

----------

### 12、安裝 Python Spark 與相關設置

#### 12-001、查看目前最新穩定版的 [Python Spark 官方文件](https://spark.apache.org/docs/latest/)（目前為 2.2.0 版）可正常運作的語言版本。
* Java 8+
* Python 2.7+/3.4+
* Scala 2.11

![](./Images/004-022.png)

#### 12-002、查看目前環境的 Java 版本是否符合 Python Spark 需求。

``` Bash
$ java -version
```

	java version "1.8.0_151"
	Java(TM) SE Runtime Environment (build 1.8.0_151-b12)
	Java HotSpot(TM) 64-Bit Server VM (build 25.151-b12, mixed mode)

#### 12-003、查看目前環境的 Python 版本是否符合 Python Spark 需求。
* 若不符合 Python Spark 需求，請使用 ```$ apt-cache showpkg python``` 指令查看可選擇安裝的版本（Versions），再使用 ```$ sudo apt-get install python=<Version>``` 來安裝指定的 Version 版本。

``` Bash
$ python --version
```

	Python 2.7.12

#### 12-004、查看目前環境的 Scala 版本是否符合 Python Spark 需求。
* 若不符合 Python Spark 需求，請使用 ```$ apt-cache showpkg scala``` 指令查看可選擇安裝的版本（Versions），再使用 ```$ sudo apt-get install scala=<Version>``` 來安裝指定的 Version 版本。

``` Bash
$ scala -version
```

	Scala code runner version 2.11.6 -- Copyright 2002-2013, LAMP/EPFL

#### 12-005、至 [Apache Spark](https://spark.apache.org/downloads.html) 官網，點擊進入目前最新穩定版（2.2.0）binary 連結。
* 「1. Choose a Spark release:」=【2.2.0 (Jul 11 2017)】。
* 「2. Choose a package type:」=【Pre-built for Apache Hadoop 2.7 and later】。
* 點選【spark-2.2.0-bin-hadoop2.7.tgz】進入下載頁面。

![](./Images/004-018.png)

#### 12-006、Apache Spark 官網會自動偵測最近的站點。請在站點上按滑鼠【右鍵】→【複製連結網址(E)】，並取代 ``` wget ``` 指令後方位址。

``` Bash
$ cd /tmp && wget "http://apache.stu.edu.tw/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.7.tgz"
```

![](./Images/004-019.png)

#### 12-007、解壓縮剛才下載的 Spark 壓縮包（這裡為 spark-2.2.0-bin-hadoop2.7.tgz 壓縮包）至 /opt 目錄，並設置權限。

``` Bash
$ tar -zxv -f "/tmp/spark-2.2.0-bin-hadoop2.7.tgz" -C "/opt"
$ sudo chown -R "$USER":"$USER" /opt && sudo chmod -R 775 /opt
```

#### 12-008、為了保持彈性，建立 spark 原始檔捷徑。

``` Bash
$ ln -sf "/opt/spark-2.2.0-bin-hadoop2.7" "/opt/spark"
```

#### 12-009、查看剛建立的 Spark 捷徑。

$ ls -al /opt

	total 8
	drwxrwxr-x 1 ubuntu ubuntu 208 十一 16 20:05 .
	drwxr-xr-x 1 root   root   234 十一 12 23:40 ..
	drwxrwxr-x 1 ubuntu ubuntu 120 十一 15 23:59 bin
	drwxrwxr-x 1 ubuntu ubuntu  10 十一 11 11:59 conf
	lrwxrwxrwx 1 ubuntu ubuntu  17 十一 14 22:26 hadoop -> /opt/hadoop-2.9.0
	drwxrwxr-x 1 ubuntu ubuntu 134 十一 15 23:13 hadoop-2.9.0
	drwxrwxr-x 1 ubuntu ubuntu 216 十一 11 11:59 hadoop.etc.hadoop.template
	drwxrwxr-x 1 ubuntu ubuntu  12 十一 15 22:51 logs
	lrwxrwxrwx 1 ubuntu ubuntu  30 十一 16 20:05 spark -> /opt/spark-2.2.0-bin-hadoop2.7
	drwxrwxr-x 1 ubuntu ubuntu 150  七   1 07:09 spark-2.2.0-bin-hadoop2.7
	drwxrwxr-x 1 ubuntu ubuntu  74 十一 11 11:59 spark.conf.template

#### 12-010、將敬翔已撰寫好的 Hadoop 設定檔複製到「/opt/spark/conf」目錄內
* 設定檔分別為「[spark-defaults.conf]()」、「[spark-env.sh]()」、「[slaves]()」，請點入連結察看設定說明。
* 相關參數請參考：[官方網站](https://spark.apache.org/docs/latest/configuration.html)。

``` Bash
$ cp -pRf /opt/spark.conf.template/* /opt/spark/conf
```

#### 12-011、因本篇是 Single Node，故我們將 Spark 自製設定檔「slaves」內的資料以「master」覆蓋。
* 在這邊以「master」覆蓋的原因是，master 除了是 NameNode、SecondaryNameNode、ResourceManager、Spark Master 外，還同時是 DataNode、NodeManager、Spark Worker 共七種角色。

``` Bash
$ echo "master" > /opt/spark/conf/slaves
```

#### 12-012、設置 /opt/bin/vm.bash 環境變數檔，要增加 Spark 相關變數。
* 「/opt/bin/vm.bash」檔會在 /etc/bash.bashrc 中被執行，且也會在 /opt/bin/vm.boot 中將變數經過處理後寫入至 /home/$USER/.ssh/environment 內。
* 「/etc/bash.bashrc」檔將會在開機時自動執行。
* 【alias】：指令別名設定。例如設置指令別名為 ```$ alias rm='rm -i'```，之後使用 rm 指令其實都是使用帶參數的 rm -i。因為 Spark 若偵測到有設置 $HIVE_HOME 時，會自動將在記憶體運算轉換成在 Hive 運算，在這邊是設定強制都要在記憶體（in-memory）運算。

``` Bash
$ vim /opt/bin/vm.bash
```

>     #!/bin/bash
>     
>     export JAVA_HOME=/usr/lib/jvm/java
>     export JRE_HOME=$JAVA_HOME/jre
>     export PATH=$PATH:$JAVA_HOME/bin
>     
>     export SCALA_HOME=/usr/share/scala
>     export PATH=$PATH:$SCALA_HOME/bin
>     
>     export HADOOP_HOME=/opt/hadoop
>     export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
>     export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
>     export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native
>     export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
>     export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
>     export HADOOP_USER_CLASSPATH_FIRST=true
>     export HADOOP_LOG_DIR=/opt/logs/hadoop
>     export HDFS_LOG_DIR=/opt/logs/hdfs
>     export YARN_LOG_DIR=/opt/logs/yarn
>     export HADOOP_MAPRED_LOG_DIR=/opt/logs/mapred
>     export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
>     
>     export SPARK_HOME=/opt/spark
>     export SPARK_CONF_DIR=$SPARK_HOME/conf
>     export SPARK_LOG_DIR=/opt/logs/spark
>     export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
>     alias pyspark='pyspark --conf spark.sql.catalogImplementation=in-memory'

#### 12-013、執行新的 /bin/bash 使用者操作介面 Shell 使剛才設置的環境變數生效。

``` Bash
$ exec /bin/bash
```

#### 12-014、查看 PATH 變數。

``` Bash
$ echo "$PATH"
$ ssh "$USER"@master 'echo "$PATH"'
```

	/home/ubuntu/bin:/home/ubuntu/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin:/usr/lib/jvm/java/bin:/usr/share/scala/bin:/opt/hadoop/bin:/opt/hadoop/sbin:/opt/spark/bin:/opt/spark/sbin

#### 12-015、啟動 PySpark 互動介面，確認可以正確執行。

``` Bash
$ pyspark
```

	Python 2.7.12 (default, Nov 19 2016, 06:48:10) 
	[GCC 5.4.0 20160609] on linux2
	Type "help", "copyright", "credits" or "license" for more information.
	Setting default log level to "WARN".
	To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
	Welcome to
	      ____              __
	     / __/__  ___ _____/ /__
	    _\ \/ _ \/ _ `/ __/  '_/
	   /__ / .__/\_,_/_/ /_/\_\   version 2.2.0
	      /_/
	
	Using Python version 2.7.12 (default, Nov 19 2016 06:48:10)
	SparkSession available as 'spark'.
	>>>

#### 12-016、進行 Spark 簡單測試，查看目前 Spark 模式。
* 在 Spark Shell 內，有一個內建的 SparkContext，名為 sc。

```python
>>> sc.master
```

	u'local[*]'

#### 12-017、計算 /opt/hadoop/LICENSE.txt 檔內文字列數。

```python
>>> textFile=sc.textFile("file:/opt/hadoop/LICENSE.txt")
>>> textFile.count()
```

	1801

#### 12-018、離開 PySpark 互動介面。

``` Bash
>>> exit()
```

----------

### 13、安裝 Anaconda 與相關設置

#### 13-001、至 [Anaconda](https://www.anaconda.com/download/#linux) 官網，請在站點上按滑鼠【右鍵】→【複製連結網址(E)】，並取代 ```wget``` 指令後方位址。

``` Bash
$ cd /tmp && wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
```

![](./Images/004-025.png)

#### 13-002、開始安裝 Anaconda。
* Anaconda*-Linux-x86_64.sh 是一個可執行的安裝檔，可直接使用 /bin/bash 來執行。
* 注意：在安裝過程中，請依序按此順序操作：按下【Enter】繼續→按下【q】離開授權條條→輸入【yes】後按下【Enter】→輸入安裝資料夾【/opt/anaconda3-5.0.1】→輸入【no】之後按下【Enter】。

``` Bash
$ sudo /bin/bash /tmp/Anaconda3-5.0.1-Linux-x86_64.sh
```

#### 13-003、設置 /opt 擁有者及權限。

``` Bash
$ sudo chown -R "$USER":"$USER" /opt && sudo chmod -R 775 /opt
```

#### 13-004、為保留彈性建立 Anaconda 捷徑。

``` Bash
$ ln -sf "/opt/anaconda3-5.0.1" "/opt/anaconda"
```

#### 13-005、查看剛建立的 Anaconda 捷徑。

``` Bash
$ ls -al /opt
```

	total 12
	drwxrwxr-x 1 ubuntu ubuntu 272 十一 16 21:06 .
	drwxr-xr-x 1 root   root   234 十一 12 23:40 ..
	lrwxrwxrwx 1 root   root    20 十一 16 21:06 anaconda -> /opt/anaconda3-5.0.1
	drwxrwxr-x 1 ubuntu ubuntu 332 十一 16 21:09 anaconda3-5.0.1
	drwxrwxr-x 1 ubuntu ubuntu 120 十一 16 21:06 bin
	drwxrwxr-x 1 ubuntu ubuntu  10 十一 11 11:59 conf
	lrwxrwxrwx 1 ubuntu ubuntu  17 十一 14 22:26 hadoop -> /opt/hadoop-2.9.0
	drwxrwxr-x 1 ubuntu ubuntu 134 十一 15 23:13 hadoop-2.9.0
	drwxrwxr-x 1 ubuntu ubuntu 216 十一 11 11:59 hadoop.etc.hadoop.template
	drwxrwxr-x 1 ubuntu ubuntu  22 十一 16 20:14 logs
	lrwxrwxrwx 1 ubuntu ubuntu  30 十一 16 20:05 spark -> /opt/spark-2.2.0-bin-hadoop2.7
	drwxrwxr-x 1 ubuntu ubuntu 158 十一 16 20:14 spark-2.2.0-bin-hadoop2.7
	drwxrwxr-x 1 ubuntu ubuntu  74 十一 11 11:59 spark.conf.template
	drwxrwxr-x 1 ubuntu ubuntu  16 十一 16 21:06 workspace

#### 13-006、設置 /opt/bin/vm.bash 環境變數檔，要增加 Anaconda 相關變數。
* 「/opt/bin/vm.bash」檔會在 /etc/bash.bashrc 中被執行，且也會在 /opt/bin/vm.boot 中將變數經過處理後寫入至 /home/$USER/.ssh/environment 內。
* 「/etc/bash.bashrc」檔將會在開機時自動執行。

``` Bash
$ vim /opt/bin/vm.bash
```

>     #!/bin/bash
>     
>     export JAVA_HOME=/usr/lib/jvm/java
>     export JRE_HOME=$JAVA_HOME/jre
>     export PATH=$PATH:$JAVA_HOME/bin
>     
>     export SCALA_HOME=/usr/share/scala
>     export PATH=$PATH:$SCALA_HOME/bin
>     
>     export HADOOP_HOME=/opt/hadoop
>     export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
>     export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
>     export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native
>     export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
>     export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
>     export HADOOP_USER_CLASSPATH_FIRST=true
>     export HADOOP_LOG_DIR=/opt/logs/hadoop
>     export HDFS_LOG_DIR=/opt/logs/hdfs
>     export YARN_LOG_DIR=/opt/logs/yarn
>     export HADOOP_MAPRED_LOG_DIR=/opt/logs/mapred
>     export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
>     
>     export SPARK_HOME=/opt/spark
>     export SPARK_CONF_DIR=$SPARK_HOME/conf
>     export SPARK_LOG_DIR=/opt/logs/spark
>     export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
>     alias pyspark='pyspark --conf spark.sql.catalogImplementation=in-memory'
>     
>     export ANACONDA_HOME=/opt/anaconda
>     export PYSPARK_PYTHON=$ANACONDA_HOME/bin/python
>     export PYSPARK_DRIVER_PYTHON=$ANACONDA_HOME/bin/jupyter
>     export PYSPARK_DRIVER_PYTHON_OPTS="notebook --port=8888 --no-browser --ip=0.0.0.0 --notebook-dir=/opt/workspace/anaconda"
>     export PATH=$PATH:$ANACONDA_HOME/bin

#### 13-007、設置 Anaconda 工作目錄，並開通權限。
* 因為我們在上述設置「/opt/bin/vm.bash」的環境變數中有使用到 Jupyter Notebook 工作目錄為要存放到「/opt/workspace/anaconda」裡，故要預先建立起來。

``` Bash
$ sudo mkdir -p /opt/workspace/anaconda && sudo chown -R "$USER":"$USER" /opt && sudo chmod -R 775 /opt
```

#### 13-008、執行新的 /bin/bash 使用者操作介面 Shell 使剛才設置的環境變數生效。

``` Bash
$ exec /bin/bash
```

#### 13-009、查看 PATH 變數。

``` Bash
$ echo "$PATH"
$ ssh "$USER"@master 'echo "$PATH"'
```

	/home/ubuntu/bin:/home/ubuntu/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin:/usr/lib/jvm/java/bin:/usr/share/scala/bin:/opt/hadoop/bin:/opt/hadoop/sbin:/usr/lib/jvm/java/bin:/usr/share/scala/bin:/opt/hadoop/bin:/opt/hadoop/sbin:/opt/spark/bin:/opt/spark/sbin:/usr/lib/jvm/java/bin:/usr/share/scala/bin:/opt/hadoop/bin:/opt/hadoop/sbin:/opt/spark/bin:/opt/spark/sbin:/opt/anaconda/bin

#### 13-010、接下來我們要在 Jupyter Notebook 介面下操作在 Spark Standalone（Spark 叢集）模式的 PySpark，首先啟動單機版 Spark 運算用 Java 程式。
* 注意：課本 [01] 中所使用的 IPython Notebook 已被 Jupyter Notebook 取代。

``` Bash
$ ssh "$USER"@master /opt/spark/sbin/start-all.sh
```

	starting org.apache.spark.deploy.master.Master, logging to /opt/logs/spark/spark-ubuntu-org.apache.spark.deploy.master.Master-1-master.out
	master: starting org.apache.spark.deploy.worker.Worker, logging to /opt/logs/spark/spark-ubuntu-org.apache.spark.deploy.worker.Worker-1-master.out

#### 13-011、查看目前啟動的 Spark Java 程式。

``` Bash
$ jps
```

	4549 Jps
	4395 Master
	4475 Worker

#### 13-012、在 Windows 使用瀏覽器查看 Spark 運算服務：[http://192.168.133.139:8080/](http://192.168.133.139:8080/)

![](./Images/004-026.png)

#### 13-013、接下來要啟動 Anaconda Jupyter Notebook 服務。

``` Bash
$ pyspark --master spark://master:7077 --num-executors 1 --total-executor-cores 3 --executor-memory 512m
```

	[I 22:01:12.060 NotebookApp] JupyterLab alpha preview extension loaded from /opt/anaconda3-5.0.1/lib/python3.6/site-packages/jupyterlab
	JupyterLab v0.27.0
	Known labextensions:
	[I 22:01:12.066 NotebookApp] Running the core application with no additional extensions or settings
	[I 22:01:12.080 NotebookApp] Serving notebooks from local directory: /opt/workspace/anaconda
	[I 22:01:12.081 NotebookApp] 0 active kernels 
	[I 22:01:12.081 NotebookApp] The Jupyter Notebook is running at: http://0.0.0.0:8888/?token=4e3997e8a8bc7fd9747fb43e35103f4f0fcf8864f380177c
	[I 22:01:12.082 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
	[C 22:01:12.085 NotebookApp] 
    
    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://0.0.0.0:8888/?token=ef63f1b9c958513c64c3177573da016ea4e7dd585e815d7f

#### 13-014、觀察上述執行訊息，使用 Jupyter Notebook 前需先進行安全性認證，請先在 Windows 下使用瀏覽器查看「http://192.168.133.139:8888/?token=XXXX」網址。
* 在此處所顯示的認證網址為「http://0.0.0.0:8888」，表示 Jupyter Notebook 目前允許來自不同來源的位址 IP 連線。所以在這邊要將 0.0.0.0 改成 NAT 的網路卡 IP「192.168.133.139」。 
* 請依據不同的認證網址來登入服務，而此處的認證網址為 [http://0.0.0.0:8888/?token=ef63f1b9c958513c64c3177573da016ea4e7dd585e815d7f](http://0.0.0.0:8888/?token=ef63f1b9c958513c64c3177573da016ea4e7dd585e815d7f)。
* 登入 Jupyter Notebook 服務後即可在 [http://192.168.133.139:8888/](http://192.168.133.139:8888/) 網頁下撰寫 Spark Python 語言，並且在上述所啟動的 Spark Standalone（Spark 叢集）下進行分散式運算（只是在此處只有一臺 VM 運算）。

![](./Images/004-027.png)

#### 13-015、建立一新的 Python Notebook。
* 請點選右側【New】→【Python 3】建立。
* 注意：因為工作目錄已被我們設置在「/opt/workspace/anaconda」，所以相關檔案會自動儲存在裡頭。

![](./Images/004-028.png)

#### 13-016、進行 Spark 簡單測試，查看目前 Spark 模式。
* 在「In [1]:」中輸入【sc.master】→按下【Shift】+【Enter】開始運算。

	Out[1]: 'spark://master:7077'

![](./Images/004-029.png)

#### 13-017、使用 Spark Standalone 叢集計算 /opt/hadoop/LICENSE.txt 檔內文字列數。
* 在「In [2]:」中輸入【textFile=sc.textFile("file:/opt/hadoop/LICENSE.txt")】→按下【Enter】。
* 接著輸入【textFile.count()】→按下【Shift】+【Enter】開始運算。

	Out[2]: 1801

![](./Images/004-030.png)

#### 13-018、測試正確無誤後，將目前 Python Notebook 關閉。
* 點選【File】→【Close and Halt】離開。
* 注意：請一定要使用此法關閉 Python Notebook，若只是將瀏覽器關閉，在將 Jupyter Notebook 關閉時會因為 Python Notebook 仍在運作而出現錯誤。 

![](./Images/004-031.png)

#### 13-019、關閉 Jupyter Notebook 服務。
* 按下鍵盤的【Ctrl】+【c】→輸入【y】→按下【Enter】完成關閉。

![](./Images/004-031.png)

#### 13-020、停止單機版 Spark 運算用 Java 程式。

``` Bash
$ ssh "$USER"@master /opt/spark/sbin/stop-all.sh
```

	master: stopping org.apache.spark.deploy.worker.Worker
	stopping org.apache.spark.deploy.master.Master

#### 13-021、查看目前啟動的 Spark Java 程式。

``` Bash
$ ssh "$USER"@master jps
```

	5259 Jps

----------

### 14、Multiple Node 前置設置

#### 14-001、目前已完成 Single Node 測試，接下要進行 Multiple Node 前先將此 Master VM 進行前置及清理。現在將敬翔的自製設定檔覆蓋回 Hadoop 及 Spark 設定檔。
* 此設定檔主要是以一個 Master Node，及三個 Data Node 來設計。

``` Bash
$ cp -pRf /opt/hadoop.etc.hadoop.template/* /opt/hadoop/etc/hadoop
$ cp -pRf /opt/spark.conf.template/* /opt/spark/conf
```

#### 14-002、設置 Multiple Node 下的本地名稱解析，data1、data2、data3 於第二張 Host-only 的網路卡 ens34 分別對映的 IP 為 192.168.206.11、192.168.206.12、192.168.206.13。

``` Bash
$ sudo vim /etc/hosts
```

> 	127.0.0.1       localhost
> 	127.0.1.1       ubuntu-virtual-machine
> 	192.168.206.10  master
> 	192.168.206.11  data1
> 	192.168.206.12  data2
> 	192.168.206.13  data3
> 	
> 	# The following lines are desirable for IPv6 capable hosts
> 	::1     ip6-localhost ip6-loopback
> 	…（後略）

#### 14-003、關閉 Ubuntu 防火牆。
* 多個 Hadoop 主機會使用多個網路連接埠來進行溝通，為了簡化操作，故將防火牆關閉。
* 【ufw】：是 Ubuntu 內建用來提供給使用者快速設定防火牆的程式。
* 【disable】指令：停用 Ubuntu 防火牆

```Bash
$ sudo ufw disable
$ sudo systemctl stop ufw
$ sudo systemctl disable ufw
```

#### 14-004、開始進行自動清除已用不到的軟體。自動清除已用不到的軟體。
* 【autoremove】：自動刪除用不到的相依軟體。
* 【autoclean】：自動刪除已安裝軟體的原始安裝檔。
* 【clean】：刪除所有已安裝軟體的原始安裝檔。

```Bash
$ sudo apt-get autoremove -y && sudo apt-get autoclean && sudo apt-get clean
```

#### 14-005、清除用不到的檔案及資料夾。

```Bash
$ sudo rm -r /home/$USER/hadoop/*
$ sudo rm -r /tmp/*
```

#### 14-006、執行安全關機。

```Bash
$ sudo sync; sudo sync; sudo sync; sudo sync; sudo sync; sudo sync; sudo sync; sudo shutdown -h now;
```

## 【References】

- [01] 林大貴，「博碩出版社 - Python+Spark 2.0+Hadoop機器學習與大數據分析實戰」，ISBN-13：9789864341535
- [01] VMware Docs, "VMware Workstation 14 Pro Product Documentation", [https://docs.vmware.com/en/VMware-Workstation-Pro/14.0/com.vmware.ws.using.doc/GUID-0EE752F8-C159-487A-9159-FE1F646EE4CA.html](https://docs.vmware.com/en/VMware-Workstation-Pro/14.0/com.vmware.ws.using.doc/GUID-0EE752F8-C159-487A-9159-FE1F646EE4CA.html)
- [02] 國家高速網路與計算中心，「NCHC 雲端運算基礎課程(Hadoop簡介、安裝與實作) 課程錄影上線」，[http://www.hadoop.tw/2009/09/nchc-hadoop.html](http://www.hadoop.tw/2009/09/nchc-hadoop.html)
- [03] 鳥哥的 Linux 私房菜，「第十二章、學習 Shell Scripts」，[http://linux.vbird.org/linux_basic/0340bashshell-scripts.php#test](http://linux.vbird.org/linux_basic/0340bashshell-scripts.php#test)
- [04] stack overflow, "Why does an SSH remote command get fewer environment variables then when run manually?", [https://stackoverflow.com/questions/216202/why-does-an-ssh-remote-command-get-fewer-environment-variables-then-when-run-man](https://stackoverflow.com/questions/216202/why-does-an-ssh-remote-command-get-fewer-environment-variables-then-when-run-man)
- [05] LIBFEIHU ，「ssh連接遠程主機執行腳本的環境變量問題」，[http://feihu.me/blog/2014/env-problem-when-ssh-executing-command-on-remote/](http://feihu.me/blog/2014/env-problem-when-ssh-executing-command-on-remote/)