# Homework - Python Spark ML（二）：Machine Learning

> 題目連結：[Python Spark ML（二）：Machine Learning](http://hemingwang.blogspot.tw/2017/09/python-spark-mlmachine-learning.html)

【My Answer】

因自身是機器學習初學者，對機器學習的理解如下：

- 在特定領域（如：校園、信用卡、購物），從已知特徵數據（如：學生提問數、對象收入、C／P 值）中，找到一組公式，使得我在此領域將所有特徵數據輸入至此公式中後，取得與現實相符的有用資訊（如：學生成績、發放信用卡、是否成交）。接著，我再用此公式來預測僅有特徵數據但實際情況未知的資訊。

- 例如：

<center><table style="width:75%; text-align:center; vertical-align:middle; border: 5px dotted #BACAC6;">
<tr>
<!------------------------------------------------------>
<th colspan="4" align="center">發福人壽核發信用卡紀錄（0：No；1：Yes）</th>
<!------------------------------------------------------>
</tr>
<tr>
<!------------------------------------------------------>
<td style="width:25%;">項次							</td>
<td style="width:25%;">年收入達百萬					</td>
<td style="width:25%;">上班公司是否上市				</td>
<td style="width:25%;">按時還款（是否核可）			</td>
<!------------------------------------------------------>
</tr>
<tr>
<!------------------------------------------------------>
<td>a												</td>
<td>0												</td>
<td>0												</td>
<td>0												</td>
<!------------------------------------------------------>
</tr>
<tr>
<!------------------------------------------------------>
<td>b												</td>
<td>0												</td>
<td>1												</td>
<td>0												</td>
<!------------------------------------------------------>
</tr>
<tr>
<!------------------------------------------------------>
<td>c												</td>
<td>1												</td>
<td>0												</td>
<td>0												</td>
<!------------------------------------------------------>
</tr>
<tr>
<!------------------------------------------------------>
<td>d												</td>
<td>1												</td>
<td>1												</td>
<td>1												</td>
<!------------------------------------------------------>
</tr>
</table></center>

- 找到 W1、W2、B 使得公式 Out = StepFun ( In1 * W1 + In2 * W2 + B ） 在是否核發信用卡恆成立

	註：StepFun ( 輸入 ) = 輸出：當輸入大於 0 時，輸出為 1；其餘輸出為 0。

- 我們可以手動的方式，不斷嘗試找到正解，如：

當 W1 = 0.0、W2 = 0.0、B = 0.0 時，計算項次 d 時答案有錯：StepFun ( 0 * 0.0 + 0 * 0.0 + 0.0 ) = 0 ≠ 1 Wrong!

當 W1 = 0.1、W2 = 0.1、B = 0.1 時，計算項次 a 時答案有錯：StepFun ( 0 * 0.1 + 0 * 0.1 + 0.1 ) = 1 ≠ 0 Wrong!

當 W1 = 0.2、W2 = 0.1、B = 0.0 時，計算項次 b 時答案有錯：StepFun ( 0 * 0.2 + 1 * 0.1 + 0.0 ) = 1 ≠ 0 Wrong!

當 W1 = 0.2、W2 = 0.1、B = -0.1 時，計算項次 c 時答案有錯：StepFun ( 1 * 0.2 + 0 * 0.1 - 0.1 ) = 1 ≠ 0 Wrong!

當 W1 = 0.2、W2 = 0.2、B = -0.1 時，計算項次 b 時答案有錯：StepFun ( 0 * 0.2 + 1 * 0.2 - 0.1 ) = 1 ≠ 0 Wrong!

當 W1 = 0.2、W2 = 0.1、B = -0.2 時，終於全對了！

	StepFun ( 0 * 0.2 + 0 * 0.1 - 0.2 ) = 0	
	StepFun ( 0 * 0.2 + 1 * 0.1 - 0.2 ) = 0	
	StepFun ( 1 * 0.2 + 0 * 0.1 - 0.2 ) = 0	
	StepFun ( 1 * 0.2 + 1 * 0.1 - 0.2 ) = 1

- 雖然在當我們知道某人的年收入及上班公司資訊，就可以知道是否核發信用卡給他，但是這樣子來取得 W1、W2、B 實在太累且太慢了！（且現實情況不會只有兩個特徵數據，極有可能有上百個！）

- 所以我們可以透過機器學習的方式，使用像是多元線性回歸方法，讓電腦自動幫我們計算例如上方的 W1、W2 及 B。

- 透過使用 GPU 等運算單元，還可以加快找到公式的速度。

【References】

1. [有趣的機器學習：最簡明入門指南](http://blog.jobbole.com/67616/)
2. [零基礎入門深度學習 (1) - 感知器](https://www.zybuluo.com/hanbingtao/note/433855)

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