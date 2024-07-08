// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyersWidget extends StatelessWidget {
  final Stream<QuerySnapshot> _buyersStream =
      FirebaseFirestore.instance.collection('buyers').snapshots();
  final Stream<QuerySnapshot> _userStream =
      FirebaseFirestore.instance.collection('buyers').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _userStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.cyan,
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.size,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final buyerData = snapshot.data!.docs[index];
            return Column(
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundImage: buyerData['profile'] == null ||
                            buyerData['profile'] == ''
                        ? AssetImage('assets/accountrb.png') as ImageProvider
                        : NetworkImage(buyerData['profile']),
                    backgroundColor: Color(0xFF5254A8),
                    radius: 50,
                  ),
                ).paddingOnly(bottom: 10),
                Text(
                  'Name : ' + buyerData['fullName'],
                ),
                Text(
                  'Email : ' + buyerData['email'],
                ),
                buyerData['phoneNumber'] == null ||
                        buyerData['phoneNumber'] == ''
                    ? Text(
                        'Phone Number : !! Not Found !!',
                      )
                    : Text(
                        'Phone Number : ' + buyerData['phoneNumber'],
                      ),
              ],
            );
          },
        );
      },
    );
  }
}
