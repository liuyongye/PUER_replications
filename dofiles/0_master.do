/* =============================================================================
 * Program: 北大教育评论-幼儿园班级规模与儿童发展：来自县域追踪调查的证据 (2020年第3期)
 * Author: Yongye Liu (liuyongye16@gmail.com), Po Yang (Peking University)
 * Date: Jun 2, 2020; Revised: Aug 13 2024
 * Stata/SE 15.1
 * ===========================================================================*/

clear all
cap log close
set more off
version 15.1


/* Before executing, please make sure your Stata contains following user-written commands
ssc install estout, replace
*/


* Yongye' s working directory 
global root = "C:\Users\Yongye LIU\Desktop\PUER_class_size_child_development"
global working_data = "$root\working_data"
global tables = "$root\tables"
global figures = "$root\figures"
global logfiles = "$root\logfiles"

* log using 
log using "$logfiles\PUER_published_results.log", replace

* run all replication files
do "$root\dofiles\1_figure1.do"
do "$root\dofiles\2_data_analysis.do"
do "$root\dofiles\2_Table2.do"
do "$root\dofiles\2_Table3.do"

log close
clear
exit, clear
