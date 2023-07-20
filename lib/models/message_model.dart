class MessageModel{
  late String senderId;
  late String receiverId;
  late String dateTime;
  late String text;
  Map<String,dynamic>? json;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.dateTime,
    required this.text,

  });

  MessageModel.fromJson(json){
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json[ 'dateTime'];
    text = json['text'];
  }

  Map<String,dynamic> toMap()
  {
    return{
      'senderId':senderId,
      'receiverId':receiverId,
      'dateTime':dateTime,
      'text':text,
    };
  }
}