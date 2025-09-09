import 'package:flutter/material.dart';
import 'package:notes_app/counter_provider.dart';
import 'package:provider/provider.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Build Method');
    return ChangeNotifierProvider(
      create: (context) => CounterProvider(),
      builder: (context, child) {
        final provider = context.read<CounterProvider>();
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              provider.incrementCounter();
            },
            child: Icon(Icons.add),
          ),
          appBar: AppBar(title: Text('Counter')),
          body: Center(
            child: Consumer<CounterProvider>(
              builder: (context, value, child) {
                return Text(
                  provider.counter.toString(),
                  style: TextStyle(fontSize: 40),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
