import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:snackeverywhere/Class/order.dart';
import 'package:http/http.dart' as http;
import 'package:snackeverywhere/Screen/Shop%20Owner%20Screen/orderreceivedScreen.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({Key key, this.order}) : super(key: key);
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  double screenWidth;
  double screenHeight;
  final df1 = new DateFormat('dd-MM-yyyy hh:mm a');
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => OrderReceivedScreen()));
              }),
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary
              ]),
            ),
          ),
          title: Text(
            "Order Status",
            style: TextStyle(color: Theme.of(context).primaryColorDark),
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Receipt ID: " + widget.order.receiptid,
              style: TextStyle(fontSize: 16),
            ),
            Container(
              width: double.infinity,
              child: Card(
                elevation: 10,
                color: Theme.of(context).backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: 150,
                                width: 150,
                                child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "https://hubbuddies.com/270607/snackeverywhere/images/product/${widget.order.product_id}.png")),
                          ],
                        ),
                      ),
                      Text(
                        "Product ID: " + widget.order.product_id,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Product Name: " + widget.order.product_name,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Product Price: RM " + widget.order.product_price,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Size: " + widget.order.product_size,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Quantity: " + widget.order.o_quantity,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Card(
                elevation: 10,
                color: Theme.of(context).backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date Order: " +
                            df1.format(DateTime.parse(widget.order.date_order)),
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Collect Option: " + widget.order.collect_option,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Collect Date: " + widget.order.collect_date,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Payment Option: " + widget.order.payment_option,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Center(
                child: Text(widget.order.status,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green))),
            Center(
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Colors.orange[800],
                onPressed: () {
                  _editStatus();
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Update Status",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.update, color: Colors.white)
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _editStatus() {
    setState(() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Container(
                      height: 25,
                      width: 25,
                      child: Image.asset("assets/images/Logo.png")),
                  Container(child: Text("Status")),
                ],
              ),
              content: Container(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      child: Text("Order Received",
                          style: TextStyle(color: Colors.green)),
                      onPressed: () {
                        update("Order Received");
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("Order Packed",
                          style: TextStyle(color: Colors.green)),
                      onPressed: () {
                        update("Order Packed");
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("Order Ready",
                          style: TextStyle(color: Colors.green)),
                      onPressed: () {
                        update("Order Ready");
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("Order Completed",
                          style: TextStyle(color: Colors.green)),
                      onPressed: () {
                        update("Order Completed");
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }

  void update(String status) {
    setState(() {
      String email = widget.order.email;
      String receiptid = widget.order.receiptid;
      http.post(
          Uri.parse(
              "https://hubbuddies.com/270607/snackeverywhere/php/updateStatus.php"),
          body: {
            "email": email,
            "receiptid": receiptid,
            "status": status
          }).then((response) {
        print(response.body);
        if (response.body == "Success") {
          Fluttertoast.showToast(
              msg: "Updated",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
          setState(() {
            widget.order.status = status;
          });
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Update Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
        }
      });
    });
  }
}
