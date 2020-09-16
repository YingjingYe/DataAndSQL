select a.drug_name, count(*)
from dim_drug_info a
right join fact_id_info b on a.drug_ndc = b.drug_ndc
group by drug_name;


drop table if exists t1;
create table t1 as
select p.member_id, (coalesce(copay1,0) + coalesce(copay2, 0) + coalesce(copay3, 0)) as 'total_copay',
(coalesce(insurancepaid1, 0) + coalesce(insurancepaid2, 0) + coalesce(insurancepaid3, 0)) as 'total_insurance_paid',
member_age, 
CASE 
	WHEN member_age >= 65 then 'age 65+'
    WHEN member_age < 65 then 'age <65'
end as age_group
from dim_patient_info p
right join dim_copay c on p.member_id = c.member_id
right join dim_insurance_paid i on c.patient_med_record = i.patient_med_record; 
select member_id, sum(total_copay) as totalcopay, sum(total_insurance_paid) as totalinsurancepaid, 
member_age, age_group, count(member_id) as num_prescriptions
from t1
group by member_id;


drop table if exists t2;
create table t2 as
select p.member_id, member_first_name, member_last_name, drug_name, 
f.fill_date1 as mr_fill_date, insurancepaid1 as mr_insurance_paid, 
row_number() over (partition by member_id order by f.fill_date1 desc) as flag 
from dim_patient_info p
left join  dim_fill_date f on p.member_id = f.member_id
left join dim_insurance_paid i on f.patient_med_record = i.patient_med_record
left join fact_id_info d on i.patient_med_record = d.patient_med_record
left join dim_drug_info r on d.drug_ndc = r.drug_ndc;
select *
from t2 
where flag = 1