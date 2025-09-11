import os
import re

def fix_screen_imports(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Fix relative screen imports within same folder
    content = re.sub(r"import '([^']+_screen\.dart)';", r"import '\1';", content)
    content = re.sub(r"import 'main_screen\.dart';", "import 'main_screen.dart';", content)
    content = re.sub(r"import 'auth_screen\.dart';", "import 'auth_screen.dart';", content)
    content = re.sub(r"import 'admin_login_screen\.dart';", "import 'admin_login_screen.dart';", content)
    
    # Fix cross-folder screen imports to use ../screens.dart
    if '/auth/' in file_path:
        content = re.sub(r"import 'main_screen\.dart';", "import '../screens.dart';", content)
        content = re.sub(r"import 'admin_login_screen\.dart';", "import '../screens.dart';", content)
    
    # Fix admin dashboard imports
    if 'admin_dashboard_screen.dart' in file_path:
        content = re.sub(r"import 'user_management_screen\.dart';", "import 'user_management_screen.dart';", content)
        content = re.sub(r"import 'admin_settings_screen\.dart';", "import 'admin_settings_screen.dart';", content)
        content = re.sub(r"import 'analytics_screen\.dart';", "import '../analytics/analytics_screen.dart';", content)
        content = re.sub(r"import 'feature_usage_screen\.dart';", "import '../analytics/feature_usage_screen.dart';", content)
        content = re.sub(r"import 'system_logs_screen\.dart';", "import '../analytics/system_logs_screen.dart';", content)
        content = re.sub(r"import 'admin_add_points_screen\.dart';", "import 'admin_add_points_screen.dart';", content)
        content = re.sub(r"import 'admin_add_store_screen\.dart';", "import 'admin_add_store_screen.dart';", content)
    
    # Fix settings screen imports
    if 'settings_screen.dart' in file_path:
        content = re.sub(r"import 'language_screen\.dart';", "import 'language_screen.dart';", content)
        content = re.sub(r"import 'notification_settings_screen\.dart';", "import 'notification_settings_screen.dart';", content)
        content = re.sub(r"import 'security_settings_screen\.dart';", "import 'security_settings_screen.dart';", content)
        content = re.sub(r"import 'about_screen\.dart';", "import 'about_screen.dart';", content)
    
    # Fix user profile screen import
    if 'profile_screen.dart' in file_path:
        content = re.sub(r"import 'settings_screen\.dart';", "import '../settings/settings_screen.dart';", content)
    
    # Fix rewards screen imports
    if 'rewards_screen.dart' in file_path:
        content = re.sub(r"import 'redeem_rewards_screen\.dart';", "import 'redeem_rewards_screen.dart';", content)
        content = re.sub(r"import 'my_cards_screen\.dart';", "import 'my_cards_screen.dart';", content)
    
    # Fix user main screen imports
    if 'main_screen.dart' in file_path and '/user/' in file_path:
        content = re.sub(r"import 'home_screen\.dart';", "import 'home_screen.dart';", content)
        content = re.sub(r"import 'profile_screen\.dart';", "import 'profile_screen.dart';", content)
        content = re.sub(r"import 'rewards_screen\.dart';", "import '../rewards/rewards_screen.dart';", content)
    
    # Fix waste calendar screen import
    if 'waste_calendar_screen.dart' in file_path:
        content = re.sub(r"import 'add_waste_screen\.dart';", "import 'add_waste_screen.dart';", content)
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

# Fix all dart files in screens
for root, dirs, files in os.walk('lib/screens'):
    for file in files:
        if file.endswith('.dart') and file != 'screens.dart':
            file_path = os.path.join(root, file)
            fix_screen_imports(file_path)
            print(f"Fixed: {file_path}")

print("Screen imports fixed!")