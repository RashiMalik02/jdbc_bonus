CREATE DATABASE IF NOT EXISTS schemaDb;

USE schemaDb;

create table user(
   user_id int primary key,
   name varchar(100) not null,
   email varchar(255) unique not null,
   gender enum("MALE", "FEMALE", "OTHERS"),
   phoneNo varchar(50),
   dateOfBirth date,
   password varchar(255) not null
);

create table candidate_info(
   candidate_id int primary key,
   encrypted_info text not null
);

create table company(
   company_id int primary key,
   name varchar(255) not null,
   email varchar(255),
   phoneNo varchar(255),
   address varchar(255)
);

create table department(
  dept_id int primary key,
  name varchar(50) not null unique
);

create table company_department(
   company_dept_id int primary key,
   dept_id int not null,
   company_id int not null,
   description text,
   total_offers int,
   total_accepted_offers int,
   foreign key (dept_id) references department(dept_id),
   foreign key (company_id) references company(company_id)
);

create table candidate(
   user_id int primary key,
   candidate_id int unique not null,
   resume_link_path varchar(255),
   experience int default 0,
   education text,
   skill text,
   foreign key (user_id) references user(user_id),
   foreign key (candidate_id) references candidate_info(candidate_id)
);

create table interviewer(
   user_id int primary key,
   interviewer_id int unique not null,
   company_dept_id int not null,
   foreign key (user_id) references user(user_id),
   foreign key (company_dept_id) references company_department(company_dept_id)
);

create table recruitor(
   user_id int primary key,
   recruitor_id int unique not null,
   company_id int not null,
   foreign key (user_id) references user(user_id),
   foreign key (company_id) references company(company_id)
);


create table application_stage(
   stage_id int primary key, 
   title varchar(100) not null
   -- 1=applied, 2=screened, 3=interview, 4=offer , -1=rejected
);

create table job(
   job_id int primary key,
   title varchar(255) not null,
   company_dept_id int not null,
   description text,
   total_applications int,
   posted_by int not null,
   status enum('open', 'closed', 'on_hold') default 'open',
   foreign key (company_dept_id) references company_department(company_dept_id),
   foreign key (posted_by) references recruitor(recruitor_id),
   index total_application_index(total_applications)
);

create table applications(
   application_id int primary key,
   candidate_id int not null,
   job_id int not null,
   applied_at datetime(2) default current_timestamp(2), 
   current_stage_id int,
   foreign key (candidate_id) references candidate(candidate_id),
   foreign key (job_id) references job(job_id),
   foreign key (current_stage_id) references application_stage(stage_id),
   index idx_applications_job_stage(job_id, current_stage_id),
   index idx_applications_candidate_time(candidate_id , applied_at desc)
);

create table application_stage_history(
  id int primary key,
  application_id int not null,
  stage_id int not null,
  changed_by int not null,
  changed_at datetime(2) default current_timestamp(2), 
  notes text,
  foreign key (application_id) references applications(application_id),
  foreign key (stage_id) references application_stage(stage_id),
  foreign key (changed_by) references recruitor(recruitor_id)
);

create table interviews(
   id int primary key,
   application_id int not null,
   interviewer_id int not null,
   scheduled_at datetime not null,
   feedback text,
   status enum('scheduled', 'cancelled', 'completed') default 'scheduled',
   result enum('pass', 'fail', 'pending') default 'pending',
   foreign key (application_id) references applications(application_id),
   foreign key (interviewer_id) references interviewer(interviewer_id),
   index idx_interviews_interviewer_status (interviewer_id, status)
);

create table offers(
   offer_id int primary key,
   application_id int not null unique, 
   salary decimal(12,2) not null,
   issued_at datetime(2) default current_timestamp(2),
   updated_at datetime(2) default current_timestamp(2) on update current_timestamp(2),
   valid_till datetime(2) not null,
   status enum('pending', 'accepted', 'declined') default 'pending',
   description text,
   foreign key (application_id) references applications(application_id)
);

create table recruitor_activities(
   activity_id int primary key,
   recruitor_id int not null,
   application_id int,
   activity_date datetime(2) default current_timestamp(2),
   activity_type enum('interview_conducted', 'application_reviewed', 'offer_created', 'stage_changed') not null,
   foreign key (recruitor_id) references recruitor(recruitor_id),
   foreign key (application_id) references applications(application_id)
);

create table audit(
   id int primary key,
   changed_by int not null,
   action_type enum('access', 'update', 'delete', 'create') not null,
   table_name varchar(100) not null,
   row_id int not null,
   old_value text,
   new_value text,
   changed_at datetime(2) default current_timestamp(2),
   foreign key (changed_by) references user(user_id)
);


-- Insert application stages
INSERT INTO application_stage (stage_id, title) VALUES
(1, 'Applied'),
(2, 'Screened'),
(3, 'Interview'),
(4, 'Offer'),
(-1, 'Rejected');

-- Insert departments
INSERT INTO department (dept_id, name) VALUES
(1, 'Software Engineering'),
(2, 'Data Science'),
(3, 'Product Management'),
(4, 'Design'),
(5, 'Marketing');

-- Insert companies
INSERT INTO company (company_id, name, email, phoneNo, address) VALUES
(1, 'TechCorp Solutions', 'hr@techcorp.com', '+1-555-0101', '123 Tech Street, Silicon Valley'),
(2, 'DataFlow Inc', 'careers@dataflow.com', '+1-555-0102', '456 Data Avenue, San Francisco'),
(3, 'InnovateLabs', 'jobs@innovatelabs.com', '+1-555-0103', '789 Innovation Blvd, Austin'),
(4, 'CloudTech Systems', 'hiring@cloudtech.com', '+1-555-0104', '321 Cloud Lane, Seattle'),
(5, 'StartupXYZ', 'team@startupxyz.com', '+1-555-0105', '654 Startup Road, Boston');

-- Insert company departments
INSERT INTO company_department (company_dept_id, dept_id, company_id, description, total_offers, total_accepted_offers) VALUES
(1, 1, 1, 'Backend and Frontend Development', 15, 12),
(2, 2, 1, 'Machine Learning and Analytics', 8, 6),
(3, 3, 1, 'Product Strategy and Management', 5, 4),
(4, 1, 2, 'Full Stack Development', 20, 16),
(5, 2, 2, 'Data Engineering and Science', 12, 10),
(6, 4, 2, 'UX/UI Design', 6, 5),
(7, 1, 3, 'Mobile and Web Development', 18, 14),
(8, 5, 3, 'Digital Marketing', 10, 8),
(9, 1, 4, 'Cloud Infrastructure Development', 25, 20),
(10, 2, 4, 'AI/ML Engineering', 15, 12);

-- Insert users (candidates, interviewers, recruiters)
INSERT INTO user (user_id, name, email, gender, phoneNo, dateOfBirth, password) VALUES
-- Candidates (1-30)
-- (1, 'Alice Johnson', 'alice.johnson@email.com', 'FEMALE', '+1-555-1001', '1995-03-15', 'hashed_password_1'),
(2, 'Bob Smith', 'bob.smith@email.com', 'MALE', '+1-555-1002', '1993-07-22', 'hashed_password_2'),
(3, 'Carol Davis', 'carol.davis@email.com', 'FEMALE', '+1-555-1003', '1996-11-08', 'hashed_password_3'),
(4, 'David Wilson', 'david.wilson@email.com', 'MALE', '+1-555-1004', '1994-01-30', 'hashed_password_4'),
(5, 'Emma Brown', 'emma.brown@email.com', 'FEMALE', '+1-555-1005', '1997-05-12', 'hashed_password_5'),
(6, 'Frank Miller', 'frank.miller@email.com', 'MALE', '+1-555-1006', '1992-09-18', 'hashed_password_6'),
(7, 'Grace Lee', 'grace.lee@email.com', 'FEMALE', '+1-555-1007', '1995-12-03', 'hashed_password_7'),
(8, 'Henry Taylor', 'henry.taylor@email.com', 'MALE', '+1-555-1008', '1994-04-25', 'hashed_password_8'),
(9, 'Ivy Chen', 'ivy.chen@email.com', 'FEMALE', '+1-555-1009', '1996-08-14', 'hashed_password_9'),
(10, 'Jack Rodriguez', 'jack.rodriguez@email.com', 'MALE', '+1-555-1010', '1993-02-07', 'hashed_password_10'),
(11, 'Kate Anderson', 'kate.anderson@email.com', 'FEMALE', '+1-555-1011', '1995-06-20', 'hashed_password_11'),
(12, 'Liam Thompson', 'liam.thompson@email.com', 'MALE', '+1-555-1012', '1994-10-15', 'hashed_password_12'),
(13, 'Maya Patel', 'maya.patel@email.com', 'FEMALE', '+1-555-1013', '1997-01-28', 'hashed_password_13'),
(14, 'Noah Garcia', 'noah.garcia@email.com', 'MALE', '+1-555-1014', '1992-11-11', 'hashed_password_14'),
(15, 'Olivia Martinez', 'olivia.martinez@email.com', 'FEMALE', '+1-555-1015', '1996-03-09', 'hashed_password_15'),
(16, 'Paul Clark', 'paul.clark@email.com', 'MALE', '+1-555-1016', '1995-07-16', 'hashed_password_16'),
(17, 'Quinn Lewis', 'quinn.lewis@email.com', 'OTHERS', '+1-555-1017', '1994-12-22', 'hashed_password_17'),
(18, 'Rachel Walker', 'rachel.walker@email.com', 'FEMALE', '+1-555-1018', '1993-05-04', 'hashed_password_18'),
(19, 'Sam Young', 'sam.young@email.com', 'MALE', '+1-555-1019', '1997-09-13', 'hashed_password_19'),
(20, 'Tina Hall', 'tina.hall@email.com', 'FEMALE', '+1-555-1020', '1994-08-27', 'hashed_password_20'),
-- Additional candidates for more applications
(21, 'Uma Sharma', 'uma.sharma@email.com', 'FEMALE', '+1-555-1021', '1995-04-18', 'hashed_password_21'),
(22, 'Victor Kim', 'victor.kim@email.com', 'MALE', '+1-555-1022', '1993-10-05', 'hashed_password_22'),
(23, 'Wendy Liu', 'wendy.liu@email.com', 'FEMALE', '+1-555-1023', '1996-02-14', 'hashed_password_23'),
(24, 'Xavier Wong', 'xavier.wong@email.com', 'MALE', '+1-555-1024', '1994-06-30', 'hashed_password_24'),
(25, 'Yara Ahmed', 'yara.ahmed@email.com', 'FEMALE', '+1-555-1025', '1997-11-07', 'hashed_password_25'),
(26, 'Zoe Baker', 'zoe.baker@email.com', 'FEMALE', '+1-555-1026', '1995-01-23', 'hashed_password_26'),
(27, 'Alex Cooper', 'alex.cooper@email.com', 'MALE', '+1-555-1027', '1992-07-19', 'hashed_password_27'),
(28, 'Blake Evans', 'blake.evans@email.com', 'OTHERS', '+1-555-1028', '1996-12-08', 'hashed_password_28'),
(29, 'Chloe Foster', 'chloe.foster@email.com', 'FEMALE', '+1-555-1029', '1994-03-26', 'hashed_password_29'),
(30, 'Drew Hughes', 'drew.hughes@email.com', 'MALE', '+1-555-1030', '1993-08-12', 'hashed_password_30'),

-- Interviewers (51-65)
(51, 'Senior Eng John Doe', 'john.doe@techcorp.com', 'MALE', '+1-555-2001', '1985-03-15', 'hashed_password_51'),
(52, 'Lead Dev Jane Smith', 'jane.smith@dataflow.com', 'FEMALE', '+1-555-2002', '1987-07-22', 'hashed_password_52'),
(53, 'Architect Mike Johnson', 'mike.johnson@innovatelabs.com', 'MALE', '+1-555-2003', '1983-11-08', 'hashed_password_53'),
(54, 'Principal Eng Sarah Wilson', 'sarah.wilson@cloudtech.com', 'FEMALE', '+1-555-2004', '1986-01-30', 'hashed_password_54'),
(55, 'Tech Lead Tom Brown', 'tom.brown@techcorp.com', 'MALE', '+1-555-2005', '1984-05-12', 'hashed_password_55'),
(56, 'Data Scientist Lisa Chen', 'lisa.chen@dataflow.com', 'FEMALE', '+1-555-2006', '1988-09-18', 'hashed_password_56'),
(57, 'ML Eng Robert Taylor', 'robert.taylor@cloudtech.com', 'MALE', '+1-555-2007', '1985-12-03', 'hashed_password_57'),
(58, 'Frontend Lead Emma Davis', 'emma.davis@innovatelabs.com', 'FEMALE', '+1-555-2008', '1987-04-25', 'hashed_password_58'),
(59, 'Backend Lead Chris Lee', 'chris.lee@techcorp.com', 'MALE', '+1-555-2009', '1986-08-14', 'hashed_password_59'),
(60, 'Design Lead Amy Rodriguez', 'amy.rodriguez@dataflow.com', 'FEMALE', '+1-555-2010', '1984-02-07', 'hashed_password_60'),

-- Recruiters (71-80)
(71, 'HR Manager Susan Green', 'susan.green@techcorp.com', 'FEMALE', '+1-555-3001', '1982-03-15', 'hashed_password_71'),
(72, 'Talent Acq Mark White', 'mark.white@dataflow.com', 'MALE', '+1-555-3002', '1980-07-22', 'hashed_password_72'),
(73, 'Recruiter Lisa Black', 'lisa.black@innovatelabs.com', 'FEMALE', '+1-555-3003', '1983-11-08', 'hashed_password_73'),
(74, 'Sr Recruiter Dave Gray', 'dave.gray@cloudtech.com', 'MALE', '+1-555-3004', '1981-01-30', 'hashed_password_74'),
(75, 'HR Specialist Anna Blue', 'anna.blue@startupxyz.com', 'FEMALE', '+1-555-3005', '1984-05-12', 'hashed_password_75');

-- Insert candidate_info (encrypted data)
INSERT INTO candidate_info (candidate_id, encrypted_info) VALUES
(1001, 'encrypted_personal_data_1001'),
(1002, 'encrypted_personal_data_1002'),
(1003, 'encrypted_personal_data_1003'),
(1004, 'encrypted_personal_data_1004'),
(1005, 'encrypted_personal_data_1005'),
(1006, 'encrypted_personal_data_1006'),
(1007, 'encrypted_personal_data_1007'),
(1008, 'encrypted_personal_data_1008'),
(1009, 'encrypted_personal_data_1009'),
(1010, 'encrypted_personal_data_1010'),
(1011, 'encrypted_personal_data_1011'),
(1012, 'encrypted_personal_data_1012'),
(1013, 'encrypted_personal_data_1013'),
(1014, 'encrypted_personal_data_1014'),
(1015, 'encrypted_personal_data_1015'),
(1016, 'encrypted_personal_data_1016'),
(1017, 'encrypted_personal_data_1017'),
(1018, 'encrypted_personal_data_1018'),
(1019, 'encrypted_personal_data_1019'),
(1020, 'encrypted_personal_data_1020'),
(1021, 'encrypted_personal_data_1021'),
(1022, 'encrypted_personal_data_1022'),
(1023, 'encrypted_personal_data_1023'),
(1024, 'encrypted_personal_data_1024'),
(1025, 'encrypted_personal_data_1025'),
(1026, 'encrypted_personal_data_1026'),
(1027, 'encrypted_personal_data_1027'),
(1028, 'encrypted_personal_data_1028'),
(1029, 'encrypted_personal_data_1029'),
(1030, 'encrypted_personal_data_1030');

-- Insert candidates
INSERT INTO candidate (user_id, candidate_id, resume_link_path, experience, education, skill) VALUES
(1, 1001, '/resumes/alice_johnson.pdf', 3, 'MS Computer Science', 'Java, Python, React, Node.js'),
(2, 1002, '/resumes/bob_smith.pdf', 5, 'BS Software Engineering', 'C++, Java, Spring Boot, MySQL'),
(3, 1003, '/resumes/carol_davis.pdf', 2, 'MS Data Science', 'Python, R, TensorFlow, SQL'),
(4, 1004, '/resumes/david_wilson.pdf', 4, 'BS Computer Science', 'JavaScript, Angular, MongoDB, Express'),
(5, 1005, '/resumes/emma_brown.pdf', 1, 'MS Information Systems', 'Python, Django, PostgreSQL, AWS'),
(6, 1006, '/resumes/frank_miller.pdf', 6, 'BS Computer Engineering', 'C#, .NET, Azure, SQL Server'),
(7, 1007, '/resumes/grace_lee.pdf', 3, 'MS Machine Learning', 'Python, Keras, Pandas, Spark'),
(8, 1008, '/resumes/henry_taylor.pdf', 4, 'BS Information Technology', 'PHP, Laravel, Vue.js, Redis'),
(9, 1009, '/resumes/ivy_chen.pdf', 2, 'MS Computer Science', 'Go, Docker, Kubernetes, Jenkins'),
(10, 1010, '/resumes/jack_rodriguez.pdf', 7, 'BS Software Development', 'Rust, WebAssembly, GraphQL, Neo4j'),
(11, 1011, '/resumes/kate_anderson.pdf', 3, 'MS Data Analytics', 'Python, Tableau, Power BI, Snowflake'),
(12, 1012, '/resumes/liam_thompson.pdf', 5, 'BS Computer Science', 'Swift, iOS, Xcode, Firebase'),
(13, 1013, '/resumes/maya_patel.pdf', 2, 'MS Artificial Intelligence', 'Python, PyTorch, OpenCV, CUDA'),
(14, 1014, '/resumes/noah_garcia.pdf', 8, 'BS Electrical Engineering', 'Embedded C, ARM, RTOS, IoT'),
(15, 1015, '/resumes/olivia_martinez.pdf', 1, 'MS Human-Computer Interaction', 'Figma, Sketch, Adobe XD, HTML/CSS'),
(16, 1016, '/resumes/paul_clark.pdf', 4, 'BS Game Development', 'Unity, C#, Blender, Git'),
(17, 1017, '/resumes/quinn_lewis.pdf', 3, 'MS Cybersecurity', 'Python, Wireshark, Metasploit, Linux'),
(18, 1018, '/resumes/rachel_walker.pdf', 6, 'BS Mathematics', 'R, MATLAB, SAS, Stata'),
(19, 1019, '/resumes/sam_young.pdf', 1, 'MS Cloud Computing', 'AWS, Terraform, Lambda, DynamoDB'),
(20, 1020, '/resumes/tina_hall.pdf', 5, 'BS Business Analytics', 'SQL, Excel, Salesforce, Hubspot'),
(21, 1021, '/resumes/uma_sharma.pdf', 2, 'MS Software Engineering', 'Kotlin, Android, Room, Retrofit'),
(22, 1022, '/resumes/victor_kim.pdf', 4, 'BS Computer Science', 'TypeScript, React Native, GraphQL, Apollo'),
(23, 1023, '/resumes/wendy_liu.pdf', 3, 'MS Information Security', 'Python, Nessus, Burp Suite, OWASP'),
(24, 1024, '/resumes/xavier_wong.pdf', 7, 'BS Network Engineering', 'Cisco, Juniper, BGP, OSPF'),
(25, 1025, '/resumes/yara_ahmed.pdf', 1, 'MS Digital Marketing', 'Google Analytics, SEO, SEM, Social Media'),
(26, 1026, '/resumes/zoe_baker.pdf', 3, 'BS Graphic Design', 'Photoshop, Illustrator, InDesign, After Effects'),
(27, 1027, '/resumes/alex_cooper.pdf', 6, 'MS Database Administration', 'Oracle, SQL Server, MySQL, MongoDB'),
(28, 1028, '/resumes/blake_evans.pdf', 2, 'BS Web Development', 'HTML, CSS, JavaScript, WordPress'),
(29, 1029, '/resumes/chloe_foster.pdf', 4, 'MS Product Management', 'Jira, Confluence, Roadmunk, Mixpanel'),
(30, 1030, '/resumes/drew_hughes.pdf', 5, 'BS DevOps Engineering', 'Jenkins, GitLab, Ansible, Prometheus');

-- Insert interviewers
INSERT INTO interviewer (user_id, interviewer_id, company_dept_id) VALUES
(51, 2001, 1), -- TechCorp Software Eng
(52, 2002, 4), -- DataFlow Software Eng
(53, 2003, 7), -- InnovateLabs Software Eng
(54, 2004, 9), -- CloudTech Software Eng
(55, 2005, 1), -- TechCorp Software Eng
(56, 2006, 5), -- DataFlow Data Science
(57, 2007, 10), -- CloudTech Data Science
(58, 2008, 7), -- InnovateLabs Software Eng
(59, 2009, 1), -- TechCorp Software Eng
(60, 2010, 6); -- DataFlow Design

-- Insert recruiters
INSERT INTO recruitor (user_id, recruitor_id, company_id) VALUES
(71, 3001, 1), -- TechCorp
(72, 3002, 2), -- DataFlow
(73, 3003, 3), -- InnovateLabs
(74, 3004, 4), -- CloudTech
(75, 3005, 5); -- StartupXYZ

-- Insert jobs (some with high application counts)
INSERT INTO job (job_id, title, company_dept_id, description, total_applications, posted_by, status) VALUES
(1, 'Senior Full Stack Developer', 1, 'Build scalable web applications using modern tech stack', 75, 3001, 'open'),
(2, 'Data Scientist - ML Engineer', 2, 'Develop machine learning models for predictive analytics', 45, 3001, 'open'),
(3, 'Frontend React Developer', 4, 'Create responsive user interfaces with React and TypeScript', 92, 3002, 'open'),
(4, 'Backend Java Developer', 4, 'Design and implement RESTful APIs and microservices', 68, 3002, 'open'),
(5, 'Product Manager - Tech', 3, 'Lead product development and strategy for B2B platform', 35, 3001, 'open'),
(6, 'UX/UI Designer', 6, 'Design user-centered digital experiences', 28, 3002, 'open'),
(7, 'Mobile App Developer', 7, 'Develop cross-platform mobile applications', 55, 3003, 'open'),
(8, 'DevOps Engineer', 9, 'Manage cloud infrastructure and CI/CD pipelines', 63, 3004, 'open'),
(9, 'AI/ML Research Scientist', 10, 'Research and develop cutting-edge AI algorithms', 40, 3004, 'open'),
(10, 'Software Engineering Intern', 1, 'Summer internship program for CS students', 120, 3001, 'open');

-- Insert applications (distributed across different stages)
INSERT INTO applications (application_id, candidate_id, job_id, applied_at, current_stage_id) VALUES
-- Job 1 applications (Senior Full Stack Developer - 75 total)
(1, 1001, 1, '2025-07-15 09:30:00', 3), -- Interview stage
(2, 1002, 1, '2025-07-16 10:15:00', 3), -- Interview stage
(3, 1003, 1, '2025-07-17 14:20:00', 2), -- Screened
(4, 1004, 1, '2025-07-18 11:45:00', 3), -- Interview stage
(5, 1005, 1, '2025-07-19 16:30:00', 4), -- Offer stage
(6, 1006, 1, '2025-07-20 09:10:00', -1), -- Rejected
(7, 1007, 1, '2025-07-21 13:25:00', 3), -- Interview stage
(8, 1008, 1, '2025-07-22 15:40:00', 2), -- Screened

-- Job 2 applications (Data Scientist)
(9, 1003, 2, '2025-07-16 12:30:00', 3), -- Interview stage
(10, 1007, 2, '2025-07-17 14:45:00', 2), -- Screened
(11, 1011, 2, '2025-07-18 10:20:00', 3), -- Interview stage
(12, 1013, 2, '2025-07-19 16:15:00', 4), -- Offer stage

-- Job 3 applications (Frontend React Developer - 92 total)
(13, 1001, 3, '2025-07-14 08:30:00', 2), -- Screened
(14, 1004, 3, '2025-07-15 11:20:00', 3), -- Interview stage
(15, 1009, 3, '2025-07-16 13:45:00', 3), -- Interview stage
(16, 1012, 3, '2025-07-17 15:30:00', 3), -- Interview stage
(17, 1015, 3, '2025-07-18 09:50:00', 4), -- Offer stage
(18, 1018, 3, '2025-07-19 14:10:00', -1), -- Rejected

-- Job 4 applications (Backend Java Developer)
(19, 1002, 4, '2025-07-15 10:30:00', 3), -- Interview stage
(20, 1006, 4, '2025-07-16 12:45:00', 2), -- Screened
(21, 1010, 4, '2025-07-17 14:20:00', 3), -- Interview stage
(22, 1014, 4, '2025-07-18 16:35:00', 4), -- Offer stage

-- More applications for job 10 (Intern position - 120 total)
(23, 1019, 10, '2025-07-12 09:15:00', 3), -- Interview stage
(24, 1020, 10, '2025-07-13 11:30:00', 3), -- Interview stage
(25, 1021, 10, '2025-07-14 13:45:00', 2), -- Screened
(26, 1022, 10, '2025-07-15 15:20:00', 3), -- Interview stage
(27, 1023, 10, '2025-07-16 10:40:00', 4), -- Offer stage
(28, 1024, 10, '2025-07-17 12:55:00', -1), -- Rejected

-- Additional applications for various jobs
(29, 1025, 5, '2025-07-18 14:30:00', 2), -- Product Manager
(30, 1026, 6, '2025-07-19 16:45:00', 3), -- UX Designer - Interview
(31, 1027, 8, '2025-07-20 11:20:00', 3), -- DevOps - Interview
(32, 1028, 7, '2025-07-21 13:35:00', 4), -- Mobile Dev - Offer
(33, 1029, 9, '2025-07-22 15:50:00', 2), -- AI/ML - Screened
(34, 1030, 8, '2025-07-23 09:25:00', 3), -- DevOps - Interview

-- Additional applications for candidates to have multiple applications
(35, 1001, 7, '2025-07-20 10:30:00', 2), -- Alice - Mobile Dev
(36, 1002, 8, '2025-07-21 12:45:00', 1), -- Bob - DevOps
(37, 1003, 5, '2025-07-22 14:20:00', 3), -- Carol - Product Manager - Interview
(38, 1004, 6, '2025-07-23 16:35:00', 2), -- David - UX Designer
(39, 1005, 9, '2025-07-24 11:50:00', 1); -- Emma - AI/ML

-- Insert application stage history
INSERT INTO application_stage_history (id, application_id, stage_id, changed_by, changed_at, notes) VALUES
(1, 1, 1, 3001, '2025-07-15 09:30:00', 'Application received'),
(2, 1, 2, 3001, '2025-07-16 14:20:00', 'Passed initial screening'),
(3, 1, 3, 3001, '2025-07-18 10:15:00', 'Moved to interview round'),
(4, 5, 1, 3001, '2025-07-19 16:30:00', 'Application received'),
(5, 5, 2, 3001, '2025-07-20 11:45:00', 'Screening completed successfully'),
(6, 5, 3, 3001, '2025-07-22 15:30:00', 'Interview completed'),
(7, 5, 4, 3001, '2025-07-24 09:20:00', 'Offer extended');

-- Insert interviews
INSERT INTO interviews (id, application_id, interviewer_id, scheduled_at, feedback, status, result) VALUES
(1, 1, 2001, '2025-07-28 10:00:00', 'Strong technical skills, good communication', 'scheduled', 'pending'),
(2, 2, 2005, '2025-07-28 14:00:00', NULL, 'scheduled', 'pending'),
(3, 4, 2009, '2025-07-29 09:30:00', NULL, 'scheduled', 'pending'),
(4, 7, 2001, '2025-07-29 15:00:00', NULL, 'scheduled', 'pending'),
(5, 9, 2006, '2025-07-30 11:00:00', 'Excellent data science background', 'completed', 'pass'),
(6, 11, 2007, '2025-07-30 16:00:00', NULL, 'scheduled', 'pending'),
(7, 14, 2002, '2025-07-31 10:30:00', NULL, 'scheduled', 'pending'),
(8, 15, 2002, '2025-07-31 14:30:00', 'Good React knowledge', 'completed', 'pass'),
(9, 16, 2008, '2025-08-01 09:00:00', NULL, 'scheduled', 'pending'),
(10, 19, 2002, '2025-08-01 13:00:00', NULL, 'scheduled', 'pending'),
(11, 21, 2004, '2025-08-02 11:00:00', 'Strong Java expertise', 'completed', 'pass'),
(12, 23, 2001, '2025-08-02 15:00:00', NULL, 'scheduled', 'pending'),
(13, 24, 2005, '2025-08-03 10:00:00', NULL, 'scheduled', 'pending'),
(14, 26, 2009, '2025-08-03 14:00:00', 'Promising intern candidate', 'completed', 'pass'),
(15, 30, 2010, '2025-08-04 11:30:00', NULL, 'scheduled', 'pending'),
(16, 31, 2004, '2025-08-04 16:00:00', NULL, 'scheduled', 'pending'),
(17, 34, 2004, '2025-08-05 09:30:00', NULL, 'scheduled', 'pending'),
(18, 37, 2001, '2025-08-05 13:30:00', NULL, 'scheduled', 'pending');

-- Insert offers
INSERT INTO offers (offer_id, application_id, salary, issued_at, valid_till, status, description) VALUES
(1, 5, 95000.00, '2025-07-24 09:20:00', '2025-08-07 23:59:59', 'pending', 'Senior Full Stack Developer position with comprehensive benefits'),
(2, 12, 105000.00, '2025-07-25 14:30:00', '2025-08-08 23:59:59', 'accepted', 'Data Scientist role with stock options'),
(3, 17, 85000.00, '2025-07-26 11:45:00', '2025-08-09 23:59:59', 'pending', 'Frontend React Developer with remote work flexibility'),
(4, 22, 88000.00, '2025-07-26 16:20:00', '2025-08-09 23:59:59', 'declined', 'Backend Java Developer position'),
(5, 27, 65000.00, '2025-07-27 10:15:00', '2025-08-10 23:59:59', 'accepted', 'Software Engineering Internship with mentorship program'),
(6, 32, 78000.00, '2025-07-27 13:40:00', '2025-08-10 23:59:59', 'pending', 'Mobile App Developer with growth opportunities');

-- Insert recruiter activities
INSERT INTO recruitor_activities (activity_id, recruitor_id, application_id, activity_date, activity_type) VALUES
(1, 3001, 1, '2025-07-16 14:20:00', 'application_reviewed'),
(2, 3001, 2, '2025-07-17 10:30:00', 'application_reviewed'),
(3, 3001, 5, '2025-07-24 09:20:00', 'offer_created'),
(4, 3002, 13, '2025-07-19 15:45:00', 'application_reviewed'),
(5, 3002, 14, '2025-07-20 11:20:00', 'stage_changed'),
(6, 3004, 31, '2025-07-25 16:30:00', 'application_reviewed'),
(7, 3001, 7, '2025-07-22 14:15:00', 'stage_changed'),
(8, 3003, 30, '2025-07-26 12:40:00', 'stage_changed');

-- Insert audit records
INSERT INTO audit (id, changed_by, action_type, table_name, row_id, old_value, new_value, changed_at) VALUES
(1, 71, 'create', 'applications', 1, NULL, '{"candidate_id":1001,"job_id":1,"stage_id":1}', '2025-07-15 09:30:00'),
(2, 71, 'update', 'applications', 1, '{"stage_id":1}', '{"stage_id":2}', '2025-07-16 14:20:00'),
(3, 72, 'create', 'offers', 1, NULL, '{"application_id":5,"salary":95000}', '2025-07-24 09:20:00'),
(4, 72, 'update', 'offers', 2, '{"status":"pending"}', '{"status":"accepted"}', '2025-07-25 15:30:00');


