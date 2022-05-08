import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/contact.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Contact> contactList = [];

  @override
  void initState() {
    super.initState();
    invokeNativeStub();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact App'),),
      body: contactList.isEmpty ? const Center(child: CircularProgressIndicator(),) : ListView.builder(
        itemCount: contactList.length,
        itemBuilder: (context, position) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://images.dog.ceo/breeds/mexicanhairless/n02113978_1551.jpg'),
                    maxRadius: 30,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            contactList[position].name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(contactList[position].phoneNumber),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )
    );
  }

  void invokeNativeStub() async {
    const platform = MethodChannel("MY_CHANNEL");
    dynamic result = await platform.invokeMethod("mycall");
    setState(() {
      for (var element in result) {
        Contact contact =
        Contact(name: element['name'], phoneNumber: element['phoneNumber']);
        contactList.add(contact);
      }
    });
  }
}
