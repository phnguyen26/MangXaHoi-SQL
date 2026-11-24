USE CHUDE14;

SET NAMES utf8mb4;
SET SESSION cte_max_recursion_depth = 20000;

-- =====================================================================
-- QUY ƯỚC MÃ (kiểu chuỗi)
--   NguoiDung : U001..U016 (người dùng chính), F00001..F10020 (fan)
--   Album     : AL01..
--   BaiViet   : BV001, BV101.. (giữ tên cũ để query.md vẫn dùng được)
--   BinhLuan  : BL01..
--   Hashtag   : HT01..
--   KiemDuyet : KD01..
--   Media     : MD01..          ChiaSe : CS01..       BaoCao : BC01..
--   TuongTac  : TT0001..TT0029 (nhập tay), TT1001..TT1600 (fan F00001..F00600 like)
--   Mã số luôn đệm 0 cố định độ dài để so sánh BETWEEN theo chuỗi đúng thứ tự.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. NGƯỜI DÙNG
--    U001 = KOL_A, U002 = KOL_B, U013/U014 = kiểm duyệt viên
--    U011, U012 = người dùng không đăng bài
-- ---------------------------------------------------------------------
INSERT INTO NguoiDung (MaNguoiDung, TenDangNhap, Email, MatKhau, NgayTao) VALUES
('U001', 'KOL_A',      'kol_a@example.com',      '$2b$10$dummyhashU001', '2026-11-10 08:00:00'),
('U002', 'KOL_B',      'kol_b@example.com',      '$2b$10$dummyhashU002', '2026-11-10 09:00:00'),
('U003', 'minh_tech',  'minh_tech@example.com',  '$2b$10$dummyhashU003', '2026-11-11 09:00:00'),
('U004', 'lan_anh',    'lan_anh@example.com',    '$2b$10$dummyhashU004', '2026-11-12 10:00:00'),
('U005', 'hung_dev',   'hung_dev@example.com',   '$2b$10$dummyhashU005', '2026-11-13 09:00:00'),
('U006', 'thu_ha',     'thu_ha@example.com',     '$2b$10$dummyhashU006', '2026-11-14 10:00:00'),
('U007', 'quang_vu',   'quang_vu@example.com',   '$2b$10$dummyhashU007', '2026-11-15 09:00:00'),
('U008', 'mai_linh',   'mai_linh@example.com',   '$2b$10$dummyhashU008', '2026-11-17 10:00:00'),
('U009', 'duc_anh',    'duc_anh@example.com',    '$2b$10$dummyhashU009', '2026-11-19 09:00:00'),
('U010', 'ngoc_bich',  'ngoc_bich@example.com',  '$2b$10$dummyhashU010', '2026-11-20 10:00:00'),
('U011', 'tuan_kiet',  'tuan_kiet@example.com',  '$2b$10$dummyhashU011', '2026-11-21 09:00:00'),
('U012', 'newbie_01',  'newbie_01@example.com',  '$2b$10$dummyhashU012', '2026-11-23 09:00:00'),
('U013', 'mod_hoa',    'mod_hoa@example.com',    '$2b$10$dummyhashU013', '2026-11-10 07:00:00'),
('U014', 'mod_nam',    'mod_nam@example.com',    '$2b$10$dummyhashU014', '2026-11-10 07:30:00'),
('U015', 'ptit',       'ptit@example.com',       '$2b$10$dummyhashU015', CURRENT_TIMESTAMP),
('U016', 'fpt',        'fpt@example.com',        '$2b$10$dummyhashU016', CURRENT_TIMESTAMP);

-- 10.020 người dùng "fan" (F00001 .. F10020) để KOL_A có > 10.000 follower
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
       '2026-11-11 08:00:00'
FROM seq;

-- ---------------------------------------------------------------------
-- 2. KIỂM DUYỆT VIÊN & HỒ SƠ CÁ NHÂN
-- ---------------------------------------------------------------------
INSERT INTO KiemDuyetVien (MaNguoiDung, CapBac, NgayBoNhiem) VALUES
('U013', 'KiemDuyetVien',       '2026-11-12 08:00:00'),
('U014', 'KiemDuyetVienCaoCap', '2026-11-12 08:30:00');

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
('U002', 'U001', '2026-11-11 08:00:00'),  -- U002 follow KOL_A ngay sau khi đăng ký
('U003', 'U001', '2026-11-12 09:00:00'),
('U004', 'U001', '2026-11-13 10:00:00'),
('U005', 'U001', '2026-11-14 11:00:00'),
('U006', 'U001', '2026-11-15 09:00:00'),
('U007', 'U001', '2026-11-16 10:00:00'),
('U008', 'U001', '2026-11-18 08:00:00'),
('U001', 'U002', '2026-11-11 10:00:00'),  -- KOL_A follow lại U002
('U003', 'U002', '2026-11-12 11:00:00'),
('U004', 'U002', '2026-11-13 12:00:00'),
('U001', 'U003', '2026-11-12 10:00:00'),
('U005', 'U003', '2026-11-14 09:00:00'),
('U003', 'U004', '2026-11-14 14:00:00'),
('U006', 'U004', '2026-11-15 15:00:00'),
('U009', 'U008', '2026-11-20 09:00:00'),
('U010', 'U008', '2026-11-21 10:00:00'),
('U011', 'U002', '2026-11-22 11:00:00');

-- Toàn bộ 10.020 fan (F00001..F10020) follow KOL_A => KOL_A có 10.027 follower
INSERT INTO TheoDoi (MaNguoiDungFollow, MaNguoiDungBeingFollowed, NgayTheoDoi)
SELECT MaNguoiDung, 'U001', '2026-11-12 12:00:00'
FROM NguoiDung
WHERE MaNguoiDung BETWEEN 'F00001' AND 'F10020';

-- 10.010 fan đầu tiên (F00001..F10010) follow KOL_B => KOL_B có 10.013 follower
INSERT INTO TheoDoi (MaNguoiDungFollow, MaNguoiDungBeingFollowed, NgayTheoDoi)
SELECT MaNguoiDung, 'U002', '2026-11-13 13:00:00'
FROM NguoiDung
WHERE MaNguoiDung BETWEEN 'F00001' AND 'F10010';

-- ---------------------------------------------------------------------
-- 4. ALBUM
-- ---------------------------------------------------------------------
INSERT INTO Album (MaAlbum, MaNguoiDung, TenAlbum, NgayTao) VALUES
('AL01', 'U001', 'Chuyến đi Đà Lạt',      '2026-11-15 09:00:00'),
('AL02', 'U004', 'Ẩm thực Hà Nội',        '2026-11-17 09:00:00'),
('AL03', 'U003', 'Góc làm việc của tôi',  '2026-11-19 09:00:00');

-- ---------------------------------------------------------------------
-- 5. BÀI VIẾT (mốc hiện tại = 2026-11-24 12:00:00)
--    TrangThai chỉ nhận 'Hien' | 'TamAn'. Tất cả đều nạp là 'Hien';
--    trạng thái 'TamAn' sẽ do trigger đặt khi nạp BaoCao/KiemDuyet ở mục 11-12.
-- ---------------------------------------------------------------------
INSERT INTO BaiViet (MaBaiViet, MaNguoiDung, MaAlbum, NoiDung, TrangThai, NgayDang) VALUES
-- Bài viết cũ
('BV001', 'U003', NULL,   'Bài viết cũ từ 10 ngày trước #CongNghe',                           'Hien', '2026-11-14 12:00:00'),
-- KOL_A
('BV101', 'U001', NULL,   'AI đang thay đổi cách chúng ta làm việc như thế nào? #CongNghe #AI', 'Hien', '2026-11-24 09:00:00'),
('BV102', 'U001', NULL,   '5 mẹo tăng năng suất cho dân văn phòng #NangSuat #CongNghe',        'Hien', '2026-11-23 16:00:00'),
('BV103', 'U001', 'AL01', 'Đà Lạt mùa này đẹp lắm mọi người ơi #DuLich',                      'Hien', '2026-11-22 10:00:00'),
-- KOL_B
('BV201', 'U002', NULL,   'Review laptop gaming mới nhất, màn hình cực đẹp #CongNghe #Review', 'Hien', '2026-11-24 07:00:00'),
('BV202', 'U002', NULL,   'Quán bún chả ngon nhất Hà Nội #AmThuc',                            'Hien', '2026-11-23 08:00:00'),
-- Người dùng thường
('BV301', 'U003', 'AL03', 'Startup công nghệ mới vừa gọi vốn thành công #CongNghe #Startup',  'Hien', '2026-11-23 06:00:00'),
('BV401', 'U004', NULL,   'Check-in Đà Lạt cuối tuần #DuLich',                                'Hien', '2026-11-23 10:00:00'),
('BV402', 'U004', 'AL02', 'Phở gà Nguyên Khải #AmThuc',                                       'Hien', '2026-11-21 09:00:00'),
('BV506', 'U005', NULL,   'Chia sẻ kinh nghiệm tối ưu truy vấn SQL #AI',                      'Hien', '2026-11-20 08:00:00'),
('BV507', 'U006', NULL,   'Tuần này đi biển cùng hội bạn #DuLich',                            'Hien', '2026-11-22 15:00:00'),
-- Bài sẽ bị báo cáo (kiểm thử trigger)
('BV505', 'U008', NULL,   'Review điện thoại mới ra mắt, giá cực tốt #CongNghe #Review',      'Hien', '2026-11-24 02:00:00'),
('BV606', 'U009', NULL,   'Mua hàng giá rẻ bất ngờ, inbox ngay! #Review',                     'Hien', '2026-11-24 06:00:00'),
('BV707', 'U010', NULL,   'Món ăn vặt hot trend #AmThuc',                                     'Hien', '2026-11-24 04:00:00');

-- ---------------------------------------------------------------------
-- 6. MEDIA (gắn với BaiViet)
-- ---------------------------------------------------------------------
INSERT INTO Media (MaMedia, MaBaiViet, LoaiMedia, Url) VALUES
('MD01', 'BV101', 'ANH',   '/media/bv101_1.jpg'),
('MD02', 'BV103', 'ANH',   '/media/bv103_1.jpg'),
('MD03', 'BV103', 'ANH',   '/media/bv103_2.jpg'),
('MD04', 'BV103', 'VIDEO', '/media/bv103_clip.mp4'),
('MD05', 'BV201', 'VIDEO', '/media/bv201_review.mp4'),
('MD06', 'BV301', 'ANH',   '/media/bv301_1.jpg'),
('MD07', 'BV402', 'ANH',   '/media/bv402_1.jpg'),
('MD08', 'BV505', 'ANH',   '/media/bv505_1.jpg');

-- ---------------------------------------------------------------------
-- 7. BÌNH LUẬN (đa cấp)
--    Cây bình luận bài BV101:
--      BL01 (gốc) U002
--        |- BL02 (cấp 1) U003
--        |    |- BL03 (cấp 2) U004
--        |         |- BL04 (cấp 3) U005
--        |- BL07 (cấp 1) U001
--      BL05 (gốc) U006
--        |- BL06 (cấp 1) U007
--      BL08 (gốc) U008
--    Cha luôn được insert trước con và luôn cùng bài viết với con
--    (FK_Comment_Cha là khóa ngoại kép MaBinhLuanCha + MaBaiViet).
-- ---------------------------------------------------------------------
INSERT INTO BinhLuan (MaBinhLuan, MaBaiViet, MaNguoiDung, MaBinhLuanCha, NoiDung, NgayBinhLuan) VALUES
('BL01', 'BV101', 'U002', NULL,   'Bài viết hay quá, AI đang phát triển nhanh thật!',                  '2026-11-24 10:00:00'),
('BL02', 'BV101', 'U003', 'BL01', 'Đồng ý, nhất là các mô hình ngôn ngữ lớn.',                          '2026-11-24 10:00:00'),
('BL03', 'BV101', 'U004', 'BL02', 'Mình đang dùng thử cho công việc, tiết kiệm nhiều thời gian.',       '2026-11-24 11:00:00'),
('BL04', 'BV101', 'U005', 'BL03', 'Bạn dùng công cụ nào vậy?',                                          '2026-11-24 11:00:00'),
('BL05', 'BV101', 'U006', NULL,   'Có lo ngại về việc mất việc làm không nhỉ?',                         '2026-11-24 10:00:00'),
('BL06', 'BV101', 'U007', 'BL05', 'Theo mình AI sẽ thay đổi chứ không thay thế hoàn toàn.',             '2026-11-24 11:00:00'),
('BL07', 'BV101', 'U001', 'BL01', 'Cảm ơn bạn đã ủng hộ!',                                              '2026-11-24 11:00:00'),
('BL08', 'BV101', 'U008', NULL,   'Chờ phần 2 của anh.',                                                '2026-11-24 11:00:00'),
-- Bài BV102
('BL09', 'BV102', 'U003', NULL,   'Mẹo số 3 rất hữu ích.',                                              '2026-11-23 18:00:00'),
('BL10', 'BV102', 'U004', 'BL09', 'Mình cũng áp dụng, hiệu quả thật.',                                  '2026-11-23 19:00:00'),
-- Bài BV505
('BL11', 'BV505', 'U003', NULL,   'Giá bao nhiêu vậy bạn?',                                             '2026-11-24 03:00:00'),
('BL12', 'BV505', 'U004', NULL,   'Pin dùng được mấy tiếng?',                                           '2026-11-24 03:00:00'),
('BL13', 'BV505', 'U008', 'BL11', 'Mình mua khoảng 12 triệu.',                                          '2026-11-24 04:00:00'),
('BL14', 'BV505', 'U005', NULL,   'Nghe giống quảng cáo quá.',                                          '2026-11-24 04:00:00'),
('BL15', 'BV505', 'U006', NULL,   'Hàng chính hãng không bạn?',                                         '2026-11-24 05:00:00'),
-- Các bài khác
('BL16', 'BV201', 'U003', NULL,   'Laptop này chơi game ổn không?',                                     '2026-11-24 08:00:00'),
('BL17', 'BV201', 'U005', NULL,   'Màn hình đẹp, đáng tiền.',                                           '2026-11-24 08:00:00'),
('BL18', 'BV301', 'U002', NULL,   'Startup này gọi vốn vòng mới rồi à?',                                '2026-11-23 08:00:00'),
('BL19', 'BV401', 'U001', NULL,   'Đà Lạt tháng này đẹp quá!',                                          '2026-11-23 12:00:00'),
('BL20', 'BV606', 'U004', NULL,   'Link này có dấu hiệu lừa đảo.',                                      '2026-11-24 07:00:00'),
('BL21', 'BV001', 'U004', NULL,   'Bài cũ nhưng vẫn hay.',                                              '2026-11-14 14:00:00'),
('BL22', 'BV202', 'U005', NULL,   'Quán này ở đâu vậy?',                                                '2026-11-23 16:00:00');

-- ---------------------------------------------------------------------
-- 8. TƯƠNG TÁC (Like/Reaction) - mỗi (người, bài) chỉ 1 dòng
-- ---------------------------------------------------------------------
INSERT INTO TuongTac (MaTuongTac, MaNguoiDung, MaBaiViet, LoaiTuongTac, NgayTuongTac) VALUES
-- BV101 (KOL_A)
('TT0001', 'U002', 'BV101', 'LIKE',  '2026-11-24 10:00:00'),
('TT0002', 'U003', 'BV101', 'LOVE',  '2026-11-24 10:00:00'),
('TT0003', 'U004', 'BV101', 'LIKE',  '2026-11-24 11:00:00'),
('TT0004', 'U005', 'BV101', 'WOW',   '2026-11-24 10:00:00'),
('TT0005', 'U006', 'BV101', 'LIKE',  '2026-11-24 11:00:00'),
('TT0006', 'U007', 'BV101', 'HAHA',  '2026-11-24 11:00:00'),
('TT0007', 'U008', 'BV101', 'LIKE',  '2026-11-24 10:00:00'),
-- BV102, BV103 (KOL_A)
('TT0008', 'U003', 'BV102', 'LIKE',  '2026-11-23 18:00:00'),
('TT0009', 'U004', 'BV102', 'LIKE',  '2026-11-23 19:00:00'),
('TT0010', 'U002', 'BV102', 'LOVE',  '2026-11-23 21:00:00'),
('TT0011', 'U005', 'BV103', 'LIKE',  '2026-11-22 20:00:00'),
('TT0012', 'U006', 'BV103', 'LIKE',  '2026-11-23 06:00:00'),
-- Bài người dùng khác
('TT0013', 'U003', 'BV202', 'LIKE',  '2026-11-23 16:00:00'),
('TT0014', 'U004', 'BV202', 'LIKE',  '2026-11-23 17:00:00'),
('TT0015', 'U009', 'BV202', 'SAD',   '2026-11-23 18:00:00'),
('TT0016', 'U002', 'BV301', 'LIKE',  '2026-11-23 08:00:00'),
('TT0017', 'U001', 'BV301', 'LIKE',  '2026-11-23 09:00:00'),
('TT0018', 'U005', 'BV301', 'LIKE',  '2026-11-23 11:00:00'),
('TT0019', 'U003', 'BV401', 'LIKE',  '2026-11-23 12:00:00'),
('TT0020', 'U008', 'BV401', 'LOVE',  '2026-11-23 16:00:00'),
('TT0021', 'U001', 'BV402', 'LIKE',  '2026-11-21 14:00:00'),
('TT0022', 'U001', 'BV506', 'LIKE',  '2026-11-20 18:00:00'),
('TT0023', 'U007', 'BV507', 'LIKE',  '2026-11-22 20:00:00'),
('TT0024', 'U001', 'BV505', 'LIKE',  '2026-11-24 03:00:00'),
('TT0025', 'U002', 'BV505', 'LIKE',  '2026-11-24 03:00:00'),
('TT0026', 'U003', 'BV606', 'ANGRY', '2026-11-24 07:00:00'),
('TT0027', 'U010', 'BV606', 'LIKE',  '2026-11-24 08:00:00'),
('TT0028', 'U011', 'BV707', 'LIKE',  '2026-11-24 10:00:00'),
-- Tương tác quá hạn 1 tuần (Q3 phải loại ra)
('TT0029', 'U004', 'BV001', 'LIKE',  '2026-11-14 14:00:00');

-- 300 fan (F00001..F00300) like BV201 và 300 fan (F00301..F00600) like BV202 của KOL_B
-- MaTuongTac = 'TT' + (1000 + số thứ tự fan)  =>  TT1001..TT1300 và TT1301..TT1600
INSERT INTO TuongTac (MaTuongTac, MaNguoiDung, MaBaiViet, LoaiTuongTac, NgayTuongTac)
SELECT CONCAT('TT', 1000 + CAST(SUBSTRING(MaNguoiDung, 2) AS UNSIGNED)), MaNguoiDung, 'BV201', 'LIKE', '2026-11-24 09:00:00'
FROM NguoiDung
WHERE MaNguoiDung BETWEEN 'F00001' AND 'F00300';

INSERT INTO TuongTac (MaTuongTac, MaNguoiDung, MaBaiViet, LoaiTuongTac, NgayTuongTac)
SELECT CONCAT('TT', 1000 + CAST(SUBSTRING(MaNguoiDung, 2) AS UNSIGNED)), MaNguoiDung, 'BV202', 'LIKE', '2026-11-23 16:00:00'
FROM NguoiDung
WHERE MaNguoiDung BETWEEN 'F00301' AND 'F00600';

-- ---------------------------------------------------------------------
-- 9. CHIA SẺ  (bảng ChiaSe)
-- ---------------------------------------------------------------------
INSERT INTO ChiaSe (MaChiaSe, MaNguoiDung, MaBaiViet, NgayChiaSe) VALUES
('CS01', 'U003', 'BV101', '2026-11-24 10:00:00'),
('CS02', 'U004', 'BV101', '2026-11-24 11:00:00'),
('CS03', 'U007', 'BV102', '2026-11-23 21:00:00'),
('CS04', 'U005', 'BV201', '2026-11-24 09:00:00'),
('CS05', 'U006', 'BV201', '2026-11-24 10:00:00'),
('CS06', 'U002', 'BV505', '2026-11-24 04:00:00'),
('CS07', 'U009', 'BV202', '2026-11-23 18:00:00'),
('CS08', 'U008', 'BV401', '2026-11-23 17:00:00');

-- ---------------------------------------------------------------------
-- 10. HASHTAG
-- ---------------------------------------------------------------------
INSERT INTO Hashtag (MaHashtag, TenHashtag) VALUES
('HT01', 'CongNghe'),
('HT02', 'AI'),
('HT03', 'DuLich'),
('HT04', 'AmThuc'),
('HT05', 'Review'),
('HT06', 'NangSuat'),
('HT07', 'Startup');

INSERT INTO BaiViet_Hashtag (MaBaiViet, MaHashtag) VALUES
('BV101', 'HT01'), ('BV101', 'HT02'),
('BV102', 'HT01'), ('BV102', 'HT06'),
('BV103', 'HT03'),
('BV201', 'HT01'), ('BV201', 'HT05'),
('BV202', 'HT04'),
('BV001', 'HT01'),
('BV301', 'HT01'), ('BV301', 'HT07'),
('BV401', 'HT03'),
('BV402', 'HT04'),
('BV506', 'HT02'),
('BV507', 'HT03'),
('BV505', 'HT01'), ('BV505', 'HT05'),
('BV606', 'HT05'),
('BV707', 'HT04');

-- ---------------------------------------------------------------------
-- 11. BÁO CÁO VI PHẠM (bảng BaoCao, người dùng gửi)
--
--  Trigger TRG_ChanBaoCaoBaiKhongHien : chỉ báo cáo được bài đang 'Hien'
--  Trigger TRG_TuDongTamAnBaiViet     : >= 5 báo cáo CHƯA XỬ LÝ -> bài thành 'TamAn'
--
--  BV505: đúng 5 báo cáo -> trigger chuyển sang 'TamAn'.
--         (Không thể có báo cáo thứ 6 vì bài đã bị ẩn, trigger 1 sẽ chặn.)
--  BV606: 4 báo cáo (sát ngưỡng) -> vẫn 'Hien'.
--  BV707: 1 báo cáo đã được KDV xử lý (không vi phạm) + 1 báo cáo mới -> vẫn 'Hien'.
--  BV402: 1 báo cáo, KDV kết luận vi phạm -> 'TamAn' (xem mục 12).
-- ---------------------------------------------------------------------
INSERT INTO BaoCao (MaBaoCao, MaBaiViet, MaNguoiDungBaoCao, LyDo, NgayBaoCao) VALUES
('BC01', 'BV505', 'U003', 'Quảng cáo trá hình',          '2026-11-24 03:00:00'),
('BC02', 'BV505', 'U004', 'Spam',                         '2026-11-24 04:00:00'),
('BC03', 'BV505', 'U005', 'Thông tin sai sự thật',        '2026-11-24 04:00:00'),
('BC04', 'BV505', 'U006', 'Spam',                         '2026-11-24 05:00:00'),
('BC05', 'BV505', 'U007', 'Quảng cáo trá hình',          '2026-11-24 06:00:00');   -- báo cáo thứ 5 -> BV505 thành TamAn

INSERT INTO BaoCao (MaBaoCao, MaBaiViet, MaNguoiDungBaoCao, LyDo, NgayBaoCao) VALUES
('BC06', 'BV606', 'U003', 'Link lừa đảo',                 '2026-11-24 07:00:00'),
('BC07', 'BV606', 'U004', 'Lừa đảo',                      '2026-11-24 07:00:00'),
('BC08', 'BV606', 'U005', 'Spam',                         '2026-11-24 08:00:00'),
('BC09', 'BV606', 'U006', 'Spam',                         '2026-11-24 08:00:00');

-- BV402: báo cáo trước, kiểm duyệt sau (mục 12)
INSERT INTO BaoCao (MaBaoCao, MaBaiViet, MaNguoiDungBaoCao, LyDo, NgayBaoCao) VALUES
('BC10', 'BV402', 'U001', 'Sai sự thật về địa điểm',      '2026-11-22 00:00:00');

-- BV707: báo cáo đầu tiên
INSERT INTO BaoCao (MaBaoCao, MaBaiViet, MaNguoiDungBaoCao, LyDo, NgayBaoCao) VALUES
('BC11', 'BV707', 'U003', 'Hình ảnh phản cảm',            '2026-11-24 06:00:00');

-- ---------------------------------------------------------------------
-- 12. KIỂM DUYỆT (bảng KiemDuyet, do kiểm duyệt viên ghi)
--     Trigger TRG_XuLyKiemDuyet tự động:
--       * KhongViPham -> BaiViet.TrangThai = 'Hien'
--       * ViPham      -> BaiViet.TrangThai = 'TamAn'
--       * gán MaKiemDuyet cho các BaoCao đang chờ của bài đó
-- ---------------------------------------------------------------------
INSERT INTO KiemDuyet (MaKiemDuyet, MaBaiViet, MaKiemDuyetVien, KetQua, GhiChu, NgayXuLy) VALUES
('KD01', 'BV707', 'U013', 'KhongViPham', 'Hình ảnh phù hợp, bác bỏ báo cáo.',        '2026-11-24 06:30:00'),
('KD02', 'BV402', 'U014', 'ViPham',      'Thông tin địa điểm sai sự thật, ẩn bài.',  '2026-11-22 08:00:00');

-- Báo cáo mới của BV707 sau khi đã kiểm duyệt (vẫn đang chờ, MaKiemDuyet = NULL)
INSERT INTO BaoCao (MaBaoCao, MaBaiViet, MaNguoiDungBaoCao, LyDo, NgayBaoCao) VALUES
('BC12', 'BV707', 'U004', 'Không phù hợp',                '2026-11-24 07:00:00');

-- =====================================================================
-- KIỂM TRA NHANH SAU KHI NẠP (bỏ comment để chạy)
-- =====================================================================
-- Trạng thái bài viết sau khi chạy trigger (kỳ vọng: BV505 và BV402 = 'TamAn', còn lại 'Hien'):
-- SELECT MaBaiViet, TrangThai FROM BaiViet ORDER BY MaBaiViet;
--
-- Báo cáo đã/chưa xử lý (kỳ vọng: BV402 và BV707 có 1 báo cáo đã xử lý; BV707 còn 1 chờ):
-- SELECT MaBaiViet, COUNT(*) AS TongBaoCao, SUM(MaKiemDuyet IS NULL) AS ChuaXuLy
-- FROM BaoCao GROUP BY MaBaiViet;
--
-- Follower của KOL_A / KOL_B (kỳ vọng: 10027 / 10013):
-- SELECT MaNguoiDungBeingFollowed, COUNT(*) FROM TheoDoi
-- WHERE MaNguoiDungBeingFollowed IN ('U001', 'U002') GROUP BY MaNguoiDungBeingFollowed;
