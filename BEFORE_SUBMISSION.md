# ✅ Checklist Trước Khi Nộp Bài

## 📋 Pre-Submission Checklist

Hãy kiểm tra các mục sau trước khi nộp bài:

### 👤 Thông Tin Sinh Viên
- [ ] **Cập nhật tên sinh viên** trong `lib/config/api_config.dart`
  ```dart
  static const String studentName = 'TÊN CỦA BẠN';
  ```
- [ ] **Cập nhật mã sinh viên** trong `lib/config/api_config.dart`
  ```dart
  static const String studentId = 'MÃ SV CỦA BẠN';
  ```
- [ ] Kiểm tra AppBar hiển thị đúng format: `TH3 - [Tên] - [Mã SV]`

### 🧪 Testing

#### Loading State
- [ ] Ứng dụng khởi động, xuất hiện spinner xoay
- [ ] Text "Đang tải dữ liệu..." hiển thị
- [ ] Kéo dài ~2 giây rồi dữ liệu xuất hiện

#### Success State
- [ ] Danh sách hoa hiển thị trong GridView 2 cột
- [ ] Mỗi card có: ảnh, tên, giá, màu, số lượng, nút Mua
- [ ] Có thể scroll xuống xem tất cả 8 loại hoa
- [ ] Nút FAB (Refresh) có thể click

#### Error State (Optional - để test)
1. Mở `lib/config/api_config.dart`
2. Set `simulateNetworkError = true`
3. Chạy lại ứng dụng
4. Kiểm tra:
   - [ ] Icon lỗi + thông báo lỗi hiển thị
   - [ ] Nút "Thử lại" có thể click
   - [ ] Click "Thử lại" → dữ liệu tải lại (Success)
5. Đổi lại `simulateNetworkError = false`

#### Responsive Test
- [ ] Chạy trên Chrome: `flutter run -d chrome`
- [ ] Bấm F12 để mở DevTools
- [ ] Thay đổi kích thước cửa sổ
- [ ] GridView tự động điều chỉnh

### 🔍 Code Review
- [ ] Tất cả file đã được tạo:
  - [ ] `lib/main.dart` ✓
  - [ ] `lib/config/api_config.dart` ✓
  - [ ] `lib/models/flower_model.dart` ✓
  - [ ] `lib/services/flower_service.dart` ✓
  - [ ] `lib/screens/home_screen.dart` ✓
  - [ ] `lib/widgets/flower_card.dart` ✓
  - [ ] `lib/widgets/error_widget.dart` ✓
  - [ ] `lib/data/mock_flowers.dart` ✓

- [ ] Code không có error
  - Chạy `flutter analyze` - không có issues

- [ ] Try-catch được dùng đúng
  - Trong `flower_service.dart`, phương thức `fetchFlowers()` có try-catch block

- [ ] FutureBuilder xử lý 3 states
  - Loading: snapshot.connectionState == waiting
  - Success: snapshot.hasData
  - Error: snapshot.hasError

### 📦 Dependencies
- [ ] Chạy `flutter pub get` thành công
- [ ] Không có missing packages

### 🎨 UI/UX
- [ ] **AppBar**: Màu hồng, text rõ ràng
- [ ] **GridView**: 2 cột, responsive
- [ ] **Cards**: Có padding, spacing, rounded corners
- [ ] **Loading**: Spinner + text
- [ ] **Error**: Icon + message + Retry button
- [ ] **Font size**: Hợp lý, dễ đọc
- [ ] Không có typo, text lệch lạc

### 📱 Performance
- [ ] Ứng dụng chạy mượt mà
- [ ] Không có lag khi scroll
- [ ] Ảnh load được
- [ ] Không có console errors (orange/red warnings)

### 🚀 Final Steps
- [ ] Xóa file rác: `lib/main_new.dart` (nếu có)
- [ ] Chạy `flutter clean` để cleanup
- [ ] Test lại toàn bộ:
  ```bash
  flutter pub get
  flutter run
  ```
- [ ] Mọi thứ hoạt động ✅

---

## 📝 Yêu Cầu Bài Tập - Tick Lại

| Yêu Cầu | Tick | 
|---------|------|
| ✅ Bỏ Counter App | [ ] |
| ✅ Danh sách bán hoa | [ ] |
| ✅ Loading state | [ ] |
| ✅ Success state | [ ] |
| ✅ Error state + Retry | [ ] |
| ✅ Try-catch exception | [ ] |
| ✅ AppBar format "TH3 - Name - ID" | [ ] |
| ✅ Tách file (Models/Services/Screens/Widgets) | [ ] |
| ✅ Responsive design | [ ] |
| ✅ 2 items per row (GridView) | [ ] |

---

## 🎯 Nộp Bài

Khi mọi thứ đã sẵn sàng:

1. **Commit code** (nếu dùng Git):
   ```bash
   git add .
   git commit -m "BÀI THỰC HÀNH 3: Call API App - Danh Sách Bán Hoa"
   git push
   ```

2. **File/Folder để nộp**:
   - Toàn bộ thư mục project: `flutter_application_2/`
   - Hoặc chỉ thư mục `lib/` + `pubspec.yaml`

3. **Thông tin bổ sung**:
   - Tên sinh viên
   - Mã sinh viên  
   - Ngày nộp
   - Liên kết GitHub (nếu có)

---

## 💡 Tips

1. **Nếu quên cập nhật tên/mã SV**: 
   - Mở `lib/config/api_config.dart`
   - Thay đổi `studentName` và `studentId`
   - Rerun ứng dụng

2. **Nếu muốn test Error State**:
   - Mở `lib/config/api_config.dart`
   - Set `simulateNetworkError = true`
   - Chạy lại, click Retry để kiểm tra

3. **Nếu có lỗi compile**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

4. **Để gửi lại**:
   - Push code mới lên
   - Ghi chú những thay đổi

---

## 🎉 Lời Chúc

Chúc bạn nộp bài thành công!

Ứng dụng của bạn đã có:
- ✅ UI chuyên nghiệp
- ✅ Xử lý 3 states (Loading, Success, Error)
- ✅ Code tổ chức tốt
- ✅ Error handling đúng cách
- ✅ Responsive design
- ✅ Dữ liệu mock sẵn

**Chỉ cần thay tên/mã SV là xong!**

Good luck! 🌸
