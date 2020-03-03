import 'package:flutter/material.dart';

class ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 16.0,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 90,
            width: 120,
            child: Container(
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width - 240,
                height: 14,
                color: Colors.black,
              ),
              SizedBox(height: 4.0),
              Container(
                width: MediaQuery.of(context).size.width - 184,
                height: 12,
                color: Colors.black,
              ),
              // SizedBox(height: 4.0),
              // Container(
              //   width: MediaQuery.of(context).size.width - 300,
              //   height: 12,
              //   color: Colors.black,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
