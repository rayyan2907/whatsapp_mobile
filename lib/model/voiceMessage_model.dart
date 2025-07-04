class AudioMessage {
  final int recieverId;
  final String type;
  final String fileName;
  final String time;
  final bool isSeen;
  final String voiceByte;

  AudioMessage({
    required this.recieverId,
    required this.type,
    required this.fileName,
    required this.time,
    required this.isSeen,
    required this.voiceByte,
  });

  Map<String, dynamic> toJson() {
    return {
      'reciever_id': recieverId,
      'type': type,
      'file_name': fileName,
      'time': time,
      'is_seen': isSeen,
      'voice_byte': voiceByte,
    };
  }

  factory AudioMessage.fromJson(Map<String, dynamic> json) {
    return AudioMessage(
      recieverId: json['reciever_id'],
      type: json['type'],
      fileName: json['file_name'],
      time: json['time'],
      isSeen: json['is_seen'],
      voiceByte: json['voice_byte'],
    );
  }
}
