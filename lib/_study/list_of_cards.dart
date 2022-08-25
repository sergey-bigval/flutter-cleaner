import 'package:flutter/material.dart';

import 'my_events.dart';


class ListOfCards extends StatefulWidget {
  const ListOfCards({Key? key}) : super(key: key);

  @override
  State<ListOfCards> createState() => _ListOfCardsState();
}

class _ListOfCardsState extends State<ListOfCards> {
  List<MyEvent> events = [];
  var ts28 = const TextStyle(fontSize: 28);
  var ts15 = const TextStyle(fontSize: 15, color: Colors.black45);
  String userInputText = "";

  @override
  void initState() {
    super.initState();
    events = List.generate(
      7,
      (i) => MyEvent(
          name: "Name $i",
          location: "Kiev-$i",
          startDateTime: DateTime.fromMillisecondsSinceEpoch((i + 1000) * (i + 1000) * (i + 1000) * (i + 1000))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: events.length, // для билдера
            itemBuilder: (BuildContext context, int index) {
              // для билдера
              return Dismissible(
                key: Key(events[index].hashCode.toString()),
                onDismissed: (direction) => removeItemAt(index),
                child: Card(
                    color: Colors.red[100],
                    elevation: index.toDouble(),
                    shadowColor: Colors.blue,
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      title: Text(events[index].name, style: ts28),
                      subtitle: Text("${events[index].location} - ${events[index].startDateTime}", style: ts15),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_sweep_rounded, color: Colors.deepOrange),
                        onPressed: () => removeItemAt(index),
                      ),
                    )),
              );
            },
            // separatorBuilder: (BuildContext context, int index) {
            //   // для билдера
            //   // return Container(width: double.infinity, height: 3, color: Colors.red, margin: const EdgeInsets.symmetric(horizontal: 10),);
            //   return const Divider(
            //     color: Colors.blue,
            //     height: 2,
            //   );
            // },
          ),
          Align(
            alignment: const Alignment(0.8, 0.9),
            child: FloatingActionButton(onPressed: () => showAddDialog(context), child: const Icon(Icons.add)),
          )
        ],
      ),
    );
  }

  void removeItemAt(int index) {
    events.removeAt(index);
    setState(() {});
  }

  void addItem(BuildContext context) {
    events.add(MyEvent(name: userInputText, location: "NewLock", startDateTime: DateTime.now()));
    setState(() {});
    Navigator.of(context).pop();
  }

  void showAddDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Add element"),
            content: TextField(
              onChanged: (String value) => {userInputText = value},
            ),
            actions: [
              ElevatedButton(onPressed: () => addItem(context), child: const Text("Add")),
              ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Dismiss")),
            ],
          );
        });
  }
}
