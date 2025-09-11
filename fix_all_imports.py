import os
import re

def fix_imports_in_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Determine the correct path prefix based on file location
    if '/admin/' in file_path:
        prefix = '../../'
    elif '/analytics/' in file_path:
        prefix = '../../'
    elif '/auth/' in file_path:
        prefix = '../../'
    elif '/rewards/' in file_path:
        prefix = '../../'
    elif '/settings/' in file_path:
        prefix = '../../'
    elif '/user/' in file_path:
        prefix = '../../'
    else:
        prefix = '../'
    
    # Fix imports
    replacements = [
        (r"import '../constants/app_constants.dart';", f"import '{prefix}constants/app_constants.dart';"),
        (r"import '../models/", f"import '{prefix}models/models.dart';"),
        (r"import '../providers/", f"import '{prefix}providers/providers.dart';"),
        (r"import '../services/", f"import '{prefix}services/services.dart';"),
        (r"import '../widgets/", f"import '{prefix}widgets/widgets.dart';"),
    ]
    
    # Apply replacements
    for pattern, replacement in replacements:
        if 'models/' in pattern:
            # Replace all model imports with single models.dart import
            content = re.sub(r"import '../models/[^']+\.dart';", replacement, content)
        elif 'providers/' in pattern:
            # Replace all provider imports with single providers.dart import
            content = re.sub(r"import '../providers/[^']+\.dart';", replacement, content)
        elif 'services/' in pattern:
            # Replace all service imports with single services.dart import
            content = re.sub(r"import '../services/[^']+\.dart';", replacement, content)
        elif 'widgets/' in pattern:
            # Replace all widget imports with single widgets.dart import
            content = re.sub(r"import '../widgets/[^']+\.dart';", replacement, content)
        else:
            content = re.sub(pattern, replacement, content)
    
    # Remove duplicate imports
    lines = content.split('\n')
    seen_imports = set()
    new_lines = []
    
    for line in lines:
        if line.strip().startswith('import '):
            if line not in seen_imports:
                seen_imports.add(line)
                new_lines.append(line)
        else:
            new_lines.append(line)
    
    content = '\n'.join(new_lines)
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

# Fix all dart files in screens
for root, dirs, files in os.walk('lib/screens'):
    for file in files:
        if file.endswith('.dart'):
            file_path = os.path.join(root, file)
            fix_imports_in_file(file_path)
            print(f"Fixed: {file_path}")

print("All imports fixed!")