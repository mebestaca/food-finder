import 'package:flutter/material.dart';

import '../shared/sharedDecoration.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late List<String> tagList = [];
  final tagController = TextEditingController();
  String tag = "";

  Iterable<Widget> get tagChips{
    return tagList.map((e) {
      return Chip(
        label: Text(e),
        deleteIcon: const Icon(Icons.close),
        onDeleted: () {
          setState(() {
            tagList.removeWhere((element) => element == e);
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: tagController,
                    decoration: fieldStyle.copyWith(
                      hintText: "ingredients",
                      labelText: "ingredients"
                    ),
                    onChanged: (val) {
                      tag = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          tagList.add(tag);
                          tagController.clear();
                        });
                      },
                      child: const Text("Add"),
                    ),
                  ),
                ),
                const Divider(
                  height: 2,
                  thickness: 2,
                ),
                Wrap(
                  children: tagChips.toList(),
                ),
                Visibility(
                  visible: tagList.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {

                          });
                        },
                        child: const Text("Search"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
