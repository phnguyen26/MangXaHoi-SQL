USE CHUDE14;

SET NAMES utf8mb4;
SET SESSION cte_max_recursion_depth = 20000;

-- ---------------------------------------------------------------------
-- 1. NGƯỜI DÙNG
--    U001 = KOL_A (cho Q6), U013/U014 = kiểm duyệt viên
--    U011, U012 = người dùng không đăng bài (cho Q5)
-- ---------------------------------------------------------------------
INSERT INTO NguoiDung (MaNguoiDung, TenDangNhap, Email, MatKhau, NgayTao) VALUES
('U001', 'KOL_A',      'kol_a@example.com',      '$2b$10$dummyhashU001', '2026-11-03 08:00:00'),
('U002', 'KOL_B',      'kol_b@example.com',      '$2b$10$dummyhashU002', '2026-11-03 09:00:00'),
('U003', 'minh_tech',  'minh_tech@example.com',  '$2b$10$dummyhashU003', '2026-11-04 09:00:00'),
('U004', 'lan_anh',    'lan_anh@example.com',    '$2b$10$dummyhashU004', '2026-11-05 10:00:00'),
('U005', 'hung_dev',   'hung_dev@example.com',   '$2b$10$dummyhashU005', '2026-11-06 09:00:00'),
('U006', 'thu_ha',     'thu_ha@example.com',     '$2b$10$dummyhashU006', '2026-11-07 10:00:00'),
('U007', 'quang_vu',   'quang_vu@example.com',   '$2b$10$dummyhashU007', '2026-11-08 09:00:00'),
('U008', 'mai_linh',   'mai_linh@example.com',   '$2b$10$dummyhashU008', '2026-11-10 10:00:00'),
('U009', 'duc_anh',    'duc_anh@example.com',    '$2b$10$dummyhashU009', '2026-11-12 09:00:00'),
('U010', 'ngoc_bich',  'ngoc_bich@example.com',  '$2b$10$dummyhashU010', '2026-11-13 10:00:00'),
('U011', 'tuan_kiet',  'tuan_kiet@example.com',  '$2b$10$dummyhashU011', '2026-11-14 09:00:00'),
('U012', 'newbie_01',  'newbie_01@example.com',  '$2b$10$dummyhashU012', '2026-11-16 09:00:00'),
('U013', 'mod_hoa',    'mod_hoa@example.com',    '$2b$10$dummyhashU013', '2026-11-03 07:00:00'),
('U014', 'mod_nam',    'mod_nam@example.com',    '$2b$10$dummyhashU014', '2026-11-03 07:30:00'),
('U015', 'ptit',    'ptit@example.com',    '$2b$10$dummyhashU015', current_timestamp()),
('U016', 'fpt',    'fpt@example.com',    '$2b$10$dummyhashU016', current_timestamp());

-- 10.020 người dùng "fan" (F00001 .. F10020) để KOL_A có > 10.000 follower (Q4)
INSERT INTO NguoiDung (MaNguoiDung, TenDangNhap, Email, MatKhau, NgayTao)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 10020
)
SELECT CONCAT('F', LPAD(n, 5, '0')),
       CONCAT('fan_', LPAD(n, 5, '0')),
       CONCAT('fan_', LPAD(n, 5, '0'), '@example.com'),
       '$2b$10$dummyhashfan',
       '2026-11-04 08:00:00'
FROM seq;

-- ---------------------------------------------------------------------
-- 2. KIỂM DUYỆT VIÊN & HỒ SƠ CÁ NHÂN
-- ---------------------------------------------------------------------
INSERT INTO KiemDuyetVien (MaNguoiDung, CapBac, NgayBoNhiem) VALUES
('U013', 'KiemDuyetVien',       '2026-11-05 08:00:00'),
('U014', 'KiemDuyetVienCaoCap', '2026-11-05 08:30:00');

INSERT INTO HoSoCaNhan (MaNguoiDung, TieuSu, AnhDaiDien, NgaySinh) VALUES
('U001', 'KOL công nghệ & du lịch. Chia sẻ về AI.',  '/avatar/u001.jpg', '1992-03-15'),
('U002', 'Reviewer đồ công nghệ, ẩm thực.',          '/avatar/u002.jpg', '1994-07-21'),
('U003', 'Lập trình viên, yêu thích startup.',       '/avatar/u003.jpg', '1998-01-09'),
('U004', 'Thích du lịch và ẩm thực.',                '/avatar/u004.jpg', '1999-11-30'),
('U005', 'Backend developer.',                       '/avatar/u005.jpg', '1997-05-12'),
('U006', 'Sinh viên năm cuối.',                      '/avatar/u006.jpg', '2002-09-02'),
('U007', 'Đam mê game và phần cứng.',                '/avatar/u007.jpg', '2000-12-25'),
('U008', 'Chuyên review điện thoại.',                '/avatar/u008.jpg', '1996-04-18'),
('U009', 'Bán hàng online.',                         '/avatar/u009.jpg', '1995-08-08'),
('U010', 'Content creator.',                         '/avatar/u010.jpg', '2001-02-14'),
('U011', 'Chỉ thích xem, ít đăng.',                  NULL,               '1993-06-06'),
('U013', 'Kiểm duyệt viên cộng đồng.',               '/avatar/u013.jpg', '1990-10-10'),
('U014', 'Kiểm duyệt viên cấp cao.',                 '/avatar/u014.jpg', '1989-12-12');

-- ---------------------------------------------------------------------
-- 3. QUAN HỆ THEO DÕI (Follow)
--    Không có dòng nào tự follow chính mình (CHECK sẽ chặn)
-- ---------------------------------------------------------------------
INSERT INTO TheoDoi (MaNguoiDungFollow, MaNguoiDungBeingFollowed, NgayTheoDoi) VALUES
('U002', 'U001', '2026-11-04 08:00:00'),  -- U002 follow KOL_A ngay sau khi đăng ký
('U003', 'U001', '2026-11-05 09:00:00'),
('U004', 'U001', '2026-11-06 10:00:00'),
('U005', 'U001', '2026-11-07 11:00:00'),
('U006', 'U001', '2026-11-08 09:00:00'),
('U007', 'U001', '2026-11-09 10:00:00'),
('U008', 'U001', '2026-11-11 08:00:00'),
('U001', 'U002', '2026-11-04 10:00:00'),  -- KOL_A follow lại U002
('U003', 'U002', '2026-11-05 11:00:00'),
('U004', 'U002', '2026-11-06 12:00:00'),
('U001', 'U003', '2026-11-05 10:00:00'),
('U005', 'U003', '2026-11-07 09:00:00'),
('U003', 'U004', '2026-11-07 14:00:00'),
('U006', 'U004', '2026-11-08 15:00:00'),
('U009', 'U008', '2026-11-13 09:00:00'),
('U010', 'U008', '2026-11-14 10:00:00'),
('U011', 'U002', '2026-11-15 11:00:00');

-- Toàn bộ 10.020 fan follow KOL_A  => KOL_A có 10.027 follower (> 10.000)
INSERT INTO TheoDoi (MaNguoiDungFollow, MaNguoiDungBeingFollowed, NgayTheoDoi)
SELECT MaNguoiDung, 'U001', '2026-11-05 12:00:00'
FROM NguoiDung WHERE MaNguoiDung LIKE 'F%';

-- 10.010 fan đầu tiên follow KOL_B => KOL_B cũng > 10.000 follower
-- (nhưng KOL_B có tương tác cao nên sẽ bị loại ở Q4 -> chứng minh HAVING lọc đúng)
INSERT INTO TheoDoi (MaNguoiDungFollow, MaNguoiDungBeingFollowed, NgayTheoDoi)
SELECT MaNguoiDung, 'U002', '2026-11-06 13:00:00'
FROM NguoiDung WHERE MaNguoiDung BETWEEN 'F00001' AND 'F10010';

-- ---------------------------------------------------------------------
-- 4. ALBUM
-- ---------------------------------------------------------------------
INSERT INTO Album (MaAlbum, MaNguoiDung, TenAlbum, NgayTao) VALUES
('AL01', 'U001', 'Chuyến đi Đà Lạt',      '2026-11-08 09:00:00'),
('AL02', 'U004', 'Ẩm thực Hà Nội',        '2026-11-10 09:00:00'),
('AL03', 'U003', 'Góc làm việc của tôi',  '2026-11-12 09:00:00');

-- ---------------------------------------------------------------------
-- 5. BÀI VIẾT (mốc hiện tại = 2026-11-17 12:00:00)
--    Phân bố theo ngày (cho Q8):
--      17/11: BV101, BV201, BV505, BV606, BV707
--      16/11: BV102, BV202, BV301, BV401
--      15/11: BV103, BV507
--      14/11: BV402      13/11: BV506      07/11: BV001
--    Q1 (24h qua = từ 2026-11-16 12:00 đến 2026-11-17 12:00):
--      BV101, BV102, BV201, BV505 có #CongNghe
-- ---------------------------------------------------------------------
INSERT INTO BaiViet (MaBaiViet, MaNguoiDung, MaAlbum, NoiDung, TrangThai, NgayDang) VALUES
-- KOL_A
('BV101', 'U001', NULL,   'AI đang thay đổi cách chúng ta làm việc như thế nào? #CongNghe #AI', 'Hien', '2026-11-17 09:00:00'),
('BV102', 'U001', NULL,   '5 mẹo tăng năng suất cho dân văn phòng #NangSuat #CongNghe',       'Hien', '2026-11-16 16:00:00'),
('BV103', 'U001', 'AL01', 'Đà Lạt mùa này đẹp lắm mọi người ơi #DuLich',                     'Hien', '2026-11-15 10:00:00'),
-- KOL_B (tương tác rất cao)
('BV201', 'U002', NULL,   'Review laptop gaming mới nhất, màn hình cực đẹp #CongNghe #Review','Hien', '2026-11-17 07:00:00'),
('BV202', 'U002', NULL,   'Quán bún chả ngon nhất Hà Nội #AmThuc',                           'Hien', '2026-11-16 08:00:00'),
-- Người dùng thường
('BV001', 'U003', NULL,   'Bài viết cũ từ 10 ngày trước #CongNghe',                          'Hien', '2026-11-07 12:00:00'),
('BV301', 'U003', 'AL03', 'Startup công nghệ mới vừa gọi vốn thành công #CongNghe #Startup', 'Hien', '2026-11-16 06:00:00'),
('BV401', 'U004', NULL,   'Check-in Đà Lạt cuối tuần #DuLich',                              'Hien', '2026-11-16 10:00:00'),
('BV402', 'U004', 'AL02', 'Phở gà Nguyên Khải #AmThuc',                                      'Hien', '2026-11-14 09:00:00'),
('BV506', 'U005', NULL,   'Chia sẻ kinh nghiệm tối ưu truy vấn SQL #AI',                     'Hien', '2026-11-13 08:00:00'),
('BV507', 'U006', NULL,   'Tuần này đi biển cùng hội bạn #DuLich',                           'Hien', '2026-11-15 15:00:00'),
-- Bài sẽ bị báo cáo (kiểm thử trigger)
('BV505', 'U008', NULL,   'Review điện thoại mới ra mắt, giá cực tốt #CongNghe #Review',     'Hien', '2026-11-17 02:00:00'),
('BV606', 'U009', NULL,   'Mua hàng giá rẻ bất ngờ, inbox ngay! #Review',                    'Hien', '2026-11-17 06:00:00'),
('BV707', 'U010', NULL,   'Món ăn vặt hot trend #AmThuc',                                    'Hien', '2026-11-17 04:00:00');

-- ---------------------------------------------------------------------
-- 6. MEDIA (theo schema hiện tại: Media gắn với BaiViet)
-- ---------------------------------------------------------------------
INSERT INTO Media (MaBaiViet, LoaiMedia, Url) VALUES
('BV101', 'ANH',   '/media/bv101_1.jpg'),
('BV103', 'ANH',   '/media/bv103_1.jpg'),
('BV103', 'ANH',   '/media/bv103_2.jpg'),
('BV103', 'VIDEO', '/media/bv103_clip.mp4'),
('BV201', 'VIDEO', '/media/bv201_review.mp4'),
('BV301', 'ANH',   '/media/bv301_1.jpg'),
('BV402', 'ANH',   '/media/bv402_1.jpg'),
('BV505', 'ANH',   '/media/bv505_1.jpg');

-- ---------------------------------------------------------------------
-- 7. BÌNH LUẬN (đa cấp)
--    Cây bình luận BV101 (Q7):
--      1 (gốc) U002
--        |- 2 (cấp 1) U003
--        |    |- 3 (cấp 2) U004
--        |         |- 4 (cấp 3) U005
--        |- 7 (cấp 1) U001
--      5 (gốc) U006
--        |- 6 (cấp 1) U007
--      8 (gốc) U008
--    Cha luôn được insert trước con.
-- ---------------------------------------------------------------------
INSERT INTO BinhLuan (MaBinhLuan, MaBaiViet, MaNguoiDung, MaBinhLuanCha, NoiDung, NgayBinhLuan) VALUES
(1,  'BV101', 'U002', NULL, 'Bài viết hay quá, AI đang phát triển nhanh thật!',         '2026-11-17 10:00:00'),
(2,  'BV101', 'U003', 1,    'Đồng ý, nhất là các mô hình ngôn ngữ lớn.',               '2026-11-17 10:00:00'),
(3,  'BV101', 'U004', 2,    'Mình đang dùng thử cho công việc, tiết kiệm nhiều thời gian.', '2026-11-17 11:00:00'),
(4,  'BV101', 'U005', 3,    'Bạn dùng công cụ nào vậy?',                               '2026-11-17 11:00:00'),
(5,  'BV101', 'U006', NULL, 'Có lo ngại về việc mất việc làm không nhỉ?',              '2026-11-17 10:00:00'),
(6,  'BV101', 'U007', 5,    'Theo mình AI sẽ thay đổi chứ không thay thế hoàn toàn.',  '2026-11-17 11:00:00'),
(7,  'BV101', 'U001', 1,    'Cảm ơn bạn đã ủng hộ!',                                   '2026-11-17 11:00:00'),
(8,  'BV101', 'U008', NULL, 'Chờ phần 2 của anh.',                                     '2026-11-17 11:00:00'),
-- BV102
(9,  'BV102', 'U003', NULL, 'Mẹo số 3 rất hữu ích.',                                   '2026-11-16 18:00:00'),
(10, 'BV102', 'U004', 9,    'Mình cũng áp dụng, hiệu quả thật.',                       '2026-11-16 19:00:00'),
-- BV505 (Q2)
(11, 'BV505', 'U003', NULL, 'Giá bao nhiêu vậy bạn?',                                  '2026-11-17 03:00:00'),
(12, 'BV505', 'U004', NULL, 'Pin dùng được mấy tiếng?',                                '2026-11-17 03:00:00'),
(13, 'BV505', 'U008', 11,   'Mình mua khoảng 12 triệu.',                               '2026-11-17 04:00:00'),
(14, 'BV505', 'U005', NULL, 'Nghe giống quảng cáo quá.',                               '2026-11-17 04:00:00'),
(15, 'BV505', 'U006', NULL, 'Hàng chính hãng không bạn?',                              '2026-11-17 05:00:00'),
-- Các bài khác
(16, 'BV201', 'U003', NULL, 'Laptop này chơi game ổn không?',                          '2026-11-17 08:00:00'),
(17, 'BV201', 'U005', NULL, 'Màn hình đẹp, đáng tiền.',                                '2026-11-17 08:00:00'),
(18, 'BV301', 'U002', NULL, 'Startup này gọi vốn vòng mới rồi à?',                     '2026-11-16 08:00:00'),
(19, 'BV401', 'U001', NULL, 'Đà Lạt tháng này đẹp quá!',                               '2026-11-16 12:00:00'),
(20, 'BV606', 'U004', NULL, 'Link này có dấu hiệu lừa đảo.',                           '2026-11-17 07:00:00'),
(21, 'BV001', 'U004', NULL, 'Bài cũ nhưng vẫn hay.',                                   '2026-11-07 14:00:00'),
(22, 'BV202', 'U005', NULL, 'Quán này ở đâu vậy?',                                     '2026-11-16 16:00:00');

-- ---------------------------------------------------------------------
-- 8. TƯƠNG TÁC (Like/Reaction) - mỗi (người, bài) chỉ 1 dòng
-- ---------------------------------------------------------------------
INSERT INTO TuongTac (MaNguoiDung, MaBaiViet, LoaiTuongTac, NgayTuongTac) VALUES
-- BV101 (KOL_A)
('U002', 'BV101', 'LIKE',  '2026-11-17 10:00:00'),
('U003', 'BV101', 'LOVE',  '2026-11-17 10:00:00'),
('U004', 'BV101', 'LIKE',  '2026-11-17 11:00:00'),
('U005', 'BV101', 'WOW',   '2026-11-17 10:00:00'),
('U006', 'BV101', 'LIKE',  '2026-11-17 11:00:00'),
('U007', 'BV101', 'HAHA',  '2026-11-17 11:00:00'),
('U008', 'BV101', 'LIKE',  '2026-11-17 10:00:00'),
-- BV102, BV103 (KOL_A)
('U003', 'BV102', 'LIKE',  '2026-11-16 18:00:00'),
('U004', 'BV102', 'LIKE',  '2026-11-16 19:00:00'),
('U002', 'BV102', 'LOVE',  '2026-11-16 21:00:00'),
('U005', 'BV103', 'LIKE',  '2026-11-15 20:00:00'),
('U006', 'BV103', 'LIKE',  '2026-11-16 06:00:00'),
-- Bài người dùng khác
('U003', 'BV202', 'LIKE',  '2026-11-16 16:00:00'),
('U004', 'BV202', 'LIKE',  '2026-11-16 17:00:00'),
('U009', 'BV202', 'SAD',   '2026-11-16 18:00:00'),
('U002', 'BV301', 'LIKE',  '2026-11-16 08:00:00'),
('U001', 'BV301', 'LIKE',  '2026-11-16 09:00:00'),
('U005', 'BV301', 'LIKE',  '2026-11-16 11:00:00'),
('U003', 'BV401', 'LIKE',  '2026-11-16 12:00:00'),
('U008', 'BV401', 'LOVE',  '2026-11-16 16:00:00'),
('U001', 'BV402', 'LIKE',  '2026-11-14 14:00:00'),
('U001', 'BV506', 'LIKE',  '2026-11-13 18:00:00'),
('U007', 'BV507', 'LIKE',  '2026-11-15 20:00:00'),
('U001', 'BV505', 'LIKE',  '2026-11-17 03:00:00'),
('U002', 'BV505', 'LIKE',  '2026-11-17 03:00:00'),
('U003', 'BV606', 'ANGRY', '2026-11-17 07:00:00'),
('U010', 'BV606', 'LIKE',  '2026-11-17 08:00:00'),
('U011', 'BV707', 'LIKE',  '2026-11-17 10:00:00'),
-- Tương tác quá hạn 1 tuần (Q3 phải loại ra)
('U004', 'BV001', 'LIKE',  '2026-11-07 14:00:00');

-- 300 fan like BV201 và 300 fan like BV202 của KOL_B
INSERT INTO TuongTac (MaNguoiDung, MaBaiViet, LoaiTuongTac, NgayTuongTac)
SELECT MaNguoiDung, 'BV201', 'LIKE', '2026-11-17 09:00:00'
FROM NguoiDung WHERE MaNguoiDung BETWEEN 'F00001' AND 'F00300';

INSERT INTO TuongTac (MaNguoiDung, MaBaiViet, LoaiTuongTac, NgayTuongTac)
SELECT MaNguoiDung, 'BV202', 'LIKE', '2026-11-16 16:00:00'
FROM NguoiDung WHERE MaNguoiDung BETWEEN 'F00301' AND 'F00600';

-- ---------------------------------------------------------------------
-- 9. CHIA SẺ
--    (tên bảng đúng như script hiện tại: Chiase; nếu nhóm đổi thành ChiaSe thì sửa lại)
-- ---------------------------------------------------------------------
INSERT INTO Chiase (MaNguoiDung, MaBaiViet, NgayChiaSe) VALUES
('U003', 'BV101', '2026-11-17 10:00:00'),
('U004', 'BV101', '2026-11-17 11:00:00'),
('U007', 'BV102', '2026-11-16 21:00:00'),
('U005', 'BV201', '2026-11-17 09:00:00'),
('U006', 'BV201', '2026-11-17 10:00:00'),
('U002', 'BV505', '2026-11-17 04:00:00'),
('U009', 'BV202', '2026-11-16 18:00:00'),
('U008', 'BV401', '2026-11-16 17:00:00');

-- ---------------------------------------------------------------------
-- 10. HASHTAG
-- ---------------------------------------------------------------------
INSERT INTO Hashtag (MaHashtag, TenHashtag) VALUES
(1, 'CongNghe'),
(2, 'AI'),
(3, 'DuLich'),
(4, 'AmThuc'),
(5, 'Review'),
(6, 'NangSuat'),
(7, 'Startup');

INSERT INTO BaiViet_Hashtag (MaBaiViet, MaHashtag) VALUES
('BV101', 1), ('BV101', 2),
('BV102', 1), ('BV102', 6),
('BV103', 3),
('BV201', 1), ('BV201', 5),
('BV202', 4),
('BV001', 1),
('BV301', 1), ('BV301', 7),
('BV401', 3),
('BV402', 4),
('BV506', 2),
('BV507', 3),
('BV505', 1), ('BV505', 5),
('BV606', 5),
('BV707', 4);

-- ---------------------------------------------------------------------
-- 11. BÁO CÁO VI PHẠM  (trigger TRG_TuDongTamAnBaiViet chạy khi INSERT)
--
--  BV505: 6 người khác nhau báo cáo  -> trigger chuyển sang 'TamAn' (đúng đề: > 5)
--  BV606: đúng 5 báo cáo (kiểm thử biên)
--         + Trigger đã sửa (> 5)    : vẫn 'Hien'
--         + Trigger cũ  (>= 5)      : bị chuyển 'TamAn'
--  BV707: 2 báo cáo, 1 cái đã bị bác bỏ -> vẫn 'Hien'
--  BV402: 1 báo cáo đã xác nhận vi phạm (kiểm duyệt viên xử lý)
-- ---------------------------------------------------------------------
-- INSERT INTO KiemDuyetBaoCao (MaBaiViet, MaNguoiDungBaoCao, MaKiemDuyetVien, LyDo, TrangThaiXuLy, NgayBaoCao) VALUES
-- ('BV505', 'U003', NULL, 'Quảng cáo trá hình',          'ChoDuyet', '2026-11-17 03:00:00'),
-- ('BV505', 'U004', NULL, 'Spam',                         'ChoDuyet', '2026-11-17 04:00:00'),
-- ('BV505', 'U005', NULL, 'Thông tin sai sự thật',        'ChoDuyet', '2026-11-17 04:00:00'),
-- ('BV505', 'U006', NULL, 'Spam',                         'ChoDuyet', '2026-11-17 05:00:00'),
-- ('BV505', 'U007', NULL, 'Quảng cáo trá hình',          'ChoDuyet', '2026-11-17 06:00:00'),
-- ('BV505', 'U009', NULL, 'Nội dung gây hiểu lầm',        'ChoDuyet', '2026-11-17 07:00:00');

-- INSERT INTO KiemDuyetBaoCao (MaBaiViet, MaNguoiDungBaoCao, MaKiemDuyetVien, LyDo, TrangThaiXuLy, NgayBaoCao) VALUES
-- ('BV606', 'U003', NULL, 'Link lừa đảo',                 'ChoDuyet', '2026-11-17 07:00:00'),
-- ('BV606', 'U004', NULL, 'Lừa đảo',                      'ChoDuyet', '2026-11-17 07:00:00'),
-- ('BV606', 'U005', NULL, 'Spam',                         'ChoDuyet', '2026-11-17 08:00:00'),
-- ('BV606', 'U006', NULL, 'Spam',                         'ChoDuyet', '2026-11-17 08:00:00'),
-- ('BV606', 'U007', NULL, 'Quảng cáo',                    'ChoDuyet', '2026-11-17 09:00:00');

-- INSERT INTO KiemDuyetBaoCao (MaBaiViet, MaNguoiDungBaoCao, MaKiemDuyetVien, LyDo, TrangThaiXuLy, NgayBaoCao) VALUES
-- ('BV707', 'U003', 'U013', 'Hình ảnh phản cảm',          'TuChoi',   '2026-11-17 06:00:00'),
-- ('BV707', 'U004', NULL,   'Không phù hợp',              'ChoDuyet', '2026-11-17 07:00:00'),
-- ('BV402', 'U001', 'U014', 'Sai sự thật về địa điểm',    'ViPham',   '2026-11-15 00:00:00');

-- Bài đã bị kiểm duyệt viên xác nhận vi phạm -> ẩn hẳn
-- UPDATE BaiViet SET TrangThai = 'An' WHERE MaBaiViet = 'BV402';

-- =====================================================================
-- KIỂM TRA NHANH SAU KHI NẠP (chạy để xác nhận dữ liệu)
-- =====================================================================
