import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_theme/screens/movie_screen.dart';
import 'package:get/get.dart';

void main() {
  runApp(ProviderScope(child: Home()));
}

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.dark().copyWith(
      ),
      home: MovieScreen(),
    );
  }
}
