// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:homework/countriesModel.dart';
import 'package:homework/Functions/functions.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List<Countries>? _countriesModel = [];
  bool isDescending = false;
  int pageNum = 0;
  int resultsNum = 10;
  late TextEditingController _controller;
  late TextEditingController _countryNameController;

  final TableRow rowSpacer = TableRow(children: [
    SizedBox(
      height: 15,
    ),
    SizedBox(
      height: 15,
    ),
    SizedBox(
      height: 15,
    ),
    SizedBox(
      height: 15,
    ),
    SizedBox(
      height: 15,
    ),
  ]);

  @override
  void initState() {
    super.initState();
    _getData();
    _controller = TextEditingController();
    _countryNameController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _countryNameController.dispose();
    super.dispose();
  }

  Future<void> _getData() async {
    _countriesModel!.clear();
    print(_countriesModel);
    _countriesModel = (await ApiService().getCountries())!;
    setState(() {});
    //Future.delayed(const Duration(seconds: 0)).then((value) => setState(() {}));
  }

  void sortAlphabetically() {
    setState((() => isDescending = !isDescending));
    _countriesModel!
      ..sort((a, b) => isDescending
          ? b.name!.compareTo(a.name.toString())
          : a.name!.compareTo(b.name.toString()));
  }

  void searchOceania() {
    final oceaniaCountries = _countriesModel!.where((element) {
      final oceaniaRegion = element.region;
      return oceaniaRegion!.contains('Oceania');
    }).toList();

    setState((() => _countriesModel = oceaniaCountries));
  }

  void searchCountry(String country) async {
    await _getData();
    final searchedCountry = _countriesModel!.where((element) {
      final searchedCountry = element.name!.toLowerCase();
      final input = country.toLowerCase();

      return searchedCountry.contains(input);
    }).toList();

    resultsNum = searchedCountry.length;
    setState((() => _countriesModel = searchedCountry));
  }

  void lessThanLT() {
    _countriesModel!.removeWhere((element) => element.area == null);
    _countriesModel!.removeWhere((element) => element.area! >= 65300);
    setState((() => _countriesModel));
  }

  Widget showList(int i, int resultsNum) => ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: resultsNum,
        // itemCount: _countriesModel!.length,
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 204, 255, 204),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Table(
                    // border: TableBorder.all(),
                    columnWidths: {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                    },

                    children: [
                      TableRow(
                        children: [
                          Text(_countriesModel![index + i].name.toString()),
                          Text(_countriesModel![index + i].region.toString()),
                          Text(_countriesModel![index + i].area.toString()),
                          Text(_countriesModel![index + i]
                              .independent
                              .toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 255, 227),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 30, 50, 30),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'REIZ TECH HOMEWORK ASSIGNMENT',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                // Expanded(
                //   child: SizedBox(
                //     width: 25,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: ElevatedButton(
                    onPressed: () {
                      _getData() => setState(() {});
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainPage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Refresh',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        shadowColor: Colors.transparent,
                        primary: Color.fromARGB(255, 143, 255, 143),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: ElevatedButton(
                      onPressed: sortAlphabetically,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          isDescending ? 'Sort Z-A' : 'Sort A-Z',
                          style: TextStyle(
                              color: Colors.black,
                              //fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          shadowColor: Colors.transparent,
                          primary: Color.fromARGB(255, 143, 255, 143),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: ElevatedButton(
                      onPressed: searchOceania,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'In Oceania',
                          style: TextStyle(
                              color: Colors.black,
                              // fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          shadowColor: Colors.transparent,
                          primary: Color.fromARGB(255, 143, 255, 143),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: ElevatedButton(
                      onPressed: lessThanLT,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Area: < Lithuania',
                          style: TextStyle(
                              color: Colors.black,
                              //fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          shadowColor: Colors.transparent,
                          primary: Color.fromARGB(255, 143, 255, 143),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Container(
                      width: 250,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 204, 255, 204),
                        border: Border.all(
                            color: Color.fromARGB(255, 143, 255, 143)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _countryNameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Insert Country',
                          ),
                          onSubmitted: (String value) async {
                            setState(() {
                              searchCountry(value);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //CountriesListHeader
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Table(
                  columnWidths: {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        Text(
                          'Country',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Region',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Area',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Independent',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            //Countries List
            Column(
              children: [
                _countriesModel == null || _countriesModel!.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : showList(pageNum, resultsNum)
              ],
            ),

            //Pagination thing

            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        pageNum = 0;
                      });
                    },
                    child: Text(
                      '1',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      primary: Color.fromARGB(
                          255, 143, 255, 143), // <-- Button color
                      onPrimary: Colors.white, // <-- Splash color
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        pageNum = 10;
                      });
                    },
                    child: Text(
                      '2',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      primary: Color.fromARGB(
                          255, 143, 255, 143), // <-- Button color
                      onPrimary: Colors.white, // <-- Splash color
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        pageNum = 20;
                      });
                    },
                    child: Text(
                      '3',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      primary: Color.fromARGB(
                          255, 143, 255, 143), // <-- Button color
                      onPrimary: Colors.white, // <-- Splash color
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        pageNum = 30;
                      });
                    },
                    child: Text(
                      '4',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      primary: Color.fromARGB(
                          255, 143, 255, 143), // <-- Button color
                      onPrimary: Colors.white, // <-- Splash color
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        pageNum = 40;
                      });
                    },
                    child: Text(
                      '5',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      primary: Color.fromARGB(
                          255, 143, 255, 143), // <-- Button color
                      onPrimary: Colors.white, // <-- Splash color
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: SizedBox(
                      width: 20.0,
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (String value) async {
                          setState(() {
                            pageNum = (int.parse(value) - 1) * 10;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text('Current Page: ' + ((pageNum / 10) + 1).toString()),
            )
          ]),
        ),
      ),
    );
  }
}
