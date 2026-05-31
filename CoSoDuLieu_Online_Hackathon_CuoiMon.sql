CREATE DATABASE StudioManagement;
USE StudioManagement;

CREATE TABLE Creator (
    creator_id VARCHAR(5) PRIMARY KEY,
    creator_name VARCHAR(100) NOT NULL,
    creator_email VARCHAR(100) UNIQUE NOT NULL,
    creator_phone VARCHAR(15) UNIQUE NOT NULL,
    creator_platform VARCHAR(50) NOT NULL
);

CREATE TABLE Studio (
    studio_id VARCHAR(5) PRIMARY KEY,
    studio_name VARCHAR(100) NOT NULL,
    studio_location VARCHAR(100) NOT NULL,
    hourly_price DECIMAL(10,2) NOT NULL,
    studio_status VARCHAR(20) NOT NULL
);

CREATE TABLE LiveSession (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    creator_id VARCHAR(5),
    studio_id VARCHAR(5),
    session_date DATE NOT NULL,
    duration_hours INT NOT NULL,
    FOREIGN KEY (creator_id) REFERENCES Creator(creator_id),
    FOREIGN KEY (studio_id) REFERENCES Studio(studio_id)
);

CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT,
    payment_method VARCHAR(50) NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    FOREIGN KEY (session_id) REFERENCES LiveSession(session_id) ON DELETE CASCADE
);

INSERT INTO Creator (creator_id, creator_name, creator_email, creator_phone, creator_platform) 
VALUES ('CR01', 'Nguyen Van A', 'a@live.com', '0901111111', 'Tiktok'),
('CR02', 'Tran Thi B', 'b@live.com', '0902222222', 'Youtube'),
('CR03', 'Le Minh C', 'c@live.com', '0903333333', 'Facebook'),
('CR04', 'Pham Thi D', 'd@live.com', '0904444444', 'Tiktok'),
('CR05', 'Vu Hoang E', 'e@live.com', '0905555555', 'Shopee live');

INSERT INTO Studio (studio_id, studio_name, studio_location, hourly_price, studio_status) 
VALUES ('ST01', 'Studio A', 'Ha Noi', 20.00, 'Available'),
('ST02', 'Studio B', 'HCM', 25.00, 'Available'),
('ST03', 'Studio C', 'Danang', 30.00, 'Booked'),
('ST04', 'Studio D', 'Ha Noi', 22.00, 'Available'),
('ST05', 'Studio E', 'Can Tho', 18.00, 'Maintenance');

INSERT INTO LiveSession (session_id, creator_id, studio_id, session_date, duration_hours) 
VALUES (1, 'CR01', 'ST01', '2025-05-01', 3),
(2, 'CR02', 'ST02', '2025-05-02', 4),
(3, 'CR03', 'ST03', '2025-05-03', 2),
(4, 'CR01', 'ST04', '2025-05-04', 5),
(5, 'CR05', 'ST02', '2025-05-05', 1);

INSERT INTO Payment (payment_id, session_id, payment_method, payment_amount, payment_date) 
VALUES (1, 1, 'Cash', 60.00, '2025-05-01'),
(2, 2, 'Credit Card', 100.00, '2025-05-02'),
(3, 3, 'Bank Transfer', 60.00, '2025-05-03'),
(4, 4, 'Credit Card', 110.00, '2025-05-04'),
(5, 5, 'Cash', 25.00, '2025-05-05');

-- Cập nhật creator_platform của creator CR03 thành "YouTube"
UPDATE Creator 
SET creator_platform = 'YouTube' 
WHERE creator_id = 'CR03';

-- Do studio ST05 hoạt động trở lại, cập nhật studio_status = 'Available' và giảm hourly_price 10%
UPDATE Studio 
SET studio_status = 'Available', 
    hourly_price = hourly_price * 0.90 
WHERE studio_id = 'ST05';

-- Xóa các payment có payment_method = 'Cash' và payment_date trước ngày 2025-05-03
DELETE FROM Payment 
WHERE payment_method = 'Cash' 
  AND payment_date < '2025-05-03';

-- PHẦN 2: Truy vấn dữ liệu cơ bản
-- Liệt kê studio có studio_status = 'Available' và hourly_price > 20.
SELECT * FROM Studio 
WHERE studio_status = 'Available' 
  AND hourly_price > 20;

-- Lấy thông tin creator (creator_name, creator_phone) có nền tảng là TikTok.
SELECT creator_name, creator_phone 
FROM Creator 
WHERE LOWER(creator_platform) = 'tiktok';

-- Hiển thị danh sách studio gồm 
-- studio_id, 
-- studio_name, 
-- hourly_price 
-- sắp xếp theo giá thuê giảm dần.
SELECT studio_id, studio_name, hourly_price 
FROM Studio 
ORDER BY hourly_price DESC;

-- Lấy 3 payment đầu tiên có payment_method ='CreditCard'.
SELECT * FROM Payment 
WHERE payment_method = 'Credit Card' 
LIMIT 3;

-- Hiển thị danh sách creator gồm creator_id, creator_name 
-- bỏ qua 2 bảng ghi đầu và lấy 2 bảng ghi tiếp theo.
SELECT creator_id, creator_name 
FROM Creator 
LIMIT 2 OFFSET 2;

-- PHẦN 3: Truy vấn dữ liệu nâng cao
-- Hiển thị danh sách livestream gồm: 
-- session_id, 
-- creator_name, 
-- studio_name, 
-- duration_hours, 
-- payment_amount.
SELECT 
    ls.session_id, 
    c.creator_name, 
    s.studio_name, 
    ls.duration_hours, 
    p.payment_amount
FROM LiveSession ls
JOIN Creator c ON ls.creator_id = c.creator_id
JOIN Studio s ON ls.studio_id = s.studio_id
LEFT JOIN Payment p ON ls.session_id = p.session_id;

-- Liệt kê tất cả studio và số lần được sử dụng (kể cả studio chưa từng được thuê).
SELECT 
    s.studio_id, 
    s.studio_name, 
    COUNT(ls.session_id) AS total_sessions
FROM Studio s
LEFT JOIN LiveSession ls ON s.studio_id = ls.studio_id
GROUP BY s.studio_id, s.studio_name;

-- Tính tổng doanh thu theo từng payment_method.
SELECT 
    payment_method, 
    SUM(payment_amount) AS total_revenue
FROM Payment
GROUP BY payment_method;

-- Lấy studio có hourly_price cao hơn mức trung bình của tất cả studio.
SELECT * FROM Studio 
WHERE hourly_price > (SELECT AVG(hourly_price) FROM Studio);

