/// Configuration để chuyển đổi giữa Real API và Mock API
class ApiConfig {
  /// Bật giả lập lỗi mạng
  static const bool simulateNetworkError = false;

  /// Set to true để sử dụng local mock data thay vì API thực
  static const bool useMockData = true;

  /// Set to true để bỏ qua việc tải ảnh từ Wikipedia (khi không có mạng)
  static const bool skipWikiImages = true;

  /// Delay thêm (milliseconds) để test Loading state
  static const int simulatedDelay = 0;

  /// Thông tin sinh viên - CẬP NHẬT TẠI ĐÂY
  static const String studentName = 'Đỗ Đình Đức';
  static const String studentId = '2351160510';
  static const String appBarTitle = 'TH3';
}
