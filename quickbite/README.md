QuickBite: Tài liệu ứng dụng đặt đồ ăn di động

QuickBite là một ứng dụng đặt đồ ăn di động được thiết kế để giúp người dùng dễ dàng khám phá, đặt món và quản lý tài khoản của họ. Ứng dụng này được phát triển với giao diện thân thiện, tính năng thanh toán an toàn, và khả năng quản lý tài khoản chi tiết.

1.Chức Năng Chính
- Người Dùng
    + Duyệt danh sách món ăn: Khám phá các món ăn với hình ảnh và thông tin chi tiết.
    + Thêm món vào giỏ hàng: Chọn món, số lượng, và thêm vào giỏ hàng.
    + Thanh toán an toàn: Thanh toán bằng cách nạp tiền vào ví trong ứng dụng.
    + Quản lý tài khoản cá nhân:
        + Cập nhật ảnh đại diện.
        + Đăng xuất tài khoản.
        + Xóa tài khoản nếu cần thiết.
Quản Trị Viên (Admin)
- Quản lý sản phẩm: Thêm, cập nhật, và xóa món ăn.
- Quản lý đơn hàng: Theo dõi trạng thái đơn hàng và xử lý chúng.


2.Công Nghệ Sử Dụng
- Frontend
    + Flutter: Tạo giao diện người dùng mượt mà và trực quan.
    + SharedPreferences: Lưu trữ dữ liệu cục bộ.
    + Image Picker: Chọn ảnh đại diện từ thư viện.
- Backend
    + Firebase Authentication: Xác thực người dùng.
    + Firebase Firestore: Lưu trữ dữ liệu động.
    + Firebase Cloud Storage: Quản lý ảnh đại diện và dữ liệu tĩnh.

3.Hướng Dẫn Cài Đặt

Frontend Setup
- Yêu cầu hệ thống:
    + Flutter SDK đã được cài đặt.
    + Thiết bị di động hoặc trình giả lập.
- Cài đặt ứng dụng:
    + Clone repository về máy: dùng git bash
        git clone https://github.com/<your-repo>/quickbite.git
        cd quickbite
    + Cài đặt các dependencies:
        flutter pub get
    + Khởi động ứng dụng:
        flutter run
Backend Setup
    + Ứng dụng sử dụng Firebase cho các chức năng backend, không cần cấu hình thêm.
    + Đảm bảo kết nối Firebase trong file google-services.json (Android) hoặc GoogleService-Info.plist (iOS).

4.Hướng Dẫn Sử Dụng
    - Đăng ký và đăng nhập:
        + Tạo tài khoản với email và mật khẩu hợp lệ.
        + Sau khi đăng nhập, bạn sẽ được chuyển đến Trang Chủ.

    - Trang Chủ:
        + Xem danh sách món ăn kèm hình ảnh và giá cả.
        + Nhấn vào món ăn để chọn số lượng và thêm vào giỏ hàng.
    
    - Thanh toán:
        + Truy cập mục Ví từ menu dưới cùng.
        + Thêm số tiền bạn muốn vào ví.
        + Sau khi ví có tiền, quay lại giỏ hàng và chọn Thanh toán.
    - Quản lý tài khoản:
        Truy cập Hồ Sơ (Profile) để:
            + Thay đổi ảnh đại diện.
            + Đăng xuất tài khoản.
            + Xóa tài khoản (hệ thống sẽ hiển thị cảnh báo trước khi xóa).


5.Môi Trường Phát Triển

Environment Variables
    - Ứng dụng Firebase yêu cầu cấu hình từ Firebase Console.

        + Tải file google-services.json (Android) hoặc GoogleService-Info.plist (iOS) từ Firebase Console và thêm vào dự án.
Testing
    - Sử dụng trình giả lập hoặc thiết bị thật để kiểm tra.
    - Cần kết nối internet để sử dụng các dịch vụ Firebase.

Ghi Chú

- Thời gian phản hồi:
    + Firebase miễn phí có thể có độ trễ nhẹ khi thực hiện các yêu cầu.
- Dữ liệu cá nhân:
    + Đảm bảo rằng ảnh đại diện và các thông tin cá nhân được quản lý an toàn.