import 'package:flutter/material.dart';
import 'package:test_app/storage/app_preference.dart';
import 'package:test_app/ui/card_payment/card_payment.dart';
import 'package:test_app/ui/configuration/configuration.dart';

class Home extends StatefulWidget {
  final String appName;

  const Home({super.key, required this.appName});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appName),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Text(
            "Welcome".toUpperCase(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 10,
          ),
          Image.asset(
            'assets/ic_logo.png',
            height: 90,
          ),
          const Spacer(
            flex: 1,
          ),
          Center(
            child: Row(
              children: [
                Expanded(
                  child: homeMenu(
                      Icons.settings,
                      "Configuration",
                      () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Configuration()),
                          )),
                ),
                Expanded(
                  child: homeMenu(
                    Icons.credit_card,
                    "Card Payment",
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CardPayment()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget homeMenu(IconData icon, String title, VoidCallback onClick) {
    return Card(
      child: InkWell(
        onTap: () => onClick(),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 50, bottom: 50),
          child: Column(
            children: [
              Icon(
                icon,
                size: 100,
                color: Colors.red,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
