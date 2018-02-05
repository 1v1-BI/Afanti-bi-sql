

SELECT * from 
(    ##source=1

SELECT 	
	s.pid,
	s.telephone_num,
	s.t as '成单日期',
z.t as 'leads日期',
IfNULL(z.source,0) as qxsource ,
	s.`name`,
	s.student_user_id,
	s.planner_name,
	s.lesson_num,
	s.amount/100,
	s.original_amount/100,
	s.`备注`


from 
(
SELECT 

DISTINCT pid ,
i.telephone_num ,
from_unixtime(update_time) as t,


        
                name ,
                student_user_id ,
        # i.telephone_num as '学生手机号',
				#系统记录咨询师-实际咨询师
                planner_name ,
                lesson_num ,
                amount,
                original_amount,
                note as '备注'
FROM series_order

LEFT JOIN(
SELECT  
telephone_num, 
user_id

from user_online
WHERE user_id in(
SELECT 
        DISTINCT    student_user_id as '学生ID'
FROM series_order
WHERE update_time BETWEEN unix_timestamp('2017-04-01') AND unix_timestamp('2017-10-31') #修改成单时间
  AND (note NOT LIKE '%zyb%')
  AND (name NOT LIKE '%测试%')
  AND (name NOT LIKE '%test%')
  and status ='SUCCESS'
  AND amount/100>100
  AND student_user_id NOT IN (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
                              141321906,
                              249450013,
                              250595219,
                              248444058,
                              248259226,
                              251804322,
                              251804626,
                              251804835,
                              251436121,
                              75462035,
                              88452392,
                              122839998,
                              247444506,247673969)
  order by from_unixtime(update_time) 
)
) as i on  i.user_id=student_user_id



WHERE update_time BETWEEN unix_timestamp('2017-04-01') AND unix_timestamp('2017-10-31') #修改成单时间
  AND (note NOT LIKE '%zyb%')
  AND (name NOT LIKE '%测试%')
  AND (name NOT LIKE '%test%')
  and status ='SUCCESS'
  AND amount/100>100
  AND student_user_id NOT IN (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
                              141321906,
                              249450013,
                              250595219,
                              248444058,
                              248259226,
                              251804322,
                              251804626,
                              251804835,
                              251436121,
                              75462035,
                              88452392,
                              122839998,
                              247444506,247673969)
  #order by from_unixtime(update_time)
ORDER BY i.telephone_num,from_unixtime(update_time)
) as s


LEFT JOIN 
(SELECT 
c.telephone_number as tel ,
max(date_format(from_unixtime(c.create_time), '%Y-%m-%d')) as t ,
c.source
from crm_form_record c 
where 
c.telephone_number in 
(# 
#成单 tel
SELECT  
DISTINCT telephone_num
#user_id

from user_online
WHERE user_id in(
SELECT 
        DISTINCT    student_user_id as '学生ID'
FROM series_order
WHERE update_time BETWEEN unix_timestamp('2017-04-01') AND unix_timestamp('2017-10-31') #修改成单时间
  AND (note NOT LIKE '%zyb%')
  AND (name NOT LIKE '%测试%')
  AND (name NOT LIKE '%test%')
  and status ='SUCCESS'
  AND amount/100>100
  AND student_user_id NOT IN (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
                              141321906,
                              249450013,
                              250595219,
                              248444058,
                              248259226,
                              251804322,
                              251804626,
                              251804835,
                              251436121,
                              75462035,
                              88452392,
                              122839998,
                              247444506,247673969)
  order by from_unixtime(update_time) 

)



)
and from_unixtime(c.create_time)>='2017-04-01' # 修改线索创建时间
AND from_unixtime(c.create_time)<='2017-10-31'
GROUP BY c.telephone_number
having t>='2017-04-01'
      AND t<='2017-10-31'
 ) as z
on z.tel=s.telephone_num
and z.t<s.t
) as qx

WHERE qx.qxsource!='0'
                      

######
#union source=0 mintime<series_order.time

UNION


SELECT 
qx.pid,
qx.telephone_num,
qx.`成单日期`,
qxtimemin.mint,
qxtimemin.source,
qx.`name`,
qx.student_user_id,
qx.planner_name,
qx.lesson_num,
qx.samount,
qx.soriginalamount,
qx.`备注`


from 
(    ##明细数据 清洗 source=0

SELECT 	
	s.pid,
	s.telephone_num,
	s.t as '成单日期',
z.t as 'leads日期',
IfNULL(z.source,0) as qxsource ,
	s.`name`,
	s.student_user_id,
	s.planner_name,
	s.lesson_num,
	s.amount/100 as samount,
	s.original_amount/100 as soriginalamount,
	s.`备注`


from 
(
SELECT 

DISTINCT pid ,
i.telephone_num ,
from_unixtime(update_time) as t,


        
                name ,
                student_user_id ,
        # i.telephone_num as '学生手机号',
				#系统记录咨询师-实际咨询师
                planner_name ,
                lesson_num ,
                amount,
                original_amount,
                note as '备注'
FROM series_order

LEFT JOIN(
SELECT  
telephone_num, 
user_id

from user_online
WHERE user_id in(
SELECT 
        DISTINCT    student_user_id as '学生ID'
FROM series_order
WHERE update_time BETWEEN unix_timestamp('2017-04-01') AND unix_timestamp('2017-10-31')#修改成单时间
  AND (note NOT LIKE '%zyb%')
  AND (name NOT LIKE '%测试%')
  AND (name NOT LIKE '%test%')
  and status ='SUCCESS'
  AND amount/100>100
  AND student_user_id NOT IN (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
                              141321906,
                              249450013,
                              250595219,
                              248444058,
                              248259226,
                              251804322,
                              251804626,
                              251804835,
                              251436121,
                              75462035,
                              88452392,
                              122839998,
                              247444506,247673969)
  order by from_unixtime(update_time) 
)
) as i on  i.user_id=student_user_id



WHERE update_time BETWEEN unix_timestamp('2017-04-01') AND unix_timestamp('2017-10-31')#修改成单时间
  AND (note NOT LIKE '%zyb%')
  AND (name NOT LIKE '%测试%')
  AND (name NOT LIKE '%test%')
  and status ='SUCCESS'
  AND amount/100>100
  AND student_user_id NOT IN (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
                              141321906,
                              249450013,
                              250595219,
                              248444058,
                              248259226,
                              251804322,
                              251804626,
                              251804835,
                              251436121,
                              75462035,
                              88452392,
                              122839998,
                              247444506,247673969)
  #order by from_unixtime(update_time)
ORDER BY i.telephone_num,from_unixtime(update_time)
) as s


LEFT JOIN 
(SELECT 
c.telephone_number as tel ,
max(date_format(from_unixtime(c.create_time), '%Y-%m-%d')) as t ,
c.source
from crm_form_record c 
where 
c.telephone_number in 
(# 
#成单 tel
SELECT  
DISTINCT telephone_num
#user_id

from user_online
WHERE user_id in(
SELECT 
        DISTINCT    student_user_id as '学生ID'
FROM series_order
WHERE update_time BETWEEN unix_timestamp('2017-04-01') AND unix_timestamp('2017-10-31')#修改成单时间
  AND (note NOT LIKE '%zyb%')
  AND (name NOT LIKE '%测试%')
  AND (name NOT LIKE '%test%')
  and status ='SUCCESS'
  AND amount/100>100
  AND student_user_id NOT IN (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
                              141321906,
                              249450013,
                              250595219,
                              248444058,
                              248259226,
                              251804322,
                              251804626,
                              251804835,
                              251436121,
                              75462035,
                              88452392,
                              122839998,
                              247444506,247673969)
  order by from_unixtime(update_time) 

)



)
and from_unixtime(c.create_time)>='2017-04-01'
AND from_unixtime(c.create_time)<='2017-10-31'
GROUP BY c.telephone_number
having t>='2017-04-01'
      AND t<='2017-10-31'
 ) as z
on z.tel=s.telephone_num
and z.t<s.t
) as qx






LEFT JOIN 
(

#成单leads 明细min time
SELECT
DISTINCT record_id,  
telephone_number,

min(date_format(from_unixtime(create_time), '%Y-%m-%d')) as mint ,
source


#COUNT(telephone_number)
FROM crm_form_record

WHERE 
 telephone_number in
(
#成单 tel
SELECT  
DISTINCT telephone_num
#user_id

from user_online
WHERE user_id in(
SELECT 
        DISTINCT    student_user_id as '学生ID'
FROM series_order
WHERE update_time BETWEEN unix_timestamp('2017-04-01') AND unix_timestamp('2017-10-31')#修改成单时间
  AND (note NOT LIKE '%zyb%')
  AND (name NOT LIKE '%测试%')
  AND (name NOT LIKE '%test%')
  and status ='SUCCESS'
  AND amount/100>100
  AND student_user_id NOT IN (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
                              141321906,
                              249450013,
                              250595219,
                              248444058,
                              248259226,
                              251804322,
                              251804626,
                              251804835,
                              251436121,
                              75462035,
                              88452392,
                              122839998,
                              247444506,247673969)
  order by from_unixtime(update_time) 

)


)

and create_time BETWEEN unix_timestamp('2017-04-01') AND unix_timestamp('2017-10-31')#修改成单时间
# 成单tel
GROUP BY telephone_number
ORDER BY telephone_number








) as qxtimemin
on qxtimemin.telephone_number=qx.telephone_num
WHERE qx.qxsource='0'

and qx.`成单日期`>qxtimemin.mint


####union source=0 未关联出部分

UNION  
SELECT * from 
(    #source 未关联出部分

SELECT 	
	s.pid,
	s.telephone_num,
	s.t as '成单日期',
z.t as 'leads日期',
IfNULL(z.source,0) as qxsource ,
	s.`name`,
	s.student_user_id,
	s.planner_name,
	s.lesson_num,
	s.amount/100,
	s.original_amount/100,
	s.`备注`


from 
(
SELECT 

DISTINCT pid ,
i.telephone_num ,
from_unixtime(update_time) as t,


        
                name ,
                student_user_id ,
        # i.telephone_num as '学生手机号',
				#系统记录咨询师-实际咨询师
                planner_name ,
                lesson_num ,
                amount,
                original_amount,
                note as '备注'
FROM series_order

LEFT JOIN(
SELECT  
telephone_num, 
user_id

from user_online
WHERE user_id in(
SELECT 
        DISTINCT    student_user_id as '学生ID'
FROM series_order
WHERE update_time BETWEEN unix_timestamp('2017-04-01') AND unix_timestamp('2017-10-31')#修改成单时间
  AND (note NOT LIKE '%zyb%')
  AND (name NOT LIKE '%测试%')
  AND (name NOT LIKE '%test%')
  and status ='SUCCESS'
  AND amount/100>100
  AND student_user_id NOT IN (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
                              141321906,
                              249450013,
                              250595219,
                              248444058,
                              248259226,
                              251804322,
                              251804626,
                              251804835,
                              251436121,
                              75462035,
                              88452392,
                              122839998,
                              247444506,247673969)
  order by from_unixtime(update_time) 
)
) as i on  i.user_id=student_user_id



WHERE update_time BETWEEN unix_timestamp('2017-04-01') AND unix_timestamp('2017-10-31')#修改成单时间
  AND (note NOT LIKE '%zyb%')
  AND (name NOT LIKE '%测试%')
  AND (name NOT LIKE '%test%')
  and status ='SUCCESS'
  AND amount/100>100
  AND student_user_id NOT IN (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
                              141321906,
                              249450013,
                              250595219,
                              248444058,
                              248259226,
                              251804322,
                              251804626,
                              251804835,
                              251436121,
                              75462035,
                              88452392,
                              122839998,
                              247444506,247673969)
  #order by from_unixtime(update_time)
ORDER BY i.telephone_num,from_unixtime(update_time)
) as s


LEFT JOIN 
(SELECT 
c.telephone_number as tel ,
max(date_format(from_unixtime(c.create_time), '%Y-%m-%d')) as t ,
c.source
from crm_form_record c 
where 
c.telephone_number in 
(# 
#成单 tel
SELECT  
DISTINCT telephone_num
#user_id

from user_online
WHERE user_id in(
SELECT 
        DISTINCT    student_user_id as '学生ID'
FROM series_order
WHERE update_time BETWEEN unix_timestamp('2017-04-01') AND unix_timestamp('2017-10-31')#修改成单时间
  AND (note NOT LIKE '%zyb%')
  AND (name NOT LIKE '%测试%')
  AND (name NOT LIKE '%test%')
  and status ='SUCCESS'
  AND amount/100>100
  AND student_user_id NOT IN (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
                              141321906,
                              249450013,
                              250595219,
                              248444058,
                              248259226,
                              251804322,
                              251804626,
                              251804835,
                              251436121,
                              75462035,
                              88452392,
                              122839998,
                              247444506,247673969)
  order by from_unixtime(update_time) 

)



)
and from_unixtime(c.create_time)>='2017-04-01'
AND from_unixtime(c.create_time)<='2017-10-31'
GROUP BY c.telephone_number
having t>='2017-04-01'
      AND t<='2017-10-31'
 ) as z
on z.tel=s.telephone_num
and z.t<s.t
) as qx

WHERE qx.qxsource='0'

and qx.pid not in
(

SELECT 
qx.pid



from 
(    ##明细数据 清洗 source=0

SELECT 	
	s.pid,
	s.telephone_num,
	s.t as '成单日期',
z.t as 'leads日期',
IfNULL(z.source,0) as qxsource ,
	s.`name`,
	s.student_user_id,
	s.planner_name,
	s.lesson_num,
	s.amount/100 as samount,
	s.original_amount/100 as soriginalamount,
	s.`备注`


from 
(
SELECT 

DISTINCT pid ,
i.telephone_num ,
from_unixtime(update_time) as t,


        
                name ,
                student_user_id ,
        # i.telephone_num as '学生手机号',
				#系统记录咨询师-实际咨询师
                planner_name ,
                lesson_num ,
                amount,
                original_amount,
                note as '备注'
FROM series_order

LEFT JOIN(
SELECT  
telephone_num, 
user_id

from user_online
WHERE user_id in(
SELECT 
        DISTINCT    student_user_id as '学生ID'
FROM series_order
WHERE update_time BETWEEN unix_timestamp('2017-04-01') AND unix_timestamp('2017-10-31')#修改成单时间
  AND (note NOT LIKE '%zyb%')
  AND (name NOT LIKE '%测试%')
  AND (name NOT LIKE '%test%')
  and status ='SUCCESS'
  AND amount/100>100
  AND student_user_id NOT IN (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
                              141321906,
                              249450013,
                              250595219,
                              248444058,
                              248259226,
                              251804322,
                              251804626,
                              251804835,
                              251436121,
                              75462035,
                              88452392,
                              122839998,
                              247444506,247673969)
  order by from_unixtime(update_time) 
)
) as i on  i.user_id=student_user_id



WHERE update_time BETWEEN unix_timestamp('2017-04-01') AND unix_timestamp('2017-10-31')#修改成单时间
  AND (note NOT LIKE '%zyb%')
  AND (name NOT LIKE '%测试%')
  AND (name NOT LIKE '%test%')
  and status ='SUCCESS'
  AND amount/100>100
  AND student_user_id NOT IN (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
                              141321906,
                              249450013,
                              250595219,
                              248444058,
                              248259226,
                              251804322,
                              251804626,
                              251804835,
                              251436121,
                              75462035,
                              88452392,
                              122839998,
                              247444506,247673969)
  #order by from_unixtime(update_time)
ORDER BY i.telephone_num,from_unixtime(update_time)
) as s


LEFT JOIN 
(SELECT 
c.telephone_number as tel ,
max(date_format(from_unixtime(c.create_time), '%Y-%m-%d')) as t ,
c.source
from crm_form_record c 
where 
c.telephone_number in 
(# 
#成单 tel
SELECT  
DISTINCT telephone_num
#user_id

from user_online
WHERE user_id in(
SELECT 
        DISTINCT    student_user_id as '学生ID'
FROM series_order
WHERE update_time BETWEEN unix_timestamp('2017-04-01') AND unix_timestamp('2017-10-31')#修改成单时间
  AND (note NOT LIKE '%zyb%')
  AND (name NOT LIKE '%测试%')
  AND (name NOT LIKE '%test%')
  and status ='SUCCESS'
  AND amount/100>100
  AND student_user_id NOT IN (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
                              141321906,
                              249450013,
                              250595219,
                              248444058,
                              248259226,
                              251804322,
                              251804626,
                              251804835,
                              251436121,
                              75462035,
                              88452392,
                              122839998,
                              247444506,247673969)
  order by from_unixtime(update_time) 

)



)
and from_unixtime(c.create_time)>='2017-04-01'
AND from_unixtime(c.create_time)<='2017-10-31'
GROUP BY c.telephone_number
having t>='2017-04-01'
      AND t<='2017-10-31'
 ) as z
on z.tel=s.telephone_num
and z.t<s.t
) as qx






LEFT JOIN 
(

#成单leads 明细min time
SELECT
DISTINCT record_id,  
telephone_number,

min(date_format(from_unixtime(create_time), '%Y-%m-%d')) as mint ,
source


#COUNT(telephone_number)
FROM crm_form_record

WHERE 
 telephone_number in
(
#成单 tel
SELECT  
DISTINCT telephone_num
#user_id

from user_online
WHERE user_id in(
SELECT 
        DISTINCT    student_user_id as '学生ID'
FROM series_order
WHERE update_time BETWEEN unix_timestamp('2017-04-01') AND unix_timestamp('2017-10-31')#修改成单时间
  AND (note NOT LIKE '%zyb%')
  AND (name NOT LIKE '%测试%')
  AND (name NOT LIKE '%test%')
  and status ='SUCCESS'
  AND amount/100>100
  AND student_user_id NOT IN (148811250,
                              141321906,
                              141321906,
                              43744461,
                              250595181,
                              141321906,
                              249450013,
                              250595219,
                              248444058,
                              248259226,
                              251804322,
                              251804626,
                              251804835,
                              251436121,
                              75462035,
                              88452392,
                              122839998,
                              247444506,247673969)
  order by from_unixtime(update_time) 

)


)

and create_time BETWEEN unix_timestamp('2017-04-01') AND unix_timestamp('2017-10-31')#修改成单时间
# 成单tel
GROUP BY telephone_number
ORDER BY telephone_number


) as qxtimemin
on qxtimemin.telephone_number=qx.telephone_num
WHERE qx.qxsource='0'

and qx.`成单日期`>qxtimemin.mint



)