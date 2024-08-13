clear all
set more off

// load data 
use "$working_data\PUER_figure1_data.dta", clear

// keep data for graph
keep if year > 2000

twoway connect 全国幼儿园 year || ///
	connect 城区幼儿园 year || ///
	connect 镇区幼儿园 year || ///
	connect 乡村幼儿园 year, ///
		yline(30, lp(shortdash)) ylab(20(2)34) yti("幼儿园平均班级规模") ///
		xt("年份") xlab(2001(1)2017, ang(45)) scheme(s1mono)

graph export "$figures\PUER_figure1.png", as(png) width(2400) height(1800) replace
