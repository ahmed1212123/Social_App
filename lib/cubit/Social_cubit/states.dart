abstract class SocialStates{}

class SocialInitialState extends SocialStates{}
class SocialGetUserLoadingState extends SocialStates{}
class SocialGetUserSuccessState extends SocialStates{}
class SocialGetUserErrorState extends SocialStates{
  final String error;
  SocialGetUserErrorState(this.error);
}
class SocialSignOutSuccessState extends SocialStates{}
class SocialGetAllUsersLoadingState extends SocialStates{}
class SocialGetAllUsersSuccessState extends SocialStates{}
class SocialGetAllUsersErrorState extends SocialStates{
  final String error;
  SocialGetAllUsersErrorState(this.error);
}

class SocialGetPostLoadingState extends SocialStates{}
class SocialGetPostSuccessState extends SocialStates{}
class SocialGetPostErrorState extends SocialStates{
  final String error;
  SocialGetPostErrorState(this.error);
}

class SocialChangeBottomNavState extends SocialStates{}
class SocialAddPostState extends SocialStates{}
class SocialProfileImageSuccessState extends SocialStates{}
class SocialProfileImageErrorState extends SocialStates{}
class SocialCoverImageSuccessState extends SocialStates{}
class SocialCoverImageErrorState extends SocialStates{}
class SocialUploadProfileImageSuccessState extends SocialStates{}
class SocialUploadProfileImageErrorState extends SocialStates{
  final String error;
  SocialUploadProfileImageErrorState(this.error);
}
class SocialUploadCoverImageSuccessState extends SocialStates{}
class SocialUploadCoverImageErrorState extends SocialStates{
  final String error;
  SocialUploadCoverImageErrorState(this.error);
}
class SocialUpdateUserImageLoadingState extends SocialStates {}
class SocialUpdateUserImageErrorState extends SocialStates{
  final String error;
  SocialUpdateUserImageErrorState(this.error);
}
class SocialPostImageSuccessState extends SocialStates{}
class SocialPostImageErrorState extends SocialStates{}

// class SocialUploadPostImageLoadingState extends SocialStates {}
// class SocialUploadPostImageSuccessState extends SocialStates{}
// class SocialUploadPostImageErrorState extends SocialStates{
//   final String error;
//   SocialUploadPostImageErrorState(this.error);
// }
class SocialClearTextSuccessState extends SocialStates{}
class SocialCreatePostLoadingState extends SocialStates {}
class SocialCreatePostSuccessState extends SocialStates{}
class SocialCreatePostErrorState extends SocialStates{}
class SocialUploadPostImageLoadingState extends SocialStates {}
class SocialUploadPostImageSuccessState extends SocialStates{}
class SocialUploadPostImageErrorState extends SocialStates{}

class SocialRemovePostImageState extends SocialStates{}

class SocialLikePostSuccessState extends SocialStates{}
class SocialLikePostErrorState extends SocialStates{
  final String error;
  SocialLikePostErrorState(this.error);
}

class SocialSendMessageSuccessState extends SocialStates{}
class SocialSendMessageErrorState extends SocialStates{}
class SocialGetMessageSuccessState extends SocialStates{}
