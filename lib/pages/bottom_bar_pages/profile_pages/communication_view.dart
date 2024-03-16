import 'package:flutter/material.dart';

class CommunicationView extends StatelessWidget {
  const CommunicationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: Text('İletişim Bilgileri'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Telefon Numarası : 05458420249"),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                          "Adres Bilgisi : Barbaros Hayrettin Paşa Mah. 2284. Sk 2/A Daire 35"),
                      SizedBox(
                        height: 12,
                      ),
                      Text("Mail Bilgisi: info@ile.com")
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
