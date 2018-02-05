#天润日均通话时间#
SELECT date_format(from_unixtime(c.start_time), '%Y-%m') as '日期',
				count(c.customer_number) as '呼出数',
				sum(if(c.status = 21, 1, 0)) as '未接通数',
				sum(if(c.status = 22, 1, 0)) as '无效数',
				sum(if(c.status = 24, 1, 0)) as '座席未接通数',
				sum(if(c.status = 28, 1, 0)) as '接通数',
				sum(if(c.status = 28, 1, 0))/count(c.customer_number) as '接通率',
				avg(if(c.status = 28,c.total_duration,0)) as '接通电话通话时长'
FROM crm_call_outcome_record c
WHERE date_format(from_unixtime(c.start_time), '%Y-%m') >= '2017-11-01' and date_format(from_unixtime(c.start_time), '%Y-%m') <= '2017-11-06'
GROUP BY date_format(from_unixtime(c.start_time), '%Y-%m')

#TMK天润日均通话时间#
SELECT date_format(from_unixtime(c.start_time), '%Y-%m') as '日期',
				count(c.customer_number) as '呼出数',
				sum(if(c.status = 21, 1, 0)) as '未接通数',
				sum(if(c.status = 22, 1, 0)) as '无效数',
				sum(if(c.status = 24, 1, 0)) as '座席未接通数',
				sum(if(c.status = 28, 1, 0)) as '接通数',
				sum(if(c.status = 28, 1, 0))/count(c.customer_number) as '接通率',
				avg(if(c.status = 28,c.total_duration,0)) as '接通通话时长'
FROM crm_call_outcome_record c join crm_personnel b 
on c.client_name=b.content
WHERE date_format(from_unixtime(c.start_time), '%Y-%m') >= '2017-11-01' and date_format(from_unixtime(c.start_time), '%Y-%m') <= '2017-12-01'
and b.role like "%TMK%"
GROUP BY date_format(from_unixtime(c.start_time), '%Y-%m')


#天润某人日均通话时间#
SELECT date_format(from_unixtime(c.start_time), '%Y-%m-%d') as '日期',
                c.client_name as '咨询师姓名',
				count(c.customer_number) as '呼出数',
				sum(if(c.status = 21, 1, 0)) as '未接通数',
				sum(if(c.status = 22, 1, 0)) as '无效数',
				sum(if(c.status = 24, 1, 0)) as '座席未接通数',
				sum(if(c.status = 28, 1, 0)) as '接通数',
				sum(if(c.status = 28, 1, 0))/count(c.customer_number) as '接通率',
				avg(if(c.status = 28,c.total_duration,0)) as '接通通话时长'
FROM crm_call_outcome_record c
WHERE
c.client_name in ('青香')
AND date_format(from_unixtime(c.start_time), '%Y-%m-%d') >= '2017-11-01' and date_format(from_unixtime(c.start_time), '%Y-%m-%d') <= '2017-12-01'
GROUP BY date_format(from_unixtime(c.start_time), '%Y-%m-%d')


#天润日通话最长#
SELECT x.a,x.b,max(x.c)
from (
SELECT date_format(from_unixtime(start_time), '%Y-%m-%d') as a,
                client_name as b,
				sum(total_duration) as c
FROM crm_call_outcome_record 
WHERE date_format(from_unixtime(start_time), '%Y-%m-%d') >= '2017-05-01' and date_format(from_unixtime(start_time), '%Y-%m-%d') <= '2017-07-07'
AND status = 28
GROUP BY date_format(from_unixtime(start_time), '%Y-%m-%d'),client_name) as x
group by x.a,x.b


- 未接通号码拨打次数分布（对应到渠道）
SELECT 
from 





- 成单电话呼出次数-接通次数分布（对应到个人）

#分时段数据分析 外呼
SELECT a.d as '日期',a.h as '时段',
       count(a.id) as '呼出数',
       sum(if(a.status = 28, 1, 0))as '接通数',
       avg(if(a.status = 28,a.t,0)) as '接通通话时长',
       count(distinct a.tel) as '呼出用户数',
       count(distinct a.name) as '呼出咨询师数'
from 
(SELECT  date_format(from_unixtime(start_time), '%Y-%m-%d') as d , 
        date_format(from_unixtime(start_time), '%H') as h,
        outcome_id as id,
        client_name as name,
        customer_number as tel,
        status,
        total_duration as t
from crm_call_outcome_record
where date_format(from_unixtime(start_time), '%Y-%m-%d')>='2017-10-06') as a 
group by a.d ,a.h

------
呼入

1:座席接听 
2:已呼叫座席，座席未接听 
3:系统接听 
4:系统未接-IVR配置错误 
5:系统未接-停机 
6:系统未接-欠费 
7:系统未接-黑名单 
8:系统未接-未注册 
9:系统未接-彩铃 
10:网上400未接受 
11:系统未接-呼叫超出营帐中设置的最大限制 
12:其他错误

#分时段数据分析 呼入
SELECT a.d as '日期',a.h as '时段',
       count(a.id) as '呼入数',
       sum(if(a.status = 1, 1, 0))as '接通数',
       avg(if(a.status = 1,a.t,0)) as '接通通话时长',
       count(distinct a.tel) as '呼入用户数',
       count(distinct a.name) as '呼入咨询师数'
from 
(SELECT  date_format(from_unixtime(start_time), '%Y-%m-%d') as d , 
        date_format(from_unixtime(start_time), '%H') as h,
        income_id as id,
        client_name as name,
        customer_number as tel,
        status,
        total_duration as t
from crm_call_income_record
where date_format(from_unixtime(start_time), '%Y-%m-%d')>='2017-10-06') as a 
group by a.d ,a.h



逐月接通率
select substring(date_format(from_unixtime(start_time), '%Y-%m-%d'),1,7) as "Month" ,
count(customer_number) as "打电话数",
count(distinct customer_number) as "拨打用户数",
sum(if(status=1,1,0)) as "接通电话数",
count(customer_number)/count(distinct customer_number)  as "用户平均拨打次数",
sum(if(status=1,1,0))/count(customer_number) as "接通率"
from crm_call_income_record
group by substring(date_format(from_unixtime(start_time), '%Y-%m-%d'),1,7)

咨询师逐月接通率
select client_name,substring(date_format(from_unixtime(start_time), '%Y-%m-%d'),1,7) as "Month" ,
count(customer_number) as "打电话数",
count(distinct customer_number) as "拨打用户数",
sum(if(status=1,1,0)) as "接通电话数",
count(customer_number)/count(distinct customer_number)  as "用户平均拨打次数",
sum(if(status=1,1,0))/count(customer_number) as "接通率"
from crm_call_income_record
where from_unixtime(start_time)>='2017-08-08' #这里可以设置要看的时间维度
group by client_name

--------
首次拨打接通率

select substring(x.t,1,10) as dt,
count(distinct x.customer_number) as '首次拨打电话数',
sum(if(x.status=28,1,0)) as '首次接通电话数',
sum(if(x.status=28,1,0)) /count(distinct x.customer_number) as '首次拨打接通率'
from 
(select customer_number,min(from_unixtime(start_time)) as t,status
from crm_call_outcome_record
group by customer_number) as x
where x.t>='2017-10-30'
group by substring(x.t,1,10) 



每月拨打号码总数
select date_format(from_unixtime(start_time), '%Y-%m') as '月份',
count(distinct customer_number) as '拨打用户数'
from crm_call_outcome_record
group by date_format(from_unixtime(start_time), '%Y-%m') 

-------


呼入数
呼入用户
接通数
接通用户

用户接通率
呼入接通率

#天润呼入接通率
SELECT  
count(customer_number) as '呼入数',
sum as '呼入用户数',
sum(if(status= ,1,0))as '接通数',
sum as '接通用户数'
from crm_call_income_record
where date_format(from_unixtime(start_time), '%Y-%m-%d') >= '2017-08-01' 
and date_format(from_unixtime(start_time), '%Y-%m-%d') <= '2017-08-14'




天润坐席未接通通话时长
SELECT sum(if(total_duration<20,1,0)) as'20秒以内',sum(if(total_duration>=20,1,0)) as'超过20秒',sum(if(total_duration<20,1,0))/count(1) as'20秒以内占比'
from crm_call_outcome_record
where status in (24)


天润呼入接通用户
select customer_number
from crm_call_income_record
where status in (1)
and date_format(from_unixtime(start_time), '%Y-%m-%d') >='2017-08-01'



SELECT telephone_number,source
from crm_form_record
where telephone_number in
(13026565552, 13536621608, 13628828211, 13642348500, 13661562624, 13673356610, 13718379800, 13803464194, 13807852460, 13821836888, 13906896151, 13918638068, 13941457101, 14785550396, 15041084707, 15303509132, 15381163499, 15843577749, 15905108633, 17817870085, 18132260963, 18170388783, 18263460840, 18381302037, 18508150744, 18600502945, 18600872103, 18635132997, 18704697465, 18746552288, 13863328460, 13919006203, 13307920627, 13482492662, 15100605350, 13911152197, 15648255477, 15302303463)






