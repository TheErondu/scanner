import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ItemDetails extends StatefulWidget {
  final String barcode;
  ItemDetails({Key? key, required this.barcode}) : super(key: key);
  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  late Future<Item> futureItem;
  Future<Item> fetchItem() async {
    var code = widget.barcode;
    print(code);
    final response =
        await http.get(Uri.parse('https://192.168.0.196/store/item/$code'));
    print(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Item.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    futureItem = fetchItem();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Item Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Item Details'),
        ),
        body: Center(
          child: FutureBuilder<Item>(
            future: futureItem,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var dept = snapshot.data!.assigned_department;
                var qty = snapshot.data!.qty;
                var serial = snapshot.data!.serial_no;
                return Center(
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.store,
                            size: 80,
                          ),
                          title: Text(snapshot.data!.item_name),
                          subtitle: Text('Assigned Department : $dept'),
                          trailing: Text('Serial No : $serial'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              child: Text('QTY : $qty '),
                              onPressed: () {/* ... */},
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              child: Text('Go Back'),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop(context);
                              },
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class Item {
  final int id;
  final String item_name;
  final String assigned_department;
  final String serial_no;
  final int qty;

  const Item({
    required this.id,
    required this.item_name,
    required this.assigned_department,
    required this.serial_no,
    required this.qty,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? 1,
      item_name: json['item_name'] ?? 'item name:null',
      assigned_department: json['assigned_department'] ?? 'department:null',
      serial_no: json['serial_no'] ?? 'Serial No:null',
      qty: json['qty'] ?? 1,
    );
  }
}
