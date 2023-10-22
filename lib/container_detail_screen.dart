import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_counter_app/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContainerDetailScreen extends StatefulWidget {
  final int containerIndex;
   final int totalCounter;
  final Function(int) updateTotalCounter;


  ContainerDetailScreen({required this.containerIndex,  required this.updateTotalCounter, required this.totalCounter, Key? key}) : super(key: key);

  @override
  State<ContainerDetailScreen> createState() => _ContainerDetailScreenState();
}

class _ContainerDetailScreenState extends State<ContainerDetailScreen> {
  List<int> customcontainerCounters = [];
  final String counterKey = "customcontainerCounters";

  @override
  void initState() {
    super.initState();

    loadContainerCounters();
  }

  Future<void> loadContainerCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final counterList = prefs.getStringList(counterKey);

    if (counterList != null) {
      setState(() {
        customcontainerCounters = counterList.map(int.parse).toList();
      });
    }
  }

  Future<void> saveContainerCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final counterList = customcontainerCounters.map((counter) => counter.toString()).toList();
    await prefs.setStringList(counterKey, counterList);
  }

  void addContainer() {
    setState(() {
      customcontainerCounters.add(0);
      saveContainerCounters();
    });
  }

  void removeContainer(int index) {
    setState(() {
      customcontainerCounters.removeAt(index);
      saveContainerCounters();
    });
    int newTotalCounter = customcontainerCounters.fold(0, (sum, counter) => sum + counter);
    widget.updateTotalCounter(newTotalCounter);
  }

  void incrementContainerCounter(int index) {
    setState(() {
      customcontainerCounters[index]++;
      saveContainerCounters();
    });
    int newTotalCounter = customcontainerCounters.fold(0, (sum, counter) => sum + counter);
    widget.updateTotalCounter(newTotalCounter);
  }

  void decrementContainerCounter(int index) {
    setState(() {
      customcontainerCounters[index]--;
      saveContainerCounters();
      if (index > 0) {
        index--;
      }
      int newTotalCounter = customcontainerCounters.fold(0, (sum, counter) => sum + counter);
      widget.updateTotalCounter(newTotalCounter);
    });
  }

  void resetContainerCounter(int index) {
    setState(() {
      customcontainerCounters[index] = 0;
      saveContainerCounters();
    });
    int newTotalCounter = customcontainerCounters.fold(0, (sum, counter) => sum + counter);
    widget.updateTotalCounter(newTotalCounter);
  }

  @override
  Widget build(BuildContext context) {

    var _mediaQuery = MediaQuery.of(context);

    int totalCounter = customcontainerCounters.fold(0, (sum, counter) => sum + counter);


    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Row(
            children: [
              Container(
                  height: _mediaQuery.size.height * 0.05,
                  width: _mediaQuery.size.width * 0.76,
                  child: Text("Container Detail for Index ${widget.containerIndex}", style: TextStyle(color: Colors.white,
                      fontSize: _mediaQuery.size.height * 0.023,
                  ))),
            ],
          ),

        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: List.generate(customcontainerCounters.length, (index) {
              return Row(
                children: [
                  InkWell(
                    onTap: () => decrementContainerCounter(index),
                    child: Container(
                      margin: EdgeInsets.only(top: _mediaQuery.size.height * 0.01, left: _mediaQuery.size.width * 0.015, bottom:  _mediaQuery.size.height * 0.01,right: _mediaQuery.size.width * 0),
                      color: Colors.black,
                      height: _mediaQuery.size.height * 0.1,
                      width: _mediaQuery.size.width * 0.12,
                      child: Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: _mediaQuery.size.height * 0.01, left: _mediaQuery.size.width * 0, bottom:  _mediaQuery.size.height * 0.01,right: _mediaQuery.size.width * 0),
                    height: _mediaQuery.size.height * 0.1,
                    width: _mediaQuery.size.width * 0.55,
                    color: Colors.black,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: _mediaQuery.size.height * 0.03,
                                width:  _mediaQuery.size.width * 0.38,
                                child: Text("New Counter $index", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _mediaQuery.size.height * 0.022,
                                ),),
                              ),
                              SizedBox(width:  _mediaQuery.size.width * 0.06,),
                              Container(
                                height: _mediaQuery.size.height * 0.06,
                                width:  _mediaQuery.size.width * 0.09,
                                child: IconButton(
                                    onPressed: () => resetContainerCounter(index),
                                    icon: Icon(Icons.settings_backup_restore_outlined,
                                      color: Colors.white,
                                      size:  _mediaQuery.size.height * 0.032,
                                    )
                                ),
                              )
                            ],
                          ),
                          Container(
                            height: _mediaQuery.size.height * 0.03,
                          child: Text(
                              '${customcontainerCounters[index]}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: _mediaQuery.size.height * 0.024,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => incrementContainerCounter(index),
                    child: Container(
                      margin: EdgeInsets.only(top: _mediaQuery.size.height * 0.01, left: _mediaQuery.size.width * 0, bottom:  _mediaQuery.size.height * 0.01,right: _mediaQuery.size.width * 0),
                      color: Colors.black,
                      height: _mediaQuery.size.height * 0.1,
                      width: _mediaQuery.size.width * 0.12,
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                  InkWell(
                    onTap: () => removeContainer(index),
                    child: Container(
                      margin: EdgeInsets.only(top: _mediaQuery.size.height * 0.01, left: _mediaQuery.size.width * 0, bottom:  _mediaQuery.size.height * 0.01,right: _mediaQuery.size.width * 0.015),
                      height: _mediaQuery.size.height * 0.1,
                      width: _mediaQuery.size.width * 0.17,
                      child: Icon(Icons.delete, color: Colors.white),
                      color: Colors.black,
                    ),
                  ),

                ],
              );

            }
            ),

          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addContainer,
          tooltip: 'Add Container',
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
        ),

      ),
    );
  }
}