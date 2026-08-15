import 'package:supabase_flutter/supabase_flutter.dart';

class AppConstants {
  static const appName = "اسم التطبيق";
  static const defaultPadding = 16.0;
  static const borderRadius = 12.0;
  static const animationDuration = Duration(milliseconds: 300);

  static initSupabase() async {
    await Supabase.initialize(
        url: 'https://kdlbuhuxgoqbufvccrsb.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtkbGJ1aHV4Z29xYnVmdmNjcnNiIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1Mzk3MDMzNiwiZXhwIjoyMDY5NTQ2MzM2fQ.72Sef2TvLYFT2NMU0u84wD4SCyznX9GsKxpRrCv7JWg');
  }
  // تقدر تزود أي ثابت عام هنا
}
