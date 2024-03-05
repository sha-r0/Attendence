class Usermodel {
  String ? uid ;
  String ? fullname;
  String ? email;
  String ? profilepic;
  Usermodel({
    this.email,this.uid,this.profilepic,this.fullname
});

  Usermodel.fromMap(Map<String,dynamic>map){
    uid= map["uid"];
    fullname = map["fullname"];
    email = map["email"];
    profilepic = map["profilepic"];
  }
  Map<String,dynamic>toMap(){
    return {
      "uid" : uid,
      "fullname" : fullname,
      "email" : email,
      "profilepic" : profilepic

    };
  }
}