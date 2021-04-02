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
          tag(Icons.family_restroom_rounded, "family1"),
          tag(Icons.family_restroom_rounded, "family2"),
          tag(Icons.family_restroom_rounded, "family3"),
          tag(Icons.family_restroom_rounded, "family4"),
          tag(Icons.family_restroom_rounded, "family5"),
          tag(Icons.family_restroom_rounded, "family6"),
          tag(Icons.family_restroom_rounded, "family7"),
          tag(Icons.family_restroom_rounded, "family8"),
          tag(Icons.family_restroom_rounded, "family9"),
          tag(Icons.family_restroom_rounded, "family10"),
        ],
      ),
    );
  }
}
