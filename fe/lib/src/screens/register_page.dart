import 'package:dio/dio.dart';
import 'package:fe/constants.dart';
import 'package:fe/src/services/api_service.dart';
import 'package:fe/src/widgets/rounded_button.dart';
import 'package:fe/src/widgets/inputfield.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

enum Gender { male, female }

class _RegisterState extends State<Register> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController pwConfirmController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  void join() async {
    if (idController.text.length == "" ||
        validatePassword(pwController.text) != null ||
        nicknameController.text == "" ||
        pwController.text != pwConfirmController.text) {
      getDialog();
      return;
    }
    try {
      ApiService apiService = ApiService();
      await apiService.post('/api/auth/register', data: {
        "id": idController.text,
        "password": pwController.text,
        "nickname": nicknameController.text,
      });
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('안내메세지'),
            content: const Text("중복된 아이디입니다."),
            actions: <Widget>[
              TextButton(
                child: const Text('닫기'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void getDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('안내메세지'),
          content: idController.text == ""
              ? const Text('아이디를 입력해주세요.')
              : validatePassword(pwController.text) != null
                  ? const Text("특수문자, 문자, 숫자 포함 8자 이상 16자 이내로 입력하세요.")
                  : pwController.text != pwConfirmController.text
                      ? const Text("입력한 비밀번호가 서로 다릅니다.")
                      : const Text("닉네임을 입력해주세요."),
          actions: <Widget>[
            TextButton(
              child: const Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String? validatePassword(String value) {
    String pattern =
        r'^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{8,15}$';
    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      return '비밀번호를 입력하세요';
    } else if (value.length < 8) {
      return '비밀번호는 8자리 이상이어야 합니다';
    } else if (!regExp.hasMatch(value)) {
      return '특수문자, 문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.';
    } else {
      return null; //null을 반환하면 정상
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeColors themeColors = ThemeColors();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Center(
              child: Text(
                '회원가입',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
            ),
            Form(
              child: Theme(
                data: ThemeData(
                    primaryColor: Colors.grey,
                    inputDecorationTheme: const InputDecorationTheme(
                        labelStyle:
                            TextStyle(color: Colors.grey, fontSize: 15.0))),
                child: Container(
                    width: 500,
                    padding: const EdgeInsets.all(40.0),
                    // 키보드가 올라와서 만약 스크린 영역을 차지하는 경우 스크롤이 되도록
                    // SingleChildScrollView으로 감싸 줌
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          InputField(
                            label: 'Id',
                            controller: idController,
                            maxLength: 10,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InputField(
                            label: 'password',
                            controller: pwController,
                            maxLength: 16,
                          ),
                          const Row(
                            children: [
                              Text(
                                "8~16자의 영문 대/소문자, 숫자, 특수문자를 사용해 주세요.",
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InputField(
                            label: 'password',
                            controller: pwConfirmController,
                            maxLength: 16,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InputField(
                            label: '닉네임',
                            controller: nicknameController,
                            maxLength: 7,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          RoundedButton(
                            maintext: '회원가입',
                            bgcolor: themeColors.color2,
                            onPressed: () {
                              join();
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          RoundedButton(
                            maintext: '돌아가기',
                            bgcolor: themeColors.color2,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
