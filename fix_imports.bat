@echo off
echo Fixing import paths...

REM Fix providers
powershell -Command "(Get-Content 'lib\providers\admin_provider.dart') -replace \"import '../models/admin.dart';\", \"import '../models/models.dart';\" | Set-Content 'lib\providers\admin_provider.dart'"
powershell -Command "(Get-Content 'lib\providers\api_store_provider.dart') -replace \"import '../models/partner_store.dart';\", \"import '../models/models.dart';\" | Set-Content 'lib\providers\api_store_provider.dart'"
powershell -Command "(Get-Content 'lib\providers\api_store_provider.dart') -replace \"import '../services/api_service.dart';\", \"import '../services/services.dart';\" | Set-Content 'lib\providers\api_store_provider.dart'"
powershell -Command "(Get-Content 'lib\providers\api_user_provider.dart') -replace \"import '../models/user.dart';\", \"import '../models/models.dart';\" | Set-Content 'lib\providers\api_user_provider.dart'"
powershell -Command "(Get-Content 'lib\providers\api_user_provider.dart') -replace \"import '../services/api_service.dart';\", \"import '../services/services.dart';\" | Set-Content 'lib\providers\api_user_provider.dart'"
powershell -Command "(Get-Content 'lib\providers\api_user_provider.dart') -replace \"import '../services/storage_service.dart';\", \"import '../services/services.dart';\" | Set-Content 'lib\providers\api_user_provider.dart'"
powershell -Command "(Get-Content 'lib\providers\store_provider.dart') -replace \"import '../models/partner_store.dart';\", \"import '../models/models.dart';\" | Set-Content 'lib\providers\store_provider.dart'"
powershell -Command "(Get-Content 'lib\providers\store_provider.dart') -replace \"import '../services/api_service.dart';\", \"import '../services/services.dart';\" | Set-Content 'lib\providers\store_provider.dart'"
powershell -Command "(Get-Content 'lib\providers\user_provider.dart') -replace \"import '../models/user.dart';\", \"import '../models/models.dart';\" | Set-Content 'lib\providers\user_provider.dart'"
powershell -Command "(Get-Content 'lib\providers\user_provider.dart') -replace \"import '../services/storage_service.dart';\", \"import '../services/services.dart';\" | Set-Content 'lib\providers\user_provider.dart'"
powershell -Command "(Get-Content 'lib\providers\user_provider.dart') -replace \"import '../services/analytics_service.dart';\", \"import '../services/services.dart';\" | Set-Content 'lib\providers\user_provider.dart'"
powershell -Command "(Get-Content 'lib\providers\waste_provider.dart') -replace \"import '../models/waste_entry.dart';\", \"import '../models/models.dart';\" | Set-Content 'lib\providers\waste_provider.dart'"
powershell -Command "(Get-Content 'lib\providers\waste_provider.dart') -replace \"import '../services/storage_service.dart';\", \"import '../services/services.dart';\" | Set-Content 'lib\providers\waste_provider.dart'"

echo Import paths fixed!
pause