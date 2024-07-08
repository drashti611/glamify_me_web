// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countup/countup.dart';

import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:glamify_me_web/views/screens/widgets/custom_widget.dart';

class DashboardScreen extends StatefulWidget {
  static const String routeName = '\DashboardScreen';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isSortingAscending = true;
  // late Stream<QuerySnapshot> _orderStream;
  String selectedSortOption = 'Pending';
  void _showSortOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sort By:'),
          content: Container(
            width: 300,
            height: 100,
            // width: double.maxFinite,
            child: DropdownButtonFormField<String>(
              value: selectedSortOption,
              onChanged: (value) {
                setState(() {
                  selectedSortOption = value!;
                  Navigator.pop(context);
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: 'Pending',
                  child: Text('Complete order'),
                ),
                DropdownMenuItem<String>(
                  value: 'Complete',
                  child: Text('pending Order'),
                ),
              ],
            ),
          ),
        );
      },
    );

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text('Sort By:'),
    //       content: Container(
    //         width: 300,
    //         height: 100,
    //         //width: double.maxFinite,
    //         child: DropdownButtonFormField<bool>(
    //           value: isSortingAscending,
    //           onChanged: (value) {
    //             setState(() {
    //               isSortingAscending = value!;
    //               Navigator.pop(context);
    //             });
    //           },
    //           items: [
    //             DropdownMenuItem<bool>(
    //               value: true,
    //               child: Text('Low to High'),
    //             ),
    //             DropdownMenuItem<bool>(
    //               value: false,
    //               child: Text('High to Low'),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
  //   showModalBottomSheet(
  //     //  ` elevation: 10,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: 200,
  //         width: double.infinity,
  //         padding: EdgeInsets.all(16),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             Text(
  //               'Sort By:',
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 18,
  //               ),
  //             ),
  //             SizedBox(height: 10),
  //             ListTile(
  //               title: Text('Low to High'),
  //               leading: Radio(
  //                 activeColor: Color.fromARGB(255, 77, 49, 49),
  //                 value: true,
  //                 groupValue: isSortingAscending,
  //                 onChanged: (value) {
  //                   setState(() {
  //                     isSortingAscending = value as bool;
  //                     Navigator.pop(context);
  //                   });
  //                 },
  //               ),
  //             ),
  //             ListTile(
  //               title: Text('High to Low'),
  //               leading: Radio(
  //                 activeColor: Color.fromARGB(255, 77, 49, 49),
  //                 value: false,
  //                 groupValue: isSortingAscending,
  //                 onChanged: (value) {
  //                   setState(() {
  //                     isSortingAscending = value as bool;
  //                     Navigator.pop(context);
  //                   });
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _rowHeader(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade700),
          color: Color.fromARGB(255, 77, 49, 49),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _rowData(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade700),
          color: Color.fromARGB(255, 172, 167, 167),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _rowAproved(String text, int flex, Function()? onpressed) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade700),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 77, 49, 49),
            ),
            onPressed: onpressed,
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  final Stream<QuerySnapshot> _orderStream = FirebaseFirestore.instance
      .collection('ReviewCart')
      .where('paymentStatus', isNotEqualTo: '')
      .snapshots();

  late double total;

  double? totalPrice;

  late double shippingCharge = 100;

  late double discount;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(10.0),
            child: Text('Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              color: Colors.black,
            ),
          ),
          Wrap(
            children: [
              Custom_widget.ResponsiveContainer(
                context: context,
                totalwidth: width,
                width: width,
                height: 130,
                child: Row(
                  children: [
                    FutureBuilder(
                      future:
                          FirebaseFirestore.instance.collection('buyers').get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List buyersCount = snapshot.data!.docs;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Countup(
                                      begin: 0,
                                      end: buyersCount.length.toDouble(),
                                      duration: Duration(seconds: 3),
                                      separator: ',',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Icon(
                                      Icons.person_outline_rounded,
                                      size: 30,
                                    ).paddingOnly(left: 5),
                                  ],
                                ),
                                Text(
                                  'Total Buyers',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ).paddingAll(10),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ).paddingAll(10),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('products')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List productsCount = snapshot.data!.docs;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Countup(
                                      begin: 0,
                                      end: productsCount.length.toDouble(),
                                      duration: Duration(seconds: 3),
                                      separator: ',',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Icon(
                                      Icons.production_quantity_limits_rounded,
                                      size: 30,
                                    ).paddingOnly(left: 5),
                                  ],
                                ),
                                Text(
                                  'Total Products',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ).paddingAll(10),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ).paddingAll(10),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('categories')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List productsCount = snapshot.data!.docs;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Countup(
                                      begin: 0,
                                      end: productsCount.length.toDouble(),
                                      duration: Duration(seconds: 3),
                                      separator: ',',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Icon(
                                      Icons.category_rounded,
                                      size: 30,
                                    ).paddingOnly(left: 5),
                                  ],
                                ),
                                Text(
                                  'Total Categories',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ).paddingAll(10),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ).paddingAll(10),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('ReviewCart')
                          .where('paymentStatus', isNotEqualTo: '')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List productsCount = snapshot.data!.docs;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Countup(
                                      begin: 0,
                                      end: productsCount.length.toDouble(),
                                      duration: Duration(seconds: 3),
                                      separator: ',',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Icon(
                                      Icons.shopping_cart_checkout_rounded,
                                      size: 30,
                                    ).paddingOnly(left: 5),
                                  ],
                                ),
                                Text(
                                  'Total Orders',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ).paddingAll(10),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ).paddingAll(10),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('ReviewCart')
                          .where('deliveryStatus', isEqualTo: 'Complete')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List productsCount = snapshot.data!.docs;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.green,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Countup(
                                      begin: 0,
                                      end: productsCount.length.toDouble(),
                                      duration: Duration(seconds: 3),
                                      separator: ',',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 25,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Icon(
                                      Icons.shopping_cart_checkout_rounded,
                                      size: 30,
                                      color: Colors.green,
                                    ).paddingOnly(left: 5),
                                  ],
                                ),
                                Text(
                                  'Complete Orders',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ).paddingAll(10),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ).paddingAll(10),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('ReviewCart')
                          .where('deliveryStatus', isNotEqualTo: '')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List productsCount = snapshot.data!.docs;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.red,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Countup(
                                      begin: 0,
                                      end: productsCount.length.toDouble(),
                                      duration: Duration(seconds: 3),
                                      separator: ',',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 25,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Icon(
                                      Icons.shopping_cart_checkout_rounded,
                                      size: 30,
                                      color: Colors.red,
                                    ).paddingOnly(left: 5),
                                  ],
                                ),
                                Text(
                                  'Pending Orders',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ).paddingAll(10),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ).paddingAll(10),
                  ],
                ),
              ),
            ],
          ),

          //////
          Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Order Details',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                ),
              ),
              Spacer(),
              IconButton(
                  onPressed: _showSortOptions,
                  icon: Icon(
                    Icons.sort,
                    size: 30,
                    color: Color.fromARGB(255, 77, 49, 49),
                    weight: 100,
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _rowHeader('NO.', 1),
                _rowHeader('USER NAME', 4),
                _rowHeader('USER EMAIL', 5),
                _rowHeader('PRODUCT NAME', 3),
                _rowHeader('PRODUCT PRICE', 3),
                _rowHeader('QUN', 2),
                _rowHeader('TOTAL', 2),
                _rowHeader('PAYMENT', 3),
                _rowHeader('DELIVERY', 3),
                _rowHeader('ACTION', 3),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _orderStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              List<DocumentSnapshot> sortedData = snapshot.data!.docs;
              if (selectedSortOption == 'Pending') {
                sortedData.sort((a, b) =>
                    a['deliveryStatus'].compareTo(b['deliveryStatus']));
              } else if (selectedSortOption == 'Complete') {
                sortedData.sort((a, b) =>
                    b['deliveryStatus'].compareTo(a['deliveryStatus']));
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: sortedData.length,
                itemBuilder: (context, index) {
                  // final ordersData = snapshot.data!.docs[index];
                  final ordersData = sortedData[index];
                  /* Here Total Price = total + shippingCharge - discount 
                     discount = (total * 10)/100
                     shippingCharge = 100
                     total = productPrice * productQuantity
                  */
                  total = ordersData['cartPrice'] * ordersData['cartQuantity'];
                  discount = (total * 10) / 100;
                  totalPrice = total + shippingCharge - discount;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        _rowData('${index + 1}'.toString(), 1),
                        _rowData(ordersData['userName'], 4),
                        _rowData(ordersData['userEmail'], 5),
                        _rowData(ordersData['cartName'], 3),
                        _rowData(
                            '\u{20B9} ' + ordersData['cartPrice'].toString(),
                            3),
                        _rowData(ordersData['cartQuantity'].toString(), 2),
                        _rowData('\u{20B9} ' + totalPrice.toString(), 2),
                        _rowData(ordersData['paymentStatus'], 3),
                        _rowData(ordersData['deliveryStatus'], 3),
                        ordersData['deliveryStatus'] == "Complete"
                            ? _rowAproved('Completed', 3, () {
                                print(
                                    'The order has already been delivered...');
                                final snackBar = SnackBar(
                                    content: Text(
                                        'The order has already been delivered...'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              })
                            : _rowAproved('Delivered', 3, () async {
                                EasyLoading.show();
                                await FirebaseFirestore.instance
                                    .collection('ReviewCart')
                                    .doc((ordersData['cartId']))
                                    .update({
                                  "paymentStatus": 'Payment Success',
                                  "deliveryStatus": 'Complete',
                                }).whenComplete(() {
                                  EasyLoading.dismiss();
                                });
                              }),
                      ],
                    ),
                  );
                },
              );
            },
          ).paddingOnly(bottom: 10),
        ],
      ),
    );
  }
}
