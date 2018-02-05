
with city_level as (select o.id,
	case when (o.base_info->>'city')::varchar like ('%北京%' , '%上海%' , ' %广州%' , '%深圳%' , '%杭州%' )then '一线'
	when (o.base_info->>'city')::varchar in ('成都','杭州','武汉',
'重庆','南京','天津','苏州','西安','长沙','沈阳','青岛','郑州','大连','东莞','宁波') then '新一线'
when (o.base_info->>'city')::varchar in ('石家庄','哈尔滨','福州','济南','昆明','兰州','台北',
'南宁','银川','太原','长春','合肥','南昌','海口','贵阳','西宁','呼和浩特','拉萨','乌鲁木齐') then '二线'
else '其他' end as 城市
from ocean o )

select extract(year from c.created_time),extract(month from c.created_time),l.城市,
count(distinct c.student_id)
from comm_records c 
left join city_level l 
on c.student_id = l.id 
group by extract(year from c.created_time),extract(month from c.created_time),l.城市



一线+二线+新一线

select
case when (u.city like '%北京%' 
or u.city like '%上海%' or u.city like  '%广州%' or u.city like  '%深圳%' ) then '一线'
	 when (u.city like '%杭州%'or u.city like 
'%成都%'or u.city like 
'%武汉%'or u.city like 
'%重庆%'or u.city like 
'%南京%'or u.city like 
'%天津%'or u.city like 
'%苏州%'or u.city like 
'%西安%'or u.city like 
'%长沙%'or u.city like 
'%沈阳%'or u.city like 
'%青岛%'or u.city like 
'%郑州%'or u.city like 
'%大连%'or u.city like 
'%东莞%'or u.city like 
'%宁波%'
) then '二线'
	 when(u.city like '%厦门%'or
	 	u.city like '%福州%'or
	 	u.city like '%无锡%'or
	 	u.city like '%合肥%'or
	 	u.city like '%昆明%'or
	 	u.city like '%哈尔滨%'or
	 	u.city like '%济南%'or
	 	u.city like '%佛山%'or
	 	u.city like '%长春%'or
	 	u.city like '%温州%'or
	 	u.city like '%石家庄%'or
	 	u.city like '%南宁%'or
	 	u.city like '%常州%'or
	 	u.city like '%泉州%'or
	 	u.city like '%南昌%'or
	 	u.city like '%贵阳%'or
	 	u.city like '%太原%'or
	 	u.city like '%烟台%'or
	 	u.city like '%嘉兴%'or
	 	u.city like '%南通%'or
	 	u.city like '%金华%'or
	 	u.city like '%珠海%'or
	 	u.city like '%惠州%'or
	 	u.city like '%徐州%'or
	 	u.city like '%海口%'or
	 	u.city like '%乌鲁木齐%'or
	 	u.city like '%绍兴%'or
	 	u.city like '%中山%'or
	 	u.city like '%台州%'or
	 	u.city like '%兰州%') then '新一线'
	 else '其他' end as city_level , 
	 year(date(from_unixtime(c.start_time))) as time_call, month(date(from_unixtime(c.start_time))),count(distinct c.customer_number)
from crm_call_outcome_record c join user_online u on u.telephone_num = c.customer_number
where date(from_unixtime(c.start_time)) >= '2017-10-01'
group by year(date(from_unixtime(c.start_time))), month(date(from_unixtime(c.start_time))),city_level






一线二线其他
with city_level as (select o.id,
	case when ((o.base_info->>'city')::varchar like '%北京%' or (o.base_info->>'city')::varchar like '%上海%' 
		or (o.base_info->>'city')::varchar like '%广州%' or (o.base_info->>'city')::varchar like '%深圳%' 
		or (o.base_info->>'city')::varchar like '%杭州%' )then '一线'
	
when ((o.base_info->>'city')::varchar like '%杭州%'
or (o.base_info->>'city')::varchar like '%南京%'or (o.base_info->>'city')::varchar like
'%济南%'or (o.base_info->>'city')::varchar like
'%重庆%'or (o.base_info->>'city')::varchar like
'%青岛%'or (o.base_info->>'city')::varchar like
'%大连%'or (o.base_info->>'city')::varchar like
'%宁波%'or (o.base_info->>'city')::varchar like
'%厦门%'or (o.base_info->>'city')::varchar like
'%成都%'or (o.base_info->>'city')::varchar like
'%武汉%'or (o.base_info->>'city')::varchar like
'%哈尔滨%'or (o.base_info->>'city')::varchar like
'%沈阳%'or (o.base_info->>'city')::varchar like
'%西安%'or (o.base_info->>'city')::varchar like
'%长春%'or (o.base_info->>'city')::varchar like
'%长沙%'or (o.base_info->>'city')::varchar like
'%福州%'or (o.base_info->>'city')::varchar like
'%郑州%'or (o.base_info->>'city')::varchar like
'%石家庄%'or (o.base_info->>'city')::varchar like
'%苏州%'or (o.base_info->>'city')::varchar like
'%佛山%'or (o.base_info->>'city')::varchar like
'%东莞%'or (o.base_info->>'city')::varchar like
'%无锡%'or (o.base_info->>'city')::varchar like
'%烟台%'or (o.base_info->>'city')::varchar like
'%太原%')then '二线'
else '其他' end as 城市
from ocean o )


