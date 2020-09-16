-- Step 4a (1)
select b.business_name as 'Hospital Name', a.license_beds as 'Total License Beds', a.bed_id
from bed_fact a left join business b on a.ims_org_id = b.ims_org_id
where bed_id = 4 or bed_id = 15
order by license_beds desc
limit 10;

-- Step 4a (2)
select b.business_name as 'Hospital Name', a.census_beds as 'Total Census Beds'
from bed_fact a left join business b on a.ims_org_id = b.ims_org_id
where bed_id = 4 or bed_id = 15
order by census_beds desc
limit 10;

-- Step 4a (3)
select b.business_name as 'Hospital Name', a.staffed_beds as 'Total Staffed Beds'
from bed_fact a left join business b on a.ims_org_id = b.ims_org_id
where bed_id = 4 or bed_id = 15
order by staffed_beds desc
limit 10;

-- Step 5a (1)
select subTable_4.business_name, (subTable_4.license_beds_4 + subTable_15.license_beds_15) as 'total_license_beds'
from 
	(select ims_org_id, business_name, bed_id as 'bed_id_4', license_beds as 'license_beds_4'
	from 
		(select bed_fact.ims_org_id, business.business_name, bed_fact.bed_id, bed_fact.license_beds
		from bed_fact left join business on bed_fact.ims_org_id = business.ims_org_id) bed_fact_with_name
	where 
		bed_id = 4) subTable_4
	left join
	(select ims_org_id, bed_id as 'bed_id_15', license_beds as 'license_beds_15'
	from 
		bed_fact
	where 
		bed_id = 15) subTable_15
on subTable_4.ims_org_id = subTable_15.ims_org_id
where bed_id_4 is not null and bed_id_15 is not null
order by total_license_beds desc
limit 10;

-- Step 5a (2)
select subTable_4.business_name, (subTable_4.census_beds_4 + subTable_15.census_beds_15) as 'total_census_beds'
from 
	(select ims_org_id, business_name, bed_id as 'bed_id_4', census_beds as 'census_beds_4'
	from 
		(select bed_fact.ims_org_id, business.business_name, bed_fact.bed_id, bed_fact.census_beds
		from bed_fact left join business on bed_fact.ims_org_id = business.ims_org_id) bed_fact_with_name
	where 
		bed_id = 4) subTable_4
	left join
	(select ims_org_id, bed_id as 'bed_id_15', census_beds as 'census_beds_15'
	from 
		bed_fact
	where 
		bed_id = 15) subTable_15
on subTable_4.ims_org_id = subTable_15.ims_org_id
where bed_id_4 is not null and bed_id_15 is not null
order by total_census_beds desc
limit 10;

-- Step 5a (3)
select subTable_4.business_name, (subTable_4.staffed_beds_4 + subTable_15.staffed_beds_15) as 'total_staffed_beds'
from 
	(select ims_org_id, business_name, bed_id as 'bed_id_4', staffed_beds as 'staffed_beds_4'
	from 
		(select bed_fact.ims_org_id, business.business_name, bed_fact.bed_id, bed_fact.staffed_beds
		from bed_fact left join business on bed_fact.ims_org_id = business.ims_org_id) bed_fact_with_name
	where 
		bed_id = 4) subTable_4
	left join
	(select ims_org_id, bed_id as 'bed_id_15', staffed_beds as 'staffed_beds_15'
	from 
		bed_fact
	where 
		bed_id = 15) subTable_15
on subTable_4.ims_org_id = subTable_15.ims_org_id
where bed_id_4 is not null and bed_id_15 is not null
order by total_staffed_beds desc
limit 10;





