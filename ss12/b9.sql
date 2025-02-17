use ss12;
create table patients (
    patient_id int auto_increment primary key,
    name varchar(100) not null,
    dob date not null,
    gender enum('male', 'female') not null,
    phone varchar(15) not null unique
);

create table doctors (
    doctor_id int auto_increment primary key,
    name varchar(100) not null,
    specialization varchar(100) not null,
    phone varchar(15) not null unique,
    salary decimal(10,2) not null
);

create table appointments (
    appointment_id int auto_increment primary key,
    patient_id int,
    doctor_id int,
    appointment_date datetime not null,
    status enum('scheduled', 'completed', 'cancelled') not null,
    foreign key (patient_id) references patients(patient_id),
    foreign key (doctor_id) references doctors(doctor_id)
);

create table prescriptions (
    prescription_id int auto_increment primary key,
    appointment_id int,
    medicine_name varchar(100) not null,
    dosage varchar(50) not null,
    duration varchar(50) not null,
    notes varchar(255),
    foreign key (appointment_id) references appointments(appointment_id)
);

create table patient_error_log (
    log_id int auto_increment primary key,
    patient_name varchar(100),
    phone_number varchar(15),
    error_message varchar(255),
    created_at timestamp default current_timestamp
);

delimiter &&
create trigger before_insert_patient
before insert on patients
for each row
begin
    if exists (
        select 1 from patients where name = new.name and dob = new.dob
    ) then
        insert into patient_error_log (patient_name, phone_number, error_message)
        values (new.name, new.phone, 'bệnh nhân đã tồn tại');
        signal sqlstate '45000' set message_text = 'bệnh nhân đã tồn tại';
    end if;
end &&
delimiter ;

delimiter &&
create trigger check_phone_number_format
before insert on patients
for each row
begin
    if new.phone not regexp '^[0-9]{10}$' then
        insert into patient_error_log (patient_name, phone_number, error_message)
        values (new.name, new.phone, 'số điện thoại không hợp lệ!');
        signal sqlstate '45000' set message_text = 'số điện thoại không hợp lệ!';
    end if;
end &&
delimiter ;

insert into patients (name, dob, gender, phone) values
('alice smith', '1985-06-15', 'female', '1234567895'),
('bob johnson', '1990-02-25', 'male', '2345678901'),
('carol williams', '1975-03-10', 'female', '3456789012');

-- invalid phone numbers (should trigger error)
insert into patients (name, dob, gender, phone) values
('dave brown', '1992-09-05', 'male', '4567890abc'),
('eve davis', '1980-12-30', 'female', '56789xyz'),
('eve', '1980-12-13', 'female', '56789');

select * from patient_error_log;

delimiter &&
create procedure update_appointment_status(in appointment_id int, in new_status varchar(20))
begin
    update appointments set status = new_status where appointment_id = appointment_id;
end &&
delimiter ;

delimiter &&
create trigger update_status_after_prescription_insert
after insert on prescriptions
for each row
begin
    call update_appointment_status(new.appointment_id, 'completed');
end &&
delimiter ;

insert into doctors (name, specialization, phone, salary) values
('dr. john smith', 'cardiology', '1234567890', 5000.00),
('dr. alice brown', 'neurology', '0987654321', 6000.00);

insert into appointments (patient_id, doctor_id, appointment_date, status) values
(1, 1, '2025-02-15 09:00:00', 'scheduled'),
(2, 2, '2025-02-16 10:00:00', 'scheduled'),
(3, 1, '2025-02-17 14:00:00', 'scheduled');

select * from appointments;

insert into prescriptions (appointment_id, medicine_name, dosage, duration, notes) 
values (1, 'paracetamol', '500mg', '5 days', 'take one tablet every 6 hours');

select * from appointments;
