import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math show Random;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

const names = [
  'Foo',
  'Bar',
  'Baz',
];

extension RandomElement<T> on Iterable<T> {
  T getRndomElement() => elementAt(
        math.Random().nextInt(length),
      );
}

class NamesCubit extends Cubit<String?> {
  NamesCubit(String? initialState) : super(initialState);

  void pickRandomName() {
    emit(names.getRndomElement());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final NamesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NamesCubit(null);
  }

  @override
  void dispose() {
    if (!cubit.isClosed) {
      cubit.close();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        builder: (context, snapshot) {
          final button = TextButton(
            onPressed: cubit.pickRandomName,
            child: const Text('pick random name'),
          );

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return button;
            case ConnectionState.waiting:
              return button;
            case ConnectionState.active:
              return Column(
                children: [
                  Text(snapshot.data ?? 'emplty'),
                  button,
                ],
              );
            case ConnectionState.done:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
