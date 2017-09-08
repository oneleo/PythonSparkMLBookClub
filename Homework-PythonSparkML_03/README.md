# Homework - Python Spark ML（三）：Decision Tree Survey

> 題目連結：[Python Spark ML（三）：Decision Tree Survey](http://hemingwang.blogspot.tw/2017/09/python-spark-mldecision-tree-survey.html)

- 學生在看到老師出的題目後，想找一個範例來測試自己看了決策樹相關資料後的了解程度。沒想到按照所學習到的公式，花了四天晚上去建構決策樹，卻無法建立出來，雖然有看解答去推論原因，但公式解建構不出決策樹的原因仍要持續找尋。此篇有提及如何計算 Homogeneous（同質性）分數、Information Gain（資訊獲得量），以及計算 Gini Index（吉尼係數）在連續尺度上找到最佳切割點。

[【My Answer 01】](./Homework-PythonSparkML_03-01.md)（仍要探討為什麼結合了 Information Gain 和 Gini Index 公式卻無法建立決策樹）

- 另外，為了驗證學生所學到的演算法是正確的，所以有找到另一簡單的範例來建構決策樹，這裡頭有提到使用 Homogeneous（同質性）分數和 Information Gain（資訊獲得量）來建構（沒有使用到 Gini Index），答案是正確的

[【My Answer 02】](./Homework-PythonSparkML_03-02.md)

- 最後如果有知道原因的同學，也請不吝提供 Tips 參考，謝謝您們：）