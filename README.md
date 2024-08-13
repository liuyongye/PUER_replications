# Data and codes for replicating "Preshool Class Size and Child Development: Evidence from a County-Level Follow-up Survey"

Yongye Liu (HKUSTGZ), Po Yang (Peking University)

Aug 2024



This README file provides an overview of the data and codes for replicating the empirical results in our paper "Preshool Class Size and Child Development: Evidence from a County-Level Follow-up Survey", together with the step-by-step instructions. The data and codes have been deposited in the author's GitHub repository. Please download all the materials, including:

```
│ README.md
│
├─dofiles
│ 0_master.do
│ 1_figure1.do
│ 2_data_analysis.do
│ 2_Table2.do
│ 2_Table3.do
│
├─figures (should be empty at the beginning)
│
├─logfiles (should be empty at the beginning)
│
├─tables (should be empty at the beginning)
│
└─working_data
  PUER_figure1_data.dta
  PUER_reg_data.dta
  PUER_table2_data.dta
  PUER_table3_data.dta
```

Note that we organize our code according to the data set used in the analysis instead of the order of tables and figures that appear in the paper. We make this arrangement because our analysis switches among different datasets frequently. Organizing the code by dataset reduces the repetitive operations and makes the flow clearer.

## 1 Step-by-Step Instructions for Replication

### 1.1 Accessing the Raw Data

Our paper uses data from the project held by Prof. [Yingquan Song](https://ciefr.pku.edu.cn/gywm/sztd/qzjs/84f2f9a1b4ca46a696d89e325796c54d.htm) from the China Instistute for Educational Finance Research (CIEFR) at Peking University. Since we don't have permission to release the raw data, we only released the working data we used in the main analyses. If you want to access the full dataset, please contact Prof. Song directly via yqsong@ciefr.pku.edu.cn.

### 1.2 Software Preparation

The file `0_master.do` depicts the steps to replicate our results. We use `Stata/SE 15.1` for data analysis. In addition to the standard Stata commands, we also use several user-written commands. Please type in Stata following commands to install them:

```Stata
ssc install estout, replace
```

### 1.3 Define the Local Paths

One needs to prepare the following folders and define them as the local paths:

* `$root`: global path of the whole project.

* `$dofiles`: the folder containing all the code (do-les) for replication.

* `$working_data`: the folder containing the analyzed data for our main analysis.

* `$tables`: the folder that stores the table outputs. It should be empty at the beginning.

* `$figures`: the folder that stores the figure outputs. It should be empty at the beginning.

* `$logfiles`: the folder that stores the log outputs. It should be empty at the beginning.

### 1.4 Run the Codes in Order

After the above preparations, one can execute the following `do-files` in order in the folder `dofiles` to replicate all the tables and gures in our paper. Table 1 provides detailed infomation on how to replicate our results. You can run the `0_master.do` to replicate our results directly.



Readme-Table 1: The Correspondence between Outputs (Table/Figure) and Codes

|          | Title                         | Source                            |
| -------- | ----------------------------- | --------------------------------- |
|          | Tables                        |                                   |
| Table 1  | 相关变量数据来源以及描述统计                | 2_data_analysis.do, lines 18-54   |
| Table 2  | 华北某县全县幼儿园平均班级规模的描述统计          | 2_Table2.do                       |
| Table 3  | 华北某县抽样园班级规模的描述统计              | 2_Table3.do                       |
| Table 4  | 班级规模和儿童总体发展水平关系的基准回归结果        | 2_data_analysis.do, lines 59-99   |
| Table 5  | 班级规模对城乡幼儿园儿童发展影响的异质性检验        | 2_data_analysis.do, lines 104-132 |
| Table 6  | 班级规模对不同所有制幼儿园儿童发展影响的异质性检验     | 2_data_analysis.do, lines 134-160 |
| Table 7  | 班级规模对不同家庭社会经济背景儿童的影响          | 2_data_analysis.do, lines 162-197 |
| Table 8  | 班级规模的非线性检验结果                  | 2_data_analysis.do, lines 199-228 |
| Table 9  | 幼师比的非线性检验结果                   | 2_data_analysis.do, lines 230-260 |
| Table 10 | 班级规模对儿童不同发展领域的影响              | 2_data_analysis.do, lines 262-294 |
|          | Figure                        |                                   |
| Figure 1 | 全国各类幼儿园平均班级规模变化趋势（2001—2017年） | 1_figure1.do                      |




