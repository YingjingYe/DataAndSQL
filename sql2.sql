drop table if exists t1;
create table t1 as
select INSPECTION_ID, PUBLIC_HOUSING_AGENCY_NAME as 'PHA_NAME', COST_OF_INSPECTION_IN_DOLLARS as 'SECOND_MR_INSPECTION_COST', INSPECTION_DATE as 'SECOND_MR_INSPECTION_DATE',
lag(COST_OF_INSPECTION_IN_DOLLARS) over (partition by PUBLIC_HOUSING_AGENCY_NAME order by INSPECTION_DATE desc) as 'MR_COST_OF_INSPECTION_IN_DOLLARS', 
lag(INSPECTION_DATE) over (partition by PUBLIC_HOUSING_AGENCY_NAME order by INSPECTION_DATE desc) as 'MR_INSPECTION_DATE',
COST_OF_INSPECTION_IN_DOLLARS - (lag(COST_OF_INSPECTION_IN_DOLLARS) over (partition by PUBLIC_HOUSING_AGENCY_NAME order by INSPECTION_DATE desc)) as 'CHANGE_IN_COST', 
((COST_OF_INSPECTION_IN_DOLLARS - (lag(COST_OF_INSPECTION_IN_DOLLARS) over (partition by PUBLIC_HOUSING_AGENCY_NAME order by INSPECTION_DATE desc))) / 
(lag(COST_OF_INSPECTION_IN_DOLLARS) over (partition by PUBLIC_HOUSING_AGENCY_NAME order by INSPECTION_DATE desc))) * 100 as 'PERCENT_CHANGE_IN_COST'
from public_housing_inspections;

select PHA_NAME, MR_INSPECTION_DATE, MR_COST_OF_INSPECTION_IN_DOLLARS, SECOND_MR_INSPECTION_DATE, SECOND_MR_INSPECTION_COST, CHANGE_IN_COST, PERCENT_CHANGE_IN_COST
from
(select PHA_NAME, MR_INSPECTION_DATE, MR_COST_OF_INSPECTION_IN_DOLLARS, SECOND_MR_INSPECTION_DATE, SECOND_MR_INSPECTION_COST, CHANGE_IN_COST, PERCENT_CHANGE_IN_COST,
row_number() over (partition by PHA_NAME order by SECOND_MR_INSPECTION_DATE desc) as flag
from t1) as t2
where flag = 2 and CHANGE_IN_COST > 0;
