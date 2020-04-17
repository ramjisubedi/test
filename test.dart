import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:med/page/zoom_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
class PrescriptionPage extends StatefulWidget {
  final String title;
  PrescriptionPage(this.title);
  bool isSelected = false;
  
  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  bool isSelected = false;
 List<Item> selectedList;
  Future<List> refresh() async{
 var url = 'http://med.ramjisubedi.com.np/get.php';
 final response = await http.get(url);
 return json.decode(response.body);

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
       ),
            body: RefreshIndicator(
              child: FutureBuilder(
                future: refresh(),
                builder: (context,snap){
                if(!snap.hasData)
                {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

        return GestureDetector(
child:  GridView.extent(maxCrossAxisExtent: 120.0,
        children: List.generate(snap.data.length, (index){
         print(snap.data[index]);
return GestureDetector(
  child: Card(
 child:Stack(
children:<Widget>[ 
  CachedNetworkImage(
            placeholder: (context, url) => CircularProgressIndicator(),
            imageUrl:
                'http://med.ramjisubedi.com.np/uploads/'+snap.data[index]['image'],
                fit: BoxFit.fill,
   colorBlendMode: BlendMode.modulate,
          ),
          isSelected
              ? Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.check_circle,
                color: Colors.blue,
              ),
            ),
          )
              : Container()
          ],
)
),
 onTap: () {
 Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new ZoomPage('http://med.ramjisubedi.com.np/uploads/'+snap.data[index]['image'])   
                        ));
         },
         
         onLongPress: (){
           setState(() {
          isSelected = !isSelected;
        });
          print('long press');
         },
);

        }
        ),
        ),
      
        );
       
              })
            
            , onRefresh: refresh),
          );
       
  }
}

class DetailScreen extends StatelessWidget {
  final String title;
  DetailScreen(this.title);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              title,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
class Item {
  String imageUrl;
  int rank;
  String text;

  Item(this.rank,this.text,this.imageUrl);
}



