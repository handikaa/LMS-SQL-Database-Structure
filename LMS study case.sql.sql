-- ============================================
-- MASTER TABLES
-- ============================================

-- CREATE USERS TABLE
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('student', 'instructor') NOT NULL,
  avatar_url VARCHAR(255) NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- CREATE COURSES TABLE
CREATE TABLE courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  instructor_id INT  NOT NULL,
  title VARCHAR(150) NOT NULL,
  slug VARCHAR(160) NOT NULL UNIQUE,
  description TEXT NOT NULL,
  level VARCHAR(50) NULL,
  thumbnail_url VARCHAR(255) NULL,
  status ENUM('draft', 'published', 'archived') NOT NULL DEFAULT 'draft',
  published_at DATETIME NULL,
  price BIGINT NOT NULL DEFAULT 0,
  quota INT NOT NULL DEFAULT 0,
  enrolled_count INT NOT NULL DEFAULT 0,
  rating_avg DECIMAL(3,2) NOT NULL DEFAULT 0.00,
  rating_count INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

ALTER TABLE courses
MODIFY COLUMN level ENUM('beginner','intermediate','advanced') NULL;


-- CREATE RELATION TABEL COURSES TO USERS
ALTER TABLE courses
  ADD CONSTRAINT fk_courses_instructor
  FOREIGN KEY (instructor_id) REFERENCES users(id)
  ON UPDATE CASCADE
  ON DELETE RESTRICT;

-- CREATE LESSONS TABLE
CREATE TABLE lessons (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT NOT NULL,
  title VARCHAR(150) NOT NULL,
  type ENUM('video', 'article', 'file') NOT NULL,
  content LONGTEXT NULL,
  video_url VARCHAR(255) NULL,
  file_url VARCHAR(255) NULL,
  order_index INT NOT NULL DEFAULT 1,
  is_preview BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- CREATE RELATION TABEL LESSONS TO COURSES
ALTER TABLE lessons
  ADD CONSTRAINT fk_lessons_course
  FOREIGN KEY (course_id) REFERENCES courses(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

-- CREATE ENROLLMENTS TABLE
CREATE TABLE enrollments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  course_id INT NOT NULL,
  status ENUM('active', 'completed', 'cancelled') NOT NULL DEFAULT 'active',
  enrolled_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  completed_at DATETIME NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_enrollments_user_course (user_id, course_id)
);

-- CREATE RELATION TABEL enrollments TO users
ALTER TABLE enrollments
  ADD CONSTRAINT fk_enrollments_user
  FOREIGN KEY (user_id) REFERENCES users(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

 -- CREATE RELATION TABEL enrollments TO courses
ALTER TABLE enrollments
  ADD CONSTRAINT fk_enrollments_course
  FOREIGN KEY (course_id) REFERENCES courses(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

 -- CREATE TABEL LESSON_PROGRESS
 CREATE TABLE lesson_progress (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  lesson_id INT NOT NULL,
  status ENUM('not_started', 'in_progress', 'completed') NOT NULL DEFAULT 'not_started',
  completed_at DATETIME NULL,
  last_accessed_at DATETIME NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_lessons_progress_user_lesson (user_id, lesson_id)
);

-- CREATE RELATION LESSON_PROGRESS REF USERS
ALTER TABLE lesson_progress
  ADD CONSTRAINT fk_lessons_progress_user
  FOREIGN KEY (user_id) REFERENCES users(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;


-- CREATE RELATION LESSON_PROGRESS REF LESSONS
 ALTER TABLE lesson_progress
  ADD CONSTRAINT fk_lessons_progress_lesson
  FOREIGN KEY (lesson_id) REFERENCES lessons(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

 -- CREATE TABEL COURSE_REVIEWS
 CREATE TABLE course_reviews (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT NOT NULL,
  user_id INT NOT NULL,
  rating TINYINT NOT NULL,
  comment TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_course_reviews_course_user (course_id, user_id),
  CONSTRAINT chk_course_reviews_rating CHECK (rating BETWEEN 1 AND 5)
);

-- CREATE RELATION TABEL COURSE_REVIEWS REF COURSES
ALTER TABLE course_reviews
  ADD CONSTRAINT fk_course_reviews_course
  FOREIGN KEY (course_id) REFERENCES courses(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

 -- CREATE RELATION TABEL COURSE_REVIEWS REF USERS
 ALTER TABLE course_reviews
  ADD CONSTRAINT fk_course_reviews_user
  FOREIGN KEY (user_id) REFERENCES users(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;
 
 
 -- CREATE TABEL CATEGORIES
 CREATE TABLE categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  slug VARCHAR(50) NOT NULL UNIQUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- CREATE PIVOT COURSE_CATEGORIES
CREATE TABLE course_categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT NOT NULL,
  category_id INT NOT NULL,
  UNIQUE KEY uq_course_category (course_id, category_id)
);

-- CREATE RELATION COURSE_CATEGORIES REF COURES
ALTER TABLE course_categories
  ADD CONSTRAINT fk_course_categories_course
  FOREIGN KEY (course_id) REFERENCES courses(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;

 -- CREATE RELATION COURSE_CATEGORIES REF CATEGORIES
ALTER TABLE course_categories
  ADD CONSTRAINT fk_course_categories_category
  FOREIGN KEY (category_id) REFERENCES categories(id)
  ON UPDATE CASCADE
  ON DELETE CASCADE;
 
 
-- ============================================
-- USERS
-- ============================================
 
 INSERT INTO users (name, email, password_hash, role) VALUES
('Ahmad Instructor', 'ahmad@lms.com', 'hashed_pw', 'instructor'),
('Budi Instructor', 'budi@lms.com', 'hashed_pw', 'instructor'),
('Citra Instructor', 'citra@lms.com', 'hashed_pw', 'instructor'),
('Dewi Instructor', 'dewi@lms.com', 'hashed_pw', 'instructor'),
('Eko Instructor', 'eko@lms.com', 'hashed_pw', 'instructor'),
('Farah Instructor', 'farah@lms.com', 'hashed_pw', 'instructor'),
('Gilang Instructor', 'gilang@lms.com', 'hashed_pw', 'instructor'),
('Hana Instructor', 'hana@lms.com', 'hashed_pw', 'instructor'),
('Indra Instructor', 'indra@lms.com', 'hashed_pw', 'instructor'),
('Student 1', 'student1@lms.com', 'hashed_pw', 'student'),
('Student 2', 'student2@lms.com', 'hashed_pw', 'student'),
('Student 3', 'student3@lms.com', 'hashed_pw', 'student'),
('Student 4', 'student4@lms.com', 'hashed_pw', 'student'),
('Student 5', 'student5@lms.com', 'hashed_pw', 'student'),
('Student 6', 'student6@lms.com', 'hashed_pw', 'student'),
('Student 7', 'student7@lms.com', 'hashed_pw', 'student'),
('Student 8', 'student8@lms.com', 'hashed_pw', 'student'),
('Student 9', 'student9@lms.com', 'hashed_pw', 'student'),
('Student 10', 'student10@lms.com', 'hashed_pw', 'student'),
('Student 11', 'student11@lms.com', 'hashed_pw', 'student'),
('Student 12', 'student12@lms.com', 'hashed_pw', 'student'),
('Student 13', 'student13@lms.com', 'hashed_pw', 'student'),
('Student 14', 'student14@lms.com', 'hashed_pw', 'student'),
('Student 15', 'student15@lms.com', 'hashed_pw', 'student'),
('Student 16', 'student16@lms.com', 'hashed_pw', 'student'),
('Student 17', 'student17@lms.com', 'hashed_pw', 'student'),
('Student 18', 'student18@lms.com', 'hashed_pw', 'student'),
('Student 19', 'student19@lms.com', 'hashed_pw', 'student'),
('Student 20', 'student20@lms.com', 'hashed_pw', 'student'),
('Student 21', 'student21@lms.com', 'hashed_pw', 'student');


-- ============================================
-- CATEGORIES
-- ============================================
INSERT INTO categories (name, slug) VALUES
('Web Development', 'web-development'),
('Backend Development', 'backend-development'),
('Frontend Development', 'frontend-development'),
('Mobile Development', 'mobile-development'),
('UI/UX Design', 'ui-ux-design');

 
-- ============================================
-- COURSES
-- ============================================
INSERT INTO courses 
(instructor_id, title, slug, description, level, status, price, quota, enrolled_count)
VALUES
(1, 'Laravel untuk Pemula', 'laravel-pemula', 'Belajar Laravel dari dasar', 'beginner', 'published', 300000, 50, 5),
(2, 'React Dasar sampai Mahir', 'react-complete', 'Belajar React lengkap', 'intermediate', 'published', 350000, 50, 4),
(3, 'UI/UX Fundamental', 'uiux-fundamental', 'Dasar desain UI/UX', 'beginner', 'published', 200000, 30, 3),
(4, 'NodeJS API Development', 'nodejs-api', 'Bangun REST API dengan NodeJS', 'advanced', 'published', 400000, 40, 2),
(5, 'Flutter Mobile Apps', 'flutter-mobile', 'Bangun aplikasi mobile', 'intermediate', 'draft', 300000, 30, 0),
(6, 'Database Design Mastery', 'database-design', 'Desain database profesional', 'advanced', 'published', 450000, 50, 3);

INSERT INTO courses
(instructor_id, title, slug, description, level, status, price, quota, enrolled_count)
VALUES
(1, 'HTML & CSS Basic', 'html-css-basic', 'Belajar dasar HTML dan CSS', 'beginner', 'published', 75000, 100, 12),
(2, 'JavaScript Modern ES6+', 'javascript-modern', 'Belajar JavaScript modern', 'beginner', 'published', 150000, 80, 20),
(3, 'Advanced React Patterns', 'advanced-react-patterns', 'Teknik lanjutan React', 'advanced', 'published', 500000, 40, 10),
(4, 'Fullstack Web Bootcamp', 'fullstack-bootcamp', 'Bootcamp fullstack dari nol', 'intermediate', 'published', 1250000, 25, 25),
(5, 'Docker untuk Developer', 'docker-developer', 'Belajar Docker untuk deployment', 'intermediate', 'published', 300000, 0, 0),
(6, 'Kubernetes Practical Guide', 'kubernetes-guide', 'Panduan Kubernetes', 'advanced', 'draft', 900000, 30, 0),
(2, 'PHP Legacy System', 'php-legacy', 'Maintain aplikasi PHP lama', 'intermediate', 'archived', 200000, 50, 15),
(3, 'Figma for Beginner', 'figma-beginner', 'Belajar desain pakai Figma', 'beginner', 'published', 50000, 200, 35),
(4, 'System Design Interview Prep', 'system-design-prep', 'Persiapan interview system design', 'advanced', 'published', 1500000, 20, 18),
(1, 'Microservices Architecture', 'microservices-architecture', 'Arsitektur microservices modern', 'advanced', 'published', 2000000, 10, 10);


INSERT INTO course_categories (course_id, category_id) VALUES
(1,2),
(1,1),
(2,3),
(2,1),
(3,5),
(4,2),
(6,2);

INSERT INTO course_categories (course_id, category_id) VALUES
(7,1),
(7,3),
(8,3),
(8,1),
(9,3),
(10,1), 
(10,2), 
(10,3), 
(11,2),
(12,2),
(13,2),
(13,1), 
(14,5),
(15,2), 
(16,2),
(16,1);


-- ============================================
-- LESSONS
-- ============================================

INSERT INTO lessons (course_id, title, type, order_index) VALUES
(1,'Intro Laravel','video',1),
(1,'Routing & Controller','video',2),
(1,'Eloquent ORM','article',3),
(2,'Intro React','video',1),
(2,'Component & Props','video',2),
(2,'State Management','article',3),
(3,'Intro UI','video',1),
(3,'Wireframing','article',2),
(3,'Prototyping','video',3),
(4,'Intro NodeJS','video',1),
(4,'ExpressJS','video',2),
(4,'Authentication JWT','article',3),
(6,'Normalisasi Database','video',1),
(6,'ERD Design','article',2),
(6,'Indexing Strategy','video',3);

INSERT INTO lessons (course_id, title, type, order_index) VALUES
(7,'HTML Structure','video',1),
(7,'CSS Styling','video',2),
(7,'Responsive Layout','article',3),
(8,'ES6 Syntax','video',1),
(8,'Async Await','video',2),
(8,'Modules & Bundler','article',3),
(9,'Advanced Hooks','video',1),
(9,'Performance Optimization','video',2),
(9,'Reusable Patterns','article',3),
(10,'Frontend Setup','video',1),
(10,'Backend API Build','video',2),
(10,'Deployment','article',3),
(11,'Docker Basic','video',1),
(11,'Dockerfile','video',2),
(11,'Docker Compose','article',3),
(13,'Legacy Code Reading','video',1),
(13,'Refactoring Strategy','article',2),
(13,'Upgrade PHP Version','video',3),
(14,'Figma Interface','video',1),
(14,'Design Component','video',2),
(14,'Prototype Interaction','article',3),
(15,'Scalability Concept','video',1),
(15,'Database Scaling','video',2),
(15,'Caching Strategy','article',3),
(16,'Service Communication','video',1),
(16,'API Gateway','video',2),
(16,'Distributed Logging','article',3);


-- ============================================
-- ENROLLMENTS
-- ============================================
INSERT INTO enrollments (user_id, course_id, status) VALUES
(10,1,'active'),
(11,1,'active'),
(12,2,'active'),
(13,3,'active'),
(14,4,'active'),
(15,6,'active');

INSERT INTO enrollments (user_id, course_id, status) VALUES
(16,1,'active'),
(17,2,'active'),
(18,6,'active');

INSERT INTO enrollments (user_id, course_id, status) VALUES
(19,10,'active'),
(20,10,'active'),
(21,10,'completed'),
(22,14,'active'),
(23,14,'active'),
(24,14,'completed'),
(25,7,'active'),
(26,8,'active'),
(27,9,'active'),
(28,15,'active'),
(29,16,'completed'),
(30,16,'active');



-- ============================================
-- LESSON_PROGRESS
-- ============================================

INSERT INTO lesson_progress (user_id, lesson_id, status) VALUES
(10,1,'completed'),
(10,2,'in_progress'),
(11,1,'completed'),
(12,4,'completed'),
(12,5,'completed'),
(13,7,'in_progress'),
(14,10,'completed'),
(15,13,'in_progress');


INSERT INTO course_reviews (course_id, user_id, rating, comment) VALUES
(10,19,5,'Bootcamp terbaik!'),
(10,20,5,'Worth the price'),
(10,21,4,'Materi lengkap'),
(14,22,4,'Cocok untuk pemula'),
(14,23,3,'Lumayan bagus'),
(16,29,5,'Advanced banget!'),
(8,26,4,'JS jadi mudah');


-- ============================================
-- COURSE_REVIEWS
-- ============================================
INSERT INTO course_reviews (course_id, user_id, rating, comment) VALUES
(1,10,5,'Sangat bagus!'),
(1,11,4,'Materi jelas'),
(2,12,5,'React jadi mudah dipahami'),
(3,13,4,'Desain sangat membantu'),
(6,15,5,'Database dijelaskan detail');

UPDATE courses c
LEFT JOIN (
    SELECT 
        course_id,
        AVG(rating) AS avg_rating,
        COUNT(*) AS total_rating
    FROM course_reviews
    GROUP BY course_id
) r ON c.id = r.course_id
SET 
    c.rating_avg = IFNULL(r.avg_rating, 0),
    c.rating_count = IFNULL(r.total_rating, 0);



-- ============================================
-- LATIHAN SOAL
-- ============================================

-- SOAL 1. SQL Fundamentals
-- A. Tampilkan seluruh data course
SELECT * FROM courses c 

-- B. Tampilkan nama course dan harga saja.
SELECT c.title as course_name, c.price  FROM courses c

-- C. Tampilkan course dengan harga antara 50.000 sampai 200.000.
SELECT * FROM courses c WHERE c.price >= 50000 AND c.price <= 200000

-- D. Tampilkan course yang memiliki kuota 0 ATAU harga di atas 500.000.
SELECT * FROM courses c WHERE quota = 0 OR price >= 500000

-- E. Tampilkan 5 course dengan harga tertinggi.
SELECT * FROM courses c ORDER BY price DESC LIMIT 5


-- SOAL 2. Aggregate & Conditional Logic 
-- A. Hitung total user yang terdaftar.
SELECT COUNT(*) as total_users FROM users u 

-- B. Hitung total course yang tersedia.
SELECT COUNT(*) as total_avail_courses FROM courses c WHERE c.status = 'published'

-- C. Hitung jumlah course per kategori.
SELECT c.id, c.name as category_name, COUNT(*) as total_courses  FROM categories c
LEFT JOIN course_categories cc ON cc.category_id = c.id 
GROUP BY c.id, c.name

-- D. Hitung rata-rata harga course per kategori.
SELECT c.id, c.name as category_name, ROUND(AVG(c2.price),0) as harga_rata_rata_course, COUNT(*) as total_courses  FROM categories c
LEFT JOIN course_categories cc ON cc.category_id = c.id
JOIN courses c2 ON c2.id = cc.course_id  
GROUP BY c.id, c.name

-- E. Tampilkan kategori yang memiliki lebih dari 3 course.
SELECT c.id, c.name as category_name, ROUND(AVG(c2.price),0) as harga_rata_rata_course, COUNT(*) as total_courses  FROM categories c
LEFT JOIN course_categories cc ON cc.category_id = c.id
JOIN courses c2 ON c2.id = cc.course_id  
GROUP BY c.id, c.name
HAVING COUNT(cc.course_id) > 3

-- Soal 3. Join Statements Gunakan INNER JOIN atau LEFT JOIN sesuai kebutuhan:

-- A. Tampilkan daftar course beserta nama kategorinya.
SELECT cat.name as category_name, cou.title as course_title FROM course_categories cc 
LEFT JOIN categories cat ON cat.id = cc.category_id  
JOIN courses cou ON cou.id  = cc.course_id 
GROUP BY cat.id, cou.title 

-- B. Tampilkan semua kategori meskipun belum memiliki course.
SELECT cat.name as category_name, cou.title as course_name FROM course_categories cc
RIGHT JOIN categories cat ON cat.id = cc.category_id  
JOIN courses cou ON cou.id  = cc.course_id 
GROUP BY cat.id, cou.title 

-- C. Tampilkan semua user meskipun belum pernah mengupload course.
SELECT 
	u.id, 
	u.name, 
	u.email, 
	c.title as course_name 
FROM users u
LEFT JOIN courses c ON c.instructor_id = u.id
WHERE u.role ='instructor'
ORDER BY u.id

-- D.Tampilkan daftar course beserta nama instructor yang membuat course tersebut.
SELECT 
	c.title as course_name,
	u.name as instructor_name, 
	u.email	as instructor_name
FROM users u
LEFT JOIN courses c ON c.instructor_id = u.id
WHERE u.role ='instructor'
ORDER BY u.id

-- E. Tampilkan jumlah course yang dibuat oleh masing-masing instructor.
SELECT 
	u.name as instructor_name,
	u.email as instructor_email,
	COUNT(c.id) as total_course_instructor
FROM users u 
LEFT JOIN courses c ON c.instructor_id =u.id 
WHERE u.role ='instructor'
GROUP BY u.id, u.name 