import 'package:flutter/material.dart';
import 'package:glamify_me_web/views/screens/widgets/buyers_widget.dart';

class BuyersScreen extends StatelessWidget {
  static const String routeName = '\BuyersScreen';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Buyers List',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              color: Colors.black,
            ),
          ),
          BuyersWidget(),
        ],
      ),
    );
  }
}
