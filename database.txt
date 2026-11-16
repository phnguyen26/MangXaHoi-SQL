-- Tạo và sử dụng database
CREATE DATABASE chude14 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE chude14;

-- 1. Bảng Người dùng
CREATE TABLE NguoiDung (
    MaNguoiDung VARCHAR(50) PRIMARY KEY,
    TenDangNhap VARCHAR(50) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL UNIQUE,
    MatKhau VARCHAR(255) NOT NULL,
    NgayTao DATE
);

-- 2. Bảng Hồ sơ cá nhân (Quan hệ 1-1 với NguoiDung)
CREATE TABLE HoSoCaNhan (
    MaNguoiDung VARCHAR(50) PRIMARY KEY,
    TieuSu TEXT,
    AnhDaiDien VARCHAR(255),
    NgaySinh DATE,
    CONSTRAINT FK_HoSo_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE
);

-- 3. Bảng Theo dõi (Quan hệ N-N đệ quy, có CHECK không tự follow chính mình)
CREATE TABLE TheoDoi (
    MaNguoiDungFollow VARCHAR(50) NOT NULL,
    MaNguoiDungBeingFollowed VARCHAR(50) NOT NULL,
    NgayTheoDoi DATE,
    PRIMARY KEY (MaNguoiDungFollow, MaNguoiDungBeingFollowed),
    CONSTRAINT FK_Follow_NguoiDung FOREIGN KEY (MaNguoiDungFollow) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    CONSTRAINT FK_Follow_BiFollow FOREIGN KEY (MaNguoiDungBeingFollowed) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    CONSTRAINT CHK_KhongTuFollow CHECK (MaNguoiDungFollow <> MaNguoiDungBeingFollowed)
);

-- 4. Bảng Album
CREATE TABLE Album (
    AlbumUrl VARCHAR(50) PRIMARY KEY,
    MaNguoiDung VARCHAR(50) NOT NULL,
    TenAlbum VARCHAR(150) NOT NULL,
    NgayTao DATE,
    CONSTRAINT FK_Album_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE
);

-- 5. Bảng Bài viết
CREATE TABLE BaiViet (
    MaBaiViet VARCHAR(50) PRIMARY KEY,
    MaNguoiDung VARCHAR(50) NOT NULL,
    AlbumUrl VARCHAR(50) NULL,
    NoiDung TEXT NOT NULL,
    TrangThai VARCHAR(20) DEFAULT 'Hien', -- Sẽ tự động chuyển thành 'TamAn' khi đủ 5 báo cáo[cite: 16]
    NgayDang DATE,
    CONSTRAINT FK_BaiViet_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    CONSTRAINT FK_BaiViet_Album FOREIGN KEY (AlbumUrl) REFERENCES Album(AlbumUrl) ON DELETE SET NULL
);

-- 6. Bảng Bình luận đa cấp (Parent-Child Comment)
CREATE TABLE BinhLuan (
    MaBinhLuan INT PRIMARY KEY AUTO_INCREMENT,
    MaBaiViet VARCHAR(50) NOT NULL,
    MaNguoiDung VARCHAR(50) NOT NULL,
    MaBinhLuanCha INT NULL,
    NoiDung TEXT NOT NULL,
    NgayBinhLuan DATE,
    CONSTRAINT FK_Comment_BaiViet FOREIGN KEY (MaBaiViet) REFERENCES BaiViet(MaBaiViet) ON DELETE CASCADE,
    CONSTRAINT FK_Comment_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    CONSTRAINT FK_Comment_Cha FOREIGN KEY (MaBinhLuanCha) REFERENCES BinhLuan(MaBinhLuan) ON DELETE CASCADE
);

-- 7. Bảng Tương tác / Reaction (UNIQUE đảm bảo mỗi người chỉ like 1 lần/bài)
CREATE TABLE TuongTac (
    MaTuongTac INT PRIMARY KEY AUTO_INCREMENT,
    MaNguoiDung VARCHAR(50) NOT NULL,
    MaBaiViet VARCHAR(50) NOT NULL,
    LoaiTuongTac VARCHAR(20) DEFAULT 'LIKE',
    NgayTuongTac DATE,
    CONSTRAINT FK_TuongTac_User FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    CONSTRAINT FK_TuongTac_BaiViet FOREIGN KEY (MaBaiViet) REFERENCES BaiViet(MaBaiViet) ON DELETE CASCADE,
    CONSTRAINT UQ_User_BaiViet_TuongTac UNIQUE (MaNguoiDung, MaBaiViet)
);

-- 8. Bảng Hashtag & Bảng trung gian Bài viết - Hashtag
CREATE TABLE Hashtag (
    MaHashtag INT PRIMARY KEY AUTO_INCREMENT,
    TenHashtag VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE BaiViet_Hashtag (
    MaBaiViet VARCHAR(50) NOT NULL,
    MaHashtag INT NOT NULL,
    PRIMARY KEY (MaBaiViet, MaHashtag),
    CONSTRAINT FK_BV_Hashtag_BV FOREIGN KEY (MaBaiViet) REFERENCES BaiViet(MaBaiViet) ON DELETE CASCADE,
    CONSTRAINT FK_BV_Hashtag_HT FOREIGN KEY (MaHashtag) REFERENCES Hashtag(MaHashtag) ON DELETE CASCADE
);

-- 9. Bảng Kiểm duyệt báo cáo vi phạm
CREATE TABLE KiemDuyetBaoCao (
    MaBaoCao INT PRIMARY KEY AUTO_INCREMENT,
    MaBaiViet VARCHAR(50) NOT NULL,
    MaNguoiDungBaoCao VARCHAR(50) NOT NULL,
    LyDo TEXT,
    TrangThaiXuLy VARCHAR(20) DEFAULT 'ChoDuyet',
    NgayBaoCao DATE,
    CONSTRAINT FK_BaoCao_BaiViet FOREIGN KEY (MaBaiViet) REFERENCES BaiViet(MaBaiViet) ON DELETE CASCADE,
    CONSTRAINT FK_BaoCao_User FOREIGN KEY (MaNguoiDungBaoCao) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    CONSTRAINT UQ_User_BaoCao_BaiViet UNIQUE (MaBaiViet, MaNguoiDungBaoCao)
);


-- =============================================
-- TRIGGER: Tự động đổi trạng thái bài viết sang 'TamAn' khi có >= 5 báo cáo từ người dùng khác nhau
-- =============================================
DELIMITER $$

CREATE TRIGGER TRG_TuDongTamAnBaiViet
AFTER INSERT ON KiemDuyetBaoCao
FOR EACH ROW
BEGIN
    DECLARE v_SoLuongBaoCao INT;

    SELECT COUNT(DISTINCT MaNguoiDungBaoCao) INTO v_SoLuongBaoCao
    FROM KiemDuyetBaoCao
    WHERE MaBaiViet = NEW.MaBaiViet;

    IF v_SoLuongBaoCao >= 5 THEN
        UPDATE BaiViet
        SET TrangThai = 'TamAn'
        WHERE MaBaiViet = NEW.MaBaiViet;
    END IF;
END$$

DELIMITER ;