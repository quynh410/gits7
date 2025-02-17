use ss12;
delimiter &&
create procedure get_doctor_details(in input_doctor_id int)
begin
    select 
        d.name as doctor_name,
        d.specialization,
        count(distinct a.patient_id) as total_patients,
        sum(if(a.status = 'completed', 100, 0)) as total_revenue,
        count(p.prescription_id) as total_medicines_prescribed
    from doctors d
    left join appointments a on d.doctor_id = a.doctor_id
    left join prescriptions p on a.appointment_id = p.appointment_id
    where d.doctor_id = input_doctor_id
    group by d.doctor_id;
end &&
delimiter ;

create table cancellation_logs (
    log_id int auto_increment primary key,
    appointment_id int,
    log_message varchar(255),
    log_time timestamp default current_timestamp
);

create table appointment_logs (
    log_id int auto_increment primary key,
    appointment_id int,
    log_message varchar(255),
    log_time timestamp default current_timestamp
);

delimiter &&
create trigger after_appointment_delete
after delete on appointments
for each row
begin
    delete from prescriptions where appointment_id = old.appointment_id;
    
    if old.status = 'cancelled' then
        insert into cancellation_logs (appointment_id, log_message) 
        values (old.appointment_id, 'cancelled appointment was deleted');
    end if;
    
    if old.status = 'completed' then
        insert into appointment_logs (appointment_id, log_message) 
        values (old.appointment_id, 'completed appointment was deleted');
    end if;
end &&
delimiter ;

create view full_revenue_report as
select 
    d.doctor_id,
    d.name as doctor_name,
    d.specialization,
    count(distinct a.patient_id) as total_patients,
    sum(if(a.status = 'completed', 100, 0)) as total_revenue,
    count(p.prescription_id) as total_medicines_prescribed
from doctors d
left join appointments a on d.doctor_id = a.doctor_id
left join prescriptions p on a.appointment_id = p.appointment_id
group by d.doctor_id;

call get_doctor_details(1);

delete from appointments where appointment_id = 3;
delete from appointments where appointment_id = 2;

select * from full_revenue_report;
