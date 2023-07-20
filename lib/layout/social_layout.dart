import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:social_app/module/add_post_screen.dart';
import 'package:social_app/module/login/login_screen.dart';
import 'package:social_app/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/module/Social_cubit/cubit.dart';
import 'package:social_app/module/Social_cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    var Cubit = SocialCubit.get(context);
    return BlocConsumer <SocialCubit , SocialStates>(
      listener: (context ,state){
        if (state is SocialAddPostState){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostScreen(),));
        }
      },
        builder: (context ,state)
        {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  Cubit.Tittles[Cubit.currentIndex]
              ),
              actions: [
                IconButton(
                  onPressed: (){
                    SocialCubit.get(context).signOut(context);
                }, icon: Icon(IconlyLight.logout),),
                IconButton(onPressed: (){}, icon: Icon(IconlyLight.notification),),
                IconButton(onPressed: (){}, icon: Icon(IconlyLight.search),)


              ],
            ),
            body: Cubit.Screens[Cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: Cubit.currentIndex,
              onTap: (index){
                Cubit.changeBottomNav(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(IconlyLight.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconlyLight.chat),
                  label: 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconlyLight.paperUpload),
                  label: 'Post',
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconlyLight.location),
                  label: 'Users',
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconlyLight.setting),
                  label: 'Setting',
                ),
              ],
            ),
          );
        },
    );
  }
}
//body: ConditionalBuilder(
//     condition: Cubit.model != null,
//     builder: (context){
//       return Column(
//         children: [
//           if (!Cubit.model!.isEmailVerified)
//           Container(
//             color: Colors.amber[600],
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 15),
//               child:Row(
//                 children: [
//                   Icon(Icons.info_outline),
//                   SizedBox(width: 15,),
//                   Expanded(child: Text('Please verify your email')),
//                   SizedBox(width: 30,),
//                   TextButton(
//                       onPressed: (){
//                         FirebaseAuth.instance.currentUser?.sendEmailVerification()
//                             .then((value){
//                           showToast(
//                             text: 'Check your mail',
//                             state: ToastStates.SUCCESS,
//                           );
//                         }).catchError((error){
//                           print(error.toString());
//
//                         });
//                       },
//                       child: Text('Send')),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     },
//     fallback: (context) => Center(child: CircularProgressIndicator(),),
//
// )
