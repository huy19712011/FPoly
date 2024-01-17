-- 1. Basics 1-n
-- e1
-- Department table
CREATE TABLE Department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL
);

-- Employee table with a foreign key referencing the Department table
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(255) NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- Inserting sample data into the Department table
INSERT INTO Department (department_id, department_name) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance'),
(4, 'Marketing'),
(5, 'Operations');

-- Inserting sample data into the Employee table
INSERT INTO Employee (employee_id, employee_name, department_id) VALUES
(101, 'John Doe', 1),
(102, 'Jane Smith', 1),
(103, 'Bob Johnson', 2),
(104, 'Alice Williams', 3),
(105, 'Charlie Brown', 4);


-- e2
-- University table
CREATE TABLE University (
    university_id INT PRIMARY KEY,
    university_name VARCHAR(255) NOT NULL
);

-- Student table with a foreign key referencing the University table
CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(255) NOT NULL,
    university_id INT,
    FOREIGN KEY (university_id) REFERENCES University(university_id)
);

-- Inserting sample data into the University table
INSERT INTO University (university_id, university_name) VALUES
(1, 'ABC University'),
(2, 'XYZ University'),
(3, '123 College'),
(4, '456 Institute'),
(5, '789 School');

-- Inserting sample data into the Student table
INSERT INTO Student (student_id, student_name, university_id) VALUES
(201, 'Emily Johnson', 1),
(202, 'Michael Smith', 1),
(203, 'Sophia Williams', 2),
(204, 'Daniel Brown', 3),
(205, 'Olivia Davis', 4);


-- e2 in VN
-- Bảng Daihoc
CREATE TABLE Daihoc (
    ma_daihoc INT PRIMARY KEY,
    ten_daihoc VARCHAR(255) NOT NULL
);

-- Bảng Sinhvien với khóa ngoại tham chiếu đến bảng Daihoc
CREATE TABLE Sinhvien (
    ma_sinhvien INT PRIMARY KEY,
    ten_sinhvien VARCHAR(255) NOT NULL,
    ma_daihoc INT,
    FOREIGN KEY (ma_daihoc) REFERENCES Daihoc(ma_daihoc)
);

-- Chèn dữ liệu mẫu vào bảng Daihoc
INSERT INTO Daihoc (ma_daihoc, ten_daihoc) VALUES
(1, 'Đại học ABC'),
(2, 'Đại học XYZ'),
(3, 'Học viện 123'),
(4, 'Viện 456'),
(5, 'Trường 789');

-- Chèn dữ liệu mẫu vào bảng Sinhvien
INSERT INTO Sinhvien (ma_sinhvien, ten_sinhvien, ma_daihoc) VALUES
(101, 'Nguyễn Văn A', 1),
(102, 'Trần Thị B', 1),
(103, 'Lê Văn C', 2),
(104, 'Phạm Thị D', 3),
(105, 'Hoàng Văn E', 4);


-- e3
-- Bảng NhaXuatBan
CREATE TABLE NhaXuatBan (
    ma_nxb INT PRIMARY KEY,
    ten_nxb VARCHAR(255) NOT NULL
);

-- Bảng Sach với khóa ngoại tham chiếu đến bảng NhaXuatBan
CREATE TABLE Sach (
    ma_sach INT PRIMARY KEY,
    ten_sach VARCHAR(255) NOT NULL,
    ma_nxb INT,
    FOREIGN KEY (ma_nxb) REFERENCES NhaXuatBan(ma_nxb)
);

-- Chèn dữ liệu mẫu vào bảng NhaXuatBan
INSERT INTO NhaXuatBan (ma_nxb, ten_nxb) VALUES
(1, 'Nhà Xuất Bản ABC'),
(2, 'Nhà Xuất Bản XYZ'),
(3, 'Nhà Xuất Bản 123'),
(4, 'Nhà Xuất Bản 456'),
(5, 'Nhà Xuất Bản 789');

-- Chèn dữ liệu mẫu vào bảng Sach
INSERT INTO Sach (ma_sach, ten_sach, ma_nxb) VALUES
(201, 'Cuộc Phiêu Lưu của Tom Sawyer', 1),
(202, 'Đắc Nhân Tâm', 2),
(203, 'To Kill a Mockingbird', 3),
(204, 'Harry Potter and the Sorcerer''s Stone', 4),
(205, 'Những Ngày Thứ Ba với Thầy Morrie', 5);

-- 2. n-n
-- e1 
-- Student table
CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(255) NOT NULL
);

-- Course table
CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL
);

-- Enrollment table representing the many-to-many relationship
CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

-- Inserting sample data into the Student table
INSERT INTO Student (student_id, student_name) VALUES
(1, 'John Doe'),
(2, 'Jane Smith'),
(3, 'Bob Johnson'),
(4, 'Alice Williams'),
(5, 'Charlie Brown');

-- Inserting sample data into the Course table
INSERT INTO Course (course_id, course_name) VALUES
(101, 'Mathematics'),
(102, 'History'),
(103, 'Computer Science'),
(104, 'Literature'),
(105, 'Physics');

-- Inserting sample data into the Enrollment table
INSERT INTO Enrollment (enrollment_id, student_id, course_id) VALUES
(1001, 1, 101),
(1002, 1, 103),
(1003, 2, 102),
(1004, 3, 104),
(1005, 4, 105);


-- e2
-- Bảng Author
CREATE TABLE Author (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(255) NOT NULL
);

-- Bảng Book
CREATE TABLE Book (
    book_id INT PRIMARY KEY,
    book_title VARCHAR(255) NOT NULL
);

-- Bảng AuthorBook đại diện cho mối quan hệ nhiều-nhiều
CREATE TABLE AuthorBook (
    authorbook_id INT PRIMARY KEY,
    author_id INT,
    book_id INT,
    FOREIGN KEY (author_id) REFERENCES Author(author_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

-- Chèn dữ liệu mẫu vào bảng Author
INSERT INTO Author (author_id, author_name) VALUES
(1, 'Jane Doe'),
(2, 'John Smith'),
(3, 'Alice Johnson'),
(4, 'Bob Williams'),
(5, 'Charlie Brown');

-- Chèn dữ liệu mẫu vào bảng Book
INSERT INTO Book (book_id, book_title) VALUES
(101, 'The Art of Programming'),
(102, 'History of the World'),
(103, 'Introduction to Machine Learning'),
(104, 'Poetry Collection'),
(105, 'Physics for Beginners');

-- Chèn dữ liệu mẫu vào bảng AuthorBook
INSERT INTO AuthorBook (authorbook_id, author_id, book_id) VALUES
(1001, 1, 101),
(1002, 1, 103),
(1003, 2, 102),
(1004, 3, 104),
(1005, 4, 105);


-- e2b
-- Bảng TacGia
CREATE TABLE TacGia (
    ma_tacgia INT PRIMARY KEY,
    ten_tacgia VARCHAR(255) NOT NULL
);

-- Bảng Sach
CREATE TABLE Sach (
    ma_sach INT PRIMARY KEY,
    ten_sach VARCHAR(255) NOT NULL
);

-- Bảng TacGiaSach đại diện cho mối quan hệ nhiều-nhiều
CREATE TABLE TacGiaSach (
    magiasach_id INT PRIMARY KEY,
    ma_tacgia INT,
    ma_sach INT,
    FOREIGN KEY (ma_tacgia) REFERENCES TacGia(ma_tacgia),
    FOREIGN KEY (ma_sach) REFERENCES Sach(ma_sach)
);

-- Chèn dữ liệu mẫu vào bảng TacGia
INSERT INTO TacGia (ma_tacgia, ten_tacgia) VALUES
(1, 'Nguyễn Nhật Ánh'),
(2, 'Ngô Tất Tố'),
(3, 'Trí Tuệ Việt'),
(4, 'Kim Dung'),
(5, 'Xuân Diệu');

-- Chèn dữ liệu mẫu vào bảng Sach
INSERT INTO Sach (ma_sach, ten_sach) VALUES
(101, 'Kính vạn hoa'),
(102, 'Tắt đèn'),
(103, 'Bí mật của may mắn'),
(104, 'Thủy hử'),
(105, 'Xuân Diệu - Tuyển tập thơ');

-- Chèn dữ liệu mẫu vào bảng TacGiaSach
INSERT INTO TacGiaSach (magiasach_id, ma_tacgia, ma_sach) VALUES
(1001, 1, 101),
(1002, 1, 102),
(1003, 2, 103),
(1004, 3, 104),
(1005, 5, 105);

-- e3
-- Bảng Nguoi
CREATE TABLE Nguoi (
    ma_nguoi INT PRIMARY KEY,
    ten_nguoi VARCHAR(255) NOT NULL
);

-- Bảng KhoaHoc
CREATE TABLE KhoaHoc (
    ma_khoahoc INT PRIMARY KEY,
    ten_khoahoc VARCHAR(255) NOT NULL
);

-- Bảng NguoiKhoaHoc đại diện cho mối quan hệ nhiều-nhiều
CREATE TABLE NguoiKhoaHoc (
    manguoikhoahoc_id INT PRIMARY KEY,
    ma_nguoi INT,
    ma_khoahoc INT,
    FOREIGN KEY (ma_nguoi) REFERENCES Nguoi(ma_nguoi),
    FOREIGN KEY (ma_khoahoc) REFERENCES KhoaHoc(ma_khoahoc)
);

-- Chèn dữ liệu mẫu vào bảng Nguoi
INSERT INTO Nguoi (ma_nguoi, ten_nguoi) VALUES
(1, 'Nguyễn Văn A'),
(2, 'Trần Thị B'),
(3, 'Lê Văn C'),
(4, 'Phạm Thị D'),
(5, 'Hoàng Văn E');

-- Chèn dữ liệu mẫu vào bảng KhoaHoc
INSERT INTO KhoaHoc (ma_khoahoc, ten_khoahoc) VALUES
(101, 'Lập trình C++'),
(102, 'Quản trị kinh doanh'),
(103, 'Ngoại ngữ'),
(104, 'Hóa học cơ bản'),
(105, 'Marketing online');

-- Chèn dữ liệu mẫu vào bảng NguoiKhoaHoc
INSERT INTO NguoiKhoaHoc (manguoikhoahoc_id, ma_nguoi, ma_khoahoc) VALUES
(1001, 1, 101),
(1002, 1, 102),
(1003, 2, 103),
(1004, 3, 104),
(1005, 4, 105);


