import 'package:cab_rider/brand_colors.dart';
import 'package:cab_rider/dataprovider/appdata.dart';
import 'package:cab_rider/screens/mainpage.dart';
import 'package:cab_rider/widgets/BrandDivier.dart';
import 'package:cab_rider/widgets/HistoryTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  static String id = "history";

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip History', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(0),
          itemBuilder: (context, index) {
          return HistoryTile(
            history: Provider.of<AppData>(context).tripHistoryDataList[index],
          );
          },
          separatorBuilder: (BuildContext context, int index) => BrandDivider(),
          itemCount: Provider.of<AppData>(context).tripHistoryDataList.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap:  true,
      ),
    );
  }
}
