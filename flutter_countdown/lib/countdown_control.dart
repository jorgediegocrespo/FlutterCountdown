import 'package:flutter/material.dart';

class CountdownController {
  _CountdownControlState? _state;

  void playCountdown(Duration duration) {
    _state?.startCountdown(duration);
  }

  void pauseCountdown() {
    _state?.pauseCountdown();
  }

  void resumeCountdown() {
    _state?.resumeCountdown();
  }

  void stopCountdown() {
    _state?.stopCountdown();
  }

  CountdownStatus getStatus() {
    return _state?._countdownStatus ?? CountdownStatus.stoped;
  }

  void dispose() {
    _state?.dispose();
  }
}

enum CountdownStatus { stoped, playing, paused }

class CountdownControl extends StatefulWidget {
  const CountdownControl({super.key, required this.controller, this.diameter});

  final CountdownController controller;
  final double? diameter;

  @override
  State<CountdownControl> createState() => _CountdownControlState();
}

class _CountdownControlState extends State<CountdownControl> with TickerProviderStateMixin {
  late AnimationController? _countdownController;
  late Animation<double> _countdownAnimation;
  late double _countdownPercentage;
  late Duration _currentDuration;
  late Duration _startDuration;
  late CountdownStatus _countdownStatus;

  @override
  void initState() {
    super.initState();
    _countdownPercentage = 0;
    _currentDuration = Duration.zero;
    _startDuration = Duration.zero;
    _countdownStatus = CountdownStatus.stoped;
    widget.controller._state = this;
    _countdownController = null;
  }

  @override
  void dispose() {
    _countdownController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: widget.diameter,
                  width: widget.diameter,
                  child: const CircularProgressIndicator(
                    value: 1,
                    color: Colors.black12,
                  ),
                ),
                SizedBox(
                    height: widget.diameter,
                    width: widget.diameter,
                    child: Center(
                        child: Text(
                            "${_currentDuration.inHours.toString().padLeft(2, '0')}:${_currentDuration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(_currentDuration.inSeconds.remainder(60).toString().padLeft(2, '0'))}"))),
                SizedBox(
                  height: widget.diameter,
                  width: widget.diameter,
                  child: CircularProgressIndicator(
                    value: _countdownPercentage,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  startCountdown(Duration duration) {
    if (_countdownController != null) {
      return;
    }

    _startDuration = duration;
    _countdownController = AnimationController(duration: _startDuration, vsync: this);
    _countdownAnimation = Tween<double>(begin: duration.inSeconds.toDouble(), end: 0).animate(_countdownController!)
      ..addListener(() {
        setState(() {
          _countdownPercentage = _countdownController!.value;
          _currentDuration = Duration(seconds: _countdownAnimation.value.round());
        });
      });
    widget.controller._state = this;
    _countdownController!.forward();
    _countdownStatus = CountdownStatus.playing;
  }

  pauseCountdown() {
    if (_countdownController != null) {
      _countdownController!.stop();
      _countdownStatus = CountdownStatus.paused;
    }
  }

  stopCountdown() {
    if (_countdownController != null) {
      _countdownController!.stop();
      _countdownController!.dispose();
      _countdownController = null;
      _countdownStatus = CountdownStatus.stoped;

      setState(() {
        _countdownPercentage = 0;
        _currentDuration = _startDuration;
      });
    }
  }

  resumeCountdown() {
    if (_countdownController != null) {
      _countdownController!.forward();
      _countdownStatus = CountdownStatus.playing;
    }
  }
}
