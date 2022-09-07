import 'package:flutter/material.dart';

class MemoryCard extends StatelessWidget {
  const MemoryCard({
    Key? key,
    required this.cardColor,
    required this.icon,
    required this.iconColor,
    required this.totalMemory,
    required this.freeMemory,
    required this.unit,
  }) : super(key: key);

  final Color cardColor;
  final IconData icon;
  final Color iconColor;
  final double totalMemory;
  final double freeMemory;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.white54,
        margin: const EdgeInsets.all(5),
        elevation: 14,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Row(children: [
                  Icon(icon, color: iconColor),
                  Text(
                    "${totalMemory.toStringAsFixed(1)}/${(totalMemory - freeMemory).toStringAsFixed(1)}$unit",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ]),
              ),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: RichText(
                      text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                          children: [
                            const TextSpan(
                                text: "Total space: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: "${totalMemory.toStringAsFixed(3)}$unit",
                            ),
                          ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: RichText(
                      text: TextSpan(
                          style: const TextStyle(
                            fontSize: 11.1,
                            color: Colors.white,
                          ),
                          children: [
                            const TextSpan(
                                text: "Occupied space: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text:
                                  "${(totalMemory - freeMemory).toStringAsFixed(3)}$unit",
                            ),
                          ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: RichText(
                      text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                          children: [
                            const TextSpan(
                                text: "Free space: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: "${freeMemory.toStringAsFixed(3)}$unit",
                            ),
                          ]),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
