// import 'package:Apka_kitchen/controller/sendController.dart';
import 'dart:async';
import 'package:Apka_kitchen/controller/auth_controller.dart';
import 'package:Apka_kitchen/controller/splash_controller.dart';
import 'package:Apka_kitchen/controller/user_controller.dart';
import 'package:Apka_kitchen/data/model/body/chat_model.dart';
import 'package:Apka_kitchen/util/app_constants.dart';
// import 'package:Apka_kitchen/data/model/body/send_message_model.dart';
import 'package:Apka_kitchen/util/messages.dart';
import 'package:Apka_kitchen/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/chat_controller.dart';
import '../../../controller/send_msg_controller.dart';
import '../../../util/styles.dart';

class ChatScreen2 extends StatefulWidget {
  //const ChatScreen2(@required this.b);
  // final ChatsModel b;

  @override
  _ChatScreen2State createState() => _ChatScreen2State();
}

class _ChatScreen2State extends State<ChatScreen2> {
  TextEditingController _textController = TextEditingController();
  final List<Widget> _messages = [];
   ScrollController _scrollController; // Add this line
  FocusNode _textFieldFocusNode = FocusNode();


  // @override
  // void initState() {
  //   Get.find<ReciverMsgController>().fetchChatData();
  //   // TODO: implement initState
  //   super.initState();
  // }

   Timer _timer;
  @override
  void initState() {
    _scrollController = ScrollController();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      Get.find<ReciverMsgController>().fetchChatData();
      _textFieldFocusNode = FocusNode();
      _textController = TextEditingController();
      // _textController..focusNode = _textFieldFocusNode;

    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the screen is disposed
    _textFieldFocusNode.dispose();
    _scrollController.dispose();
    _textController.dispose();
    _textFieldFocusNode.dispose(); // Dispose of the FocusNode

    super.dispose();


  }

  @override
  Widget build(BuildContext context) {

    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent,
    //   duration: Duration(milliseconds: 300),
    //   curve: Curves.easeOut,
    // );

    return Scaffold(
       backgroundColor: Colors.white,
      // backgroundColor: Colors.black12,

        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/image/bg.jpg"),fit: BoxFit.fill
            )
          ),
          child: GetBuilder<UserController>(
            builder: (userController){
              return  GetBuilder<ReciverMsgController>(
                builder: (reciverControllers) {
                  return Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20,),
                        height: 110,
                        width: Get.width,
                        decoration: const BoxDecoration(
                          //  color: AppColors.white,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 45,
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 36,
                                  width: 36,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9.34),
                                      border: Border.all(
                                        color: Colors.grey,
                                      )

                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Icon(Icons.arrow_back,color: Colors.white,),
                                  ),
                                ),
                                SizedBox(
                                  width: 18,
                                ),
                                Row(
                                  children: [
                                    ClipOval(
                                        child: CustomImage(
                                          image:
                                          '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                                              '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        )),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //  SizedBox(height:  30,),
                                        Text(
                                          userController.userInfoModel.fName+ userController.userInfoModel.lName,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,color: Colors.white
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      StreamBuilder<ChatModel>(
                        stream: reciverControllers.chatStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            ChatModel chatModel = snapshot.data;
                            chatModel.mesages.sort((a, b) => a.id.compareTo(b.id));
                            return Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                reverse: false,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: chatModel.mesages.length ?? 0,
                                itemBuilder: (context, index) {
                                  Mesages message = chatModel.mesages[index];
                                  bool isMyMessage = message.senderId == AppConstants.userID;

                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: isMyMessage
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.end,
                                    children: [
                                      if (isMyMessage)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          child: ClipOval(
                                            child: CustomImage(
                                              image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                                                  '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      Container(
                                        margin: isMyMessage
                                            ? EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 120)
                                            : const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 100),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                        decoration: BoxDecoration(
                                          color: isMyMessage ? Color(0xffcbfcca) : Color(0xffcccccc),
                                          borderRadius: isMyMessage
                                              ? BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            topLeft: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          )
                                              : BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                          ),
                                        ),
                                        child: Text(
                                          message.content,
                                          style: robotoMedium,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          } else {
                            // Handle the case when there is no data (e.g., loading indicator)
                            return Expanded(
                              child: Column(
                                children: [
                                  SizedBox(height: 300,),
                                  CircularProgressIndicator(),
                                ],
                              ),
                            );
                          }
                        },
                      ),




                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        //  color: Colors.red,
                        height: 80,
                        width: Get.width,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: (){
                                _textFieldFocusNode.unfocus();
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    // gradient: ,
                                    border: Border.all(color: Colors.white),
                                    color: Colors.white),
                                child: Icon(Icons.bedroom_parent_outlined,color: Colors.black,),
                                // child: Image.asset("assets/icons/cross.png",scale: 3.8,),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: GetBuilder<ReciverMsgController>(
                                    builder: (reciverController) {
                                      return GetBuilder<SendMessageController>(
                                        builder: (sendController) {
                                          return ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: 1,
                                              itemBuilder: (context, index) {
                                                return TextField(
                                                  focusNode: _textFieldFocusNode,
                                                  controller: _textController,
                                                  style: TextStyle(color: Colors.black),
                                                  decoration: InputDecoration(
                                                    hintText: 'Type here...',

                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.white)
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    prefixIcon:
                                                    null, // Assuming you don't need a prefix icon
                                                    suffixIcon: InkWell(
                                                        onTap: () {
                                                          sendController.sendMessageController(message: _textController.text, userId: '1');

                                                          setState(() {
                                                            Mesages message = reciverController.chatModel.mesages[index];

                                                            if (message.senderId == AppConstants.userID) {_messages.add(SenderMessage(text: message.content));

                                                            _messages.add(SenderMessage(text: reciverController.chatModel.mesages.toString()));
                                                            _scrollController.animateTo(
                                                              _scrollController.position.maxScrollExtent,
                                                              duration: Duration(milliseconds: 300),
                                                              curve: Curves.easeOut,
                                                            );
                                                              // } else {
                                                              //   _messages.add(
                                                              //       ReceiverMessage(text: message.content));
                                                              //
                                                              //   // _messages.add(SenderMessage(text: reciverController.chatModel.mesages.toString()));
                                                              // }

                                                            }
                                                          });
                                                          _textController.clear();

                                                        },
                                                        child: Icon(Icons.arrow_circle_right_outlined,color: Colors.black,)
                                                      // Image.asset("assets/icons/arrowfarward2.png", scale: 4),
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                      );
                                    },
                                  )),
                            )
                          ],
                        ),
                      ),

                    ],
                  );
                },
              );
            },
          ),
        )

    );
  }
}

class SenderMessage extends StatelessWidget {
  final String text;

  const SenderMessage({@required this.text});

  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
    return
      GetBuilder<UserController>(builder: (userController){
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Padding(
            //   padding: EdgeInsets.only(top: 20, left: 10),
            //   child: CircleAvatar(
            //     radius: 18,
            //     backgroundColor: Colors.blue,
            //     // backgroundImage: AssetImage("assets/images/beard2.png"),
            //   ),
            // ),
            ClipOval(
                child: CustomImage(
                  image:
                  '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                      '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                )),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 120),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Text(
                  text, style: robotoBold,
                  // GoogleFonts.dmSans(textStyle:  TextStyle(fontSize: MySize.scaleFactorHeight*13,fontWeight: FontWeight.w400,color: const Color(0xff524B6B)),)),
                ),
              ),
            )
          ],
        );
      });


  }
}

// class ReceiverMessage extends StatelessWidget {
//   final String text;
//
//   const ReceiverMessage({@required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
//     if (_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
//       Get.find<UserController>().getUserInfo();
//     }
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//       Container(
//         margin: const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 100),
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         decoration: const BoxDecoration(
//           color: Colors.blue,
//           // gradient: blu,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(15),
//             topRight: Radius.circular(15),
//             bottomLeft: Radius.circular(15),
//           ),
//         ),
//         child: Text(
//           text, style: robotoBold,
//           // GoogleFonts.dmSans(textStyle: GoogleFonts.dmSans(textStyle:  TextStyle(fontSize: MySize.scaleFactorHeight*13,fontWeight: FontWeight.w400,color: Colors.white),),),textAlign: TextAlign.center,),
//         ),
//       )
//     ]);
//   }
// }
//
// class ChatsModel {
//   String title;
//   String subtitle;
//   String images;
//   ChatsModel(this.title, this.subtitle, this.images);
// }
