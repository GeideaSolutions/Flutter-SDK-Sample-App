import 'package:flutter/material.dart';

class TabSelector extends StatelessWidget {
  final String title1;
  final String title2;
  final String selectedTitle;
  final Function(String selection) onClick;

  const TabSelector({
    super.key,
    required this.title1,
    required this.title2,
    required this.selectedTitle,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => onClick(title1),
          child: Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            decoration: BoxDecoration(
                color: (selectedTitle == title1)
                    ? Colors.blue.withOpacity(0.2)
                    : Colors.transparent,
                border: Border.all(
                    color:
                        (selectedTitle == title1) ? Colors.blue : Colors.grey,
                    width: 1),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0))),
            child: Text(
              title1.toUpperCase(),
              style: TextStyle(
                color: (selectedTitle == title1) ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () => onClick(title2),
          child: Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            decoration: BoxDecoration(
                color: (selectedTitle == title2)
                    ? Colors.blue.withOpacity(0.2)
                    : Colors.transparent,
                border: Border.all(
                    color:
                        (selectedTitle == title2) ? Colors.blue : Colors.grey,
                    width: 1),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0))),
            child: Text(
              title2.toUpperCase(),
              style: TextStyle(
                color: (selectedTitle == title2) ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
