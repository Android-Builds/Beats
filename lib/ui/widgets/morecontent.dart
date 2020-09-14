import 'package:flutter/material.dart';

class MoreContentWidget extends StatelessWidget {
  const MoreContentWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UnconstrainedBox(
            child: CircleAvatar(
              radius: 20.0,
              child: Icon(Icons.arrow_forward),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'More',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
