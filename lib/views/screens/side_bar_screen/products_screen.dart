// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProductsScreen extends StatefulWidget {
  static const String routeName = '\ProductsScreen';

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final Stream<QuerySnapshot> _productsStream =
      FirebaseFirestore.instance.collection('products').snapshots();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  dynamic _image;

  String? fileName;
  late String productName;
  late String productPrice;
  late String productQuantity;
  late String productDetail;
  late String productCategory;
  String? productId;
  void _showSortOptions() {
    showModalBottomSheet(
      //  ` elevation: 10,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sort By:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('Comple'),
                // leading: Radio(
                //   activeColor: Color.fromARGB(255, 77, 49, 49),
                //   value: true,
                // groupValue: isSortingAscending,
                // onChanged: (value) {
                //   setState(() {
                //     isSortingAscending = value as bool;
                //     Navigator.pop(context);
                //   });
                // },
                // ),
              ),
              ListTile(
                title: Text('High to Low'),
                // leading: Radio(
                //   activeColor: Color.fromARGB(255, 77, 49, 49),
                //   value: false,
                //   groupValue: isSortingAscending,
                //   onChanged: (value) {
                //     setState(() {
                //       isSortingAscending = value as bool;
                //       Navigator.pop(context);
                //     });
                //   },
                // ),
              ),
            ],
          ),
        );
      },
    );
  }

  _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  _uploadProductBannerToStorage(dynamic image) async {
    Reference ref = _storage.ref().child('ProductImages').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadProduct() async {
    EasyLoading.show();
    if (_formKey.currentState!.validate()) {
      String imgUrl = await _uploadProductBannerToStorage(_image);
      productId = _firestore.collection('products').doc().id;
      await _firestore.collection('products').doc(productId).set({
        'image': imgUrl,
        'productName': productName,
        'productPrice': int.parse(productPrice),
        'productQuantity': int.parse(productQuantity),
        'productDetail': productDetail,
        'productCategory': productCategory,
        'productID': productId,
      }).whenComplete(() {
        EasyLoading.dismiss();
        setState(() {
          _image = null;
          _formKey.currentState!.reset();
        });
      });
    } else {
      print('O Bad Guy');
    }
  }

  // Widget _rowHeader(String text,int flex){
  //   return Expanded(
  //     flex: flex,
  //     child: Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.grey.shade700),
  //         color: Colors.yellow.shade900,
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Text(
  //           text,
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    'Products',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.sort))
                ],
              ),
            ),
            // Row(
            //   children: [
            //     _rowHeader('IMAGE', 1),
            //     _rowHeader('NAME', 3),
            //     _rowHeader('PRICE', 2),
            //     _rowHeader('QUANTITY', 2),
            //     _rowHeader('ACTION', 1),
            //     _rowHeader('VIEW MORE', 1),
            //   ],
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 155, 126, 126),
                          border: Border.all(
                            width: 5,
                            color: Color.fromARGB(255, 114, 102, 102),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: _image != null
                              ? Image.memory(
                                  _image,
                                  fit: BoxFit.cover,
                                ) //Then
                              : Center(
                                  child: Text(
                                    'Product',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ), //Else,
                        ), //Else
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 196, 167, 157),
                        ),
                        onPressed: () {
                          _pickImage();
                        },
                        child: Text(
                          'Upload Image',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          onChanged: (value) {
                            productName = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Product Name Must Not Be Empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 196, 167, 157),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Enter Product Name',
                            hintText: 'Enter Product Name',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          onChanged: (value) {
                            productPrice = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Product Price Must Not Be Empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 196, 167, 157),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Enter Product Price',
                            hintText: 'Enter Product Price',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          onChanged: (value) {
                            productQuantity = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Product Quantity Must Not Be Empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 196, 167, 157),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Enter Product Quantity',
                            hintText: 'Enter Product Quantity',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          onChanged: (value) {
                            productDetail = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Product Details Must Not Be Empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 196, 167, 157),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Enter Product Detail',
                            hintText: 'Enter Product Detail',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          onChanged: (value) {
                            productCategory = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Product Category Must Not Be Empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 196, 167, 157),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'Enter Product Category',
                            hintText: 'Enter Product Category',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 196, 167, 157),
                  ),
                  onPressed: () {
                    uploadProduct();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //  ProductWidget(),
            /////////////////////////////////
            ///
            StreamBuilder<QuerySnapshot>(
              stream: _productsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
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
                            SizedBox(
                              width: 200,
                              child: Text(
                                'Name : ' + productData['productName'],
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis),
                              ),
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
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 77, 49, 49),
                              ),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('products')
                                    .doc(productData.id)
                                    .delete()
                                    .then((value) =>
                                        ScaffoldMessenger.of(context)
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
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
