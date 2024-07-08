// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ProductWidget extends StatefulWidget {
  // final MyController controller;

  const ProductWidget({
    super.key,
  });
  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  final Stream<QuerySnapshot> _productsStream =
      FirebaseFirestore.instance.collection('products').snapshots();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
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
              mainAxisExtent: 280,
              crossAxisCount: 6,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  // height: 1000,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.brown.shade300),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.network(productData['image']),
                      ),
                      Text(
                        'Name : ' + productData['productName'],
                      ),
                      Text(
                        'Price : ' +
                            '\u{20B9} ' +
                            productData['productPrice'].toString(),
                      ),
                      Text(
                        'Quantity : ' +
                            productData['productQuantity'].toString(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 77, 49, 49),
                            ),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("collectionPath")
                                  .doc(productData.id)
                                  .update({});
                              //  FirebaseFirestore.instance
                              //                                       .collection(
                              //                                             'Item')
                              //                                         .doc(id)
                              //                                         .update({
                              //                                       "id": id,
                              //                                       "image":
                              //                                           itemname
                              //                                               .text,
                              //                                       "Item Price":
                              //                                           itemprice
                              //                                               .text,
                              //                                       "Item Quantity":
                              //                                           itemquantity
                              //                                               .text,
                              //                                       "Total": total
                              //                                     }).then((value) {
                              //                                       Navigator.pop(
                              //                                           context);
                              //                                     });
                              //uploadProduct();
                            },
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 77, 49, 49),
                            ),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(productData.id)
                                  .delete()
                                  .then((value) => ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Product deleted successfully'),
                                          duration: Duration(seconds: 2),
                                          backgroundColor: Colors.green,
                                        ),
                                      ));
                              // uploadProduct();
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
