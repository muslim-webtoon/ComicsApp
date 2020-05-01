import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pkcomics/states/account_state.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:pkcomics/public.dart';


class LoginScene extends StatefulWidget {
  @override
  LoginSceneState createState() => LoginSceneState();
}

class LoginSceneState extends State<LoginScene> {

  TextEditingController _email;
  TextEditingController _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool _validate = false;

  _submit() {
    if (_formKey.currentState.validate()) {
      // No any error in validation
      _formKey.currentState.save();
      AccountState $account =
          Provider.of<AccountState>(_formKey.currentContext);
      $account.login();
      Navigator.pushReplacementNamed(context, '/');
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

    String validatePassword(String value) {
    if (value.length < 6)
      return 'Password must be more than 6 letters';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _email,
                    validator: validateEmail,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "Email",
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _password,
                    validator: validatePassword,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: "Password",
                        border: OutlineInputBorder()),
                  ),
                ),                
                SizedBox(height: 10),
                RaisedButton(onPressed: _submit, child: Text('로그인')),
                SizedBox(
                  height: 40,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("OR"),
                  ),
                ),
                GoogleSignInButton(onPressed: () {}, darkMode: true),
                SizedBox(height: 20),
                FacebookSignInButton(onPressed: () {}),         
              ],
            ),
          )
        ],
      ),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Login'), 
        elevation: 0
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              autovalidate: _validate,
              child: _buildBody(),
            ),
          ),
        ),
      ),
    );
  }

}