import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'dart:async';

import 'package:pkcomics/public.dart';
import 'package:pkcomics/services/authentication.dart';

class LoginScene extends StatefulWidget {
  LoginScene({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => LoginSceneState();
}

class LoginSceneState extends State<LoginScene> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;
  
  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form =_formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });
        
        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                toggleFormMode();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showEmailInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColor.paper,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        maxLines: 1,
        style: TextStyle(fontSize: 14, color: AppColor.darkGray),
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: TextStyle(color: AppColor.gray),
          border: InputBorder.none,
          icon: new Icon(
            Icons.mail,
            color: Colors.grey,
          ),
        ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColor.paper,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        textInputAction: TextInputAction.done,
        style: TextStyle(fontSize: 14, color: AppColor.darkGray),
        decoration: InputDecoration(
          hintText: 'password',
          hintStyle: TextStyle(color: AppColor.gray),
          border: InputBorder.none,
          icon: new Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.primary,
      ),
      height: 40,
      child: FlatButton(
        child: new Text(_isLoginForm ? 'Login' : 'Create account',
            style: new TextStyle(fontSize: 20.0, color: Colors.white)),
        onPressed: validateAndSubmit,
      ),
    );
  }

  Widget showSecondaryButton() {
    return new FlatButton(
      child: new Text(
          _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: toggleFormMode);
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
                showEmailInput(),
                SizedBox(height: 10),
                showPasswordInput(),
                SizedBox(height: 10),
                showPrimaryButton(),
                showSecondaryButton(),
                showErrorMessage(),
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
      appBar: AppBar(title: Text('Login'), elevation: 0),
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          _buildBody(),
          _showCircularProgress(),
        ],
      )
    );
  }

}