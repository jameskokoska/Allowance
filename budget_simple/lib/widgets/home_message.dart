import 'package:budget_simple/widgets/text_font.dart';
import 'package:flutter/material.dart';

class HomeMessage extends StatelessWidget {
  final String title;
  final String message;
  final bool show;
  final Function onClose;
  const HomeMessage({
    super.key,
    required this.title,
    required this.message,
    required this.show,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: Alignment.topCenter,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOutCubicEmphasized,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: show == false
            ? Container(
                key: const ValueKey(1),
              )
            : GestureDetector(
                key: const ValueKey(2),
                onTap: () {},
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Stack(
                    children: [
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          padding: const EdgeInsets.all(15),
                          icon: const Icon(Icons.close),
                          color: Theme.of(context).colorScheme.tertiary,
                          onPressed: () {
                            onClose();
                          },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 28.0),
                                    child: TextFont(
                                      text: title,
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  TextFont(
                                    fontSize: 15,
                                    text: message,
                                    maxLines: 50,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
