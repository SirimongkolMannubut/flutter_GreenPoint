# โครงสร้างโปรเจค GreenPoint

## 📁 โครงสร้างไฟล์

```
lib/
├── 📁 config/           # การตั้งค่าแอป
│   └── api_config.dart
├── 📁 constants/        # ค่าคงที่
│   └── app_constants.dart
├── 📁 models/          # โมเดลข้อมูล
│   ├── activity.dart
│   ├── admin.dart
│   ├── partner_store.dart
│   ├── user.dart
│   ├── waste_entry.dart
│   └── models.dart     # Export ทั้งหมด
├── 📁 providers/       # State Management
│   ├── admin_provider.dart
│   ├── api_store_provider.dart
│   ├── api_user_provider.dart
│   ├── settings_provider.dart
│   ├── store_provider.dart
│   ├── user_provider.dart
│   ├── waste_provider.dart
│   └── providers.dart  # Export ทั้งหมด
├── 📁 screens/         # หน้าจอแอป
│   ├── 📁 admin/       # หน้าจอแอดมิน
│   │   ├── admin_add_points_screen.dart
│   │   ├── admin_add_store_screen.dart
│   │   ├── admin_dashboard_screen.dart
│   │   ├── admin_login_screen.dart
│   │   ├── admin_settings_screen.dart
│   │   └── user_management_screen.dart
│   ├── 📁 analytics/   # หน้าจอสถิติ
│   │   ├── analytics_screen.dart
│   │   ├── feature_usage_screen.dart
│   │   └── system_logs_screen.dart
│   ├── 📁 auth/        # หน้าจอเข้าสู่ระบบ
│   │   ├── auth_screen.dart
│   │   └── splash_screen.dart
│   ├── 📁 rewards/     # หน้าจอรางวัล
│   │   ├── my_cards_screen.dart
│   │   ├── redeem_rewards_screen.dart
│   │   └── rewards_screen.dart
│   ├── 📁 settings/    # หน้าจอตั้งค่า
│   │   ├── about_screen.dart
│   │   ├── language_screen.dart
│   │   ├── notification_settings_screen.dart
│   │   ├── security_settings_screen.dart
│   │   └── settings_screen.dart
│   ├── 📁 user/        # หน้าจอผู้ใช้
│   │   ├── add_waste_screen.dart
│   │   ├── home_screen.dart
│   │   ├── main_screen.dart
│   │   ├── partner_stores_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── qr_scanner_screen.dart
│   │   └── waste_calendar_screen.dart
│   └── screens.dart    # Export ทั้งหมด
├── 📁 services/        # บริการต่างๆ
│   ├── 📁 auth/        # บริการเข้าสู่ระบบ
│   │   ├── google_auth_service.dart
│   │   └── security_service.dart
│   ├── 📁 data/        # บริการข้อมูล
│   │   ├── analytics_service.dart
│   │   ├── api_service.dart
│   │   └── storage_service.dart
│   ├── 📁 external/    # บริการภายนอก
│   │   ├── email_service.dart
│   │   ├── firebase_email_service.dart
│   │   ├── localization_service.dart
│   │   └── notification_service.dart
│   └── services.dart   # Export ทั้งหมด
├── 📁 utils/           # ฟังก์ชันช่วย
│   ├── 📁 formatters/  # จัดรูปแบบข้อมูล
│   ├── 📁 helpers/     # ฟังก์ชันช่วย
│   └── 📁 validators/  # ตรวจสอบข้อมูล
├── 📁 widgets/         # Widget ที่ใช้ซ้ำ
│   ├── 📁 cards/       # Card widgets
│   │   ├── points_card.dart
│   │   ├── stats_overview.dart
│   │   └── waste_entry_card.dart
│   ├── 📁 common/      # Widget ทั่วไป
│   │   ├── common_app_bar.dart
│   │   ├── greenpoint_logo.dart
│   │   └── localized_text.dart
│   ├── 📁 ui/          # UI widgets
│   │   ├── activity_grid.dart
│   │   ├── custom_qr_icon.dart
│   │   └── level_progress.dart
│   └── widgets.dart    # Export ทั้งหมด
└── main.dart           # จุดเริ่มต้นแอป
```

## 🎯 วิธีใช้งาน

### Import แบบง่าย
```dart
// แทนที่จะ import หลายไฟล์
import '../screens/auth/auth_screen.dart';
import '../screens/user/home_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';

// ใช้แค่บรรทัดเดียว
import '../screens/screens.dart';
```

### Import ตามหมวดหมู่
```dart
// Models
import '../models/models.dart';

// Providers
import '../providers/providers.dart';

// Services
import '../services/services.dart';

// Widgets
import '../widgets/widgets.dart';
```

## 📋 หลักการจัดระเบียบ

1. **จัดกลุ่มตามหน้าที่** - แยกไฟล์ตามความรับผิดชอบ
2. **ใช้ index files** - สร้างไฟล์ export เพื่อ import ง่าย
3. **โครงสร้างชัดเจน** - ตั้งชื่อโฟลเดอร์ให้เข้าใจง่าย
4. **แยกตามผู้ใช้** - แยกหน้าจอ admin, user, settings
5. **จัดกลุ่ม widgets** - แยก common, cards, ui

## 🔧 ประโยชน์

- **หาไฟล์ง่าย** - รู้ทันทีว่าไฟล์อยู่ที่ไหน
- **Import สะดวก** - ใช้ index files
- **บำรุงรักษาง่าย** - โครงสร้างชัดเจน
- **ทำงานเป็นทีม** - ทุกคนเข้าใจโครงสร้าง
- **ขยายง่าย** - เพิ่มฟีเจอร์ใหม่ได้ง่าย