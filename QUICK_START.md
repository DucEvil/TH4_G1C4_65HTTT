# ⚡ QUICK START - Danh Sách Bán Hoa

## 🚀 Chạy Liền

```bash
# 1. Terminal di chuyển vào project
cd "g:\Android Project\flutter_application_2"

# 2. Cập nhật dependencies
flutter pub get

# 3. Chạy ứng dụng
flutter run      # Android/iOS emulator
# hoặc
flutter run -d chrome  # Web browser
```

---

## 📱 Màn Hình Chính

- **AppBar**: TH3 - [Tên] - [Mã SV] (màu hồng)
- **Content**: GridView 2 cột (responsive)
- **Items**: Card với ảnh, tên, giá, màu, số lượng, nút Mua
- **FAB** (Nút góc phải): Refresh dữ liệu

---

## 🎯 3 States Chính

### 1. Loading
```
🔄 Vòng xoay
📝 "Đang tải dữ liệu..."
```

### 2. Success ✅
```
📋 Hiển thị 8 loại hoa
🖼️ Mỗi item có ảnh từ Unsplash
💰 Giá: ₫85k - ₫250k
🏷️ Màu sắc & số lượng tồn kho
```

### 3. Error ❌
```
⚠️ Icon lỗi đỏ
📄 Thông báo lỗi chi tiết
🔘 Nút "Thử lại"
```

---

## 🔧 Cấu Hình (lib/config/api_config.dart)

### Normal (Mặc định)
```dart
simulateNetworkError = false   // Không lỗi
useMockData = true              // Dùng mock data
simulatedDelay = 2000           // Loading 2s
```

### Test Error UI
```dart
simulateNetworkError = true    // ← Bật lỗi
useMockData = true
simulatedDelay = 1000
```

### Test Loading
```dart
simulateNetworkError = false
simulatedDelay = 5000          // Loading 5s (kiểm tra spinner)
```

---

## 📁 File Quan Trọng

| File | Chức Năng |
|------|----------|
| `lib/main.dart` | Entry point app |
| `lib/config/api_config.dart` | **⭐ Cập nhật tên SV ở đây** |
| `lib/screens/home_screen.dart` | Screen chính + FutureBuilder |
| `lib/services/flower_service.dart` | Fetch API + error handling |
| `lib/models/flower_model.dart` | Data model |
| `lib/widgets/flower_card.dart` | Item card UI |
| `lib/widgets/error_widget.dart` | Error display |
| `lib/data/mock_flowers.dart` | Mock data (8 loại hoa) |

---

## ✅ Yêu Cầu - Kiểm Tra Danh Sách

- [ ] Cập nhật tên sin viên trong `api_config.dart`
- [ ] GridView 2 cột hiển thị đúng
- [ ] Loading spinner hiển thị lúc đầu
- [ ] Success state: Hiển thị danh sách hoa
- [ ] Error state: Bật `simulateNetworkError = true` & kiểm tra
- [ ] Retry button: Click nút "Thử lại" hoặc FAB để tải lại
- [ ] Code tách file: models/, services/, screens/, widgets/ ✓
- [ ] Try-catch: Trong FlowerService.fetchFlowers() ✓
- [ ] AppBar format: "TH3 - [Tên] - [Mã SV]" ✓
- [ ] Responsive: Test trên Chrome browser (F12 resize)

---

## 🎨 Màu Sắc & Design

- **AppBar**: `Colors.pink.shade400`
- **Primary**: Hồng (Pink)
- **Loading**: Vòng xoay hồng + text ghế
- **Error**: Đỏ + icon `Icons.error_outline`
- **Card**: Rounded 12px + elevation 4
- **Font**: Default Flutter (Roboto)

---

## 📞 Troubleshoot

**Ứng dụng không build?**
→ `flutter clean` → `flutter pub get` → `flutter run`

**Ảnh không hiển thị?**
→ Kiểm tra internet connection
→ Xóa app → reinstall

**Hot reload không work?**
→ Bấm `r` trong terminal hoặc hot restart `R`

**Lỗi kompilasi?**
→ Chạy `flutter analyze` để xem chi tiết
→ Hoặc `flutter clean && flutter pub get`

---

## 🎓 Điều Cần Biết

1. **Mock Data**: 8 loại hoa, dễ test
2. **Config**: Một file để tùy chỉnh tất cả (tên, lỗi, delay)
3. **Error UI**: Full error handling + retry logic
4. **Responsive**: Auto adjust trên web + emulator
5. **Try-catch**: Exception handling an toàn

---

**Lưu ý**: Nhớ cập nhật `studentName` & `studentId` trước khi nộp!

Good luck! 🌸
