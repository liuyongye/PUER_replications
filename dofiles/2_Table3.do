
use "$working_data\PUER_table3_data.dta", clear

* Table 3. 华北某县抽样园班级规模的描述统计
*** 平均班级规模
//抽样班级
tabstat NumTotChi, stat(mean) format(%9.2f) 
//小班
tabstat NumTotChi if Grade==1, stat(mean) format(%9.2f)
//中班
tabstat NumTotChi if Grade==2, stat(mean) format(%9.2f)

*** 不同规模班级占比（%）
//抽样班级
tab class_size
//小班
tab class_size if Grade==1
//中班
tab class_size if Grade==2
