class ChatMessage {
  final int recieverId;
  final String type;
  final String textMsg;
  final String timestamp;
  final bool is_seen;


  ChatMessage({
    required this.recieverId,
    required this.type,
    required this.textMsg,
    required this.timestamp,
    required this.is_seen,
  });


  Map<String, dynamic> toJson() => {
    'reciever_id': recieverId,
    'type': "msg",
    'text_msg': textMsg,
    'time': timestamp,
    'is_seen' : is_seen,
  };
}
