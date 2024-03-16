// ignore_for_file: depend_on_referenced_packages, prefer_final_fields

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // DateFormat kullanmak için bu paketi eklemeyi unutmayın.

import '../../const/const.dart';
import '../../model/message_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      required this.senderID,
      required this.image,
      required this.name});
  final String senderID;
  final String image;
  final String name;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> messages = [];
  bool isLoading = false;
  Future<MessageModel> getMessageFridens() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.post(
      Uri.parse("https://vocopus.com/api/v1/getMessageWithSenderReceiverID"),
      body: {
        "apiToken": apiToken,
        "senderID": widget.senderID,
        "receiverID": configID
      },
    );

    if (response.statusCode == 200) {
      var model = MessageModel.fromJson(jsonDecode(response.body));

      print(response.body);
      if (model.response?.isNotEmpty ?? false)
        for (var i = 0; i < model.response!.length; i++) {
          String dateString = model.response![i].createdAt.toString();
          DateFormat format = DateFormat("dd-MM-yyyy HH:mm:ss");
          DateTime dateTime = format.parse(dateString);
          var message = Message(
              text: model.response?[i].message.toString() ?? "",
              isFromUser: false,
              timestamp: dateTime);

          messages.add(message);
        }
      setState(() {
        isLoading = false;
      });
      return MessageModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Kayıt Başarısız');
    }
  }

  Future<MessageModel> getMessage() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.post(
      Uri.parse("https://vocopus.com/api/v1/getMessageWithSenderReceiverID"),
      body: {
        "apiToken": apiToken,
        "senderID": configID,
        "receiverID": widget.senderID,
      },
    );

    if (response.statusCode == 200) {
      var model = MessageModel.fromJson(jsonDecode(response.body));
      print(response.body);
      if (model.response?.isNotEmpty ?? false) {
        for (var i = 0; i < model.response!.length; i++) {
          String dateString = model.response![i].createdAt.toString();
          DateFormat format = DateFormat("dd-MM-yyyy HH:mm:ss");
          DateTime dateTime = format.parse(dateString);
          var message = Message(
              text: model.response?[i].message.toString() ?? "",
              isFromUser: true,
              timestamp: dateTime);
          print(message);
          messages.add(message);
        }
      }

      setState(() {
        isLoading = false;
      });
      return MessageModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Kayıt Başarısız');
    }
  }

  Future<void> sendMessage(String message) async {
    var response = await http.post(
      Uri.parse("https://vocopus.com/api/v1/sendMessageChat"),
      body: {
        "apiToken": apiToken,
        "senderID": configID,
        "receiverID": widget.senderID,
        "message": message
      },
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Kayıt Başarısız');
    }
  }

  final TextEditingController _controller = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState

    super.initState();
    getMessage();
    getMessageFridens();
  }

  @override
  Widget build(BuildContext context) {
    messages.sort((a, b) =>
        a.timestamp.compareTo(b.timestamp)); // Zaman damgasına göre sıralama

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(widget.name),
        leading: Container(
            padding: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
                color: Color.fromARGB(97, 255, 255, 255),
                shape: BoxShape.circle),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.image),
              ),
            )),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      String formattedTime =
                          DateFormat('HH.mm').format(message.timestamp);
                      return Align(
                        alignment: message.isFromUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: message.isFromUser
                                ? Colors.blue
                                : Colors.grey[300],
                          ),
                          child: Column(
                            crossAxisAlignment: message.isFromUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.text,
                                style: TextStyle(
                                  color: message.isFromUser
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                message.isFromUser
                                    ? 'Ben, $formattedTime'
                                    : 'Melisa Yıldırım, $formattedTime',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: message.isFromUser
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    // itemBuilder: (context, index) {

                    //   return Align(
                    //     alignment: message.isFromUser
                    //         ? Alignment.topRight
                    //         : Alignment.topLeft,
                    //     child: ListTile(
                    //       title: Text(
                    //         message.text,
                    //         style: TextStyle(
                    //           color: message.isFromUser
                    //               ? Colors.blue
                    //               : Colors.black,
                    //         ),
                    //       ),
                    //       subtitle: Text(
                    //         message.isFromUser
                    //             ? 'Ben, $formattedTime'
                    //             : 'Emre, $formattedTime',
                    //       ),
                    //     ),
                    //   );
                    // },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                              hintText: 'Mesajınızı yazın...'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          setState(() {
                            final currentTime = DateTime.now();
                            sendMessage(_controller.text);
                            messages.add(Message(
                                text: _controller.text,
                                isFromUser: true,
                                timestamp: currentTime));
                            _controller.clear();
                          });
                          _scrollToBottom(); // Listenin en altına kaydırma
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }
}

class Message {
  final String text;
  final bool isFromUser;
  final DateTime timestamp;

  Message(
      {required this.text, required this.isFromUser, required this.timestamp});
}
