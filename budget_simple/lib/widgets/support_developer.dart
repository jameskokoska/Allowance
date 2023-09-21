import 'dart:async';
import 'dart:developer';

import 'package:budget_simple/pages/about_page.dart';
import 'package:budget_simple/struct/functions.dart';
import 'package:budget_simple/widgets/plasma_render.dart';
import 'package:budget_simple/widgets/settings_container.dart';
import 'package:budget_simple/widgets/tappable.dart';
import 'package:budget_simple/widgets/text_font.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sa3_liquid/liquid/plasma/plasma.dart' as plasma;
import 'package:universal_io/io.dart';

class SupportDeveloper extends StatefulWidget {
  const SupportDeveloper({super.key});

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
    if (!kIsWeb && Platform.isIOS == false) {
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
            // inspect(response.productDetails);
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
    return kIsWeb || products.keys.isEmpty || Platform.isIOS
        ? const SizedBox.shrink()
        : Column(
            children: [
              const Divider(),
              closed
                  ? const SizedBox.shrink()
                  : SettingsContainer(
                      title: "Buy me a coffee",
                      afterWidget: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 17,
                      ),
                      icon: Icons.coffee,
                      onTap: () {
                        InAppPurchase.instance.buyConsumable(
                          purchaseParam: PurchaseParam(
                            productDetails: products["coffee"]!,
                          ),
                        );
                      },
                    ),
              closed
                  ? const SizedBox.shrink()
                  : SettingsContainer(
                      title: "Buy me a cake",
                      afterWidget: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 17,
                      ),
                      icon: Icons.cake,
                      onTap: () {
                        InAppPurchase.instance.buyConsumable(
                          purchaseParam: PurchaseParam(
                            productDetails: products["cake"]!,
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

class CashewPromo extends StatelessWidget {
  const CashewPromo({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 550),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      tileMode: TileMode.mirror,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.4)
                            : Theme.of(context).colorScheme.primary,
                        Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.secondary,
                        Theme.of(context).brightness == Brightness.light
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.4)
                            : Theme.of(context).colorScheme.primary
                      ],
                      stops: const [
                        0,
                        0.3,
                        5.3,
                      ],
                    ),
                    backgroundBlendMode: BlendMode.srcOver,
                  ),
                  child: plasma.PlasmaRenderer(
                    type: plasma.PlasmaType.infinity,
                    particles: 7,
                    color: Theme.of(context).brightness == Brightness.light
                        ? const Color(0x28B4B4B4)
                        : const Color(0x2DB6B6B6),
                    blur: 0.4,
                    size: 0.8,
                    speed: 3.5,
                    offset: 0,
                    blendMode: BlendMode.plus,
                    particleType: plasma.ParticleType.atlas,
                    variation1: 0,
                    variation2: 0,
                    variation3: 0,
                    rotation: 0,
                  ),
                ),
              ),
              Image(
                image: AssetImage(
                  Theme.of(context).brightness == Brightness.light
                      ? kIsWeb
                          ? "assets/cashew-promo/CashewPromoLightAll.png"
                          : "assets/cashew-promo/CashewPromoLight.png"
                      : kIsWeb
                          ? "assets/cashew-promo/CashewPromoDarkAll.png"
                          : "assets/cashew-promo/CashewPromoDark.png",
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    onTap: () {
                      if (kIsWeb) {
                        openUrl("https://cashewapp.web.app/");
                      } else {
                        openUrl(
                            "https://play.google.com/store/apps/details?id=com.budget.tracker_app");
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CashewPromoPopup extends StatefulWidget {
  const CashewPromoPopup({super.key});

  @override
  State<CashewPromoPopup> createState() => _CashewPromoPopupState();
}

class _CashewPromoPopupState extends State<CashewPromoPopup> {
  bool closed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: Alignment.topCenter,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOutCubicEmphasized,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: closed
            ? Container(
                key: const ValueKey(1),
              )
            : Stack(
                key: const ValueKey(2),
                children: [
                  const CashewPromo(),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: IconButton(
                      padding: const EdgeInsets.all(15),
                      onPressed: () {
                        setState(() {
                          closed = true;
                        });
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
