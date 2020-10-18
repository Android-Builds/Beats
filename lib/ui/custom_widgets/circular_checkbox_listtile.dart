import 'package:flutter/material.dart';

enum CheckBoxPostion {
  leading,
  trailing,
}

class CircularCheckBoxListTile extends StatefulWidget {
  final Color color;
  final bool value;
  final Widget title;
  final Widget subtitle;
  final CheckBoxPostion position;
  final EdgeInsetsGeometry padding;
  final ValueChanged<bool> onChanged;

  const CircularCheckBoxListTile({
    Key key,
    this.color,
    @required this.value,
    @required this.onChanged,
    this.padding,
    this.title,
    this.position = CheckBoxPostion.leading,
    this.subtitle,
  }) : super(key: key);
  @override
  _CircularCheckBoxListTileState createState() =>
      _CircularCheckBoxListTileState(
        color,
        value,
        onChanged,
        padding,
        title,
        position,
        subtitle,
      );
}

class _CircularCheckBoxListTileState extends State<CircularCheckBoxListTile> {
  final Color color;
  final bool value;
  final Widget title;
  final Widget subtitle;
  final CheckBoxPostion position;
  final EdgeInsetsGeometry padding;
  final ValueChanged<bool> onChanged;

  _CircularCheckBoxListTileState(
    this.color,
    this.value,
    this.onChanged,
    this.padding,
    this.title,
    this.position,
    this.subtitle,
  );

  bool selected = false;
  double scale = 1.0;

  @override
  void initState() {
    super.initState();
    selected = value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        selected = !selected;
        onChanged(selected);
      },
      onTapDown: (details) {
        scale = 0.95;
        setState(() {});
      },
      onTapUp: (details) {
        scale = 1.0;
        setState(() {});
      },
      child: ListTile(
        contentPadding: padding ?? EdgeInsets.all(8.0),
        onTap: null,
        leading: position == CheckBoxPostion.leading
            ? getChild()
            : SizedBox.shrink(),
        trailing: position == CheckBoxPostion.trailing
            ? getChild()
            : SizedBox.shrink(),
        title: title,
      ),
    );
  }

  Widget getChild() {
    return Transform.scale(
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
          crossFadeState:
              !selected ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        ),
      ),
    );
  }
}
