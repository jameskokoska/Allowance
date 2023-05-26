import 'dart:async';
import 'dart:developer';

import 'package:budget_simple/pages/about_page.dart';
import 'package:budget_simple/widgets/plasma_render.dart';
import 'package:budget_simple/widgets/settings_container.dart';
import 'package:budget_simple/widgets/tappable.dart';
import 'package:budget_simple/widgets/text_font.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:budget_simple/struct/functions.dart';
import 'package:budget_simple/struct/translations.dart';

class SupportDeveloper extends StatefulWidget {
  const SupportDeveloper({super.key, this.showCloseButton = false});
  final bool showCloseButton;

  @override
  State<SupportDeveloper> createState() => _SupportDeveloperState();
}

class _SupportDeveloperState extends State<SupportDeveloper> {
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  Map<String, ProductDetails> products = {};
  bool closed = false;
  bool storeAvailable = false;

  @override
  void initState() {
    if (!kIsWeb) {
      Stream<List<PurchaseDetails>> purchaseUpdated =
          InAppPurchase.instance.purchaseStream;
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList, context);
      }, onDone: () {
        _subscription?.cancel();
      }, onError: (error) {
        // handle error here.
      });
      Future.delayed(const Duration(milliseconds: 0), () async {
        final bool available = await InAppPurchase.instance.isAvailable();
        setState(() {
          closed = !available;
        });
        if (available) {
          const Set<String> kIds = <String>{
            'coffee',
            'cake',
            'meal',
            'subscription',
          };
          final ProductDetailsResponse response =
              await InAppPurchase.instance.queryProductDetails(kIds);
          if (response.notFoundIDs.isNotEmpty) {
            setState(() {
              closed = true;
            });
          } else {
            Map<String, ProductDetails> productMap = {
              for (var product in response.productDetails) product.id: product
            };
            inspect(response.productDetails);
            setState(() {
              products = productMap;
            });
          }
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb || products.keys.isEmpty
        ? const SizedBox.shrink()
        : Column(
            children: [
              AnimatedSize(
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
                                              horizontal: 10, vertical: 25),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 28.0),
                                                child: Wrap(
                                                  spacing: 15,
                                                  runSpacing: 10,
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    DonationMenuItem(
                                                        subheader:
                                                            products["coffee"]!
                                                                .price,
                                                        onTap: () {
                                                          InAppPurchase.instance
                                                              .buyConsumable(
                                                            purchaseParam:
                                                                PurchaseParam(
                                                              productDetails:
                                                                  products[
                                                                      "coffee"]!,
                                                            ),
                                                          );
                                                        },
                                                        imagePath:
                                                            "assets/icons/coffee-cup.png"),
                                                    DonationMenuItem(
                                                        subheader:
                                                            products["cake"]!
                                                                .price,
                                                        onTap: () {
                                                          InAppPurchase.instance
                                                              .buyConsumable(
                                                            purchaseParam:
                                                                PurchaseParam(
                                                              productDetails:
                                                                  products[
                                                                      "cake"]!,
                                                            ),
                                                          );
                                                        },
                                                        imagePath:
                                                            "assets/icons/cupcake.png"),
                                                    DonationMenuItem(
                                                        subheader:
                                                            products["meal"]!
                                                                .price,
                                                        onTap: () {
                                                          InAppPurchase.instance
                                                              .buyConsumable(
                                                            purchaseParam:
                                                                PurchaseParam(
                                                              productDetails:
                                                                  products[
                                                                      "meal"]!,
                                                            ),
                                                          );
                                                        },
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
              ),
              widget.showCloseButton
                  ? const SizedBox.shrink()
                  : const Divider(),
              widget.showCloseButton
                  ? const SizedBox.shrink()
                  : SettingsContainer(
                      title: "Donate Monthly",
                      afterWidget: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 17,
                      ),
                      icon: Icons.thumb_up_alt_outlined,
                      onTap: () {
                        InAppPurchase.instance.buyConsumable(
                          purchaseParam: PurchaseParam(
                            productDetails: products["subscription"]!,
                          ),
                        );
                      },
                    ),
            ],
          );
  }
}

void _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList, BuildContext context) {
  // ignore: avoid_function_literals_in_foreach_calls
  purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      // print("LOADING");
    } else {
      if (purchaseDetails.status == PurchaseStatus.error ||
          purchaseDetails.status == PurchaseStatus.canceled) {
        SnackBar snackBar = const SnackBar(
          content: Text('There was an error. Please try again later.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        SnackBar snackBar = const SnackBar(
          content: Text('Thank you for supporting Allowance!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }
  });
}
