use "$working_data\PUER_table2_data.dta", clear

* Table 2. 华北某县全县幼儿园平均班级规模的描述统计
// 全县平均
tabstat AverClassize, stat(mean sd p50 min max) format(%9.2f)
tab CScat

//公办园
tabstat AverClassize if public == 1, stat(mean sd p50 min max) format(%9.2f)
tab CScat if public == 1

//民办园
tabstat AverClassize if public == 0, stat(mean sd p50 min max) format(%9.2f)
tab CScat if public == 0

//城镇园
tabstat AverClassize if urban17 == 1, stat(mean sd p50 min max) format(%9.2f)
tab CScat if urban17 == 1

//乡村园
tabstat AverClassize if urban17 == 0, stat(mean sd p50 min max) format(%9.2f)
tab CScat if urban17 == 0 
