# Homework - Python Spark ML（八）：Hadoop 的安裝

## 【題目連結】
### [Python Spark ML（八）：Hadoop 的安裝](http://hemingwang.blogspot.tw/2017/10/python-spark-mlhadoop.html)

## 【My Answer】

> 因自身是機器學習初學者，此份作業參考各方資料並加入自己的理解，若有誤還請多指教（建立 Github Issue 來協助我修正），謝謝。

### 01、VMware Workstation 虛擬機機器軟體安裝。

- 因課本[01]已針對 Virtual Box 有詳細安裝介紹，且學生工作因素經常接觸 VMware 牌軟體，故這邊將以不同於課本，使用 VMware Workstation 來建立 Apache Spark 實驗區的虛擬平台。

- 解答連結：[001-VMwareWorkstation](./001-VMwareWorkstation)

### 02、CenOS Linux 作業系統安裝

- 課本所使用之 Ubuntu Linux 每半年更新一次，非常適合日新月異的機器學習領域；除了因應後面[第六](./006-CreateHadoopContainerImage)及[第七](./007-HadoopClusterOnUbuntuContainerInCentos)章節，若有同學想嘗試使用在伺服器界較穩定之 CentOS Linux 來作為 Apache Spark 實驗區的作業系統平台，亦可以參考本節。

- 解答連結：[002-InstallCentOS](./002-InstallCentOS)

### 03、Ubuntu Linux 作業系統安裝

- [第四](./004-HadoopSingleNodeOnUbuntu)及[第五](./005-HadoopMultipleNodeOnUbuntu)章節則彷照書中方法使用 Ubuntu 作為 Apache Spark 實驗區的作業系統平台。

- 解答連結：[003-InstallUbuntu](./003-InstallUbuntu)

### 04、Hadoop & Spark Single Node Cluster 安裝

- 彷照課本方式，並加入自己額外的想法，將單機版的 Hadoop 及 Spark + Jupyter Notebook 架設完成。

- 解答連結：[004-HadoopSingleNodeOnUbuntu](./004-HadoopSingleNodeOnUbuntu)

### 05、Hadoop & Spark Multi Node Cluster 安裝

- 彷照課本方式，並加入自己額外的想法，將叢集版的 Hadoop 及 Spark + Jupyter Notebook 架設完成。

- 解答連結：[005-HadoopMultipleNodeOnUbuntu](./005-HadoopMultipleNodeOnUbuntu)

### 06、Hadoop & Spark 工作用 Docker Image 的製作

- 建置提供[下一章節](./007-HadoopClusterOnUbuntuContainerInCentos)所需使用的 Container 容器。

- 解答連結：[006-CreateHadoopContainerImage](./006-CreateHadoopContainerImage)

### 07、Hadoop & Spark 叢集使用 Container 建立

- 為減少多個 VM 造成的資源損耗，故使用一個 VM 多個 Container 建置叢集版的 Hadoop 及 Spark + Jupyter Notebook。

- 解答連結：[007-HadoopClusterOnUbuntuContainerInCentos](./007-HadoopClusterOnUbuntuContainerInCentos)

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
