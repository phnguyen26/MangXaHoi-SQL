# 1. Phân tích Yêu cầu
Nghiệp vụ thực tế:

<<<<<<< HEAD
+ Quản lý tài khoản & Hồ sơ: Quản lý thông tin người dùng và hồ sơ cá nhân tương ứng.   

+ Mối quan hệ xã hội: Quản lý quan hệ theo dõi (Follower/Following) giữa các người dùng với nhau.   

+ Nội dung số: Hỗ trợ người dùng đăng tải Album ảnh/video, viết Bài viết, gắn nhãn Hashtag, và thực hiện Bình luận đa cấp (Parent-Child comment).   

+ Tương tác: Ghi nhận các lượt tương tác (Like/Reaction) của người dùng trên bài viết.   

+ Kiểm duyệt nội dung: Cho phép người dùng gửi báo cáo vi phạm và đội ngũ kiểm duyệt xử lý.   

Quy tắc nghiệp vụ ràng buộc (Business Rules):

+ Một người dùng không được phép tự theo dõi chính mình.   

+ Mỗi người dùng chỉ được phép tương tác (like) một lần duy nhất trên mỗi bài viết.   

+ Quy tắc kiểm duyệt tự động: Bài viết nhận được từ 5 báo cáo vi phạm trở lên từ những người dùng khác nhau sẽ tự động chuyển sang trạng thái tạm ẩn (TamAn) để chờ kiểm duyệt viên xử lý.   

# 2. Thiết kế Cơ sở dữ liệu
Cơ sở dữ liệu được thiết kế đạt chuẩn 3NF (Dạng chuẩn 3) nhằm hạn chế tối đa dư thừa dữ liệu và đảm bảo tính toàn vẹn.   
Các thành phần ràng buộc kỹ thuật:

+ Khóa chính (PRIMARY KEY) và Khóa ngoại (FOREIGN KEY): Liên kết chặt chẽ giữa các bảng, kết hợp cơ chế ON DELETE CASCADE để tự động dọn dẹp dữ liệu rác khi xóa thực thể gốc.

+ Ràng buộc CHECK: Đảm bảo mã người theo dõi khác với mã người được theo dõi (MaNguoiDungFollow <> MaNguoiDungBeingFollowed).   

+ Ràng buộc UNIQUE: Đảm bảo tính duy nhất cho cặp (MaNguoiDung, MaBaiViet) trong bảng tương tác và bảng báo cáo vi phạm.   

+ Trigger tự động hóa: Sử dụng TRIGGER trên bảng KiemDuyetBaoCao để tự động kiểm tra số lượng báo cáo và cập nhật trạng thái bài viết sang "TamAn" khi đạt ngưỡng số lượng báo cáo ≥5.

# 3. Mô hình Thực thể Kết hợp (ER Model & Quan hệ giữa các bảng)
Hệ thống gồm 9 bảng chính với các mối quan hệ cụ thể như sau:

Quan hệ 1 - 1 (One-to-One):

- NguoiDung <-> HoSoCaNhan: Mỗi người dùng có đúng một hồ sơ cá nhân chi tiết.
=======
+ Quản lý tài khoản & Hồ sơ: Quản lý thông tin đăng nhập của người dùng (tên đăng nhập, email, mật khẩu, ngày tạo) và hồ sơ cá nhân tương ứng (tiểu sử, ảnh đại diện, ngày sinh).

+ Phân quyền kiểm duyệt: Một số người dùng được bổ nhiệm làm Kiểm duyệt viên (có cấp bậc và ngày bổ nhiệm) để xử lý các báo cáo vi phạm.

+ Mối quan hệ xã hội: Quản lý quan hệ theo dõi (Follower/Following) giữa các người dùng với nhau, có ghi nhận ngày bắt đầu theo dõi.

+ Nội dung số: Người dùng viết Bài viết, đính kèm nhiều tệp Media (ảnh/video) vào mỗi bài viết, gom bài viết vào Album, gắn nhãn Hashtag và thực hiện Bình luận đa cấp (Parent-Child comment).

+ Tương tác: Ghi nhận các lượt tương tác (Like/Reaction) và lượt chia sẻ (Share) của người dùng trên bài viết.

+ Kiểm duyệt nội dung: Cho phép người dùng gửi báo cáo vi phạm kèm lý do; kiểm duyệt viên tiếp nhận và cập nhật trạng thái xử lý báo cáo (mặc định: ChoDuyet).

Quy tắc nghiệp vụ ràng buộc (Business Rules):

+ Một người dùng không được phép tự theo dõi chính mình.

+ Mỗi người dùng chỉ được phép tương tác (like/reaction) một lần duy nhất trên mỗi bài viết.

+ Mỗi người dùng chỉ được chia sẻ một bài viết một lần.

+ Mỗi người dùng chỉ được báo cáo một bài viết một lần.

+ Media đính kèm bài viết chỉ thuộc một trong hai loại: 'ANH' hoặc 'VIDEO'.

+ Quy tắc kiểm duyệt tự động: Bài viết nhận được từ 5 báo cáo vi phạm trở lên từ những người dùng khác nhau sẽ tự động chuyển sang trạng thái tạm ẩn (TamAn) để chờ kiểm duyệt viên xử lý.

+ Khi xóa một người dùng, toàn bộ dữ liệu của người đó (hồ sơ, album, bài viết, bình luận, tương tác, chia sẻ, báo cáo, quan hệ theo dõi) bị xóa theo. Khi xóa album, các bài viết trong album vẫn được giữ lại (chỉ gỡ khỏi album). Khi một kiểm duyệt viên bị xóa, các báo cáo họ đã xử lý vẫn được giữ lại.

# 2. Thiết kế Cơ sở dữ liệu
Cơ sở dữ liệu được thiết kế đạt chuẩn 3NF (Dạng chuẩn 3) nhằm hạn chế tối đa dư thừa dữ liệu và đảm bảo tính toàn vẹn. Hệ quản trị: MySQL 8.0+.
Các thành phần ràng buộc kỹ thuật:

+ Khóa chính (PRIMARY KEY):
  - Khóa đơn dạng chuỗi VARCHAR(50): NguoiDung, Album, BaiViet.
  - Khóa đơn tự tăng INT AUTO_INCREMENT: Media, BinhLuan, TuongTac, Chiase, Hashtag, KiemDuyetBaoCao.
  - Khóa chính đồng thời là khóa ngoại (quan hệ 1 - 1): HoSoCaNhan, KiemDuyetVien (MaNguoiDung).
  - Khóa chính phức hợp: TheoDoi (MaNguoiDungFollow, MaNguoiDungBeingFollowed), BaiViet_Hashtag (MaBaiViet, MaHashtag).

+ Khóa ngoại (FOREIGN KEY): Liên kết chặt chẽ giữa các bảng, kết hợp các cơ chế:
  - ON DELETE CASCADE: tự động dọn dữ liệu con khi xóa thực thể gốc (áp dụng cho hầu hết các khóa ngoại, kể cả khóa tự tham chiếu MaBinhLuanCha: xóa bình luận cha sẽ xóa toàn bộ trả lời bên dưới).
  - ON DELETE SET NULL: BaiViet.MaAlbum (xóa album thì bài viết giữ lại, MaAlbum = NULL) và KiemDuyetBaoCao.MaKiemDuyetVien (xóa kiểm duyệt viên thì báo cáo giữ lại, MaKiemDuyetVien = NULL).

+ Ràng buộc CHECK:
  - CHK_KhongTuFollow: Đảm bảo mã người theo dõi khác với mã người được theo dõi (MaNguoiDungFollow <> MaNguoiDungBeingFollowed).
  - CHK_LoaiMedia: Loại media chỉ nhận giá trị 'ANH' hoặc 'VIDEO'.
  - CHK_TrangThaiBaiViet: Trạng thái bài viết chỉ nhận 'Hien' (hiển thị), 'TamAn' (tạm ẩn chờ duyệt) hoặc 'An' (đã ẩn sau kiểm duyệt).
  - CHK_LoaiTuongTac: Loại tương tác chỉ nhận 'LIKE', 'LOVE', 'HAHA', 'WOW', 'SAD' hoặc 'ANGRY'.
  - CHK_TrangThaiXuLy: Trạng thái xử lý báo cáo chỉ nhận 'ChoDuyet' (chờ duyệt), 'ViPham' (xác nhận vi phạm) hoặc 'TuChoi' (bác bỏ báo cáo).

+ Ràng buộc UNIQUE:
  - NguoiDung: TenDangNhap và Email là duy nhất.
  - Hashtag: TenHashtag là duy nhất.
  - TuongTac: cặp (MaNguoiDung, MaBaiViet) là duy nhất.
  - Chiase: cặp (MaNguoiDung, MaBaiViet) là duy nhất.
  - KiemDuyetBaoCao: cặp (MaBaiViet, MaNguoiDungBaoCao) là duy nhất.

+ Giá trị mặc định (DEFAULT): BaiViet.TrangThai = 'Hien', TuongTac.LoaiTuongTac = 'LIKE', KiemDuyetBaoCao.TrangThaiXuLy = 'ChoDuyet' (ba cột trạng thái này đều NOT NULL), KiemDuyetVien.CapBac = 'KiemDuyetVien'.

+ Kiểu dữ liệu thời gian: Các cột ghi nhận thời điểm (NgayTao, NgayBoNhiem, NgayTheoDoi, NgayDang, NgayBinhLuan, NgayTuongTac, NgayChiaSe, NgayBaoCao) dùng DATETIME DEFAULT CURRENT_TIMESTAMP để lưu đến giờ-phút-giây (phục vụ sắp xếp bảng tin, bình luận theo thời gian) và tự điền khi thêm bản ghi. Riêng NgaySinh giữ kiểu DATE.

+ Trigger tự động hóa: TRG_TuDongTamAnBaiViet (AFTER INSERT trên bảng KiemDuyetBaoCao) đếm số người dùng khác nhau đã báo cáo bài viết vừa bị báo cáo; nếu ≥ 5 thì cập nhật BaiViet.TrangThai sang 'TamAn'.

# 3. Mô hình Thực thể Kết hợp (ER Model & Quan hệ giữa các bảng)
Hệ thống gồm 13 bảng: NguoiDung, HoSoCaNhan, KiemDuyetVien, TheoDoi, Album, BaiViet, Media, BinhLuan, TuongTac, Chiase, Hashtag, BaiViet_Hashtag, KiemDuyetBaoCao. Các mối quan hệ cụ thể như sau:

Quan hệ 1 - 1 (One-to-One):

- NguoiDung <-> HoSoCaNhan: Mỗi người dùng có tối đa một hồ sơ cá nhân chi tiết; mỗi hồ sơ thuộc đúng một người dùng.

- NguoiDung <-> KiemDuyetVien: Quan hệ chuyên biệt hóa (IS-A). Kiểm duyệt viên là một người dùng được bổ nhiệm thêm vai trò kiểm duyệt; mỗi người dùng có tối đa một bản ghi kiểm duyệt viên.
>>>>>>> main

Quan hệ 1 - N (One-to-Many):

- Album --> NguoiDung: Một album chỉ được sở hữu bởi 1 người, một người dùng có thể tạo nhiều album.

- BaiViet --> NguoiDung: Một người dùng có thể đăng nhiều bài viết, một bài viết do đúng 1 người đăng.

<<<<<<< HEAD
- BaiViet --> Album: Một album có thể chứa nhiều bài viết.

- TuongTac --> BaiViet: Một bài viết có nhiều lượt tương tác.

- KiemDuyetBaoCao --> BaiViet: Một bài viết có thể nhận nhiều báo cáo vi phạm.
=======
- BaiViet --> Album: Một album có thể chứa nhiều bài viết; một bài viết thuộc tối đa 1 album (có thể không thuộc album nào).

- Media --> BaiViet: Một bài viết có thể đính kèm nhiều ảnh/video; mỗi media thuộc đúng 1 bài viết.

- BinhLuan --> BaiViet: Một bài viết có nhiều bình luận; mỗi bình luận thuộc đúng 1 bài viết.

- BinhLuan --> NguoiDung: Một người dùng có thể viết nhiều bình luận; mỗi bình luận do đúng 1 người viết.

- KiemDuyetBaoCao --> KiemDuyetVien: Một kiểm duyệt viên có thể xử lý nhiều báo cáo; mỗi báo cáo do tối đa 1 kiểm duyệt viên xử lý (NULL khi chưa được tiếp nhận).
>>>>>>> main

Quan hệ Tự tham chiếu / Đệ quy (Self-Referencing):

- BinhLuan - BinhLuan | BinhLuan <-- BinhLuanCha: Quản lý bình luận đa cấp thông qua cột MaBinhLuanCha (bình luận gốc có NULL, các trả lời cấp con sẽ trỏ về khóa chính của bình luận cha).

Quan hệ N - N (Many-to-Many):

<<<<<<< HEAD
- NguoiDung --- NguoiDung (thông qua bảng trung gian TheoDoi): Quản lý danh sách người theo dõi và được theo dõi.   
=======
- NguoiDung --- NguoiDung (thông qua bảng trung gian TheoDoi): Quản lý danh sách người theo dõi và được theo dõi, kèm ngày theo dõi.

- NguoiDung --- BaiViet (thông qua bảng trung gian TuongTac): Một người dùng tương tác nhiều bài viết, một bài viết có nhiều lượt tương tác; mỗi cặp chỉ có 1 lượt (kèm loại tương tác và ngày).

- NguoiDung --- BaiViet (thông qua bảng trung gian Chiase): Một người dùng chia sẻ nhiều bài viết, một bài viết được nhiều người chia sẻ; mỗi cặp chỉ có 1 lượt chia sẻ.

- NguoiDung --- BaiViet (thông qua bảng trung gian KiemDuyetBaoCao): Một người dùng có thể báo cáo nhiều bài viết, một bài viết có thể nhận nhiều báo cáo vi phạm; mỗi cặp chỉ có 1 báo cáo (kèm lý do, trạng thái xử lý, ngày báo cáo).
>>>>>>> main

- BaiViet --- Hashtag (thông qua bảng trung gian BaiViet_Hashtag): Một bài viết có nhiều hashtag và một hashtag xuất hiện ở nhiều bài viết.