import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/Social_cubit/cubit.dart';
import 'package:social_app/cubit/cubit_login/cubit.dart';
import 'package:social_app/cubit/cubit_login/states.dart';
import 'package:social_app/module/layout/social_layout.dart';

import '../../shared/components.dart';
import '../../shared/network/cache_helper.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatelessWidget {
  var formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {

    var model = SocialCubit.get(context).userModel ;
    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is SocialLoginErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }
          if (state is SocialLoginSuccessState) {

              CacheHelper.saveData(
                key: 'uId',
                value: state.uId,
              ).then((value) {

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SocialLayout(),
                    ),
                    (route) => false);
              });
            }

        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Login now to browse out hot offers',
                      style: TextStyle(
                          fontSize: 15.0,
                          //fontWeight: FontWeight.w900,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your text";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      // onChanged: (value){
                      //   NewsCubit.get(context).getSearch(value);
                      // },
                      obscureText: SocialLoginCubit.get(context).isPassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Password";
                        }
                        return null;
                      },

                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () {
                            SocialLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                          icon: Icon(SocialLoginCubit.get(context).suffix),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      child: ConditionalBuilder(
                        condition: state is! SocialLoginLoadingState,
                        builder: (context) => MaterialButton(
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              SocialLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                            if (state is! SocialLoginSuccessState)
                              {
                                print(model!.isEmailVerified);
                                print(model.email);
                                print(model.name);
                                print(model.phone);
                                print(model.uId);
                              }
                          },
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          color: Colors.blue,
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(),));
                          },
                          child: Text(
                            'REGISTER',
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
