import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:social_app/cubit/Social_cubit/cubit.dart';
import 'package:social_app/cubit/Social_cubit/states.dart';
import 'package:social_app/models/message_model.dart';

import '../models/user_model.dart';

class ChatDetailsScreen extends StatelessWidget {
  UserModel userModel;
  var textController = TextEditingController();

  ChatDetailsScreen({super.key,
    required this.userModel
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (BuildContext context) {
          SocialCubit.get(context).getMessage(
            receiverId: userModel.uId,
          );
         // if(SocialCubit.get(context).messages.isNotEmpty)
          return BlocConsumer<SocialCubit, SocialStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    titleSpacing: 0.0,
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 25.0,
                          backgroundImage: NetworkImage(
                            userModel.image,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                            userModel.name,
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: SocialCubit.get(context).messages.isNotEmpty ?
                  ConditionalBuilder(
                    condition: SocialCubit
                        .get(context)
                        .messages
                        .length > 0,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                itemBuilder: (context,index) {
                                  var message = SocialCubit.get(context).messages[index];
                                  if(SocialCubit.get(context).userModel!.uId == message.senderId)
                                    return buildMyMessage(message);
                                  return buildMessage(message);
                                },
                                separatorBuilder: (context,index)=>SizedBox(height: 15,),
                                itemCount: SocialCubit.get(context).messages.length,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: TextFormField(
                                        controller: textController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Type your message here ....',
                                        ),
                                      ),
                                    ),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      SocialCubit.get(context).sendMessage(
                                        receiverId: userModel.uId,
                                        dateTime: DateTime.now().toString(),
                                        text: textController.text,
                                      );
                                    },
                                    child: Icon(
                                      IconlyLight.send,
                                      size: 35.0,
                                      color: Colors.blue,
                                    ),

                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    fallback: (context) =>
                        Center(child: CircularProgressIndicator(),),
                  ) :
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context,index) {
                              var message = SocialCubit.get(context).messages[index];
                              if(SocialCubit.get(context).userModel!.uId == message.senderId)
                                return buildMyMessage(message);
                              return buildMessage(message);
                            },
                            separatorBuilder: (context,index)=>SizedBox(height: 15,),
                            itemCount: SocialCubit.get(context).messages.length,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: TextFormField(
                                    controller: textController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Type your message here ....',
                                    ),
                                  ),
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  SocialCubit.get(context).sendMessage(
                                    receiverId: userModel.uId,
                                    dateTime: DateTime.now().toString(),
                                    text: textController.text,
                                  );

                                },
                                child: Icon(
                                  IconlyLight.send,
                                  size: 35.0,
                                  color: Colors.blue,
                                ),

                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
              );
            },
          );
        }
    );
  }

  Widget buildMessage(MessageModel model) =>
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
            ),
            color: Colors.grey[300],
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 15.0,
          ),
          child: Text(model.text),
        ),
      );

  Widget buildMyMessage(MessageModel model) =>
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
            ),
            color: Colors.blue.withOpacity(0.2),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 15.0,
          ),
          child: Text(model.text),
        ),
      );

}
