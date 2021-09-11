import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'dart:io' show Platform;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'No Contact WA',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'No Contact WA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final inputController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  String countryCode = "";

  void _onCountryChange(CountryCode countryCode) {
    this.countryCode = countryCode.toString().replaceAll("+", "");
  }

  initCountry(String code) {
    countryCode = code.toString().replaceAll("+", "");
  }

  validate(String text) {
    if (text == '' || text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a WhatsApp number')),
      );
    } else if (text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter 10 digit WhatsApp number')),
      );
    } else {
      if (Platform.isAndroid) {
        final intent = AndroidIntent(
            action: 'action_view',
            data: Uri.encodeFull(
                'https://wa.me/' + countryCode + inputController.text),
            package: 'com.whatsapp');
        intent.launch();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: GestureDetector(
                onTap: () {
                  if (Platform.isAndroid) {
                    final intent = AndroidIntent(
                        action: 'action_view',
                        data: Uri.encodeFull(
                            'https://github.com/devphilip18/no-contact-whatsapp-flutter'),
                        package: 'com.android.chrome');
                    intent.launch();
                  }
                },
                child: Image.asset('assets/images/github.png'),
              )),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: CountryCodePicker(
                      onInit: initCountry('+91'),
                      onChanged: _onCountryChange,
                      initialSelection: 'IN',
                      favorite: const ['+91', 'IN'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: TextField(
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        decoration: const InputDecoration(
                            hintText: 'Enter the WhatsApp number',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            isDense: true),
                        controller: inputController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 10,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  validate(inputController.text);
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: const [
        Center(
          child: Text(
            "Made With Flutter 💚",
          ),
        ),
      ],
    );
  }
}

