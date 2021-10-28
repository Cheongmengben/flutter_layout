import 'package:exercise_4/UserData.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'UserData.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Contact List Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 

  // Fetch content from the json file
  Future<List<UserData>> readJson() async {
    final response = await rootBundle.loadString('assets/sample.json');
    final data = await json.decode(response) as List <dynamic>;
    return data.map((e) => UserData.fromJson(e)).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
      future: readJson(),
      builder: (context, data) {
        if (data.hasError) {
         //in case if error found
          return Center(child: Text("${data.error}"));
        } else if (data.hasData) {
           //once data is ready this else block will execute
          // items will hold all the data of DataModel
           //items[index].name can be used to fetch name of product as done below
          var items = data.data as List<UserData>;
          return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                          margin: EdgeInsets.all(10),
                           child: Row(
                children: <Widget> [ 
               CircleAvatar(
                    backgroundImage: NetworkImage(items[index].avatar.toString()),
                    
                  ), 
                   Expanded(
                    flex:5,
                    
                    child: Container(
                      
                      child: Column(children: <Widget>[
                        Container(
                          child: Text(items[index].first_name.toString(),textAlign: TextAlign.left,),
                        ),
                        Container(
                          child: Text(items[index].username.toString())
                        ),
                        Container(
                          child: Text(items[index].status.toString())
                        )
                      ],)

                  ),
                  ),
                  Expanded(
                    flex: 1,
                    child:Container(
                    child: Column(children: <Widget>[
                      Container(
                        child: Text(items[index].last_seen_time.toString()),
                      ),
                      Container(
                        child: Text(items[index].messages.toString()),
                      )
                    ],),
                  )
                  ) 
                ]
                           )
                );
              });
        } else {
              // show circular progress while data is getting fetched from json file
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    )
    );
  }
}
