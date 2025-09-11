import os
import re

def fix_remaining_imports():
    # Fix all remaining '../' imports in screens
    screen_files = [
        'lib/screens/analytics/analytics_screen.dart',
        'lib/screens/analytics/feature_usage_screen.dart', 
        'lib/screens/analytics/system_logs_screen.dart',
        'lib/screens/auth/auth_screen.dart',
        'lib/screens/auth/splash_screen.dart',
        'lib/screens/rewards/my_cards_screen.dart',
        'lib/screens/rewards/redeem_rewards_screen.dart',
        'lib/screens/rewards/rewards_screen.dart',
        'lib/screens/settings/about_screen.dart',
        'lib/screens/settings/language_screen.dart',
        'lib/screens/settings/notification_settings_screen.dart',
        'lib/screens/settings/security_settings_screen.dart',
        'lib/screens/settings/settings_screen.dart',
        'lib/screens/user/add_waste_screen.dart',
        'lib/screens/user/main_screen.dart',
        'lib/screens/user/partner_stores_screen.dart',
        'lib/screens/user/profile_screen.dart',
        'lib/screens/user/qr_scanner_screen.dart',
        'lib/screens/user/waste_calendar_screen.dart'
    ]
    
    for file_path in screen_files:
        if os.path.exists(file_path):
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Replace '../' with '../../' for screens in subfolders
            content = re.sub(r"import '../widgets/widgets\.dart';", "import '../../widgets/widgets.dart';", content)
            content = re.sub(r"import '../services/services\.dart';", "import '../../services/services.dart';", content)
            content = re.sub(r"import '../constants/app_constants\.dart';", "import '../../constants/app_constants.dart';", content)
            content = re.sub(r"import '../providers/providers\.dart';", "import '../../providers/providers.dart';", content)
            content = re.sub(r"import '../models/models\.dart';", "import '../../models/models.dart';", content)
            
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print(f"Fixed: {file_path}")

if __name__ == "__main__":
    fix_remaining_imports()
    print("All remaining imports fixed!")