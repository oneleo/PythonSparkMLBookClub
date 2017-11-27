# Homework - Python Spark ML（八）：Hadoop 的安裝

## 【題目連結】
### [Python Spark ML（九）：Hadoop 基本功能介紹](http://hemingwang.blogspot.tw/2017/11/python-spark-mlhadoop.html)

## 【My Answer】

> 因自身是機器學習初學者，此份作業參考各方資料並加入自己的理解，若有誤還請多指教（建立 Github Issue 來協助我修正），謝謝。

### 001、本處使用[上一篇](../Homework-PythonSparkML_08)作業作好的 Container 叢集環境進行操作。首先將上一篇作業已裝好 Docker 的 CentOS 宿主 VM 開機。

![](./Images/001.png)

### 002、使用 hadoop 帳號及 hadoop 密碼登入後開啟 Terminal，即可開始操作，首先將 Hadoop 叢集架設好。

``` Bash
$ /opt/bin/dkrstart
```

### 003、格式化 HDFS 檔案系統。

``` Bash
$ ssh "$USER"@master hdfs namenode -format
```

### 004、啟動 HDFS、Yarn、SparkWorker。

``` Bash
$ ssh "$USER"@master start-dfs.sh && ssh "$USER"@master start-yarn.sh && ssh "$USER"@master /opt/spark/sbin/start-all.sh
```

### 005、查看 master 容器 Java 程式執行狀況。

``` Bash
$ ssh "$USER"@master jps
```

### 006、查看 data 容器 Java 程式執行狀況。

``` Bash
$ ssh "$USER"@data1 jps
$ ssh "$USER"@data2 jps
$ ssh "$USER"@data3 jps
```

### 007、開始測試 HDFS（第 06 章），首先（遠端至 Master Container）建立 user 目錄。

``` Bash
$ ssh "$USER"@master hadoop fs -mkdir "/user"
```

### 008、（遠端至 Master Container）在 user 目錄下，建立 hadoop 子目錄。

``` Bash
$ ssh "$USER"@master hadoop fs -mkdir "/user/$USER"
```

### 009、（遠端至 Master Container）在 hadoop 目錄下，建立 test 子目錄。

``` Bash
$ ssh "$USER"@master hadoop fs -mkdir /user/$USER/test
```

### 010、（遠端至 Master Container）查看之前建立的 HDFS 目錄。

``` Bash
$ ssh "$USER"@master hadoop fs -ls
```

### 011、（遠端至 Master Container）查看 HDFS 根目錄。

``` Bash
$ ssh "$USER"@master hadoop fs -ls /
```

### 012、（遠端至 Master Container）查看 HDFS 的 /user 目錄。

``` Bash
$ ssh "$USER"@master hadoop fs -ls /user
```

### 013、（遠端至 Master Container）查看 HDFS 的 /user/hadoop 目錄。

``` Bash
$ ssh "$USER"@master hadoop fs -ls /user/$USER
```

### 014、（遠端至 Master Container）一次查看所有子目錄。

``` Bash
$ ssh "$USER"@master hadoop fs -ls -R /
```

### 015、（遠端至 Master Container）建立多層 HDFS 目錄。

``` Bash
$ ssh "$USER"@master hadoop fs -mkdir -p /dir1/dir2/dir3
```

### 016、（遠端至 Master Container）查看所有 HDFS 子目錄。

``` Bash
$ ssh "$USER"@master hadoop fs -ls -R /
```

### 017、（遠端至 Master Container）複製 Master Container 檔案至 HDFS 的目錄。

``` Bash
$ ssh "$USER"@master hadoop fs -copyFromLocal "/opt/hadoop/README.txt" "/user/$USER/test"
```

### 018、（遠端至 Master Container）複製 Master Container 檔案至 HDFS 的目錄的 test1.txt。

``` Bash
$ ssh "$USER"@master hadoop fs -copyFromLocal "/opt/hadoop/README.txt" "/user/$USER/test/test1.txt"
```

### 019、（遠端至 Master Container）列出 HDFS 目錄下的檔案。

``` Bash
$ ssh "$USER"@master hadoop fs -ls /user/$USER/test
```

### 020、（遠端至 Master Container）列出 HDFS 目錄下的檔案內容。

``` Bash
$ ssh "$USER"@master hadoop fs -cat /user/$USER/test/README.txt
```

### 021、（遠端至 Master Container）列出 HDFS 目錄下的檔案內容（導入 more）。

``` Bash
$ ssh "$USER"@master hadoop fs -cat /user/$USER/test/README.txt | more
```

### 022、（遠端至 Master Container）複製 Master Container 檔案至 HDFS 的目錄時，檔案已經存在。

``` Bash
$ ssh "$USER"@master hadoop fs -copyFromLocal "/opt/hadoop/README.txt" "/user/$USER/test"
```

### 023、（遠端至 Master Container）強迫複製檔案。

``` Bash
$ ssh "$USER"@master hadoop fs -copyFromLocal -f "/opt/hadoop/README.txt" "/user/$USER/test"
```

### 024、（遠端至 Master Container）同時複製 NOTICE.txt 與 LICENSE.txt 至 HDFS 目錄 /user/hadoop/test。

``` Bash
$ ssh "$USER"@master hadoop fs -copyFromLocal /opt/hadoop/NOTICE.txt /opt/hadoop/LICENSE.txt /user/$USER/test
```

### 025、（遠端至 Master Container）複製整個 Master Container 目錄 /opt/hadoop/etc 至 HDFS 目錄 /user/hduser/test。

``` Bash
$ ssh "$USER"@master hadoop fs -copyFromLocal /opt/hadoop/etc /user/$USER/test
```

### 026、（遠端至 Master Container）列出在 HDFS 目錄下的檔案。

``` Bash
$ ssh "$USER"@master hadoop fs -ls /user/$USER/test
```

### 027、（遠端至 Master Container）列出 HDFS 目錄 /user/hadoop/test/etc 下的所有檔案。

``` Bash
$ ssh "$USER"@master hadoop fs -ls -R /user/$USER/test/etc
```

### 028、（遠端至 Master Container）使用 put 複製檔案至 HDFS 目錄，會直接覆蓋檔案。

``` Bash
$ ssh "$USER"@master hadoop fs -put "/opt/hadoop/README.txt" "/user/$USER/test/test2.txt"
```

### 029、（遠端至 Master Container）將原本顯示在螢幕上的內容儲存到 HDFS 檔案。

``` Bash
$ ssh "$USER"@master "echo abc | hadoop fs -put - /user/$USER/test/echoin.txt"
```

### 030、（遠端至 Master Container）顯示在 HDFS 的檔案 echoin.txt 的內容。

``` Bash
$ ssh "$USER"@master hadoop fs -cat "/user/$USER/test/echoin.txt"
```

### 031、（遠端至 Master Container）Master Container 目錄的列表，儲存到 HDFS 檔案。

``` Bash
$ ssh "$USER"@master "ls /opt/hadoop | hadoop fs -put - /user/$USER/test/hadooplist.txt"
```

### 032、（遠端至 Master Container）顯示 HDFS 的檔案 hadooplist.txt 內容。

``` Bash
$ ssh "$USER"@master hadoop fs -cat "/user/$USER/test/hadooplist.txt"
```

### 033、（遠端至 Master Container）建立 /tmp/test 測試目錄。

``` Bash
$ ssh "$USER"@master mkdir /tmp/test
```

### 034、（遠端至 Master Container）將 HDFS 的檔案複製到 Master Container。

``` Bash
$ ssh "$USER"@master hadoop fs -copyToLocal "/user/$USER/test/hadooplist.txt" "/tmp/test"
```

### 035、（遠端至 Master Container）查看 Master Container 目錄。

``` Bash
$ ssh "$USER"@master ls "/tmp/test"
```

### 036、（遠端至 Master Container）將整個 HDFS 上的目錄複製到 Master Container。

``` Bash
$ ssh "$USER"@master hadoop fs -get "/user/$USER/test/etc" "/tmp"
```

### 037、（遠端至 Master Container）將 HDFS 上的檔案複製到 Master Container。

``` Bash
$ ssh "$USER"@master hadoop fs -get "/user/$USER/test/README.txt" "/tmp/localREADME.txt"
```

### 038、（遠端至 Master Container）在 HDFS 上建立測試目錄 /user/hadoop/test/temp。

``` Bash
$ ssh "$USER"@master hadoop fs -mkdir "/user/$USER/test/temp"
```

### 039、（遠端至 Master Container）複製 HDFS 檔案至 HDFS 測試目錄。

``` Bash
$ ssh "$USER"@master hadoop fs -cp "/user/$USER/test/README.txt" "/user/$USER/test/temp"
```

### 040、（遠端至 Master Container）查看 HDFS 測試目錄。

``` Bash
$ ssh "$USER"@master hadoop fs -ls "/user/$USER/test/temp"
```

### 041、（遠端至 Master Container）先查看預定要刪除的檔案。

``` Bash
$ ssh "$USER"@master hadoop fs -ls "/user/$USER/test"
```

### 042、（遠端至 Master Container）刪除 HDFS 檔案

``` Bash
$ ssh "$USER"@master hadoop fs -rm "/user/$USER/test/test2.txt"
```

### 043、（遠端至 Master Container）查看預備刪除的 HDFS 目錄

``` Bash
$ ssh "$USER"@master hadoop fs -ls "/user/$USER/test"
```

### 044、（遠端至 Master Container）刪除 HDFS 目錄

``` Bash
$ ssh "$USER"@master hadoop fs -rm -R "/user/$USER/test/etc"
```

### 045、接下來要開始進行 Yarn 測試，首先 SSH 進入到 Master Container 內。

``` Bash
$ ssh "$USER"@master
```

### 046、建立 wordcount 目錄。

``` Bash
hadoop@master:~$ mkdir -p "/home/$USER/wordcount/input"
```

### 047、到下列網址複製 Java 原始碼
* 連結：將 [http://hadoop.apache.org/docs/current/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html#Source_Code](http://hadoop.apache.org/docs/current/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html#Source_Code) 連結內的 Java 程式複製至 /home/$USER/wordcount/WordCount.java 檔內。

``` Bash
hadoop@master:~$ vim /home/$USER/wordcount/WordCount.java
```

> 	import java.io.IOException;
> 	import java.util.StringTokenizer;
> 	
> 	import org.apache.hadoop.conf.Configuration;
> 	import org.apache.hadoop.fs.Path;
> 	import org.apache.hadoop.io.IntWritable;
> 	import org.apache.hadoop.io.Text;
> 	import org.apache.hadoop.mapreduce.Job;
> 	import org.apache.hadoop.mapreduce.Mapper;
> 	import org.apache.hadoop.mapreduce.Reducer;
> 	import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
> 	import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
> 	
> 	public class WordCount {
> 	
> 	  public static class TokenizerMapper
> 	       extends Mapper<Object, Text, Text, IntWritable>{
> 	
> 	    private final static IntWritable one = new IntWritable(1);
> 	    private Text word = new Text();
> 	
> 	    public void map(Object key, Text value, Context context
> 	                    ) throws IOException, InterruptedException {
> 	      StringTokenizer itr = new StringTokenizer(value.toString());
> 	      while (itr.hasMoreTokens()) {
> 	        word.set(itr.nextToken());
> 	        context.write(word, one);
> 	      }
> 	    }
> 	  }
> 	
> 	  public static class IntSumReducer
> 	       extends Reducer<Text,IntWritable,Text,IntWritable{
> 	    private IntWritable result = new IntWritable();
> 	
> 	    public void reduce(Text key, Iterable<IntWritablevalues,
> 	                       Context context
> 	                       ) throws IOException, InterruptedException {
> 	      int sum = 0;
> 	      for (IntWritable val : values) {
> 	        sum += val.get();
> 	      }
> 	      result.set(sum);
> 	      context.write(key, result);
> 	    }
> 	  }
> 	
> 	  public static void main(String[] args) throws Exception {
> 	    Configuration conf = new Configuration();
> 	    Job job = Job.getInstance(conf, "word count");
> 	    job.setJarByClass(WordCount.class);
> 	    job.setMapperClass(TokenizerMapper.class);
> 	    job.setCombinerClass(IntSumReducer.class);
> 	    job.setReducerClass(IntSumReducer.class);
> 	    job.setOutputKeyClass(Text.class);
> 	    job.setOutputValueClass(IntWritable.class);
> 	    FileInputFormat.addInputPath(job, new Path(args[0]));
> 	    FileOutputFormat.setOutputPath(job, new Path(args[1]));
> 	    System.exit(job.waitForCompletion(true) ? 0 : 1);
> 	  }
> 	}

### 048、新增 HADOOP_CLASSPATH 臨時環境變數。

``` Bash
hadoop@master:~$ export HADOOP_CLASSPATH="$JAVA_HOME/lib/tools.jar" && echo "$HADOOP_CLASSPATH"
```

### 049、切換至 /home/$USER/wordcount 資料檔目錄。

``` Bash
hadoop@master:~$ cd "/home/$USER/wordcount"
```

### 050、編譯 WordCount 程式。

``` Bash
hadoop@master:~$ hadoop com.sun.tools.javac.Main WordCount.java
```

### 051、打包 WordCount 類別成為 wc.jar。

``` Bash
hadoop@master:~$ jar cf wc.jar WordCount*.class
```

### 052、查看目錄內容。

``` Bash
hadoop@master:~$ ls
```

### 053、複製 LICENSE.txt。

``` Bash
hadoop@master:~$ cp "/opt/hadoop/LICENSE.txt" "/home/$USER/wordcount/input"
hadoop@master:~$ ls "/home/$USER/wordcount/input"
```

### 054、在 HDFS 建立目錄。

``` Bash
hadoop@master:~$ hadoop fs -mkdir -p "/user/$USER/wordcount/input"
```

### 055、上傳文字檔至 HDFS

``` Bash
hadoop@master:~$ hadoop fs -copyFromLocal "/home/$USER/wordcount/input/LICENSE.txt" "/user/$USER/wordcount/input"
```

### 056、列出 HDFS 檔案

``` Bash
hadoop@master:~$ hadoop fs -ls "/user/$USER/wordcount/input"
```

### 057、切換至 /home/$USER/wordcount 資料檔目錄。

``` Bash
hadoop@master:~$ cd "/home/$USER/wordcount"
```

### 058、執行 WordCount 程式

``` Bash
hadoop@master:~$ hadoop jar wc.jar WordCount "/user/$USER/wordcount/input/LICENSE.txt" "/user/$USER/wordcount/output"
```

### 059、查看 HDFS 的目錄（若有出現 _SUCCESS 檔案，表示上述程式執行成功）

``` Bash
hadoop@master:~$ hadoop fs -ls "/user/$USER/wordcount/output"
```

### 060、查看 HDFS 的輸出檔案內容

``` Bash
hadoop@master:~$ hadoop fs -cat /user/$USER/wordcount/output/part-r-00000 | more
```

### 061、將輸出檔案內容複製到 Master Container 內

``` Bash
hadoop@master:~$ hadoop fs -copyToLocal "/user/$USER/wordcount/output" "/home/$USER/wordcount"
```

### 062、若要再次執行 wc.jar 程式，請先刪除輸出目錄，才不會出現檔案已經存在的錯誤訊息。

``` Bash
hadoop@master:~$ hadoop fs -rm -R /user/$USER/wordcount/output
```

#### 063、停止 SparkWorker、Hadoop Yarn、Hadoop HDFS Java 程式。

``` Bash
$ ssh "$USER"@master /opt/spark/sbin/stop-all.sh && ssh "$USER"@master stop-yarn.sh && ssh "$USER"@master stop-dfs.sh
```

#### 064、關閉所有 Containers。

``` Bash
$ /opt/bin/dkrstop
```

#### 065、刪除所有 Containers。

``` Bash
$ /opt/bin/dkrremove
```

### 066、將 CentOS 宿主進行安全關機。

``` Bash
$ sudo sync; sudo sync; sudo sync; sudo sync; sudo sync; sudo sync; sudo sync; sudo shutdown -h now;
```

## 【References】

- [01] 林大貴，「博碩出版社 - Python+Spark 2.0+Hadoop機器學習與大數據分析實戰」，ISBN-13：9789864341535
- [02] Fenriswolf 程式筆記，「Hadoop 參數設定」，[https://fenriswolf.me/](https://fenriswolf.me/)
- [03] 陳松林老師，「Big Data 研究室」，[http://bigdatahome.blogspot.tw/](http://bigdatahome.blogspot.tw/)
- [04] Apache Hadoop，「Hadoop Docs」，[http://hadoop.apache.org/docs/current/](http://hadoop.apache.org/docs/current/)
- [05] VMware，「VMware Workstation Docs」，[https://docs.vmware.com/en/VMware-Workstation-Pro/14.0/com.vmware.ws.using.doc/GUID-0EE752F8-C159-487A-9159-FE1F646EE4CA.html](https://docs.vmware.com/en/VMware-Workstation-Pro/14.0/com.vmware.ws.using.doc/GUID-0EE752F8-C159-487A-9159-FE1F646EE4CA.html)
- [07] 楊保華、戴王劍、曹亞侖，「碁峰書局 - Docker入門與實戰」，[http://www.books.com.tw/products/0010676115](http://www.books.com.tw/products/0010676115)

License
=============

Copyright {yyyy} Sean Chen

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
