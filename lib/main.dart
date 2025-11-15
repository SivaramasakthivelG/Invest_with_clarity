import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qna01/pages/CategoryPage.dart';
import 'package:qna01/providers/category_provider.dart';
import 'package:qna01/providers/question_provider.dart';
import 'package:qna01/providers/sub_category_provider.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => SubCategoryProvider()),
        ChangeNotifierProvider(create: (_) => QuestionProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Investment QnA',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/categories': (_) => CategoryPage(),
      },
    );
  }
}
