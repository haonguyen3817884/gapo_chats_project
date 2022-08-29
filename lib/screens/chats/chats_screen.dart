import 'package:base_flutter/screens/chats/chats_controller.dart';
import 'package:base_flutter/screens/chats/widgets/chats_body.dart';
import 'package:base_flutter/screens/chats/widgets/header.dart';
import 'package:base_flutter/screens/chats/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ChatsController());
  }
}

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: const [
              HeaderChats(),
              SizedBox(height: 20,),
              SearchChats(),
              SizedBox(height: 5,),
              ChatsBody()
            ],
          ),
        ),
      ),
    );
  }
}

