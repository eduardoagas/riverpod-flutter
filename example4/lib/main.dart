import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

const names = [
  'Janete',
  'Torete',
  'Janemba',
  'Cassoty',
  'Pedrita',
  'Sebastiana',
  'Hamurabi',
  'Venomoth',
  'Aoede',
  'Lucinda',
  'Beth Balanço'
];

final tickerProvider = StreamProvider(
    (ref) => Stream.periodic(const Duration(seconds: 1), (i) => i + 1));

final namesProvider = StreamProvider((ref) => ref.watch(tickerProvider).map(
      data: (count) => Stream.value(
        names.getRange(
          0,
          count.value,
        ),
      ),
      error: (error) => Stream.error(
        error.error,
        error.stackTrace,
      ),
      loading: (loading) => const Stream.empty(),
    ));

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('StreamProvider')),
      body: names.when(
        data: (names) {
          return ListView.builder(
            itemCount: names.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(names.elementAt(index)),
              );
            },
          );
        },
        error: (error, stackTrace) =>
            const Text('Reached the end of the list!'),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
