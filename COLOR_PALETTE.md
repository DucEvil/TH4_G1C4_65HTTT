# 🌈 Bảng Màu Hoa - Color Palette

## Ánh Xạ Màu Sắc Động

Mỗi loại hoa có **2 màu**:
1. **Primary Color** - Dùng cho badge, border
2. **Accent Color** - Dùng cho button, giá

### Danh Sách Chi Tiết

#### 🌹 1. Hồng Đỏ Premium
```
Primary:  #E53935 (Đỏ tươi)
Accent:   #B71C1C (Đỏ đậm)
Hiển thị: Badge "Đỏ tươi" + Button Mua Ngay (màu đỏ)
```

#### 🌻 2. Hoa Hướng Dương
```
Primary:  #FDD835 (Vàng)
Accent:   #F57F17 (Vàng đậm)
Hiển thị: Badge "Vàng" + Button Mua Ngay (màu vàng)
```

#### 🌼 3. Hoa Cúc Vàng
```
Primary:  #FDD835 (Vàng nhạt)
Accent:   #F57F17 (Vàng đậm)
Hiển thị: Badge "Vàng nhạt" + Button Mua Ngay (màu vàng)
```

#### 💐 4. Tulip Hồng
```
Primary:  #EC407A (Hồng)
Accent:   #C2185B (Hồng đậm)
Hiển thị: Badge "Hồng" + Button Mua Ngay (màu hồng)
```

#### 🟣 5. Hoa Lan Tím
```
Primary:  #7B1FA2 (Tím đậm)
Accent:   #4A148C (Tím siêu đậm)
Hiển thị: Badge "Tím đậm" + Button Mua Ngay (màu tím)
```

#### 🌺 6. Hoa Loa Kèn
```
Primary:  #F5F5F5 (Trắng)
Accent:   #E0E0E0 (Xám nhạt)
Hiển thị: Badge "Trắng" + Button Mua Ngay (màu xám)
```

#### 🌻 7. Hoa Mẫu Đơn Cam
```
Primary:  #FB8C00 (Cam)
Accent:   #E65100 (Cam đậm)
Hiển thị: Badge "Cam" + Button Mua Ngay (màu cam)
```

#### 💗 8. Hoa Cẩm Chướng
```
Primary:  #AB47BC (Tím nhạt)
Accent:   #6A1B9A (Tím đậm)
Hiển thị: Badge "????" + Button Mua Ngay (màu tím)
```

---

## 🎨 Cách Hoạt Động

### Trên Mỗi Item Card:

```
┌─────────────────────────────┐
│  ┌─────────────────────┐   │
│  │                     │   │
│  │    Image Hoa        │   │
│  │   + Gradient        │   │  ← Gradient overlay color
│  │   + Badge "Đỏ       │   │  ← Primary color badge
│  │      tươi"          │   │
│  └─────────────────────┘   │
│                             │
│ Hồng Đỏ Premium             │
│                             │
│ ┌──────────────────────┐   │
│ │ ₫150,000  │  25 bó   │   │  ← Accent color background
│ └──────────────────────┘   │
│                             │
│ ┌──────────────────────┐   │
│ │    Mua Ngay (Đỏ)     │   │  ← Accent color button
│ └──────────────────────┘   │
└─────────────────────────────┘
     ↑ Border: Primary color
```

---

## 📝 Source Code

Chi tiết trong: `lib/constants/flower_colors.dart`

```dart
class FlowerColors {
  static const Map<String, Color> colorMap = {
    'Đỏ tươi': Color(0xFFE53935),
    'Vàng': Color(0xFFFDD835),
    // ... etc
  };

  static const Map<String, Color> accentMap = {
    'Đỏ tươi': Color(0xFFB71C1C),
    'Vàng': Color(0xFFF57F17),
    // ... etc
  };

  static Color getColor(String colorName) {
    return colorMap[colorName] ?? const Color(0xFFE91E63);
  }

  static Color getAccentColor(String colorName) {
    return accentMap[colorName] ?? const Color(0xFFC2185B);
  }
}
```

---

## 🎯 Tùy Chỉnh Màu

Để thêm loại hoa mới hoặc thay đổi màu:

1. Mở `lib/constants/flower_colors.dart`
2. Thêm vào `colorMap`:
   ```dart
   'Tên màu mới': Color(0xFFHEXCODE),
   ```
3. Thêm vào `accentMap`:
   ```dart
   'Tên màu mới': Color(0xFFHEXCODE_DARK),
   ```
4. Lưu & restart app

---

## 🌐 Hex Color Codes

Danh sách hex codes để reference:

| Tên | Hex | Appearance |
|-----|-----|------------|
| Đỏ tươi | #E53935 | 🔴 Red |
| Đỏ đậm | #B71C1C | 🔴 Dark Red |
| Vàng | #FDD835 | 🟡 Yellow |
| Vàng đậm | #F57F17 | 🟠 Dark Yellow |
| Hồng | #EC407A | 💗 Pink |
| Hồng đậm | #C2185B | 💗 Dark Pink |
| Tím đậm | #7B1FA2 | 🟣 Purple |
| Tím siêu đậm | #4A148C | 🟣 Very Dark Purple |
| Trắng | #F5F5F5 | ⚪ White |
| Xám nhạt | #E0E0E0 | ⚪ Light Gray |
| Cam | #FB8C00 | 🟠 Orange |
| Cam đậm | #E65100 | 🟠 Dark Orange |
| Tím nhạt | #AB47BC | 🟣 Light Purple |

---

## ✨ Visual Harmony

Các màu được chọn để:
- ✅ Tương ứng với loại hoa thực tế
- ✅ Có độ tương phản tốt (WCAG AA)
- ✅ Đẹp trên Material Design 3
- ✅ Thân thiện với người dùng

---

**Color System Last Updated**: 2025-03-06
