import 'package:budget_simple/pages/about_page.dart';
import 'package:budget_simple/widgets/plasma_render.dart';
import 'package:budget_simple/widgets/tappable.dart';
import 'package:budget_simple/widgets/text_font.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SupportDeveloper extends StatefulWidget {
  const SupportDeveloper({super.key, this.showCloseButton = false});
  final bool showCloseButton;

  @override
  State<SupportDeveloper> createState() => _SupportDeveloperState();
}

class _SupportDeveloperState extends State<SupportDeveloper> {
  bool closed = false;

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? const SizedBox.shrink()
        : AnimatedSize(
            alignment: Alignment.topCenter,
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOutCubicEmphasized,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: closed
                  ? Container(
                      key: const ValueKey(1),
                    )
                  : ConstrainedBox(
                      key: const ValueKey(2),
                      constraints: const BoxConstraints(maxWidth: 550),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Tappable(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer
                              .withOpacity(0.7),
                          onTap: () {},
                          borderRadius: 15,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: PlasmaRender(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer
                                        : Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                  ),
                                ),
                              ),
                              widget.showCloseButton
                                  ? Positioned(
                                      top: 5,
                                      right: 5,
                                      child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              closed = true;
                                            });
                                          },
                                          icon: const Icon(Icons.close)),
                                    )
                                  : const SizedBox.shrink(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 40),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextFont(
                                              text: "Support the Developer",
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              textAlign: TextAlign.center,
                                              maxLines: 5,
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: TextFont(
                                              text:
                                                  "Buy the developer something off the menu!",
                                              fontSize: 15,
                                              textAlign: TextAlign.center,
                                              maxLines: 5,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 28.0),
                                            child: Wrap(
                                              spacing: 15,
                                              runSpacing: 10,
                                              alignment: WrapAlignment.center,
                                              children: [
                                                DonationMenuItem(
                                                    onTap: () {},
                                                    imagePath:
                                                        "assets/icons/coffee-cup.png"),
                                                DonationMenuItem(
                                                    onTap: () {},
                                                    imagePath:
                                                        "assets/icons/cupcake.png"),
                                                DonationMenuItem(
                                                    onTap: () {},
                                                    imagePath:
                                                        "assets/icons/salad.png"),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
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
            ),
          );
  }
}
