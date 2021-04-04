import 'package:flutter/material.dart';

class Tags extends StatefulWidget {
   List<String> tags = [];
  
  Tags({@required this.tags});
  @override
  _TagsState createState() => _TagsState();
}

class _TagsState extends State<Tags> {
 

  Widget tag(IconData icon, String title) {
    return Column(children: [
      InkWell(
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.tags.contains(title) ? Colors.white : Colors.greenAccent,
                border: Border.all(color: Colors.grey.shade400)),
            child: Icon(icon,
                color:  widget.tags.contains(title)
                    ? Colors.greenAccent
                    : Colors.amberAccent,
                size: 25),
          ),
          onTap: () {
            setState(() {
              if ( widget.tags.contains(title)) {
                 widget.tags.remove(title);
              
              } else {
                widget. tags.add(title);
              
              }
            });
          }),
      Text(title, style: TextStyle(fontSize: 12, color: Colors.grey))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,

        children: [
          tag(Icons.family_restroom_rounded, "family"),
          tag(Icons.person_rounded, "friends"),
          tag(Icons.favorite, "date"),
          tag(Icons.extension_rounded, "exercise"),
          tag(Icons.sports_baseball, "sports"),
          tag(Icons.chrome_reader_mode, "reading"),
          tag(Icons.games, "gaming"),
          tag(Icons.family_restroom_rounded, "cleaning"),
          tag(Icons.family_restroom_rounded, "shopping"),
          tag(Icons.family_restroom_rounded, "relax"),
          tag(Icons.family_restroom_rounded, "sleep early"),
          tag(Icons.family_restroom_rounded, "movies"),
          tag(Icons.family_restroom_rounded, "eat healthy"),
        ],
      ),
    );
  }
}
