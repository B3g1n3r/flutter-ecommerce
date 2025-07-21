import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NodeExample extends StatefulWidget {
  @override
  _NodeExampleState createState() => _NodeExampleState();
}

class _NodeExampleState extends State<NodeExample> {
  String message = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchMessage();
  }

  Future<void> fetchMessage() async {
    final response = await http.get(Uri.parse('http://192.168.164.1:3000/api/hello'));

    if (response.statusCode == 200) {
      setState(() {
        message = jsonDecode(response.body)['message'];
      });
    } else {
      setState(() {
        message = 'Failed to fetch data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Node.js API')),
      body: Center(child: Text(message)),
    );
  }
}
