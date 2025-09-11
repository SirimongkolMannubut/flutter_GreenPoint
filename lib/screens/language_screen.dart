import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/settings_provider.dart';
import '../constants/app_constants.dart';
import '../widgets/common_app_bar.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CommonAppBar(
        title: context.watch<SettingsProvider>().translate('language'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          final languages = settingsProvider.getSupportedLanguages();
          
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppConstants.primaryGreen.withOpacity(0.1),
                        AppConstants.lightGreen.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppConstants.primaryGreen.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.language,
                          color: AppConstants.primaryGreen,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              settingsProvider.translate('select_language'),
                              style: GoogleFonts.kanit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppConstants.darkGreen,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              settingsProvider.translate('language_description'),
                              style: GoogleFonts.kanit(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),
                const SizedBox(height: 24),
                Text(
                  settingsProvider.translate('available_languages'),
                  style: GoogleFonts.kanit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.darkGreen,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final language = languages[index];
                      final isSelected = language['code'] == settingsProvider.currentLanguage;
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected 
                                ? AppConstants.primaryGreen 
                                : Colors.grey.withOpacity(0.2),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected 
                                  ? AppConstants.primaryGreen.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? AppConstants.primaryGreen.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                language['flag']!,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          title: Text(
                            language['name']!,
                            style: GoogleFonts.kanit(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              color: isSelected 
                                  ? AppConstants.primaryGreen 
                                  : AppConstants.darkGreen,
                            ),
                          ),
                          subtitle: Text(
                            language['code']!.toUpperCase(),
                            style: GoogleFonts.kanit(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: isSelected
                              ? Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppConstants.primaryGreen,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                )
                              : const Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                ),
                          onTap: () => _selectLanguage(
                            context,
                            settingsProvider,
                            language['code']!,
                          ),
                        ),
                      ).animate(delay: (index * 100).ms)
                          .fadeIn(duration: 400.ms)
                          .slideX(begin: 0.3, end: 0);
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppConstants.primaryGreen,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        settingsProvider.translate('language_restart_note'),
                        style: GoogleFonts.kanit(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
              ],
            ),
          );
        },
      ),
    );
  }

  void _selectLanguage(
    BuildContext context,
    SettingsProvider settingsProvider,
    String languageCode,
  ) async {
    if (languageCode == settingsProvider.currentLanguage) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: AppConstants.primaryGreen,
              ),
              const SizedBox(height: 16),
              Text(
                settingsProvider.translate('changing_language'),
                style: GoogleFonts.kanit(
                  fontSize: 14,
                  color: AppConstants.darkGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Change language
    await settingsProvider.setLanguage(languageCode);

    // Close loading dialog
    Navigator.pop(context);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          settingsProvider.translate('language_changed'),
          style: GoogleFonts.kanit(),
        ),
        backgroundColor: AppConstants.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Go back to settings
    Navigator.pop(context);
  }
}