# 📱 Danh Sách Bán Hoa - BÀI THỰC HÀNH 3: CALL API APP

Ứng dụng Flutter để hiển thị danh sách bán hoa với xử lý dữ liệu từ API, Loading & Error UI.

## 🎯 Tính Năng Chính

✅ **Xử lý 3 trạng thái dữ liệu:**
- **Loading**: Hiệu ứng vòng xoay `CircularProgressIndicator`
- **Success**: Dữ liệu hiển thị trên GridView 2 cột
- **Error**: Thông báo lỗi + Nút Retry

✅ **Giao diện chuyên nghiệp:**
- Card items gọn gàng với ảnh hoa
- Giá tiền, màu sắc, số lượng tồn kho
- Responsive design (GridView 2 columns)
- Nút "Mua" cho mỗi sản phẩm

✅ **Tổ chức code cấu trúc:**
- `models/` - Định nghĩa model Flower
- `services/` - Service gọi API
- `screens/` - Màn hình chính (HomeScreen)
- `widgets/` - UI components (FlowerCard, ErrorWidget)

## 📁 Cấu Trúc Project

```
lib/
├── main.dart              # Entry point
├── models/
│   └── flower_model.dart  # Flower data model
├── services/
│   └── flower_service.dart # API service
├── screens/
│   └── home_screen.dart   # Main UI screen
└── widgets/
    ├── flower_card.dart   # Item card widget
    └── error_widget.dart  # Error display widget
```

## 🚀 Chạy Ứng Dụng

```bash
flutter pub get
flutter run
```

## 📝 Cách Sử Dụng

### Chỉnh sửa thông tin sinh viên
Vào file `lib/screens/home_screen.dart` và sửa dòng AppBar:
```dart
title: const Text(
  'TH3 - [Họ tên Sinh viên] - [Mã SV]',
  ...
)
```

### Thay đổi nguồn dữ liệu
Chỉnh sửa `FlowerService.fetchFlowers()` trong `lib/services/flower_service.dart` để kết nối tới API thực tế hoặc Firebase.

### Tạo Error UI
Uncomment dòng này trong `FlowerService.fetchFlowers()` để kiểm tra Error UI:
```dart
throw Exception('Lỗi kết nối mạng mô phỏng');
```

## 🛠️ Công Nghệ Sử Dụng

- **Flutter** - Framework UI
- **Dart** - Ngôn ngữ lập trình
- **HTTP** - Gọi API
- **FutureBuilder** - Xử lý async
- **GridView** - Hiển thị danh sách 2 cột

## 📌 Yêu Cầu Bài Tập

✅ Danh sách bán hoa (GridView 2 items/hàng)
✅ Xử lý Loading state
✅ Xử lý Success state (Map Model)
✅ Xử lý Error state + Retry button
✅ Tách file (Models, Services, Screens, Widgets)
✅ Try-catch exception handling
✅ AppBar định dạng: TH3 - [Họ tên] - [Mã SV]
✅ Responsive design

---

**Chú ý:** Hãy cập nhật thông tin sinh viên trong AppBar trước khi nộp bài!
