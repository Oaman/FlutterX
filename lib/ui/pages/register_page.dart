import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/http/api.dart';
import 'package:toast/toast.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode _userNameNode = new FocusNode();
  FocusNode _pwdNode = new FocusNode();
  FocusNode _pwd2Node = new FocusNode();

  String _username, _pwd, _pwd2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("注册"),
      ),
      //Form
      body: Form(
          key: _formKey,
          child: ListView(
            //因爲輸入框會彈出軟鍵盤 所以使用了一個滑動的View
            padding: EdgeInsets.fromLTRB(22.0, 18.0, 22.0, 0.0),
            children: <Widget>[
              _buildUserName(),
              _buildPwd(),
              _buildPwd2(),
              _buildRegister(),
            ],
          )),
    );
  }

  Widget _buildUserName() {
    return TextFormField(
      focusNode: _userNameNode,
      //以用户名输入框 为默认焦点，则进入页面会自动弹出软键盘
      autofocus: true,
      decoration: InputDecoration(
        labelText: "用户名",
      ),
      //  如键盘动作类型
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        //按下action 的响应
        FocusScope.of(context).requestFocus(_pwdNode);
      },
      //校验
      validator: (String value) {
        if (value.trim().isEmpty) {
          //错误提示
          return "请输入用户名";
        }
        _username = value;
      },
    );
  }

  Widget _buildPwd() {
    return TextFormField(
      focusNode: _pwdNode,
      //以用户名输入框 为默认焦点，则进入页面会自动弹出软键盘
      autofocus: true,
      decoration: InputDecoration(
        labelText: "密码",
      ),
      //  如键盘动作类型
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        //按下action 的响应
        FocusScope.of(context).requestFocus(_pwd2Node);
      },
      //校验
      validator: (String value) {
        if (value.trim().isEmpty) {
          //错误提示
          return "请输入密码";
        }
        _pwd = value;
      },
    );
  }

  Widget _buildPwd2() {
    return TextFormField(
      focusNode: _pwd2Node,
      //以用户名输入框 为默认焦点，则进入页面会自动弹出软键盘
      autofocus: true,
      decoration: InputDecoration(
        labelText: "确认密码",
      ),
      //  如键盘动作类型
      textInputAction: TextInputAction.go,
      onEditingComplete: () {
        //按下action 的响应
        _click();
      },
      //校验
      validator: (String value) {
        if (value.trim().isEmpty) {
          //错误提示
          return "请确认密码";
        }

        if (_pwd != value) {
          return "两次密码输入不一致";
        }
        _pwd2 = value;
      },
    );
  }

  Widget _buildRegister() {
    ///Container:装饰性容器
    return Container(
      height: 52.0,
      margin: EdgeInsets.only(top: 18.0),
      child: RaisedButton(
        child: Text(
          "注册",
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        color: Theme.of(context).primaryColor,
        onPressed: _click,
      ),
    );
  }

  _click() async {
    //点击注册按钮 让软键盘隐藏
    _userNameNode.unfocus();
    _pwdNode.unfocus();
    _pwd2Node.unfocus();

    //校验输入内容
    if (_formKey.currentState.validate()) {
      //弹出一个加载框
      // barrierDismissible： 不允许按返回dismiss
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });

      var result = await Api.register(_username, _pwd);
      print("注册结果：$result");
      //对话框dismiss
      Navigator.pop(context);
      if (result['errorCode'] == -1) {
        var error = result['errorMsg'];
        //弹出提示
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(error),
        ));
        // Toast.show(error, context,gravity: Toast.CENTER);
      } else {
        Toast.show("注册成功!", context, gravity: Toast.CENTER);
        Navigator.pop(context);
      }
    }
  }
}
