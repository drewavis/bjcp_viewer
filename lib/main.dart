import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bjcp_viewer/styleGuide2015.dart';
import 'package:bjcp_viewer/styleGuide2008.dart';
List<String> categories = [];
final List beerClass2015 = styleGuide2015['class'][0]['category'];


void main() {
  for (Map cat in beerClass2015) {
    categories.add(cat['name']);
  }

  runApp(
    MaterialApp(
      title: 'BCJP Viewer',
      home: MainScreen(categories: categories),
    ),
  );
}

class MainScreen extends StatefulWidget {
  final List<String> categories;
  int _styleYear = 1;
  void _handleYearChange(int value){

  }

  MainScreen({Key key, @required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'BJCP Beer Categories';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions:<Widget>[
          FlatButton(
              child:Text('2008'),
          onPressed: (){_handleYearChange(0);}),
          FlatButton (

          child:Text( '2015'),
          onPressed: (){_handleYearChange(1);}),

        ]


      ),
      body: ListView.builder(
        padding: EdgeInsets.all(0.0),
        itemCount: categories.length,
        itemExtent: 32.0,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${index + 1}: ${categories[index]}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategories(
                      subCats: beerClass2015[index]['subcategory'],
                      subCatNum: index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SubCategories extends StatelessWidget {
  final List subCats;
  final int subCatNum;

  SubCategories({Key key, @required this.subCats, @required this.subCatNum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${subCatNum + 1}: ${categories[subCatNum]}'),
      ),
      body: ListView.builder(
        itemCount: subCats.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${subCats[index]['_id']}: ${subCats[index]['name']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StyleScreen(
                      beerStyle: beerClass2015[subCatNum]['subcategory'][index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class StyleScreen extends StatelessWidget {
  final Map beerStyle;

  StyleScreen({Key key, @required this.beerStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List elements = [
      'Aroma',
      'Appearance',
      'Flavor',
      'Mouthfeel',
      'Impression',
      'Comments',
      'History',
      'Ingredients',
      'Comparison',
      'Examples',
      'Stats'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('${beerStyle['_id']} ${beerStyle['name']}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: elements.length,
          itemBuilder: (context, index) {
            String section = elements[index].toString().toLowerCase();
            if (section == 'stats') {
              return ListTile(
                  title: Text('Vital Statistics'),
                  subtitle: Column(
                    children: buildStats(beerStyle),
                  ));
            } else if (beerStyle[section] != null) {
              return ListTile(
                title: Text('${elements[index]}:'),
                subtitle: Text(' ${beerStyle[section]}'),
              );
            }
          },
        ),
      ),
    );
  }
}

List<Widget> buildStats(Map beerStyle) {
  List<Widget> ret = [
    Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Expanded(
        child: Text(
            'OG: ${beerStyle['stats']['og']['low']} - ${beerStyle['stats']['og']['high']}',
            textAlign: TextAlign.left,
            ),
      ),
      Expanded(
          child: Text(
              'FG: ${beerStyle['stats']['fg']['low']} - ${beerStyle['stats']['fg']['high']}',
              textAlign: TextAlign.left))
    ]),
    Row(
      children: <Widget>[
        Expanded(
        child:Text(
            'IBUs: ${beerStyle['stats']['ibu']['low']} - ${beerStyle['stats']['ibu']['high']}')),
        Expanded( child: Text(
            'SRM: ${beerStyle['stats']['srm']['low']} - ${beerStyle['stats']['srm']['high']}')),
      ],
    ),
    Row(children: <Widget>[
      Text(
          'ABV: ${beerStyle['stats']['abv']['low']} - ${beerStyle['stats']['abv']['high']}'),
    ]),
  ];
  return ret;
}
