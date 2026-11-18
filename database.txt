CREATE DATABASE CHUDE14 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE CHUDE14;

CREATE TABLE NguoiDung (
    MaNguoiDung INT AUTO_INCREMENT PRIMARY KEY,
    TenDangNhap VARCHAR(50) NOT NULL UNIQUE,
    Email       VARCHAR(100) NOT NULL UNIQUE,
    MatKhau     VARCHAR(200) NOT NULL,
    NgayTao     DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE KiemDuyetVien (
    MaNguoiDung INT PRIMARY KEY,
    CapBac      VARCHAR(50) DEFAULT 'KiemDuyetVien',
    NgayBoNhiem DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_KDV_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE
);

CREATE TABLE HoSoCaNhan (
    MaNguoiDung INT PRIMARY KEY,
    TieuSu      TEXT,
    AnhDaiDien  VARCHAR(200),
    NgaySinh    DATE,
    CONSTRAINT FK_HoSo_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE
);

CREATE TABLE TheoDoi (
    MaNguoiDungFollow        INT NOT NULL,
    MaNguoiDungBeingFollowed INT NOT NULL,
    NgayTheoDoi              DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (MaNguoiDungFollow, MaNguoiDungBeingFollowed),
    CONSTRAINT FK_Follow_NguoiDung FOREIGN KEY (MaNguoiDungFollow) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    CONSTRAINT FK_Follow_BiFollow FOREIGN KEY (MaNguoiDungBeingFollowed) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    CONSTRAINT CHK_KhongTuFollow CHECK (MaNguoiDungFollow <> MaNguoiDungBeingFollowed)
);

CREATE TABLE Album (
    MaAlbum     INT AUTO_INCREMENT PRIMARY KEY,
    MaNguoiDung INT NOT NULL,
    TenAlbum    VARCHAR(50) NOT NULL,
    NgayTao     DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Album_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE
);

CREATE TABLE BaiViet (
    MaBaiViet   INT AUTO_INCREMENT PRIMARY KEY,
    MaNguoiDung INT NOT NULL,
    MaAlbum     INT NULL,                                              
    NoiDung     TEXT NOT NULL,
    TrangThai   VARCHAR(20) NOT NULL DEFAULT 'TamAn',  -- 'TamAn' (chờ duyệt / không hiển thị) | 'Hien' (công khai)
    NgayDang    DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT CHK_TrangThaiBaiViet CHECK (TrangThai IN ('Hien', 'TamAn')),
    CONSTRAINT FK_BaiViet_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    CONSTRAINT FK_BaiViet_Album FOREIGN KEY (MaAlbum) REFERENCES Album(MaAlbum) ON DELETE SET NULL
);

CREATE TABLE Media (
    MaMedia     INT AUTO_INCREMENT PRIMARY KEY,                                                                     
    MaBaiViet   INT NOT NULL,       
    LoaiMedia   VARCHAR(10) NOT NULL,   -- 'ANH' hoặc 'VIDEO'
    Url         VARCHAR(500) NOT NULL,
    CONSTRAINT FK_Media_BaiViet FOREIGN KEY (MaBaiViet) REFERENCES BaiViet(MaBaiViet) ON DELETE CASCADE,
    CONSTRAINT CHK_LoaiMedia    CHECK (LoaiMedia IN ('ANH', 'VIDEO'))
);


CREATE TABLE BinhLuan (
    MaBinhLuan    INT AUTO_INCREMENT PRIMARY KEY,
    MaBaiViet     INT NOT NULL,
    MaNguoiDung   INT NOT NULL,
    MaBinhLuanCha INT NULL,
    NoiDung       TEXT NOT NULL,
    NgayBinhLuan  DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Comment_BaiViet FOREIGN KEY (MaBaiViet) REFERENCES BaiViet(MaBaiViet) ON DELETE CASCADE,
    CONSTRAINT FK_Comment_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    CONSTRAINT UQ_BinhLuan_BaiViet UNIQUE (MaBinhLuan, MaBaiViet),
    -- Bình luận cha phải thuộc cùng bài viết với bình luận trả lời
    CONSTRAINT FK_Comment_Cha FOREIGN KEY (MaBinhLuanCha, MaBaiViet) REFERENCES BinhLuan(MaBinhLuan, MaBaiViet) ON DELETE CASCADE
);

CREATE TABLE TuongTac (
    MaTuongTac   INT AUTO_INCREMENT PRIMARY KEY,
    MaNguoiDung  INT NOT NULL,
    MaBaiViet    INT NOT NULL,
    LoaiTuongTac VARCHAR(20) NOT NULL DEFAULT 'LIKE',
    NgayTuongTac DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT CHK_LoaiTuongTac CHECK (LoaiTuongTac IN ('LIKE', 'LOVE', 'HAHA', 'WOW', 'SAD', 'ANGRY')),
    CONSTRAINT FK_TuongTac_User FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    CONSTRAINT FK_TuongTac_BaiViet FOREIGN KEY (MaBaiViet) REFERENCES BaiViet(MaBaiViet) ON DELETE CASCADE,
    CONSTRAINT UQ_User_BaiViet_TuongTac UNIQUE (MaNguoiDung, MaBaiViet)
);

CREATE TABLE ChiaSe (
    MaChiaSe    INT AUTO_INCREMENT PRIMARY KEY,
    MaNguoiDung INT NOT NULL,
    MaBaiViet   INT NOT NULL,
    NgayChiaSe  DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Chiase_User FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    CONSTRAINT FK_Chiase_BaiViet FOREIGN KEY (MaBaiViet) REFERENCES BaiViet(MaBaiViet) ON DELETE CASCADE,
    CONSTRAINT UQ_User_BaiViet_Chiase UNIQUE (MaNguoiDung, MaBaiViet)
);


CREATE TABLE Hashtag (
    MaHashtag  INT AUTO_INCREMENT PRIMARY KEY,
    TenHashtag VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE BaiViet_Hashtag (
    MaBaiViet INT NOT NULL,
    MaHashtag INT NOT NULL,
    PRIMARY KEY (MaBaiViet, MaHashtag),
    CONSTRAINT FK_BV_Hashtag_BV FOREIGN KEY (MaBaiViet) REFERENCES BaiViet(MaBaiViet) ON DELETE CASCADE,
    CONSTRAINT FK_BV_Hashtag_HT FOREIGN KEY (MaHashtag) REFERENCES Hashtag(MaHashtag) ON DELETE CASCADE
);

-- Mỗi lần kiểm duyệt viên xem xét một bài viết (dành cho KDV)
CREATE TABLE KiemDuyet (
    MaKiemDuyet     INT AUTO_INCREMENT PRIMARY KEY,
    MaBaiViet       INT NOT NULL,
    MaKiemDuyetVien INT NULL,
    KetQua          VARCHAR(20) NOT NULL,   -- 'ViPham' | 'KhongViPham'
    GhiChu          TEXT,
    NgayXuLy        DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT CHK_KetQuaKiemDuyet CHECK (KetQua IN ('ViPham', 'KhongViPham')),
    CONSTRAINT UQ_KiemDuyet_BaiViet UNIQUE (MaKiemDuyet, MaBaiViet),
    CONSTRAINT FK_KiemDuyet_BaiViet FOREIGN KEY (MaBaiViet) REFERENCES BaiViet(MaBaiViet) ON DELETE CASCADE,
    CONSTRAINT FK_KiemDuyet_KDV FOREIGN KEY (MaKiemDuyetVien) REFERENCES KiemDuyetVien(MaNguoiDung) ON DELETE SET NULL
);

-- Báo cáo vi phạm do người dùng gửi (dành cho toàn bộ user)
CREATE TABLE BaoCao (
    MaBaoCao           INT AUTO_INCREMENT PRIMARY KEY,
    MaBaiViet          INT NOT NULL,
    MaNguoiDungBaoCao  INT NOT NULL,
    MaKiemDuyet        INT NULL,   -- NULL = chưa được xử lý
    LyDo               TEXT,
    NgayBaoCao         DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_BaoCao_BaiViet FOREIGN KEY (MaBaiViet) REFERENCES BaiViet(MaBaiViet) ON DELETE CASCADE,
    CONSTRAINT FK_BaoCao_User FOREIGN KEY (MaNguoiDungBaoCao) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    -- Báo cáo chỉ được gắn vào lần kiểm duyệt của đúng bài viết đó
    CONSTRAINT FK_BaoCao_KiemDuyet FOREIGN KEY (MaKiemDuyet, MaBaiViet) REFERENCES KiemDuyet(MaKiemDuyet, MaBaiViet),
    CONSTRAINT UQ_User_BaoCao_BaiViet UNIQUE (MaBaiViet, MaNguoiDungBaoCao)
);


DELIMITER $$

-- Trigger 1: chỉ cho phép báo cáo bài đang hiển thị công khai
-- (bài đang chờ duyệt / đã bị kết luận vi phạm thì người dùng không thấy nên không được báo cáo)
CREATE TRIGGER TRG_ChanBaoCaoBaiKhongHien
BEFORE INSERT ON BaoCao
FOR EACH ROW
BEGIN
    IF (SELECT TrangThai FROM BaiViet WHERE MaBaiViet = NEW.MaBaiViet) <> 'Hien' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Chi duoc bao cao bai viet dang hien thi';
    END IF;
END$$

-- Trigger 2: bài đang hiển thị nhận từ 5 báo cáo CHƯA XỬ LÝ trở lên -> tạm ẩn chờ duyệt lại
CREATE TRIGGER TRG_TuDongTamAnBaiViet
AFTER INSERT ON BaoCao
FOR EACH ROW
BEGIN
    DECLARE SoLuongBaoCao INT;

    SELECT COUNT(*) INTO SoLuongBaoCao
    FROM BaoCao
    WHERE MaBaiViet = NEW.MaBaiViet
      AND MaKiemDuyet IS NULL;

    IF SoLuongBaoCao >= 5 THEN
        UPDATE BaiViet
        SET TrangThai = 'TamAn'
        WHERE MaBaiViet = NEW.MaBaiViet
          AND TrangThai = 'Hien';
    END IF;
END$$

-- Trigger 3: KDV ghi kết quả kiểm duyệt -> 'KhongViPham' thì công khai bài, 'ViPham' thì giữ tạm ẩn;
-- đồng thời đánh dấu các báo cáo đang chờ của bài đó là đã xử lý
CREATE TRIGGER TRG_XuLyKiemDuyet
AFTER INSERT ON KiemDuyet
FOR EACH ROW
BEGIN
    UPDATE BaiViet
    SET TrangThai = IF(NEW.KetQua = 'ViPham', 'TamAn', 'Hien')
    WHERE MaBaiViet = NEW.MaBaiViet;

    UPDATE BaoCao
    SET MaKiemDuyet = NEW.MaKiemDuyet
    WHERE MaBaiViet = NEW.MaBaiViet
      AND MaKiemDuyet IS NULL;
END$$

DELIMITER ;