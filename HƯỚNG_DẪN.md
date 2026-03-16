# 📖 Hướng Dẫn Tùy Chỉnh & Testing

## 🎓 Cập Nhật Thông Tin Sinh Viên

Tạo file `lib/config/api_config.dart` và cập nhật các thông tin sau:

```dart
/// Configuration để chuyển đổi giữa Real API và Mock API
class ApiConfig {
  // CÁCH 1: Test với Mock Data (Mặc định)
  static const bool useMockData = true;
  
  // CÁCH 2: Test Error UI (mô phỏng lỗi mạng)
  static const bool simulateNetworkError = false;
  
  // Độ trễ khi tải dữ liệu (milliseconds) - thay đổi để test loading
  static const int simulatedDelay = 2000;
  
  /// ⭐ CẬP NHẬT THÔNG TIN SINH VIÊN TẠI ĐÂY
  static const String studentName = 'Nguyễn Văn A';      // Thay tên sinh viên
  static const String studentId = 'SV001';               // Thay mã sinh viên
  static const String appBarTitle = 'TH3';
}
```

## 🧪 Các Cách Testing

### 1️⃣ **Test Normal Flow (Thành công)**
```dart
static const bool useMockData = true;
static const bool simulateNetworkError = false;
static const int simulatedDelay = 2000;  // Loading 2s
```
👉 Kết quả: Hiển thị danh sách hoa, có loading spinner 2 giây

### 2️⃣ **Test Error UI (Thất bại/Mất mạng)**
```dart
static const bool useMockData = true;
static const bool simulateNetworkError = true;  // ← Bật lỗi
static const int simulatedDelay = 1000;
```
👉 Kết quả: Hiển thị lỗi + nút "Thử lại"

### 3️⃣ **Test Loading State Lâu**
```dart
static const int simulatedDelay = 5000;  // Loading 5s
```
👉 Kết quả: Spinner hiển thị lâu hơn để kiểm tra UX

### 4️⃣ **Không Delay (Nhanh nhất)**
```dart
static const int simulatedDelay = 0;  // Không delay
```
👉 Kết quả: Dữ liệu hiển thị ngay lập tức

## 🚀 Chạy Ứng Dụng

### Trên Emulator Android:
```bash
flutter run
```

### Trên Web Browser (Chrome):
```bash
flutter run -d chrome
```

### Trên iOS Simulator (nếu có Mac):
```bash
flutter run -d macos
```

## 📋 Cấu Trúc File Đã Tạo

```
lib/
├── main.dart                          # ✅ Entry point
├── config/
│   └── api_config.dart               # ✅ Config & thông tin SV
├── data/
│   └── mock_flowers.dart             # ✅ Dữ liệu mock
├── models/
│   └── flower_model.dart             # ✅ Model Flower
├── services/
│   └── flower_service.dart           # ✅ API / Fetch data
├── screens/
│   └── home_screen.dart              # ✅ Screen chính
└── widgets/
    ├── flower_card.dart              # ✅ Widget item
    └── error_widget.dart             # ✅ Widget error
```

## ✅ Kiểm Tra Yêu Cầu Bài Tập

| Yêu Cầu | Trạng Thái |
|---------|-----------|
| ✅ Danh sách bán hoa | ✓ GridView 2 cột |
| ✅ Loading state | ✓ CircularProgressIndicator |
| ✅ Success state | ✓ Hiển thị Model data |
| ✅ Error state | ✓ Lỗi + Retry button |
| ✅ Tách file | ✓ Models, Services, Screens, Widgets |
| ✅ Try-catch | ✓ Bắt exception trong `FlowerService` |
| ✅ AppBar format | ✓ "TH3 - [Tên] - [Mã SV]" |
| ✅ Responsive | ✓ Tự điều chỉnh khi resize |

## 🎨 Giao Diện

- **AppBar**: Màu hồng (`Colors.pink.shade400`)
- **Items**: Card layout với ảnh, tên, giá, màu, số lượng
- **FAB**: Nút làm mới dữ liệu
- **Loading**: Vòng xoay + text "Đang tải dữ liệu..."
- **Error**: Icon lỗi + thông báo + nút Thử lại

## 💡 Tips

1. **Để test Error UI**: Set `simulateNetworkError = true` trong `api_config.dart`
2. **Để test Loading lâu**: Tăng `simulatedDelay` lên 5000ms
3. **Để không delay**: Set `simulatedDelay = 0`
4. **Để clear error**: Bấm nút FloatingActionButton (Refresh)
5. **Để add retry**: Bấm nú "Thử lại" trong Error UI

---

📝 **Lưu ý**: Hãy cập nhật `studentName` và `studentId` tại `lib/config/api_config.dart` trước khi nộp bài!
