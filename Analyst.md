# 1. Phân tích Yêu cầu
- Nghiệp vụ thực tế:

+ Quản lý tài khoản & Hồ sơ: Quản lý thông tin người dùng và hồ sơ cá nhân tương ứng.   

+ Mối quan hệ xã hội: Quản lý quan hệ theo dõi (Follower/Following) giữa các người dùng với nhau.   

+ Nội dung số: Hỗ trợ người dùng đăng tải Album ảnh/video, viết Bài viết, gắn nhãn Hashtag, và thực hiện Bình luận đa cấp (Parent-Child comment).   

+ Tương tác: Ghi nhận các lượt tương tác (Like/Reaction) của người dùng trên bài viết.   

+ Kiểm duyệt nội dung: Cho phép người dùng gửi báo cáo vi phạm và đội ngũ kiểm duyệt xử lý.   

- Quy tắc nghiệp vụ ràng buộc (Business Rules):

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

- Quan hệ 1 - 1 (One-to-One):

NguoiDung <-> HoSoCaNhan: Mỗi người dùng có đúng một hồ sơ cá nhân chi tiết.

- Quan hệ 1 - N (One-to-Many):

Album --> NguoiDung: Một album chỉ được sở hữu bởi 1 người, một người dùng có thể tạo nhiều album.

BaiViet --> NguoiDung: Một người dùng có thể đăng nhiều bài viết, một bài viết do đúng 1 người đăng.

BaiViet --> Album: Một album có thể chứa nhiều bài viết.

TuongTac --> BaiViet: Một bài viết có nhiều lượt tương tác.

KiemDuyetBaoCao --> BaiViet: Một bài viết có thể nhận nhiều báo cáo vi phạm.

- Quan hệ Tự tham chiếu / Đệ quy (Self-Referencing):

BinhLuan - BinhLuan | BinhLuan <-- BinhLuanCha: Quản lý bình luận đa cấp thông qua cột MaBinhLuanCha (bình luận gốc có NULL, các trả lời cấp con sẽ trỏ về khóa chính của bình luận cha).

- Quan hệ N - N (Many-to-Many):

NguoiDung --- NguoiDung (thông qua bảng trung gian TheoDoi): Quản lý danh sách người theo dõi và được theo dõi.   

BaiViet --- Hashtag (thông qua bảng trung gian BaiViet_Hashtag): Một bài viết có nhiều hashtag và một hashtag xuất hiện ở nhiều bài viết.