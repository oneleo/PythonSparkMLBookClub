#!/bin/bash
# 取得 /etc/hosts（從 /opt/conf/hosts 複製而來）設計圖位置。
CtnConf=/opt/conf/hosts

# Linux 目錄的正則表達式。「x?」：零個或 1 個 x 就符合。「^」：放在中括號外 ^[] 表示要緊連最前面，放在中括號內 [^] 表示符合此中括號內的條件都要排除。「\r」：Linux 的換行字元為 \n，Windows 的換行字元為\r\n，需避免 Linux 將 \r 當作有效字元。「x+」：x 至少要 1 個或多個才符合。
RegPath='(/[^/ ]*)+/?'

# 設置 Anaconda Jupyter Notebook 工作目錄。
AnacondaWork=/opt/workspace/anaconda

# 設置 Log 檔所在目錄位置。
LogDir=/opt/logs

# 設置 Log 檔路徑。
[[ $USER != "" ]] && LogFile="$LogDir/$HOSTNAME-$USER.log" || LogFile="$LogDir/$HOSTNAME-root.log"

# 製作空的 $LogFile 檔，並設置此檔有寫入權限。
[[ ! -f $LogFile ]] && touch "$LogFile" && chmod 777 -R "$LogFile"

# 將 $LogFile 變數寫入 $LogFile 內。「$(date)」：當下的時間。「$HOSTNAME」：目前的主機名稱。
echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set LogFile = $LogFile" >> $LogFile 2>&1

# 從 /opt/conf/hosts 設計圖中，將對映的 AppAdmin 值取出。在 Linux 裡使用者名稱不會超過 32 字元，並將取得的變數寫入 $LogFile 內。
AppAdmin=$(cat $CtnConf | grep -oP "^[ \t]*#[ \t]*appadmin[ \t]*=[ \t]*[0-9a-zA-Z_.][0-9a-zA-Z_.-]{0,31}" | cut -d '=' -f 2 | grep -oE '[0-9a-zA-Z_.][0-9a-zA-Z_.-]{0,31}' | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set AppAdmin = $AppAdmin" >> $LogFile 2>&1
# 若有設置 $ClusterConf 目錄及 Hadoop 等應用程式對映的資料夾，則此應用程式的設定檔將會指到此資料夾內（非原來的預設目錄），方便彈性管理（例如可以將設定檔放在不同的 $ClusterConf 內，供不同規模的叢集快速切換使用）。
ClusterConf=$(cat $CtnConf | grep -oP "^[ \t]*#[ \t]*clusterconf[ \t]*=[ \t\'\"]*$RegPath" | cut -d '=' -f 2 | grep -oE "$RegPath" | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set ClusterConf = $ClusterConf" >> $LogFile 2>&1
# 若有設置 $SparkPython，則將 Spark 預設使用的 Python 更改成指定的版本。
SparkPython=$(cat $CtnConf | grep -oP "^[ \t]*#[ \t]*sparkpython[ \t]*=[ \t\'\"]*python[2-3]" | cut -d '=' -f 2 | grep -oE "python[2-3]" | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set SparkPython = $SparkPython" >> $LogFile 2>&1
# 從 /opt/conf/hosts 設計圖中，將對映的 Hadoop 應用程式的家目錄值取出，依此類推。
HadoopHome=$(cat $CtnConf | grep -oP "^[ \t]*#[ \t]*hadoophome[ \t]*=[ \t\'\"]*$RegPath" | cut -d '=' -f 2 | grep -oE "$RegPath" | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set HadoopHome = $HadoopHome" >> $LogFile 2>&1
HBaseHome=$(cat $CtnConf | grep -oP "^[ \t]*#[ \t]*hbasehome[ \t]*=[ \t\'\"]*$RegPath" | cut -d '=' -f 2 | grep -oE "$RegPath" | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set HBaseHome = $HBaseHome" >> $LogFile 2>&1
HiveHome=$(cat $CtnConf | grep -oP "^[ \t]*#[ \t]*hivehome[ \t]*=[ \t\'\"]*$RegPath" | cut -d '=' -f 2 | grep -oE "$RegPath" | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set HiveHome = $HiveHome" >> $LogFile 2>&1
PigHome=$(cat $CtnConf | grep -oP "^[ \t]*#[ \t]*pighome[ \t]*=[ \t\'\"]*$RegPath" | cut -d '=' -f 2 | grep -oE "$RegPath" | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set PigHome = $PigHome" >> $LogFile 2>&1
ZookeeperHome=$(cat $CtnConf | grep -oP "^[ \t]*#[ \t]*zookeeperhome[ \t]*=[ \t\'\"]*$RegPath" | cut -d '=' -f 2 | grep -oE "$RegPath" | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set ZookeeperHome = $ZookeeperHome" >> $LogFile 2>&1
FlumeHome=$(cat $CtnConf | grep -oP "^[ \t]*#[ \t]*flumehome[ \t]*=[ \t\'\"]*$RegPath" | cut -d '=' -f 2 | grep -oE "$RegPath" | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set FlumeHome = $FlumeHome" >> $LogFile 2>&1
KafkaHome=$(cat $CtnConf | grep -oP "^[ \t]*#[ \t]*kafkahome[ \t]*=[ \t\'\"]*$RegPath" | cut -d '=' -f 2 | grep -oE "$RegPath" | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set KafkaHome = $KafkaHome" >> $LogFile 2>&1
SparkHome=$(cat $CtnConf | grep -oP "^[ \t]*#[ \t]*sparkhome[ \t]*=[ \t\'\"]*$RegPath" | cut -d '=' -f 2 | grep -oE "$RegPath" | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set SparkHome = $SparkHome" >> $LogFile 2>&1
AnacondaHome=$(cat $CtnConf | grep -oP "^[ \t]*#[ \t]*anacondahome[ \t]*=[ \t\'\"]*$RegPath" | cut -d '=' -f 2 | grep -oE "$RegPath" | head -n 1) \
&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Set AnacondaHome = $AnacondaHome" >> $LogFile 2>&1

if ( [ -d /usr/lib/jvm/java ] || [ -L /usr/lib/jvm/java ] ); then
	export JAVA_HOME=/usr/lib/jvm/java \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export JAVA_HOME = $JAVA_HOME" >> $LogFile 2>&1
	export JRE_HOME=$JAVA_HOME/jre \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export JRE_HOME = $JRE_HOME" >> $LogFile 2>&1
	# 新增可執行檔位置至 $PATH 環境變數，即可直接輸入對映指令（例如 $ java 等）使用。
	export PATH=$PATH:$JAVA_HOME/bin	
fi

if ( [ -d /usr/share/scala ] || [ -L /usr/share/scala ] ); then
	export SCALA_HOME=/usr/share/scala \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export SCALA_HOME = $SCALA_HOME" >> $LogFile 2>&1
	export PATH=$PATH:$SCALA_HOME/bin	
fi

if [ -d "$HadoopHome" ]; then
	export HADOOP_HOME=$HadoopHome \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HADOOP_HOME = $HADOOP_HOME" >> $LogFile 2>&1
#	export HADOOP_COMMON_HOME=$HADOOP_HOME/share/hadoop/common \
#	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HADOOP_COMMON_HOME = $HADOOP_COMMON_HOME" >> $LogFile 2>&1
#	export HADOOP_HDFS_HOME=$HADOOP_HOME/share/hadoop/hdfs \
#	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HADOOP_HDFS_HOME = $HADOOP_HDFS_HOME" >> $LogFile 2>&1
#	export HADOOP_MAPRED_HOME=$HADOOP_HOME/share/hadoop/mapreduce \
#	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HADOOP_MAPRED_HOME = $HADOOP_MAPRED_HOME" >> $LogFile 2>&1
#	export HADOOP_YARN_HOME=$HADOOP_HOME/share/hadoop/yarn \
#	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HADOOP_YARN_HOME = $HADOOP_YARN_HOME" >> $LogFile 2>&1

	# 若沒有設定 $HADOOP_CONF_DIR，預設 Hadoop 設定檔是放置在 $HADOOP_HOME/etc/hadoop 內。
	[[ -d $ClusterConf/hadoop ]] && export HADOOP_CONF_DIR=$ClusterConf/hadoop || export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HADOOP_CONF_DIR = $HADOOP_CONF_DIR" >> $LogFile 2>&1
	[[ -d $ClusterConf/hadoop ]] && export YARN_CONF_DIR=$ClusterConf/hadoop || export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export YARN_CONF_DIR = $YARN_CONF_DIR" >> $LogFile 2>&1

	export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export LD_LIBRARY_PATH = $LD_LIBRARY_PATH" >> $LogFile 2>&1
	export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HADOOP_COMMON_LIB_NATIVE_DIR = $HADOOP_COMMON_LIB_NATIVE_DIR" >> $LogFile 2>&1
	export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native" \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HADOOP_OPTS = $HADOOP_OPTS" >> $LogFile 2>&1
	export HADOOP_USER_CLASSPATH_FIRST=true \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HADOOP_USER_CLASSPATH_FIRST = $HADOOP_USER_CLASSPATH_FIRST" >> $LogFile 2>&1

	# 設置 Log 檔的放置目錄，若目錄不存在就建立。
	[[ ! -d $LogDir/hadoop ]] && mkdir -p $LogDir/hadoop && chmod 777 -R $LogDir/hadoop
	[[ ! -d $LogDir/hdfs ]] && mkdir -p $LogDir/hdfs && chmod 777 -R $LogDir/hdfs
	[[ ! -d $LogDir/yarn ]] && mkdir -p $LogDir/yarn && chmod 777 -R $LogDir/yarn
	[[ ! -d $LogDir/mapred ]] && mkdir -p $LogDir/mapred && chmod 777 -R $LogDir/mapred
	export HADOOP_LOG_DIR=$LogDir/hadoop \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HADOOP_LOG_DIR = $HADOOP_LOG_DIR" >> $LogFile 2>&1
	export HDFS_LOG_DIR=$LogDir/hdfs \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HDFS_LOG_DIR = $HDFS_LOG_DIR" >> $LogFile 2>&1
	export YARN_LOG_DIR=$LogDir/yarn \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export YARN_LOG_DIR = $YARN_LOG_DIR" >> $LogFile 2>&1
	export HADOOP_MAPRED_LOG_DIR=$LogDir/mapred \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HADOOP_MAPRED_LOG_DIR = $HADOOP_MAPRED_LOG_DIR" >> $LogFile 2>&1

	export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
fi

if [ -d "$HBaseHome" ]; then
	export HBASE_HOME=$HBaseHome \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HBASE_HOME = $HBASE_HOME" >> $LogFile 2>&1

	[[ -d $ClusterConf/hbase ]] && export HBASE_CONF_DIR=$ClusterConf/hbase || export HBASE_CONF_DIR=$HBASE_HOME/conf \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HBASE_CONF_DIR = $HBASE_CONF_DIR" >> $LogFile 2>&1
	[[ ! -d $LogDir/hbase ]] && mkdir -p $LogDir/hbase && chmod 777 -R $LogDir/hbase
	export HBASE_LOG_DIR=$LogDir/hbase \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HBASE_LOG_DIR = $HBASE_LOG_DIR" >> $LogFile 2>&1

	export PATH=$PATH:$HBASE_HOME/bin
fi

if [ -d "$PigHome" ]; then
	export PIG_HOME=$PigHome \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export PIG_HOME = $PIG_HOME" >> $LogFile 2>&1

	[[ -d $ClusterConf/pig ]] && export PIG_CONF_DIR=$ClusterConf/pig || export PIG_CONF_DIR=$PIG_HOME/conf \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export PIG_CONF_DIR = $PIG_CONF_DIR" >> $LogFile 2>&1
	export PIG_HEAPSIZE=512 \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export PIG_HEAPSIZE = $PIG_HEAPSIZE" >> $LogFile 2>&1
	[[ ! -d $LogDir/pig ]] && mkdir -p $LogDir/pig && chmod 777 -R $LogDir/pig
	export PIG_LOG_DIR=$LogDir/pig \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export PIG_LOG_DIR = $PIG_LOG_DIR" >> $LogFile 2>&1

	export PATH=$PATH:$PIG_HOME/bin
fi

if [ -d "$HiveHome" ]; then
	export HIVE_HOME=$HiveHome \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HIVE_HOME = $HIVE_HOME" >> $LogFile 2>&1

	[[ -d $ClusterConf/hive ]] && export HIVE_CONF_DIR=$ClusterConf/hive || export HIVE_CONF_DIR=$HIVE_HOME/conf \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HIVE_CONF_DIR = $HIVE_CONF_DIR" >> $LogFile 2>&1
	[[ ! -d $LogDir/hive ]] && mkdir -p $LogDir/hive && chmod 777 -R $LogDir/hive
	export HIVE_LOG_DIR=$LogDir/hive \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export HIVE_LOG_DIR = $HIVE_LOG_DIR" >> $LogFile 2>&1

	export PATH=$PATH:$HIVE_HOME/bin
fi

if [ -d "$FlumeHome" ]; then
	export FLUME_HOME=$FlumeHome \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export FLUME_HOME = $FLUME_HOME" >> $LogFile 2>&1

	[[ -d $ClusterConf/flume ]] && export FLUME_CONF_DIR=$ClusterConf/flume || export FLUME_CONF_DIR=$FLUME_HOME/conf \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export FLUME_CONF_DIR = $FLUME_CONF_DIR" >> $LogFile 2>&1
	[[ ! -d $LogDir/flume ]] && mkdir -p $LogDir/flume && chmod 777 -R $LogDir/flume
	export FLUME_LOG_DIR=$LogDir/flume \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export FLUME_LOG_DIR = $FLUME_LOG_DIR" >> $LogFile 2>&1

	export PATH=$PATH:$FLUME_HOME/bin
fi

if [ -d "$KafkaHome" ]; then
	export KAFKA_HOME=$KafkaHome \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export KAFKA_HOME = $KAFKA_HOME" >> $LogFile 2>&1

	[[ -d $ClusterConf/kafka ]] && export KAFKA_CONF_DIR=$ClusterConf/kafka || export KAFKA_CONF_DIR=$KAFKA_HOME/config \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export KAFKA_CONF_DIR = $KAFKA_CONF_DIR" >> $LogFile 2>&1
	[[ ! -d $LogDir/kafka ]] && mkdir -p $LogDir/kafka && chmod 777 -R $LogDir/kafka
	export KAFKA_LOG_DIR=$LogDir/kafka \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export KAFKA_LOG_DIR = $KAFKA_LOG_DIR" >> $LogFile 2>&1

	export PATH=$PATH:$KAFKA_HOME/bin
fi

if [ -d "$ZookeeperHome" ]; then
	export ZOOKEEPER_HOME=$ZookeeperHome \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export ZOOKEEPER_HOME = $ZOOKEEPER_HOME" >> $LogFile 2>&1

	[[ -d $ClusterConf/zookeeper ]] && export ZOOKEEPER_CONF_DIR=$ClusterConf/zookeeper || export ZOOKEEPER_CONF_DIR=$ZOOKEEPER_HOME/conf \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export ZOOKEEPER_CONF_DIR = $ZOOKEEPER_CONF_DIR" >> $LogFile 2>&1
	[[ ! -d $LogDir/zookeeper ]] && mkdir -p $LogDir/zookeeper && chmod 777 -R $LogDir/zookeeper
	export ZOOKEEPER_LOG_DIR=$LogDir/zookeeper \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export ZOOKEEPER_LOG_DIR = $ZOOKEEPER_LOG_DIR" >> $LogFile 2>&1

	export PATH=$PATH:$ZOOKEEPER_HOME/bin
fi

if [ -d "$SparkHome" ]; then
	export SPARK_HOME=$SparkHome \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export SPARK_HOME = $SPARK_HOME" >> $LogFile 2>&1

	# 判斷 $SparkPython 是否有值，有的話則將 Spark 所用的 Python 更改成指定的版本。
	[[ -n $SparkPython ]] && export PYSPARK_PYTHON=$SparkPython || export PYSPARK_PYTHON=python2

	#export SPARK_HOME=/opt/spark-1.6.3-bin-hadoop2.6
	[[ -d $ClusterConf/spark ]] && export SPARK_CONF_DIR=$ClusterConf/spark || export SPARK_CONF_DIR=$SPARK_HOME/conf \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export SPARK_CONF_DIR = $SPARK_CONF_DIR" >> $LogFile 2>&1
	[[ ! -d $LogDir/spark ]] && mkdir -p $LogDir/spark && chmod 777 -R $LogDir/spark
	export SPARK_LOG_DIR=$LogDir/spark \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export SPARK_LOG_DIR = $SPARK_LOG_DIR" >> $LogFile 2>&1

	export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

	# 不論是否有安裝 Hive，強制 PySpark 都在記憶體內進行運算。
	alias pyspark='pyspark --conf spark.sql.catalogImplementation=in-memory'
fi

if [ -d "$AnacondaHome" ]; then
	export ANACONDA_HOME=$AnacondaHome \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export ANACONDA_HOME = $ANACONDA_HOME" >> $LogFile 2>&1

	export PATH=$PATH:$ANACONDA_HOME/bin
fi

# 若有安裝 Anaconda 及 Spark，則設置使用 Jupyter Notebook。
if ( [ -d "$AnacondaHome" ] && [ -d "$SparkHome" ] ); then
	# 即使 Python 版本由使用者在 /opt/conf/hosts 設計圖中設置，但 Jupyter Notebook 需使用軟體內附的 Python 2.7 版本。
	export PYSPARK_PYTHON=$AnacondaHome/bin/python
	# ipython 未來將被 jupyter 取代。
	#export PYSPARK_DRIVER_PYTHON=$AnacondaHome/bin/ipython \
	#&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export PYSPARK_DRIVER_PYTHON = $PYSPARK_DRIVER_PYTHON" >> $LogFile 2>&1
	export PYSPARK_DRIVER_PYTHON=$AnacondaHome/bin/jupyter \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export PYSPARK_DRIVER_PYTHON = $PYSPARK_DRIVER_PYTHON" >> $LogFile 2>&1

	# 設置 Anaconda 工作目錄，若不存在則建立一個。
	[[ ! -d "$AnacondaWork" ]] && mkdir -p "$AnacondaWork" && chmod 777 -R "$AnacondaWork"

	# 設置 Jupyter Notebook 執行參數。「--port」：設置監聽的連接埠。「--no-browser」：執行程式不自動開啟瀏覽器。「--ip」：設置允許連入 IP，0.0.0.0 為不限制。「--notebook-dir」：設置預設的工作目錄，若為空則為執行應用程式的目錄。
	export PYSPARK_DRIVER_PYTHON_OPTS="notebook --port=8888 --no-browser --ip=0.0.0.0 --notebook-dir=$AnacondaWork" \
	&& echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME: Export PYSPARK_DRIVER_PYTHON_OPTS = $PYSPARK_DRIVER_PYTHON_OPTS" >> $LogFile 2>&1
fi

# 若有非 root 的使用者使用 SSH 登入，則紀錄其登入資訊。
if [ "$SSH_CLIENT" != "" ]; then
	echo "$(date +%Y-%m-%dT%H:%M:%S) $USER@$HOSTNAME Login Info: $(who)" >> $LogFile 2>&1
fi

# 經測試，若在結尾 unset 變數，會導致 ssh 遠端執行時無法辨視相關指令（如：hdfs 等）。
#unset CtnConf RegPath AnacondaWork LogDir LogFile AppAdmin ClusterConf SparkPython HadoopHome HBaseHome HiveHome PigHome ZookeeperHome FlumeHome KafkaHome SparkHome AnacondaHome