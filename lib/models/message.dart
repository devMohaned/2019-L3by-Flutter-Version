class Message{
   String chatText, chatSender, roomId;
   String chatSenderUid;
   int timeStamp;
   bool seen = false;

   Message(this.roomId,this.chatSenderUid,this.chatSender,this.chatText,this.seen,this.timeStamp);


   Map<String, dynamic> toMap() {
     return {
       'chatSenderUid': chatSenderUid,
       'chatSender': chatSender,
       'chatText': chatText,
       'seen': seen,
       'timeStamp': timeStamp,
     };
   }

   Message.fromMap(Map<dynamic, dynamic> map) {
     chatSenderUid = map['chatSenderUid'];
     chatText = map['chatText'];
     chatText = map['chatText'];
     timeStamp = map['timeStamp'];
     seen = map['seen'];
   }}