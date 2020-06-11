import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
// we are creating  static keys since we dont want to change the getter and setter names since it will cause errors
  static String sharedPreferrenceUserLoggedInKey = "ISLOGGEDIN" ;
  static String sharedPreferrenceUserNameKey  ="USERNAMEKEY" ;
  static String sharedPreferrenceUserEmailKey  = "USEREMAILKEY" ;


// saving data to shared preferrence
//  we are using static function so that we can use this function anywhere
  static Future<bool> saveuserLoggedInSharedPreferrence(bool isUserLoggedIn) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferrenceUserLoggedInKey, isUserLoggedIn) ;
  }

  static Future<bool> saveUserNameSharedPreferrence(String userName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferrenceUserNameKey, userName) ;
  }

  static Future<bool> saveUserEmailSharedPreferrence(String userEmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferrenceUserEmailKey, userEmail) ;
  }

// getting data from the share preferrence
  static Future<bool> getUserLoggedInSharedPreferrence() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPreferrenceUserLoggedInKey) ;
  }

  static Future<String> getUserNameSharedPreferrence() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferrenceUserNameKey) ;
  }

  static Future<String> getUserEmailSharedPreferrence() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferrenceUserEmailKey) ;
  }
}

