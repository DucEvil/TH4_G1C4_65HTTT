# 🌸 DANH SÁCH BÁN HOA - Flutter App
## BÀI THỰC HÀNH 3: CALL API APP

### ✨ Tính Năng Đã Hoàn Thành

✅ **Xử lý Network & States**
- Loading State: CircularProgressIndicator
- Success State: GridView 2 cột (responsive)
- Error State: Lỗi + Retry button
- Data fetching: Mock API + HTTP support

✅ **Giao Diện**
- AppBar: Định dạng "TH3 - [Tên SV] - [Mã SV]"
- GridView: 2 items per row
- Card Layout: Ảnh, tên, giá, màu, số lượng
- Professional UI: Padding, spacing, rounded corners

✅ **Code Organization** 
```
lib/
├── main.dart                  # Entry point
├── config/api_config.dart    # Configuration & student info
├── data/mock_flowers.dart    # Mock data
├── models/flower_model.dart  # Data model
├── services/flower_service.dart # API service
├── screens/home_screen.dart  # Main screen
└── widgets/
    ├── flower_card.dart      # Item widget
    └── error_widget.dart     # Error widget
```

✅ **Exception Handling**
- Try-catch trong FlowerService
- Error UI: Hiển thị thông báo lỗi chi tiết
- Retry: Tải lại dữ liệu

---

## 📝 Hướng Dẫn Nộp Bài

### Bước 1: Cập nhật thông tin sinh viên
Mở file: `lib/config/api_config.dart`

```dart
static const String studentName = 'Nguyễn Văn A';  // ← Nhập tên bạn
static const String studentId = 'SV001';           // ← Nhập mã SV
```

### Bước 2: Lựa chọn UI States để demo

**Option A: Demo Success State** (Mặc định - Khuyến khích)
```dart
static const bool useMockData = true;
static const bool simulateNetworkError = false;
static const int simulatedDelay = 2000;  // 2s loading
```

**Option B: Demo Error State**
```dart
static const bool simulateNetworkError = true;  // Bật lỗi
static const int simulatedDelay = 1000;
```

### Bước 3: Chạy ứng dụng
```bash
flutter pub get
flutter run
```

---

## 🎯 Kết Quả Dự Kiến

### Success State
- Hiển thị 8 loại hoa trong GridView
- Mỗi item có: ảnh, tên, giá, màu, số lượng, nút Mua
- Loading spinner 2 giây lúc đầu
- Nút Refresh (FAB) để tải lại

### Loading State
- Spinner xoay + text "Đang tải dữ liệu..."
- Màu hồng

### Error State
- Icon error + thông báo lỗi
- Nút "Thử lại" để retry
- Bấm retry = fetch lại dữ liệu

---

## 🧪 Kiểm Tra Yêu Cầu

| Yêu Cầu | Vị Trí | Kiểm Tra |
|---------|--------|----------|
| Danh sách hoa | HomeScreen | GridView 2 columns ✓ |
| Loading | home_screen.dart:45 | CircularProgressIndicator ✓ |
| Success | home_screen.dart:60 | GridView.builder ✓ |
| Error + Retry | error_widget.dart | ErrorDisplayWidget ✓ |
| Tách file | lib/models, services, screens, widgets | ✓ |
| Try-catch | flower_service.dart:15-25 | try-catch block ✓ |
| AppBar format | home_screen.dart:34 | 'TH3 - ${name} - ${id}' ✓ |
| Responsive | flower_card.dart:13 | GridView flexible ✓ |

---

## 💾 Pubspec Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.0
  http: ^1.1.0  # ← Cho API calls
```

---

## 🚀 Lênh CLI Hữu Ích

```bash
# Cập nhật dependencies
flutter pub get

# Phân tích code
flutter analyze

# Chạy trên emulator/simulator
flutter run

# Chạy trên Chrome
flutter run -d chrome

# Build APK (nếu cần)
flutter build apk --release

# Clean project
flutter clean
```

---

## ❓ FAQ

**Q: Làm sao để test Error UI?**
A: Mở `lib/config/api_config.dart`, set `simulateNetworkError = true`

**Q: Ảnh không hiển thị?**
A: Kiểm tra internet connection, ứng dụng dùng URL Unsplash

**Q: Làm sao để thay đổi delay loading?**
A: Mở `api_config.dart`, thay `simulatedDelay` value

**Q: Nên dùng Mock hay Real API?**
A: Mock data là tốt nhất cho bài tập, stable + nhanh

---

## 📸 About Mock Data

8 loại hoa được tạo sẵn trong `lib/data/mock_flowers.dart`:
1. Hồng Đỏ Premium (₫150k)
2. Hoa Hướng Dương (₫120k)
3. Hoa Cúc Vàng (₫85k)
4. Tulip Hồng (₫200k)
5. Hoa Lan Tím (₫250k)
6. Hoa Loa Kèn (₫95k)
7. Hoa Mẫu Đơn Cam (₫180k)
8. Hoa Cẩm Chướng (₫140k)

---

**Created for Assignment: BÀI THỰC HÀNH 3: CALL API APP**
**Theme: Flower Sales List (Danh sách bán hoa)**
**Requirements: ✅ All completed**

Good luck! 🎊
