CREATE DATABASE CHUDE14 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE CHUDE14;

CREATE TABLE NguoiDung (
    MaNguoiDung VARCHAR(50) PRIMARY KEY,
    TenDangNhap VARCHAR(50) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL UNIQUE,
    MatKhau VARCHAR(255) NOT NULL,
    NgayTao DATE
);

CREATE TABLE HoSoCaNhan (
    MaNguoiDung VARCHAR(50) PRIMARY KEY,
    TieuSu TEXT,
    AnhDaiDien VARCHAR(255),
    NgaySinh DATE,
    CONSTRAINT FK_HoSo_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE
);

CREATE TABLE TheoDoi (
    MaNguoiDungFollow VARCHAR(50) NOT NULL,
    MaNguoiDungBeingFollowed VARCHAR(50) NOT NULL,
    NgayTheoDoi DATE,
    PRIMARY KEY (MaNguoiDungFollow, MaNguoiDungBeingFollowed),
    CONSTRAINT FK_Follow_NguoiDung FOREIGN KEY (MaNguoiDungFollow) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    CONSTRAINT FK_Follow_BiFollow FOREIGN KEY (MaNguoiDungBeingFollowed) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    CONSTRAINT CHK_KhongTuFollow CHECK (MaNguoiDungFollow <> MaNguoiDungBeingFollowed)
);

CREATE TABLE Album (
    MaAlbum VARCHAR(50) PRIMARY KEY,
    MaNguoiDung VARCHAR(50) NOT NULL,
    TenAlbum VARCHAR(150) NOT NULL,
    NgayTao DATE,
    CONSTRAINT FK_Album_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE
);

CREATE TABLE BaiViet (
    MaBaiViet VARCHAR(50) PRIMARY KEY,
    MaNguoiDung VARCHAR(50) NOT NULL,
    MaAlbum VARCHAR(50) NULL,                                              
    NoiDung TEXT NOT NULL,
    TrangThai VARCHAR(20) DEFAULT 'Hien', 
    NgayDang DATE,
    CONSTRAINT FK_BaiViet_NguoiDung FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    CONSTRAINT FK_BaiViet_Album FOREIGN KEY (MaAlbum) REFERENCES Album(MaAlbum) ON DELETE SET NULL
);

CREATE TABLE Media (
    MaMedia     INT PRIMARY KEY AUTO_INCREMENT,                                                                     
    MaBaiViet   VARCHAR(50) NOT NULL,       
    LoaiMedia   VARCHAR(10) NOT NULL,   -- 'ANH' hoặc 'VIDEO'
    Url         VARCHAR(500) NOT NULL,
    CONSTRAINT FK_Media_BaiViet FOREIGN KEY (MaBaiViet) REFERENCES BaiViet(MaBaiViet) ON DELETE CASCADE,
    CONSTRAINT CHK_LoaiMedia    CHECK (LoaiMedia IN ('ANH', 'VIDEO'))
);


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

CREATE TABLE Chiase (
    MaChiaSe INT PRIMARY KEY AUTO_INCREMENT,
    MaNguoiDung VARCHAR(50) NOT NULL,
    MaBaiViet VARCHAR(50) NOT NULL,
    NgayChiaSe DATE,
    CONSTRAINT FK_Chiase_User FOREIGN KEY (MaNguoiDung) REFERENCES NguoiDung(MaNguoiDung) ON DELETE CASCADE,
    CONSTRAINT FK_Chiase_BaiViet FOREIGN KEY (MaBaiViet) REFERENCES BaiViet(MaBaiViet) ON DELETE CASCADE,
    CONSTRAINT UQ_User_BaiViet_Chiase UNIQUE (MaNguoiDung, MaBaiViet)
);


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