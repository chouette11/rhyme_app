import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rhyme_app/data/firebase_config.dart';
import 'package:rhyme_app/pages/root_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (useFirestore) {
    await Firebase.initializeApp();
  }
  runApp(const ProviderScope(child: RhymeApp()));
}
