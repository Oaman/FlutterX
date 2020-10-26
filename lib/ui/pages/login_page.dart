import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/event/events.dart';
import 'package:flutter_app/common/http/api.dart';
import 'package:flutter_app/manager/app_manager.dart';
import 'package:flutter_app/ui/pages/register_page.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _userName, _password;

  bool _isObscure = true;

  Color _eyeColor;

  FocusNode _pwdNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: <Widget>[
              _buildUserName(),
              _buildPassword(),
              _buildLogin(),
              _buildRegister(),
            ],
          )),
    );
  }

  _buildUserName() {
    return TextFormField(
      autofocus: true,
      decoration: InputDecoration(
        labelText: "用户名",
      ),
      initialValue: _userName,
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_pwdNode);
      },
      // ignore: missing_return
      validator: (value) {
        if (value.trim().isEmpty) {
          return "请输入用户名";
        }
        _userName = value;
      },
    );
  }

  _buildPassword() {
    return TextFormField(
      focusNode: _pwdNode,
      obscureText: _isObscure,
      decoration: InputDecoration(
        labelText: "密码",

        ///给密码添加眼睛,控制明文与否
        suffix: IconButton(
            icon: Icon(Icons.remove_red_eye),
            color: _eyeColor,
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
                _eyeColor = _isObscure
                    ? Colors.grey
                    : Theme.of(context).iconTheme.color;
              });
            }),
      ),
      initialValue: _userName,
      textInputAction: TextInputAction.done,
      onEditingComplete: _doLogin,
      // ignore: missing_return
      validator: (value) {
        if (value.trim().isEmpty) {
          return "请输入密码";
        }
        _password = value;
      },
    );
  }

  _buildLogin() {
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 18, top: 18, right: 18),
      child: RaisedButton(
          child: Text(
            "登录",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          onPressed: _doLogin),
      color: Colors.blue,
    );
  }

  Widget _buildRegister() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('没有账号？'),
          GestureDetector(
            child: Text(
              '点击注册',
              style: TextStyle(color: Colors.green),
            ),
            onTap: () async {
              ///进入注册
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return RegisterPage();
              }));
            },
          ),
        ],
      ),
    );
  }

  void _doLogin() async {
    _pwdNode.unfocus();
    if (_formKey.currentState.validate()) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return Center(child: CircularProgressIndicator());
          });

      var result = await Api.login(_userName, _password);
      print("登录结果：$result");

      ///关闭loading dialog
      Navigator.pop(context);

      if (result['errorCode'] == -1) {
        Toast.show(result['errorMsg'], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        AppManager.eventBus.fire(LoginEvent(_userName));
        Navigator.pop(context);
      }
    }
  }
}
