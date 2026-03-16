import 'package:flutter/material.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorDisplayWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  bool get _isNetworkError {
    final lower = error.toLowerCase();
    return lower.contains('kết nối') ||
        lower.contains('internet') ||
        lower.contains('wifi') ||
        lower.contains('mạng') ||
        lower.contains('socket') ||
        lower.contains('timeout') ||
        lower.contains('network');
  }

  @override
  Widget build(BuildContext context) {
    final isNetwork = _isNetworkError;
    final iconData = isNetwork ? Icons.wifi_off_rounded : Icons.error_outline;
    final bgColor = isNetwork ? Colors.orange : Colors.red;
    final title = isNetwork ? 'Không có kết nối mạng' : 'Oops! Có lỗi xảy ra';
    final helperText = isNetwork
        ? 'Vui lòng bật WiFi hoặc dữ liệu di động rồi thử lại'
        : 'Kiểm tra kết nối Internet và thử lại';

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: bgColor.shade50,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(iconData, size: 60, color: bgColor.shade600),
              ),
              const SizedBox(height: 24),

              // Error title
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: bgColor.shade600,
                ),
              ),
              const SizedBox(height: 16),

              // Error message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: bgColor.shade200, width: 1.5),
                ),
                child: Text(
                  error,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: bgColor.shade700,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Retry button M3
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Thử Lại'),
                style: FilledButton.styleFrom(
                  backgroundColor: bgColor.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Helper text
              Text(
                helperText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
