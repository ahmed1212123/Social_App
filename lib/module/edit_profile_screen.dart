import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'Social_cubit/cubit.dart';
import 'Social_cubit/states.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var nameController= TextEditingController();
          var bioController= TextEditingController();
          var phoneController= TextEditingController();

          var userModel = SocialCubit.get(context).userModel;
          var profileImage = SocialCubit.get(context).profileImage;
          var coverImage = SocialCubit.get(context).coverImage;

          nameController.text = userModel!.name ;
          bioController.text = userModel.bio ;
          phoneController.text = userModel.phone ;


          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(IconlyLight.arrowLeft2),
              ),
              title: const Text('Edit Profile'),
              actions: [
                TextButton(
                  onPressed: ()
                  {
                   SocialCubit.get(context).updateUser(
                       name: nameController.text,
                       phone: phoneController.text,
                       bio: bioController.text,
                   );
                  },
                  child:  Text('Update' ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      children: [
                        if(state is SocialUpdateUserImageLoadingState)
                          LinearProgressIndicator(),
                        if(state is SocialUpdateUserImageLoadingState)
                          SizedBox(height: 10.0,),
                        SizedBox(
                          height: 200,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              Stack(
                                alignment: AlignmentDirectional.topEnd,
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional.topCenter,
                                    child: Container(
                                      width: double.infinity,
                                      height: 150.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                        image: coverImage == null ? DecorationImage(
                                          image: NetworkImage(
                                            userModel.cover,
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                            : DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(coverImage)
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      SocialCubit.get(context).getCoverImage();
                                    },
                                    icon: const CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: 20.0,
                                      child: Icon(
                                        IconlyLight.camera,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children: [
                                  CircleAvatar(
                                    radius: 65.0,
                                    backgroundColor:
                                    Theme
                                        .of(context)
                                        .scaffoldBackgroundColor,
                                    child: profileImage == null ?
                                    CircleAvatar(
                                      radius: 58.0,
                                      backgroundImage:  NetworkImage(
                                        userModel.image,
                                      ) ,
                                    )
                                        : CircleAvatar(
                                      radius: 58.0,
                                      backgroundImage: FileImage(profileImage),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      SocialCubit.get(context).getProfileImage();
                                    },
                                    icon: const CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: 20.0,
                                      child: Icon(
                                        IconlyLight.camera,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        if (SocialCubit.get(context).profileImage != null || SocialCubit.get(context).coverImage != null )
                         Row(
                          children: [
                            if(SocialCubit.get(context).profileImage != null)
                              Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 45,
                                    child: MaterialButton(
                                      onPressed: (){
                                        SocialCubit.get(context).uploadProfileImage(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          bio: bioController.text,
                                        );
                                      },
                                      child: Text(
                                        'Upload profile Image',
                                        style: TextStyle(fontSize: 14,color: Colors.white),
                                      ),
                                      color: Colors.blue,
                                    ),
                                  ),
                                  if(state is SocialUpdateUserImageLoadingState)
                                    SizedBox(height: 5.0,),
                                  if(state is SocialUpdateUserImageLoadingState)
                                    LinearProgressIndicator(),
                                ],
                              ),
                            ),
                            SizedBox(width: 8,),
                            if(SocialCubit.get(context).coverImage != null)
                              Expanded(
                              child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 45,
                                  child: MaterialButton(
                                    onPressed: (){
                                      SocialCubit.get(context).uploadCoverImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text,
                                      );
                                    },
                                    child: Text(
                                      'Upload Cover Image',
                                      style: TextStyle(fontSize: 14,color: Colors.white),
                                    ),
                                    color: Colors.blue,
                                  ),
                                ),
                                if(state is SocialUpdateUserImageLoadingState)
                                  SizedBox(height: 5.0,),
                                if(state is SocialUpdateUserImageLoadingState)
                                  LinearProgressIndicator(),
                              ],
                              ),
                            ),
                          ],
                        ),
                        if (SocialCubit.get(context).profileImage != null || SocialCubit.get(context).coverImage != null )
                          const SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Name must not be empty";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: bioController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Bio must not be empty";
                            }
                            return null;
                          },

                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            labelText: 'Bio',
                            prefixIcon: Icon(Icons.lock_outline),

                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "phone number must not be empty";
                            }
                            return null;
                          },

                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            labelText: 'Phone Number',
                            prefixIcon: Icon(Icons.call),

                          ),
                        ),
                      ]
                  )
              ),
            ),
          );
        }
    );
  }
}