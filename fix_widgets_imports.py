import os
import re

def fix_widget_imports(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Fix imports for widgets
    replacements = [
        (r"import '../constants/app_constants.dart';", "import '../../constants/app_constants.dart';"),
        (r"import '../models/", "import '../../models/models.dart';"),
        (r"import '../providers/", "import '../../providers/providers.dart';"),
        (r"import 'greenpoint_logo.dart';", "import 'greenpoint_logo.dart';"),  # Keep relative imports within same folder
    ]
    
    # Apply replacements
    for pattern, replacement in replacements:
        if 'models/' in pattern:
            content = re.sub(r"import '../models/[^']+\.dart';", replacement, content)
        elif 'providers/' in pattern:
            content = re.sub(r"import '../providers/[^']+\.dart';", replacement, content)
        else:
            content = content.replace(pattern, replacement)
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

# Fix all dart files in widgets
for root, dirs, files in os.walk('lib/widgets'):
    for file in files:
        if file.endswith('.dart') and file != 'widgets.dart':
            file_path = os.path.join(root, file)
            fix_widget_imports(file_path)
            print(f"Fixed: {file_path}")

print("Widget imports fixed!")