import 'package:flutter/material.dart';

class DataCard extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  final String emoji;

  const DataCard({
    super.key,
    required this.color,
    required this.emoji,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(color: color,
    borderRadius: BorderRadius.circular(15),
    
      ),
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          Text(emoji,style: TextStyle(fontSize: 30),),
          Text(label,style: TextStyle(fontWeight: FontWeight.bold),),
          Text(value, style: TextStyle(fontSize: 18),),
        ],
      ),
    );
  }
}
