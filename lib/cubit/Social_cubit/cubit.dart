import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/cubit/Social_cubit/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';

import 'package:social_app/module/add_post_screen.dart';
import 'package:social_app/module/chats_screen.dart';
import 'package:social_app/module/feeds_screen.dart';
import 'package:social_app/module/login/login_screen.dart';
import 'package:social_app/module/setting_screen.dart';
import 'package:social_app/module/users_screen.dart';
import 'package:social_app/shared/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../models/message_model.dart';


class SocialCubit extends Cubit<SocialStates>
{
 SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);


  UserModel? userModel;
  void getUserData()
  {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value) {
          userModel = UserModel.fromJson(value.data());
          emit(SocialGetUserSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }



  int currentIndex = 0 ;

  List Screens = [
    FeedsScreen(),
    ChatsScreen(),
    AddPostScreen(),
    UsersScreen(),
    SettingScreen()
  ];
 List Tittles = [
   'Home',
   'Chats',
   'Post',
   'Users',
   'Settings',
 ];
  void changeBottomNav (int index)
  {
    if (index == 1 )
      getUsers();
    if (index == 2 )
    {
      emit(SocialAddPostState());
    }
    else
    {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }

  }

  void signOut (context)
  {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ), (route) => false);
      emit(SocialSignOutSuccessState());
    }).catchError((error){});
  }

  var picker = ImagePicker();
  File? profileImage;

  Future getProfileImage()async
  {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile != null)
      {
        profileImage = File(pickedFile.path);
        emit(SocialProfileImageSuccessState());
      }
    else {
      print('No Images selected');
      emit(SocialProfileImageErrorState());
    }
  }
  File? coverImage;
  Future getCoverImage()async
  {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) 
    {
     coverImage = File(pickedFile.path);
     emit(SocialCoverImageSuccessState());
    }
   else
   {
     print('No Images selected');
     emit(SocialCoverImageErrorState());
   }
  }


  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
})
  {
    emit(SocialUpdateUserImageLoadingState());

    firebase_storage.FirebaseStorage
        .instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value)
    {
      value.ref.getDownloadURL()
          .then((value) {
        //emit(SocialUploadProfileImageSuccessState());
        print(value);
        updateUser(
          name:name,
          phone:phone,
          bio:bio,
          image:value,
        );
      }).catchError((error){
        emit(SocialUploadProfileImageErrorState(error.toString()));
      });
    }).catchError((error){
        emit(SocialUploadProfileImageErrorState(error.toString()));
    });
  }

 void uploadCoverImage({
   required String name,
   required String phone,
   required String bio,
})
 {
   emit(SocialUpdateUserImageLoadingState());
   firebase_storage.FirebaseStorage
       .instance
       .ref()
       .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
       .putFile(coverImage!)
       .then((value)
   {
     value.ref.getDownloadURL().then((value) {
       //emit(SocialUploadCoverImageSuccessState());
       print(value);
       updateUser(
         name: name,
         phone: phone,
         bio: bio,
         cover: value,
       );
     }).catchError((error){
       emit(SocialUploadCoverImageErrorState(error.toString()));
     });
   }).catchError((error){
     emit(SocialUploadCoverImageErrorState(error.toString()));
   });
 }
//  void UpdateUserImage({
//    required String name,
//    required String phone,
//    required String bio
// })
//  {
//    if(coverImage != null)
//      {
//        getCoverImage();
//      }
//    else if (profileImage != null)
//      {
//        getProfileImage();
//      }
//    else if (coverImage != null && profileImage != null)
//      {
//        getCoverImage();
//        getProfileImage();
//      }
//    else
//      {
//        UserModel model = UserModel(
//          name: name,
//          email: userModel!.email,
//          phone: phone,
//          uId: userModel!.uId,
//          cover: userModel!.cover,
//          image: userModel!.image,
//          bio: bio,
//          isEmailVerified:false,
//        );
//
//        FirebaseFirestore.instance
//            .collection('users')
//            .doc(userModel!.uId)
//            .update(model.toMap())
//            .then((value)
//        {
//          getUserData();
//        })
//            .catchError((error)
//        {
//          emit(SocialUpdateUserImageErrorState(error.toString()));
//        });
//      }
//  }

 void updateUser({
   required String name,
   required String phone,
   required String bio,
   String? cover,
   String? image,
})
 {
  UserModel model = UserModel(
    name: name,
    email: userModel!.email,
    phone: phone,
    uId: userModel!.uId,
    cover: cover ?? userModel!.cover,
    image: image ?? userModel!.image,
    bio: bio,
    isEmailVerified:false,
  );

  FirebaseFirestore.instance
      .collection('users')
      .doc(userModel!.uId)
      .update(model.toMap())
      .then((value)
  {
    getUserData();
  })
      .catchError((error)
  {
    emit(SocialUpdateUserImageErrorState(error.toString()));
  });
 }

  // File? postImage;
  // Future getPostImage()async
  // {
  //   var pickedFile = await picker.pickImage(
  //       source: ImageSource.gallery
  //   );
  //   if(pickedFile != null)
  //   {
  //     postImage = File(pickedFile.path);
  //     emit(SocialPostImageSuccessState());
  //   }
  //   else
  //   {
  //     print('No Images selected');
  //     emit(SocialPostImageErrorState());
  //   }
  // }
  //
  // // void uploadPostImage({
  // //   required String dateTime,
  // //   required String text,
  // // })
  // // {
  // //   emit(SocialCreatePostLoadingState());
  // //   firebase_storage.FirebaseStorage
  // //       .instance
  // //       .ref()
  // //       .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
  // //       .putFile(postImage!)
  // //       .then((value)
  // //   {
  // //     value.ref.getDownloadURL().then((value) {
  // //       print(value);
  // //       createPost(
  // //         dateTime: dateTime,
  // //         text: text,
  // //         postImage: value,
  // //       );
  // //     }).catchError((error){
  // //       emit(SocialCreatePostErrorState());
  // //     });
  // //   }).catchError((error){
  // //     emit(SocialCreatePostErrorState());
  // //   });
  // // }
  //
  // void uploadPostImage({
  //   required String dateTime,
  //   required String text,
  // }) {
  //   emit(SocialCreatePostLoadingState());
  //
  //   firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
  //       .putFile(postImage!)
  //       .then((value) {
  //     value.ref.getDownloadURL().then((value) {
  //       print(value);
  //       createPost(
  //         dateTime: dateTime,
  //         text: text,
  //         postImage: value,
  //       );
  //     }).catchError((error) {
  //       emit(SocialCreatePostErrorState());
  //     });
  //   }).catchError((error) {
  //     emit(SocialCreatePostErrorState());
  //   });
  // }
  //
  //
  // void RemovePostImage()
  // {
  //   postImage = null;
  //   emit(SocialRemovePostImageState());
  // }
  //
  // void createPost({
  //   required String dateTime,
  //   required String text,
  //   String? postImage,
  // })
  // {
  //   emit(SocialCreatePostLoadingState());
  //   PostModel model = PostModel(
  //     name: userModel!.name,
  //     image: userModel!.image,
  //     uId: userModel!.uId,
  //     dateTime: dateTime,
  //     text: text,
  //     postImage: postImage!,
  //   );
  //
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .add(model.toMap())
  //       .then((value)
  //   {
  //
  //     emit(SocialCreatePostSuccessState());
  //   })
  //       .catchError((error)
  //   {
  //     emit(SocialCreatePostErrorState());
  //   });
  // }

  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null)
    {
      postImage = File(pickedFile.path);
      emit(SocialPostImageSuccessState());
    } else {
      print('No images selected');
      emit(SocialPostImageErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialUploadPostImageLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: value,
        );
        //emit(SocialUploadPostImageSuccessState());
      }).catchError((error) {
        emit(SocialUploadPostImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadPostImageErrorState());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());

    PostModel model = PostModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: userModel!.image,
      dateTime: dateTime,
      postImage: postImage ?? '',
      text: text,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postId = [];
  List<int>  likes =[];

  void getPosts()
  {

    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {
        element.reference
        .collection('likes')
        .get()
        .then((value){
          likes.add(value.docs.length);
          postId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        })
        .catchError((error){});
      });
      emit(SocialGetPostSuccessState());
    })
        .catchError((error)
    {
      emit(SocialGetPostErrorState(error.toString()));
    });
  }

  void likePost(String postId)
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like':true,
    })
        .then((value){
          emit(SocialLikePostSuccessState());
    })
        .catchError((error){
          emit(SocialLikePostErrorState(error.toString()));
    });
  }
  List<UserModel> users = [] ;

  void getUsers()
  {
    if(users.isEmpty) {
      FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {
        if(element.data()['uId'] != userModel!.uId)
          users.add(UserModel.fromJson(element.data()));
      });
      emit(SocialGetAllUsersSuccessState());
    })
        .catchError((error)
    {
      emit(SocialGetAllUsersErrorState(error.toString()));
    });
    }
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
}){
    MessageModel model = MessageModel(
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );
    //set my chat
    FirebaseFirestore.instance
    .collection('users')
    .doc(userModel!.uId)
    .collection('chats')
    .doc(receiverId)
    .collection('messages')
    .add(model.toMap())
    .then((value){
      emit(SocialSendMessageSuccessState());
    })
    .catchError((error){
      emit(SocialSendMessageErrorState());
    });

    // set receiver chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value){
      emit(SocialSendMessageSuccessState());
    })
        .catchError((error){
      emit(SocialSendMessageErrorState());
    });
}
List<MessageModel> messages = [];
  void getMessage({
    required String receiverId,
  }) {

    //set my chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event)
    {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessageSuccessState());
    });
  }
}
