import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AskLegalPage extends StatelessWidget {
  const AskLegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask Legal')),
      body: const Center(child: Text('Ask Legal Page')),
    );
  }
}
