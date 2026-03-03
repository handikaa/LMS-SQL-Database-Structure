Description ERD : 

tabel users
Menyimpan semua akun user dalam satu tabel.
Di dalam users terdapat kolom role yang membedakan user sebagai:
student: peserta course
instructor: pembuat course
Tujuan: memusatkan data autentikasi dan profil user dalam satu tabel.

tabel course
Menyimpan data course yang dibuat oleh instructor.
Setiap course memiliki instructor_id yang mengarah ke users.id.
Relasi:
1 instructor dapat membuat banyak course (one-to-many)
courses.instructor_id -> users.id
Atribut penting tambahan:
price: harga course dalam rupiah.
quota: kapasitas maksimal peserta.
enrolled_count: jumlah peserta aktif saat ini (ringkasan untuk performa dan validasi kuota).
rating_avg dan rating_count: ringkasan rating course untuk memudahkan tampilan di frontend (tanpa harus hitung AVG setiap kali).

tabel lessons
Menyimpan materi/lesson yang berada di dalam course.
Setiap lesson pasti milik satu course melalui course_id.
Relasi:
1 course memiliki banyak lesson (one-to-many)
lessons.course_id -> courses.id
Tujuan: memecah course menjadi unit materi yang bisa dipelajari bertahap.


tabel enrollments (pivot student ↔ course)
Tabel ini digunakan untuk mencatat course apa saja yang diikuti oleh student.
Karena relasi student dan course adalah many-to-many:
1 student bisa mengikuti banyak course
1 course bisa diikuti banyak student
Relasi:
enrollments.user_id -> users.id (student)
enrollments.course_id -> courses.id
Aturan penting:
UNIQUE (user_id, course_id) untuk memastikan:
1 student tidak bisa mendaftar course yang sama dua kali (mencegah data redundan)
Status enrollment:
active (sedang ikut)
completed (selesai)
cancelled (batal)
Logika kuota:
Student hanya boleh enroll jika courses.enrolled_count < courses.quota.
Saat enrollment aktif bertambah, enrolled_count ikut bertambah (biasanya dalam transaksi).

lesson_progress
Tabel ini mencatat progress belajar student per lesson.
Karena progress harus dicatat per user dan per lesson:
1 student punya banyak record progress (untuk lesson yang berbeda)
1 lesson punya banyak progress record (dari student yang berbeda)
Relasi:	
lesson_progress.user_id -> users.id (student)
lesson_progress.lesson_id -> lessons.id
Aturan penting:
UNIQUE (user_id, lesson_id) untuk memastikan:
1 student hanya punya 1 progress record untuk 1 lesson (tidak duplikat)
Status progress:
not_started, in_progress, completed

tabel categories
Menyimpan daftar kategori course (misal: backend, frontend, web-development).
slug dipakai untuk URL/filter yang rapi

tabel course_categories (pivot course ↔ category)
Tabel pivot ini menghubungkan course dan categories.
Kenapa perlu tabel ini?
Karena relasi course dan category adalah many-to-many:
1 course bisa punya banyak category
1 category bisa digunakan oleh banyak course
Relasi:
course_categories.course_id -> courses.id
course_categories.category_id -> categories.id
Aturan penting:
PK gabungan / UNIQUE (course_id, category_id) untuk memastikan:
1 course tidak bisa ditambahkan ke kategori yang sama dua kali

course_reviews
Menyimpan rating dan komentar student terhadap course.
Relasi:
course_reviews.course_id -> courses.id
course_reviews.user_id -> users.id (student)
Aturan penting (disarankan):
UNIQUE (course_id, user_id) untuk memastikan:
- 1 student hanya bisa memberi 1 review untuk 1 course
Kaitan dengan rating summary di courses:
course_reviews adalah data detail (source of truth)
courses.rating_avg dan courses.rating_count adalah ringkasan agar tampilan list course lebih cepat dan mudah.

