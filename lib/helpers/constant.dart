
//I would also like this user to be stored in a database, so that we can use it in chat.
// this is an indirect method which in case of my lst mehtod i did directly
//I will create a constants.dart file under helpers folder

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
final Firestore _db = Firestore.instance;
final usersRef = _db.collection('users');
final chatsRef = _db.collection('chats');

final FirebaseStorage _storage = FirebaseStorage.instance;
final storageRef =_storage.ref();


