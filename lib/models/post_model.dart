class PostModel{
  late String name;
  late String uId;
  late String image;
  late String postImage;
  late String dateTime;
  late String text;
  Map<String,dynamic>? json;

  PostModel({
    required this.name,
    required this.uId,
    required this.image,
    required this.postImage,
    required this.dateTime,
    required this.text,
  });

  PostModel.fromJson(json){
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    postImage = json['postImage'];
    dateTime = json['dateTime'];
    text = json['text'];
  }

  Map<String,dynamic> toMap()
  {
    return{
      'name':name,
      'uId':uId,
      'image':image,
      'postImage':postImage,
      'dateTime':dateTime,
      'text':text,
    };
  }
}