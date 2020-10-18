import 'package:flutter/material.dart';

class CircularCheckBox extends StatefulWidget {
  final Color color;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CircularCheckBox({
    Key key,
    this.color,
    @required this.onChanged,
    //Add reqired key and throw error if not assigned
    @required this.value,
  }) : super(key: key);
  @override
  _CircularCheckBoxState createState() =>
      _CircularCheckBoxState(color, onChanged, value);
}

class _CircularCheckBoxState extends State<CircularCheckBox> {
  final Color color;
  final bool value;
  final ValueChanged<bool> onChanged;

  _CircularCheckBoxState(
    this.color,
    this.onChanged,
    this.value,
  );

  bool selected = false;
  double scale = 1.0;

  void onClick() {
    selected = !selected;
    onChanged(selected);
  }

  @override
  void initState() {
    super.initState();
    selected = value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      onTapDown: (details) {
        scale = 0.95;
        setState(() {});
      },
      onTapUp: (details) {
        scale = 1.0;
        setState(() {});
      },
      child: Transform.scale(
        scale: scale,
        child: AnimatedContainer(
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? color ?? Colors.blue[700] : Colors.grey,
              width: 2.0,
            ),
            shape: BoxShape.circle,
            color: selected ? color ?? Colors.blue[700] : Colors.transparent,
          ),
          duration: Duration(milliseconds: 250),
          child: AnimatedCrossFade(
            firstCurve: Curves.bounceIn,
            secondCurve: Curves.bounceOut,
            duration: const Duration(milliseconds: 300),
            firstChild: Icon(
              Icons.radio_button_off,
              color: Colors.transparent,
            ),
            secondChild: Icon(
              Icons.check,
              color: Colors.white,
            ),
            crossFadeState: !selected
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
          ),
        ),
      ),
    );
  }
}
