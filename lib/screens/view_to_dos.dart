import 'package:flutter/material.dart';

class ViewToDos extends StatelessWidget {
  const ViewToDos({
    super.key,
    required this.title,
    required this.description,
    required this.time,
  });

  final String title;
  final String description;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Dos'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title: ',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 20,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 25,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Description: ',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 20,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 25,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text('Created On'),
                    Text(time),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
