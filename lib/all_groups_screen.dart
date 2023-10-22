import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_counter_app/container_detail_screen.dart';
import 'package:multi_counter_app/custom_drawer.dart';

class AllGroupsScreen extends StatefulWidget {
  const AllGroupsScreen({Key? key}) : super(key: key);

  @override
  State<AllGroupsScreen> createState() => _AllGroupsScreenState();
}

class _AllGroupsScreenState extends State<AllGroupsScreen> {
  int totalCounter = 0;
  List<int> containerCounters = [];
  final String counterKey = "containerCounters";

  @override
  void initState() {
    super.initState();
    // Load containerCounters from SharedPreferences when the screen is initialized.
    loadContainerCounters();
  }


  Future<void> loadContainerCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final counterList = prefs.getStringList(counterKey);

    if (counterList != null) {
      setState(() {
        containerCounters = counterList.map(int.parse).toList();
        totalCounter = calculateTotalCounter();
      });
    }
  }

  Future<void> saveContainerCounters() async {
    final prefs = await SharedPreferences.getInstance();
    final counterList = containerCounters.map((counter) => counter.toString()).toList();
    await prefs.setStringList(counterKey, counterList);
  }

  void addContainer() {
    setState(() {
      containerCounters.add(0);
      saveContainerCounters(); // Save in SharedPreferences
      totalCounter = calculateTotalCounter();
    });
  }

  void removeContainer(int index) {
    setState(() {
      containerCounters.removeAt(index);
      saveContainerCounters(); // Save in SharedPreferences
      totalCounter = calculateTotalCounter();
    });
  }
  void updateTotalCounterInAllGroupsScreen(int newTotalCounter) {
    setState(() {
      totalCounter = newTotalCounter;
    });
  }

  void navigateToContainerDetail(int index) async{
    int updatedTotalCounter = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContainerDetailScreen(
          containerIndex: index,
          totalCounter: totalCounter,
          updateTotalCounter: updateTotalCounterInAllGroupsScreen,
        ),
      ),
    );
    setState(() {
      totalCounter = updatedTotalCounter;
    });


  }

  int calculateTotalCounter() {
    return containerCounters.fold(0, (sum, counter) => sum + counter);
  }

  @override
  Widget build(BuildContext context) {

    var _mediaQuery = MediaQuery.of(context);

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Container(
            height: _mediaQuery.size.height * 0.09,
            width: _mediaQuery.size.width * 0.86,
          child: Row(
            children: [
              Container(
                  height: _mediaQuery.size.height * 0.05,
                  width: _mediaQuery.size.width * 0.16,
                  child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios, color: Colors.white,
                    size: _mediaQuery.size.height * 0.03,))),
              Container(
                  height: _mediaQuery.size.height * 0.05,
                  width: _mediaQuery.size.width * 0.50,
                  child: Text("All Groups", style: TextStyle(color: Colors.white,fontSize: _mediaQuery.size.height * 0.03,)
                  )),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: containerCounters.asMap().entries.map((entry) {
            final index = entry.key;
            final counter = entry.value;
            return GestureDetector(
              onTap: () => navigateToContainerDetail(index),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: _mediaQuery.size.height * 0.01, left: _mediaQuery.size.width * 0.02, bottom:  _mediaQuery.size.height * 0.01,right: _mediaQuery.size.width * 0),
                    height: _mediaQuery.size.height * 0.19,
                    width: _mediaQuery.size.width * 0.774,
                    color: Colors.black,
                    child: Column(
                      children: [



                          Center(
                                child: Container(
                                    height: _mediaQuery.size.height * 0.04,
                                    width:  _mediaQuery.size.width * 0.49,
                                    margin: EdgeInsets.only(top: _mediaQuery.size.height * 0.02, bottom:  _mediaQuery.size.height * 0.01),
                                    child: Text("New Group $index",style: TextStyle(
                                      color: Colors.white,
                                      fontSize: _mediaQuery.size.height * 0.03,
                                      fontWeight: FontWeight.bold,

                                    ),))),

                      Container(
                          height: _mediaQuery.size.height * 0.03,
                          width:  _mediaQuery.size.width * 0.8,
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: _mediaQuery.size.height * 0.02, left: _mediaQuery.size.width * 0.06, bottom:  _mediaQuery.size.height * 0.01,right: _mediaQuery.size.width * 0),
                          child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Counters: ",style: TextStyle(
                                color: Colors.white,
                                fontSize: _mediaQuery.size.height * 0.02,

                              ),),
                              Text("${totalCounter}   ",style: TextStyle(color: Colors.white,
                                fontSize: _mediaQuery.size.height * 0.02,
                              ),),


                            ],
                          ),
                        ],
                      )),
                        Container(
                            height: _mediaQuery.size.height * 0.03,
                            width:  _mediaQuery.size.width * 0.8,
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(top: _mediaQuery.size.height * 0.0, left: _mediaQuery.size.width * 0.06, bottom:  _mediaQuery.size.height * 0.01,right: _mediaQuery.size.width * 0),
                            child: Column(
                              children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text("Total value: ",style: TextStyle(color: Colors.white,
                                   fontSize: _mediaQuery.size.height * 0.02,
                                 ),),

                                 Text("0   ",style: TextStyle(color: Colors.white,
                                   fontSize: _mediaQuery.size.height * 0.02,
                                 ),),
                               ],
                             ),
                                ],
                            )),
                      ]
                    ),
                  ),
                  GestureDetector(
                    onTap: () => removeContainer(index),
                    child: Container(
                      margin: EdgeInsets.only(top: _mediaQuery.size.height * 0.01, right: _mediaQuery.size.width * 0.02, bottom:  _mediaQuery.size.height * 0.01),
                      height: _mediaQuery.size.height * 0.19,
                      width: _mediaQuery.size.width * 0.178,
                      child: Icon(Icons.delete, color: Colors.white),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addContainer,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
    );
  }
}
