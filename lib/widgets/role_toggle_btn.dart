import 'package:flutter/material.dart';
import 'package:classlog/core/theme/app_settings.dart';

// 📌 Role function para la siguiente version..
// (profesor->puede pasar lista etc.)
class RoleSegmentToggle extends StatelessWidget {
  final int selectedIndex; // 0 = Estudiante, 1 = Profesor
  final ValueChanged<int> onChanged;

  const RoleSegmentToggle({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffe9e9ee),
        borderRadius: BorderRadius.circular(Sizes.size32),
      ),
      padding: const EdgeInsets.all(4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final itemWidth = totalWidth / 2;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                left: selectedIndex == 0 ? 0 : itemWidth,
                top: 0,
                bottom: 0,
                child: Container(
                  width: itemWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(Sizes.size32),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(0),
                      child: SizedBox(
                        height: 32,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              color: selectedIndex == 0
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                            child: const Text('Estudiante'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onChanged(1),
                      child: SizedBox(
                        height: 32,
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              color: selectedIndex == 1
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                            child: const Text('Profesor'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
