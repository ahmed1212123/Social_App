import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'Social_cubit/cubit.dart';
import 'Social_cubit/states.dart';

class AddPostScreen extends StatelessWidget {

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var postImage = SocialCubit.get(context).postImage;
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(IconlyLight.arrowLeft2),
              ),
              title: const Text('Create Post'),
              actions: [
                TextButton(
                  onPressed: ()
                  {
                    var now = DateTime.now();
                    if(postImage == null)
                      {
                        SocialCubit.get(context).createPost(
                          dateTime: now.toString(),
                          text: textController.text,
                        );
                      }
                    else{
                      SocialCubit.get(context).uploadPostImage(
                        dateTime: now.toString(),
                        text: textController.text,

                      );
                    }
                  },
                  child: Text('Post'),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if(state is SocialCreatePostLoadingState)
                    LinearProgressIndicator(),
                  if(state is SocialCreatePostLoadingState)
                    SizedBox(height: 15,),
                  Row(
                    children:
                    [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(
                          '${SocialCubit.get(context).userModel!.image}',
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Text(
                          '${SocialCubit.get(context).userModel!.name}',
                          style: Theme
                              .of(context)
                              .textTheme
                              .subtitle1,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TextFormField
                      (
                      controller: textController,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: 'What is on your mind ....',
                        border: InputBorder.none,
                        fillColor: Colors.grey[300],
                        filled: true,
                      ),
                    ),
                  ),
                  if(postImage != null)
                    Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          image:  DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(postImage)
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: ()
                        {
                          SocialCubit.get(context).removePostImage() ;
                        },
                        icon: const CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 20.0,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextButton(
                            onPressed: ()
                            {
                              SocialCubit.get(context).getPostImage();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(IconlyLight.image),
                                SizedBox(width: 5,),
                                Text('Add Photo'),
                              ],
                            ),
                          )
                      ),
                      Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: Text('# flags'),
                          )
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}
