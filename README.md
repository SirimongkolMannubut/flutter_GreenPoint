GreenPoint App
แอปพลิเคชัน Flutter สำหรับการสะสมแต้มจากการลดขยะและลดการใช้ถุงพลาสติก พร้อมระบบรางวัลรายเดือนและคูปองส่วนลดจากร้านค้าพันธมิตร
API ที่เรียกใช้

https://github.com/ItzSakkarinTH/HarukiApi
Google Authentication API
Google Maps API

📱 ฟีเจอร์หลัก

ระบบสะสมแต้ม (Point System)

รับแต้มจากการไม่รับถุงพลาสติก
รับแต้มจากการลดการใช้ทรัพยากร
ติดตามประวัติการรับแต้ม
แสดงยอดแต้มสะสมทั้งหมด


ระบบรางวัล (Reward System)

ลุ้นรางวัลรายเดือนจากแต้มสะสม
แลกคูปองส่วนลดจากร้านค้า
แสดงรายการรางวัลที่ได้รับ
ประวัติการแลกรางวัล


Authentication System

เข้าสู่ระบบด้วย Google Account
ระบบจัดการผู้ใช้
ออกจากระบบ


แผนที่และร้านค้า (Map & Stores)

แสดงแผนที่ร้านค้าพันธมิตร
ค้นหาร้านค้าใกล้เคียง
รายละเอียดร้านค้าและโปรโมชั่น


โปรไฟล์ผู้ใช้ (User Profile)

ข้อมูลส่วนตัว
ประวัติการใช้งาน
สถิติการลดขยะ



🏗️ โครงสร้างโปรเจ็กต์
lib/
├── components/          # UI Components ที่ใช้ซ้ำ
│   ├── point_card.dart      # แสดงยอดแต้ม
│   ├── reward_card.dart     # การ์ดรางวัล
│   └── store_card.dart      # การ์ดร้านค้า
├── controllers/         # State Management Controllers
│   ├── auth_controller.dart      # จัดการ Authentication
│   ├── point_controller.dart     # จัดการแต้มสะสม
│   ├── reward_controller.dart    # จัดการรางวัล
│   └── map_controller.dart       # จัดการแผนที่
├── models/              # Data Models
│   ├── user_model.dart
│   ├── point_model.dart
│   ├── reward_model.dart
│   └── store_model.dart
├── routes/              # การจัดการ Routes
│   ├── app_pages.dart       # กำหนด Pages และ Bindings
│   └── app_routes.dart      # กำหนดชื่อ Routes
├── screens/             # หน้าจอต่างๆ
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── home_screen.dart
│   ├── points/
│   │   ├── points_screen.dart
│   │   └── points_history_screen.dart
│   ├── rewards/
│   │   ├── rewards_screen.dart
│   │   ├── reward_detail_screen.dart
│   │   └── my_rewards_screen.dart
│   ├── map/
│   │   ├── map_screen.dart
│   │   └── store_detail_screen.dart
│   └── profile/
│       ├── profile_screen.dart
│       └── statistics_screen.dart
├── services/            # Services สำหรับการจัดการข้อมูล
│   ├── api_service.dart         # API Service
│   ├── auth_service.dart        # Google Auth Service
│   ├── storage_service.dart     # Local Storage Service
│   └── location_service.dart    # Location Service
├── utils/               # Utilities และ Helpers
│   ├── api.dart             # API Configuration
│   ├── constants.dart       # Constants
│   └── helpers.dart         # Helper Functions
└── main.dart            # Entry Point
🛠️ เทคโนโลยีที่ใช้
Dependencies หลัก

Flutter SDK ^3.8.1 - Framework หลัก
GetX ^4.7.2 - State Management, Routing, และ Dependency Injection
Hive ^2.2.3 - NoSQL Database สำหรับ Local Storage
HTTP ^1.5.0 - HTTP Client สำหรับเรียก API
Google Sign In ^6.1.5 - Google Authentication
Google Maps Flutter ^2.5.0 - แสดงแผนที่
Geolocator ^10.1.0 - Location Service
Path Provider ^2.1.4 - จัดการ File Path

Dev Dependencies

Flutter Test - Testing Framework
Flutter Lints ^5.0.0 - Code Analysis และ Linting

🎨 UI/UX Features

Material Design - ใช้ Material Design Components
Custom Theme - ธีมสีเขียวเพื่อสิ่งแวดล้อม
Responsive Design - ปรับขนาดได้กับหน้าจอต่างๆ
Smooth Animations - Animation ที่ลื่นไหล
Interactive Maps - แผนที่แบบ Interactive
Loading States - แสดงสถานะการโหลด
Error Handling - จัดการข้อผิดพลาดอย่างเหมาะสม

🚀 การติดตั้งและรัน
ความต้องการของระบบ

Flutter SDK ^3.8.1
Dart SDK
Android Studio หรือ VS Code
Android/iOS Emulator หรืออุปกรณ์จริง
Google Maps API Key
Google OAuth Client ID

ขั้นตอนการติดตั้ง

Clone Repository

bash   git clone https://github.com/SirimongkolMannubut/flutter_GreenPoint.git
   cd flutter_GreenPoint

ติดตั้ง Dependencies

bash   flutter pub get

ตั้งค่า API Keys
สร้างไฟล์ lib/utils/api_keys.dart:

dart   const String GOOGLE_MAPS_API_KEY = 'YOUR_GOOGLE_MAPS_API_KEY';
   const String GOOGLE_CLIENT_ID = 'YOUR_GOOGLE_CLIENT_ID';

รันแอป

bash   flutter run
🔧 การตั้งค่า
API Configuration
แก้ไขไฟล์ lib/utils/api.dart เพื่อตั้งค่า API Endpoint:
dartconst String BASE_URL = 'https://haruki-api-domain.com';
const String POINTS_ENDPOINT = '/api/points';
const String REWARDS_ENDPOINT = '/api/rewards';
const String STORES_ENDPOINT = '/api/stores';
Google Maps Setup
Android
เพิ่ม API Key ใน android/app/src/main/AndroidManifest.xml:
xml<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
iOS
เพิ่ม API Key ใน ios/Runner/AppDelegate.swift:
swiftGMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
Assets

ไอคอนและรูปภาพอยู่ในโฟลเดอร์ assets/images/
รองรับไฟล์: logo.png, green_bg.png, reward_icons/

📋 ฟีเจอร์โดยละเอียด
1. Point System

การรับแต้ม

สแกน QR Code ที่ร้านค้า
ยืนยันการไม่รับถุงพลาสติก
รับแต้มอัตโนมัติ


ติดตามแต้ม

แสดงยอดแต้มปัจจุบัน
ประวัติการรับแต้ม
แต้มที่หมดอายุ



2. Reward System

ประเภทรางวัล

รางวัลรายเดือน (ลุ้นด้วยแต้ม)
คูปองส่วนลด (แลกด้วยแต้ม)
ของรางวัลพิเศษ


การจัดการรางวัล

แสดงรางวัลที่มี
แลกรางวัล
ใช้งานคูปอง
ประวัติรางวัล



3. Map & Store Locator

แสดงร้านค้าพันธมิตรบนแผนที่
ค้นหาร้านค้าใกล้เคียง
เส้นทางไปร้านค้า
รายละเอียดร้านค้าและโปรโมชั่น

4. User Profile

ข้อมูลผู้ใช้
สถิติการลดขยะ
ระดับผู้ใช้ (Level System)
Achievement/Badges
ตั้งค่าการแจ้งเตือน

🧪 การทดสอบ
bash# รันการทดสอบ
flutter test

# ตรวจสอบ Code Quality
flutter analyze

# รัน Integration Tests
flutter test integration_test
📱 Platform Support

✅ Android (API 21+)
✅ iOS (iOS 12+)
⚠️ Web (Limited - no maps)
❌ Desktop (Not Supported)

🔒 Security Features

Google OAuth Authentication
Secure Token Storage
API Request Encryption
Input Validation
Secure Local Storage (Hive Encryption)
Auto-logout on Token Expiry

🌱 การมีส่วนร่วมกับสิ่งแวดล้อม
GreenPoint ช่วยลดขยะพลาสติกโดย:

✅ ส่งเสริมการไม่ใช้ถุงพลาสติก
✅ ให้รางวัลกับพฤติกรรมที่เป็นมิตรกับสิ่งแวดล้อม
✅ สร้างชุมชนคนรักษ์โลก
✅ ติดตามสถิติการลดขยะ

🤝 การพัฒนาต่อ
Roadmap

 ระบบ Social Feed
 Challenge รายเดือน
 Leaderboard
 Push Notifications
 Dark Mode
 Multi-language Support

Code Style

ใช้ Flutter/Dart conventions
ใส่ comments เป็นภาษาไทยและอังกฤษ
ตัวแปรและฟังก์ชันเป็นภาษาอังกฤษ

Git Workflow
bash# ตัวอย่าง commit messages
git commit -m "feat: add monthly lottery system"
git commit -m "fix: handle point redemption error"
git commit -m "refactor: improve map performance"
🐛 ปัญหาที่พบบ่อย
Google Maps ไม่แสดง

ตรวจสอบ API Key
เปิดใช้งาน Maps SDK ใน Google Cloud Console
ตรวจสอบ Billing Account

Google Sign In ล้มเหลว

ตรวจสอบ SHA-1 fingerprint
ตรวจสอบ OAuth Client ID
ตั้งค่า Consent Screen

📄 License
สามารถใช้เพื่อการศึกษาและพัฒนาได้อย่างอิสระ
👨‍💻 ผู้พัฒนา
โดย Sirimongkol Mannubut
GitHub: @SirimongkolMannubut
🙏 Credits

HarukiApi - Backend API โดย @ItzSakkarinTH
Google Maps Platform - Map Services
Flutter Team - Framework


📞 การติดต่อและสนับสนุน
หากมีคำถามหรือปัญหาในการใช้งาน สามารถสร้าง Issue ในโปรเจ็กต์นี้ได้
Together, Let's Make Earth Greener! 🌍💚
