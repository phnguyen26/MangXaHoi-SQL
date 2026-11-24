# 1. Phân tích Yêu cầu
Nghiệp vụ thực tế:

+ Quản lý tài khoản & Hồ sơ: Quản lý thông tin đăng nhập của người dùng (tên đăng nhập, email, mật khẩu, ngày tạo) và hồ sơ cá nhân tương ứng (tiểu sử, ảnh đại diện, ngày sinh).

+ Phân quyền kiểm duyệt: Một số người dùng được bổ nhiệm làm Kiểm duyệt viên (có cấp bậc và ngày bổ nhiệm) để duyệt bài viết và xử lý các báo cáo vi phạm.

+ Mối quan hệ xã hội: Quản lý quan hệ theo dõi (Follower/Following) giữa các người dùng với nhau, có ghi nhận ngày bắt đầu theo dõi.

+ Nội dung số: Người dùng viết Bài viết, đính kèm nhiều tệp Media (ảnh/video) vào mỗi bài viết, gom bài viết vào Album, gắn nhãn Hashtag và thực hiện Bình luận đa cấp (Parent-Child comment).

+ Tương tác: Ghi nhận các lượt tương tác (Like/Reaction) và lượt chia sẻ (Share) của người dùng trên bài viết.

+ Kiểm duyệt nội dung: Bài viết phải được kiểm duyệt viên duyệt mới được công khai. Người dùng gửi báo cáo vi phạm kèm lý do; kiểm duyệt viên ghi nhận kết quả kiểm duyệt (vi phạm / không vi phạm), mỗi lần kiểm duyệt xử lý luôn các báo cáo đang chờ của bài đó.

Quy tắc nghiệp vụ ràng buộc (Business Rules):

+ Một người dùng không được phép tự theo dõi chính mình.

+ Mỗi người dùng chỉ được phép tương tác (like/reaction) một lần duy nhất trên mỗi bài viết.

+ Mỗi người dùng chỉ được chia sẻ một bài viết một lần.

+ Mỗi người dùng chỉ được báo cáo một bài viết một lần.

+ Media đính kèm bài viết chỉ thuộc một trong hai loại: 'ANH' hoặc 'VIDEO'.

+ Bình luận trả lời phải thuộc cùng bài viết với bình luận cha.

+ Bài viết mới mặc định tạm ẩn (TamAn), chỉ hiển thị (Hien) khi kiểm duyệt viên kết luận không vi phạm; nếu vi phạm thì giữ TamAn. Kiểm duyệt viên không xóa bài, việc xóa do tác giả quyết định.

+ Chỉ được báo cáo bài viết đang hiển thị.

+ Quy tắc kiểm duyệt tự động: Bài viết đang hiển thị nhận được từ 5 báo cáo vi phạm chưa xử lý trở lên từ những người dùng khác nhau sẽ tự động chuyển sang trạng thái tạm ẩn (TamAn) để chờ kiểm duyệt viên xem xét lại.

+ Khi xóa một người dùng, toàn bộ dữ liệu của người đó (hồ sơ, album, bài viết, bình luận, tương tác, chia sẻ, báo cáo, quan hệ theo dõi) bị xóa theo. Khi xóa album, các bài viết trong album vẫn được giữ lại (chỉ gỡ khỏi album). Khi một kiểm duyệt viên bị xóa, các lần kiểm duyệt họ đã thực hiện vẫn được giữ lại.

# 2. Thiết kế Cơ sở dữ liệu
Cơ sở dữ liệu được thiết kế đạt chuẩn 3NF (Dạng chuẩn 3) nhằm hạn chế tối đa dư thừa dữ liệu và đảm bảo tính toàn vẹn. Hệ quản trị: MySQL 8.0+.
Các thành phần ràng buộc kỹ thuật:

+ Khóa chính (PRIMARY KEY):
  - Khóa đơn kiểu chuỗi VARCHAR(36), mã do người nhập cung cấp (không tự tăng): NguoiDung, Album, BaiViet, Media, BinhLuan, TuongTac, ChiaSe, Hashtag, KiemDuyet, BaoCao. Quy ước mã: NguoiDung 'U001', Album 'AL01', BaiViet 'BV101', Media 'MD01', BinhLuan 'BL01', TuongTac 'TT0001', ChiaSe 'CS01', Hashtag 'HT01', KiemDuyet 'KD01', BaoCao 'BC01' (phần số đệm 0 cố định độ dài để sắp xếp và so sánh theo chuỗi đúng thứ tự).
  - Khóa chính đồng thời là khóa ngoại (quan hệ 1 - 1): HoSoCaNhan, KiemDuyetVien (MaNguoiDung). Mọi khóa ngoại đều cùng kiểu VARCHAR(36) với khóa chính được tham chiếu.
  - Khóa chính phức hợp: TheoDoi (MaNguoiDungFollow, MaNguoiDungBeingFollowed), BaiViet_Hashtag (MaBaiViet, MaHashtag).

+ Khóa ngoại (FOREIGN KEY): Liên kết chặt chẽ giữa các bảng, kết hợp các cơ chế:
  - ON DELETE CASCADE: tự động dọn dữ liệu con khi xóa thực thể gốc (áp dụng cho hầu hết các khóa ngoại, kể cả khóa tự tham chiếu MaBinhLuanCha: xóa bình luận cha sẽ xóa toàn bộ trả lời bên dưới).
  - ON DELETE SET NULL: BaiViet.MaAlbum (xóa album thì bài viết giữ lại, MaAlbum = NULL) và KiemDuyet.MaKiemDuyetVien (xóa kiểm duyệt viên thì lịch sử kiểm duyệt giữ lại, MaKiemDuyetVien = NULL).
  - Khóa ngoại phức hợp: BinhLuan (MaBinhLuanCha, MaBaiViet) đảm bảo bình luận cha cùng bài viết; BaoCao (MaKiemDuyet, MaBaiViet) đảm bảo báo cáo chỉ gắn vào lần kiểm duyệt của đúng bài đó.

+ Ràng buộc CHECK:
  - CHK_KhongTuFollow: Đảm bảo mã người theo dõi khác với mã người được theo dõi (MaNguoiDungFollow <> MaNguoiDungBeingFollowed).
  - CHK_LoaiMedia: Loại media chỉ nhận giá trị 'ANH' hoặc 'VIDEO'.
  - CHK_TrangThaiBaiViet: Trạng thái bài viết chỉ nhận 'TamAn' (chờ duyệt / không hiển thị) hoặc 'Hien' (công khai).
  - CHK_LoaiTuongTac: Loại tương tác chỉ nhận 'LIKE', 'LOVE', 'HAHA', 'WOW', 'SAD' hoặc 'ANGRY'.
  - CHK_KetQuaKiemDuyet: Kết quả kiểm duyệt chỉ nhận 'ViPham' hoặc 'KhongViPham'.

+ Ràng buộc UNIQUE:
  - NguoiDung: TenDangNhap và Email là duy nhất.
  - Hashtag: TenHashtag là duy nhất.
  - TuongTac: cặp (MaNguoiDung, MaBaiViet) là duy nhất.
  - ChiaSe: cặp (MaNguoiDung, MaBaiViet) là duy nhất.
  - BaoCao: cặp (MaBaiViet, MaNguoiDungBaoCao) là duy nhất.
  - BinhLuan: cặp (MaBinhLuan, MaBaiViet) và KiemDuyet: cặp (MaKiemDuyet, MaBaiViet) là duy nhất, làm đích cho hai khóa ngoại phức hợp ở trên.

+ Giá trị mặc định (DEFAULT): BaiViet.TrangThai = 'TamAn', TuongTac.LoaiTuongTac = 'LIKE' (hai cột này đều NOT NULL), KiemDuyetVien.CapBac = 'KiemDuyetVien'. BaoCao.MaKiemDuyet = NULL nghĩa là báo cáo chưa được xử lý.

+ Kiểu dữ liệu thời gian: Các cột ghi nhận thời điểm (NgayTao, NgayBoNhiem, NgayTheoDoi, NgayDang, NgayBinhLuan, NgayTuongTac, NgayChiaSe, NgayBaoCao, NgayXuLy) dùng DATETIME DEFAULT CURRENT_TIMESTAMP để lưu đến giờ-phút-giây (phục vụ sắp xếp bảng tin, bình luận theo thời gian) và tự điền khi thêm bản ghi. Riêng NgaySinh giữ kiểu DATE.

+ Trigger tự động hóa:
  - TRG_ChanBaoCaoBaiKhongHien (BEFORE INSERT trên BaoCao): từ chối báo cáo nếu bài viết không ở trạng thái 'Hien'.
  - TRG_TuDongTamAnBaiViet (AFTER INSERT trên BaoCao): bài đang 'Hien' có ≥ 5 báo cáo chưa xử lý thì chuyển sang 'TamAn'.
  - TRG_XuLyKiemDuyet (AFTER INSERT trên KiemDuyet): 'KhongViPham' thì bài thành 'Hien', 'ViPham' thì giữ 'TamAn'; đồng thời đánh dấu các báo cáo đang chờ của bài là đã xử lý.

# 3. Mô hình Thực thể Kết hợp (ER Model & Quan hệ giữa các bảng)
Hệ thống gồm 14 bảng: NguoiDung, HoSoCaNhan, KiemDuyetVien, TheoDoi, Album, BaiViet, Media, BinhLuan, TuongTac, ChiaSe, Hashtag, BaiViet_Hashtag, KiemDuyet, BaoCao. Các mối quan hệ cụ thể như sau:

Quan hệ 1 - 1 (One-to-One):

- NguoiDung <-> HoSoCaNhan: Mỗi người dùng có tối đa một hồ sơ cá nhân chi tiết; mỗi hồ sơ thuộc đúng một người dùng.

- NguoiDung <-> KiemDuyetVien: Quan hệ chuyên biệt hóa (IS-A). Kiểm duyệt viên là một người dùng được bổ nhiệm thêm vai trò kiểm duyệt; mỗi người dùng có tối đa một bản ghi kiểm duyệt viên.

Quan hệ 1 - N (One-to-Many):

- Album --> NguoiDung: Một album chỉ được sở hữu bởi 1 người, một người dùng có thể tạo nhiều album.

- BaiViet --> NguoiDung: Một người dùng có thể đăng nhiều bài viết, một bài viết do đúng 1 người đăng.

- BaiViet --> Album: Một album có thể chứa nhiều bài viết; một bài viết thuộc tối đa 1 album (có thể không thuộc album nào).

- Media --> BaiViet: Một bài viết có thể đính kèm nhiều ảnh/video; mỗi media thuộc đúng 1 bài viết.

- BinhLuan --> BaiViet: Một bài viết có nhiều bình luận; mỗi bình luận thuộc đúng 1 bài viết.

- BinhLuan --> NguoiDung: Một người dùng có thể viết nhiều bình luận; mỗi bình luận do đúng 1 người viết.

- BaoCao --> NguoiDung: Một người dùng có thể gửi nhiều báo cáo; mỗi báo cáo do đúng 1 người gửi.

- BaoCao --> BaiViet: Một bài viết có thể nhận nhiều báo cáo; mỗi báo cáo nhắm vào đúng 1 bài viết.

- BaoCao --> KiemDuyet: Một lần kiểm duyệt xử lý nhiều báo cáo; mỗi báo cáo được xử lý trong tối đa 1 lần kiểm duyệt (NULL khi chưa xử lý).

- KiemDuyet --> BaiViet: Một bài viết có thể được kiểm duyệt nhiều lần; mỗi lần kiểm duyệt xét đúng 1 bài viết.

- KiemDuyet --> KiemDuyetVien: Một kiểm duyệt viên thực hiện nhiều lần kiểm duyệt; mỗi lần do 1 kiểm duyệt viên thực hiện.

Quan hệ Tự tham chiếu / Đệ quy (Self-Referencing):

- BinhLuan - BinhLuan | BinhLuan <-- BinhLuanCha: Quản lý bình luận đa cấp thông qua cột MaBinhLuanCha (bình luận gốc có NULL, các trả lời cấp con sẽ trỏ về khóa chính của bình luận cha thuộc cùng bài viết).

Quan hệ N - N (Many-to-Many):

- NguoiDung --- NguoiDung (thông qua bảng trung gian TheoDoi): Quản lý danh sách người theo dõi và được theo dõi, kèm ngày theo dõi.

- NguoiDung --- BaiViet (thông qua bảng trung gian TuongTac): Một người dùng tương tác nhiều bài viết, một bài viết có nhiều lượt tương tác; mỗi cặp chỉ có 1 lượt (kèm loại tương tác và ngày). Bảng có mã riêng MaTuongTac làm khóa chính, cặp (MaNguoiDung, MaBaiViet) được giữ duy nhất bằng UNIQUE.

- NguoiDung --- BaiViet (thông qua bảng trung gian ChiaSe): Một người dùng chia sẻ nhiều bài viết, một bài viết được nhiều người chia sẻ; mỗi cặp chỉ có 1 lượt chia sẻ. Bảng có mã riêng MaChiaSe làm khóa chính, cặp (MaNguoiDung, MaBaiViet) được giữ duy nhất bằng UNIQUE.

- BaiViet --- Hashtag (thông qua bảng trung gian BaiViet_Hashtag): Một bài viết có nhiều hashtag và một hashtag xuất hiện ở nhiều bài viết.