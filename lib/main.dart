// @dart=2.9

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Задание',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(title: 'Кейс 3.1', storage: CounterStorage(),),
    );
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({key, this.storage, this.title}) : super(key: key);

  final String title;
  final CounterStorage storage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counterone = 0;
  int _countertwo = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _countertwo = value;
      });
    });
  }


  void _loadCounter () async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counterone = (prefs.getInt('counterone') ?? 0);
    });
  }

  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counterone = (prefs .getInt('counterone') ?? 0) + 1;
      prefs.setInt('counterone', _counterone);
    });
  }

  Future<File> _incrementCounterTwo() {
    setState(() {
      _countertwo++;
    });
    return widget.storage.writeCounter(_countertwo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Нажал на красную кнопку:',
            ),
            Text(
              '$_counterone',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
                onPressed: _incrementCounter,
                child: const Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent),
            ),
            const Text(
              'Нажал на зеленую кнопку:',
            ),
            Text(
              '$_countertwo',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: _incrementCounterTwo,
              child: const Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreen),
            )
          ],
        ),
      ),
    );
  }
}
