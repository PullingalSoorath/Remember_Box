import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:remember_box/api/api_key.dart';
import 'package:remember_box/screens/add_new.dart';
import 'package:http/http.dart' as http;
import 'package:remember_box/screens/view_to_dos.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List item = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: routeToAddItem,
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        scrolledUnderElevation: 0.2,
        elevation: 0,
        title: const Text('To Do'),
        centerTitle: true,
      ),
      body: item.isEmpty
          ? const Center(child: Text('Empty List'))
          : RefreshIndicator(
              onRefresh: fetchData,
              child: ListView.builder(
                itemCount: item.length,
                itemBuilder: (context, index) {
                  //  final item = items[index];
                  final title = item[index]['title'];
                  final description = item[index]['description'];
                  final id = item[index]['_id'] as String;
                  final time = item[index]['created_at'];
                  final utcTime = DateTime.parse(time);
                  final istTime =
                      utcTime.add(const Duration(hours: 5, minutes: 30));
                  final formattedTime =
                      DateFormat('h:mm | dd-MM-yyyy').format(istTime);

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewToDos(
                              title: title,
                              description: description,
                              time: formattedTime,
                            ),
                          ),
                        );
                      },
                      // title: Text(title),
                      // subtitle: Text(description),

                      trailing: PopupMenuButton(
                        icon: const Icon(
                          Icons.more_horiz,
                        ),
                        onSelected: (value) {
                          if (value == 'edit') {
                            routeToEditItem({}..addAll(item[index]));
                          } else if (value == 'delete') {
                            deleteById(id);
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            )
                          ];
                        },
                      ),
                      // isThreeLine: true,
                      tileColor: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text(
                        title,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            description,
                            maxLines: 1,
                          ),
                          Text('Created On $formattedTime'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Future<void> deleteById(id) async {
    final url = '$editApi$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      setState(() {
        item.removeWhere((element) => element['_id'] == id);
      });
    } else {
      log('Error');
    }
    // print(response.statusCode);
    // log(response.body);
  }

  Future<void> fetchData() async {
    const url = fetchDataApi;
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        item = result;
      });
    } else {
      // log('Error');
    }
    // print(response.statusCode);
    // log(response.body);
  }

  Future<void> routeToAddItem() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNew(),
      ),
    );
  }

  void routeToEditItem(Map item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNew(todo: item),
      ),
    );
  }
}
