// lib/screens/category_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qna01/pages/questions_page.dart';
import 'package:qna01/providers/sub_category_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/category_provider.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    Future.microtask(() =>
        Provider.of<CategoryProvider>(context, listen: false).fetchCategories(auth.token));
        Provider.of<SubCategoryProvider>(context, listen: false)
            .fetchSubcategories(auth.token.toString(), 1);
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: Center(
        child: categoryProvider.isLoading
            ? CircularProgressIndicator()
            : categoryProvider.errorMessage != null
            ? Text(categoryProvider.errorMessage!)
            : GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: categoryProvider.categories.length,
          itemBuilder: (context, index) {
            final category = categoryProvider.categories[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuestionPage(
                      subCategoryId: category['id'],
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      category['name'] ?? 'Unnamed',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
