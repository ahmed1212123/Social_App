import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/module/Social_cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

import 'Social_cubit/cubit.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state){
        return ConditionalBuilder(
          condition: SocialCubit.get(context).posts.length > 0 && SocialCubit.get(context).userModel != null,
          builder: (context)=>SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 10.0,
                  margin: EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Image(
                        image: NetworkImage(
                          'https://img.freepik.com/free-photo/showing-tablet-s-blank-screen_155003-21288.jpg?w=996&t=st=1671143146~exp=1671143746~hmac=4a7e04c69083e491205e41016e68747df6e97b531ec417a901b45f93d6d7bd16',
                        ),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200.0,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Communicate with your friends',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context ,index)=> buildPostItem(SocialCubit.get(context).posts[index],context,index),
                  separatorBuilder: (context,index) => SizedBox(height: 10.0,),
                  itemCount: SocialCubit.get(context).posts.length,
                ),
                SizedBox(height: 10.0,),
              ],
            ),
          ),
          fallback: (context)=>Center(child: CircularProgressIndicator(),),
        );
      },
    );
  }
  Widget buildPostItem(PostModel model,context , index) => Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 10,
    margin: EdgeInsets.symmetric(horizontal: 8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start ,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  model.image,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          model.name,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                        )
                      ],
                    ),
                    Text(
                      model.dateTime,
                      style: Theme.of(context).textTheme.caption,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_horiz,
                    size: 16,
                  ))
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          Text(
            model.text,
            style: TextStyle(fontSize: 15),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 6.0),
          //   child: Container(
          //     width: double.infinity,
          //     child: Wrapc(
          //       children: [
          //         Padding(
          //           padding: EdgeInsetsDirectional.only(end: 8.0),
          //           child: Container(
          //             height: 25.0,
          //             child: MaterialButton(
          //               minWidth: 1.0,
          //               padding: EdgeInsets.zero,
          //               onPressed: () {},
          //               child: Text(
          //                 '#Software',
          //                 style: Theme.of(context)
          //                     .textTheme
          //                     .caption
          //                     ?.copyWith(color: Colors.blue),
          //               ),
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: EdgeInsetsDirectional.only(end: 8.0),
          //           child: Container(
          //             height: 25.0,
          //             child: MaterialButton(
          //               minWidth: 1.0,
          //               padding: EdgeInsets.zero,
          //               onPressed: () {},
          //               child: Text(
          //                 '#Flutter',
          //                 style: Theme.of(context)
          //                     .textTheme
          //                     .caption
          //                     ?.copyWith(color: Colors.blue),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          if (model.postImage != '')
            Padding(
            padding: const EdgeInsetsDirectional.only(top: 10.0),
            child: Container(
              width: double.infinity,
              height: 150.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                image: DecorationImage(
                  image: NetworkImage(
                    model.postImage,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 5.0,),
          Row(
            children: [
              Expanded(
                child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          Icon(
                            IconlyLight.heart,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${SocialCubit.get(context).likes[index]}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    )),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          IconlyLight.chat,
                          color: Colors.amber,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('0 Comment'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: InkWell(
                    onTap: (){},
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 15.0,
                          backgroundImage: NetworkImage(
                            SocialCubit.get(context).userModel!.image,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Write your comment ...',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  )
              ),
              InkWell(
                  onTap: ()
                  {
                    SocialCubit.get(context).likePost(SocialCubit.get(context).postId[index]);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        Icon(
                          IconlyLight.heart,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Like',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  )),
            ],
          )
        ],
      ),
    ),
  );
}
