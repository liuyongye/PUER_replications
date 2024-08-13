/* =============================================================================
 * Program: 北大教育评论-幼儿园班级规模与儿童发展：来自县域追踪调查的证据
 * Author: Yongye Liu (liuyongye16@gmail.com), Po Yang (Peking University)
 * Date: Jun 2, 2020
 * Stata/SE 15.1
 * ===========================================================================*/

clear all
set more off

* load data
use "$working_data\PUER_reg_data.dta", clear

* change data label to English
label language english
des

					**********************************
					*** Part 1: Summary Statistics ***
					**********************************
*** Kindergarten level summary statistics
preserve 
	duplicates drop kidid, force
	eststo clear
	eststo tab0a: estpost summarize public urban17 kgdloc

	esttab tab0a using "$tables\summary_statistics.rtf", ///
		cell("count(fmt(0)) mean(fmt(4)) sd(fmt(4)) min(fmt(4)) max(fmt(4))") ///
		label nonumber replace
restore

** Classroom level summary statistics
preserve
	duplicates drop classid, force
	eststo clear
	eststo tab0b: estpost summarize tlnwage avg_tage avg_texp avg_theduy ES CO IS

	esttab tab0b using "$tables\summary_statistics.rtf", ///
		cell("count(fmt(0)) mean(fmt(4)) sd(fmt(4)) min(fmt(4)) max(fmt(4))") ///
		label nonumber append
restore


** Children level summary statistics

local variables "stdtotal_17 stdtotal_18 stdcd_17 stdcd_18 stdsed_17 stdsed_18"
local indvar "boy age17 heduy guardian ruralhk siblings hai"

eststo clear
eststo tab0c: estpost summarize `variables' `indvar'

esttab tab0c using  "$tables\summary_statistics.rtf", ///
	cell("count(fmt(0)) mean(fmt(4)) sd(fmt(4)) min(fmt(4)) max(fmt(4))") ///
label nonumber append

							********************
							*** HLM analysis ***
							********************
global le1covar "boy age17 heduy guardian ruralhk siblings hai"
global le2covar1 "public urban17 avg_theduy avg_texp tlnwage avg_tage"
/*层二的第一组变量是所有班级内的教师（含保育员）的平均水平*/

global le2covar2 "public urban17 avg_ztheduy avg_ztexp tzlnwage avg_ztage"
/*层二的第一组变量是所有班级内的主班教师的平均水平*/


					**********************************
					*** 回归表格: quasi-gains model ***
					**********************************
		* ------------------------ 班级规模分类变量 ------------------------- *
* 表4： 基准回归 
** 小班样本完整模型
mixed stdtotal_18 b3.class_size $le1covar $le2covar1 NumTea || classid: if Grade == 1, nolog reml
eststo r1

** 小班样本完整模型：纳入基线得分
mixed stdtotal_18 b3.class_size stdtotal_17 $le1covar $le2covar1 NumTea || classid: if Grade == 1,nolog reml
eststo r2 

** 中班样本完整模型
mixed stdtotal_18 b3.class_size $le1covar $le2covar1 NumTea || classid: if Grade == 2, nolog reml
eststo r3

** 中班样本完整模型：纳入基线得分
mixed stdtotal_18 b3.class_size stdtotal_17 $le1covar $le2covar1 NumTea || classid: if Grade == 2, nolog reml
eststo r4

esttab r* using "$tables/published_table20200703.rtf", ///
	transform(ln*: exp(2*@) 2*exp(2*@)) ///
	eqlabels ("" "var(_cons)" "var(Residual)", none) ///
	se nogaps compress label nobaselevels ///
	order(1.class_size 2.class_size $le2covar1 NumTea $le1covar) ///
	mgroups("Juniors sample" "Middle sample", pattern(1 0 1 0 1 0)) ///
	nomtitles ///
	b(%6.3f) t(%6.2f)  star(* 0.1 ** 0.05 *** 0.01) ///
	scalars("ll Log lik." "chi2 Wald chi2") ///
	title("{\b Table 4. Baseline regression}") replace

eststo clear

							*****************
							*** 异质性分析 ***
							*****************
* 表5：班级规模对城乡幼儿园儿童发展影响的异质性检验
*** 城乡heterogeneity 
global level2cov "tlnwage avg_tage avg_texp avg_theduy"

mixed stdtotal_18 b3.class_size stdtotal_17 $le1covar $level2cov NumTea public || classid: if Grade == 1 & urban17 == 0, nolog reml
eststo r1 //农村小班

mixed stdtotal_18 b3.class_size stdtotal_17 $le1covar $level2cov NumTea public || classid: if Grade == 1 & urban17 == 1, nolog reml
eststo r2 //城镇小班

mixed stdtotal_18 b3.class_size stdtotal_17 $le1covar $level2cov NumTea public || classid: if Grade == 2 & urban17 == 0, nolog reml
eststo r3 //农村中班

mixed stdtotal_18 b3.class_size stdtotal_17 $le1covar $level2cov NumTea public || classid: if Grade == 2 & urban17 == 1, nolog reml
eststo r4 //城镇中班

esttab r* using "$tables/published_table20200703.rtf", ///
	transform(ln*: exp(2*@) 2*exp(2*@)) ///
	eqlabels ("" "var(_cons)" "var(Residual)", none) ///
	se nogaps compress label ///
	keep(1.class_size 2.class_size) ///
	mgroups("Juniors sample" "Middle sample", pattern(1 0 1 0)) ///
	nonumbers mtitles("Rural kindergartens" "Urban kindergartens" "Rural kindergartens" "Urban kindergartens" ) ///
	b(%6.3f) t(%6.2f)  star(* 0.1 ** 0.05 *** 0.01) ///
	scalars("ll Log lik." "chi2 Wald chi2") ///
	title("{\b Table 5. urban & rural heterogeneity}") ///
	append 

eststo clear

* 表6.班级规模对不同所有制幼儿园儿童发展影响的异质性检验
*** 公民办
mixed stdtotal_18 b3.class_size stdtotal_17 $le1covar $level2cov NumTea urban17 || classid: if Grade == 1 & public == 1, nolog reml
eststo r1 //公办小班

mixed stdtotal_18 b3.class_size stdtotal_17 $le1covar $level2cov NumTea urban17 || classid: if Grade == 1 & public == 0, nolog reml
eststo r2 //民办小班

mixed stdtotal_18 b3.class_size stdtotal_17 $le1covar $level2cov NumTea urban17 || classid: if Grade == 2 & public == 1, nolog reml
eststo r3 //公办中班

mixed stdtotal_18 b3.class_size stdtotal_17 $le1covar $level2cov NumTea urban17 || classid: if Grade == 2 & public == 0, nolog reml
eststo r4 //民办中班

esttab r* using "$tables/published_table20200703.rtf", ///
	transform(ln*: exp(2*@) 2*exp(2*@)) ///
	eqlabels ("" "var(_cons)" "var(Residual)", none) ///
	se nogaps compress label ///
	nobaselevels keep(1.class_size 2.class_size) ///
	mgroups("Juniors sample" "Middle sample", pattern(1 0 1 0)) ///
	nonumbers mtitles("Pubilc kindergartens" "Private kindergartens" "Pubilc kindergartens" "Private kindergartens" ) ///
	b(%6.3f) t(%6.2f)  star(* 0.1 ** 0.05 *** 0.01) ///
	scalars("ll Log lik." "chi2 Wald chi2") ///
	title("{\b Table 6. Public and Private Kindergarten heterogeneity}") ///
	append 

eststo clear

*** 表7：班级规模对不同家庭社会经济背景儿童的影响

egen median_hai = median(hai)
gen low_hai = .
replace low_hai = 1 if hai < median_hai
replace low_hai = 0 if hai >= median_hai

tab low_hai


eststo clear
** 小班样本完整模型
mixed stdtotal_18 b3.class_size stdtotal_17 $le1covar $le2covar1 NumTea || classid: if Grade == 1 & low_hai == 1, nolog reml
eststo r1 //小班低SES

mixed stdtotal_18 b3.class_size stdtotal_17 $le1covar $le2covar1 NumTea || classid: if Grade == 1 & low_hai == 0, nolog reml
eststo r2 //小班高SES

** 中班样本完整模型
mixed stdtotal_18 b3.class_size stdtotal_17 $le1covar $le2covar1 NumTea || classid: if Grade == 2 & low_hai == 1, nolog reml
eststo r3 //中班低SES

mixed stdtotal_18 b3.class_size stdtotal_17 $le1covar $le2covar1 NumTea || classid: if Grade == 2 & low_hai == 0, nolog reml
eststo r4 //中班高SES

esttab r* using "$tables/published_table20200703.rtf", ///
	transform(ln*: exp(2*@) 2*exp(2*@)) ///
	eqlabels ("" "var(_cons)" "var(Residual)", none) ///
	se nogaps compress label ///
	nobase keep(1.class_size 2.class_size) ///
	mgroups("Juniors sample" "Middle sample", pattern(1 0  1 0 )) /// 
	nonumbers mtitles("Low SES" "High SES" "Low SES" "High SES") ///
	b(%6.3f) t(%6.2f)  star(* 0.1 ** 0.05 *** 0.01) ///
	scalars("ll Log lik." "chi2 Wald chi2") ///
	title("{\b Table 4. SES heterogeneity}") ///
	append

						************************
						*** Robustness Check ***
						************************

			* -------------------- 表8. 班级规模的非线性检验结果 -------------------- *
** 小班样本
mixed stdtotal_18 NumTotChi stdtotal_17 $le1covar $le2covar1 NumTea || classid: if Grade == 1, nolog reml
eststo r1

mixed stdtotal_18 NumTotChi cs2 stdtotal_17 $le1covar $le2covar1 NumTea || classid: if Grade == 1, nolog reml
eststo r2

** 中班样本完整模型
mixed stdtotal_18 NumTotChi stdtotal_17 $le1covar $le2covar1 NumTea || classid: if Grade == 2, nolog reml
eststo r3

mixed stdtotal_18 NumTotChi cs2 stdtotal_17 $le1covar $le2covar1 NumTea || classid: if Grade == 2, nolog reml
eststo r4

// 使用keep仅保留感兴趣的系数： 班级规模以及班级规模的二次方  
esttab r* using "$tables/published_table20200703.rtf", ///
	se nogaps compress label ///
	transform(ln*: exp(2*@) 2*exp(2*@)) ///
	eqlabels ("" "var(_cons)" "var(Residual)", none) ///
	nodepvar nonumbers mgroups("Juniors sample" "Middle sample", pattern(1 0 1 0)) ///
	b(%6.3f) star(* 0.1 ** 0.05 *** 0.01) ///
	scalars("ll Log lik." "chi2 Wald chi2") ///
	keep(NumTotChi cs2) ///
	title("{\b Table 5. Panel A continous CS & non-linear relationship}") ///
	append

* 表9. 幼师比的非线性检验结果
gen ratios = NumTotChi/NumTea
label var ratios "Observed Classroom's child-to-teachers ratio"

gen sq_ratios = ratios*ratios

eststo clear
** 小班样本
mixed stdtotal_18 ratios NumTotChi stdtotal_17 $le1covar $le2covar1 NumTea || classid: if Grade == 1, nolog reml
eststo r1

mixed stdtotal_18 ratios sq_ratios NumTotChi stdtotal_17 $le1covar $le2covar1 NumTea || classid: if Grade == 1, nolog reml
eststo r2

** 中班样本完整模型
mixed stdtotal_18 ratios NumTotChi stdtotal_17 $le1covar $le2covar1 NumTea || classid: if Grade == 2, nolog reml
eststo r3

mixed stdtotal_18 ratios sq_ratios NumTotChi stdtotal_17 $le1covar $le2covar1 NumTea || classid: if Grade == 2, nolog reml
eststo r4

esttab r* using "$tables/published_table20200703.rtf", ///
	se nogaps compress ///
	transform(ln*: exp(2*@) 2*exp(2*@)) ///
	eqlabels ("" "var(_cons)" "var(Residual)", none) ///
	nodepvar nonumbers mgroups("Juniors sample" "Middle sample", pattern(1 0 1 0)) ///
	b(%6.3f) se(%6.3f) star(* 0.1 ** 0.05 *** 0.01) ///
	scalars("ll Log lik." "chi2 Wald chi2") ///
	keep(ratios sq_ratios) ///
	title("{\b Table 5. Panel B child-to-staff ratios (with CS control)}") ///
	append

			* ------------- 换因变量: 不同维度的稳健性检验 ------------- *
* 表 10. 班级规模对儿童不同发展领域的影响
*** 认知发展维度： 
eststo clear
** 小班样本完整模型
mixed stdcd_18 b3.class_size stdcd_17 $le1covar $le2covar1 NumTea || classid: if Grade == 1, nolog reml
eststo r1

** 中班样本完整模型
mixed stdcd_18 b3.class_size stdcd_17 $le1covar $le2covar1 NumTea || classid: if Grade == 2, nolog reml
eststo r2 

*** 社会性情感发展维度： 
** 小班样本完整模型
mixed stdsed_18 b3.class_size stdsed_17 $le1covar $le2covar1 NumTea || classid: if Grade == 1, nolog reml
eststo r3

** 中班样本完整模型
mixed stdsed_18 b3.class_size stdsed_17 $le1covar $le2covar1 NumTea || classid: if Grade == 2, nolog reml
eststo r4

esttab r* using "$tables/published_table20200703.rtf", ///
	transform(ln*: exp(2*@) 2*exp(2*@)) ///
	eqlabels ("" "var(_cons)" "var(Residual)", none) ///
	se nogaps compress label ///
	nobase keep(1.class_size 2.class_size) ///
	mgroups("Cognitive development" "Social emotional development", pattern(1 0 1 0)) /// 
	nonumbers mtitles("Juniors sample" "Middle sample" "Juniors sample" "Middle sample") ///
	b(%6.3f) t(%6.2f)  star(* 0.1 ** 0.05 *** 0.01) ///
	scalars("ll Log lik." "chi2 Wald chi2") ///
	title("{\b Table 6. Different outcomes} ") ///
	append 
eststo clear

clear
exit, clear
