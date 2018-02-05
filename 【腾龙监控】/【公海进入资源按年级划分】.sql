--公海进入资源按年级划分



select  date(o.created_time), 
sum(case when (o.base_info->>'grade')::varchar = '0' 
	or (o.base_info->>'grade')::varchar = ' ' then 1 else 0 end) as 其他,
sum(case when (o.base_info->>'grade')::varchar = '1' 
	or (o.base_info->>'grade')::varchar = '101' then 1 else 0 end) as 一年级,
sum(case when (o.base_info->>'grade')::varchar = '2' 
	or (o.base_info->>'grade')::varchar = '102' then 1 else 0 end) as 二年级,
sum(case when (o.base_info->>'grade')::varchar = '3' 
	or (o.base_info->>'grade')::varchar = '103' then 1 else 0 end) as 三年级,
sum(case when (o.base_info->>'grade')::varchar = '4' 
	or (o.base_info->>'grade')::varchar = '104' then 1 else 0 end) as 四年级,
sum(case when (o.base_info->>'grade')::varchar = '5' 
	or (o.base_info->>'grade')::varchar = '105' then 1 else 0 end) as 五年级,
sum(case when (o.base_info->>'grade')::varchar = '6' 
	or (o.base_info->>'grade')::varchar = '106' then 1 else 0 end) as 六年级,
sum(case when (o.base_info->>'grade')::varchar = '10' then 1 else 0 end) as 小学,
sum(case when (o.base_info->>'grade')::varchar = '7' then 1 else 0 end) as 初一,
sum(case when (o.base_info->>'grade')::varchar = '8' then 1 else 0 end) as 初二,
sum(case when (o.base_info->>'grade')::varchar = '9' then 1 else 0 end) as 初三,
sum(case when (o.base_info->>'grade')::varchar = '11' then 1 else 0 end) as 高一,
sum(case when (o.base_info->>'grade')::varchar = '12' then 1 else 0 end) as 高二,
sum(case when (o.base_info->>'grade')::varchar = '13' then 1 else 0 end) as 高三
from ocean o 
where date(o.created_time) >='2017-12-01'
group by date(o.created_time)


--