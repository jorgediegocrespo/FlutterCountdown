import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'countdown_control.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TextEditingController _textController;
  late CountdownController _countdownController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _countdownController = CountdownController();
    _textController.text = '25';
  }

  @override
  void dispose() {
    _textController.dispose();
    _countdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: _textController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Countdown time (in seconds)',
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                ),
              ),
            ),
            buildButtonPanel(),
            CountdownControl(controller: _countdownController, diameter: 300),
          ],
        ),
      ),
    );
  }

  Row buildButtonPanel() {
    if (_countdownController.getStatus() == CountdownStatus.stoped) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.play_arrow_rounded),
            onPressed: () {
              setState(() {
                _countdownController.playCountdown(Duration(seconds: int.parse(_textController.text)));
              });
            },
          )
        ],
      );
    } else if (_countdownController.getStatus() == CountdownStatus.playing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.pause_rounded),
            onPressed: () {
              setState(() {
                _countdownController.pauseCountdown();
              });
            },
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.stop_rounded),
            onPressed: () {
              setState(() {
                _countdownController.stopCountdown();
              });
            },
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.play_arrow_rounded),
            onPressed: () {
              setState(() {
                _countdownController.resumeCountdown();
              });
            },
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.stop_rounded),
            onPressed: () {
              setState(() {
                _countdownController.stopCountdown();
              });
            },
          ),
        ],
      );
    }
  }
}
