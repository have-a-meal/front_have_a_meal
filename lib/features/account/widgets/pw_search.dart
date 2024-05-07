import 'package:flutter/material.dart';
import 'package:front_have_a_meal/features/account/pw_reset_screen.dart';
import 'package:front_have_a_meal/features/account/widgets/bottom_button.dart';
import 'package:front_have_a_meal/widget_tools/swag_platform_dialog.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PwSearch extends StatefulWidget {
  const PwSearch({super.key});

  @override
  State<PwSearch> createState() => _PwSearchState();
}

class _PwSearchState extends State<PwSearch> {
  bool _isSubmitted = false;
  bool _isBarrier = false;

  void _onCheckSearchData() {
    setState(() {
      _isSubmitted = (_searchNameController.text.trim().isNotEmpty &&
              _searchNameErrorText == null) &&
          (_searchPhoneNumberController.text.trim().isNotEmpty &&
              _searchPhoneNumberErrorText == null);
    });
  }

  void _onChangeBarrier() {
    setState(() {
      _isBarrier = true;
    });
  }

  // ID 찾기 API
  void _onSearchPw() async {
    swagPlatformDialog(
      context: context,
      title: "비밀번호 재설정",
      message: "비밀번호를 재설정하시겠습니까?",
      actions: [
        ElevatedButton(
          onPressed: () {
            context.pop();
          },
          child: const Text("아니오"),
        ),
        ElevatedButton(
          onPressed: () {
            context.pushNamed(pwResetScreen.routeName);
          },
          child: const Text("네"),
        ),
      ],
    );
  }

  final RegExp _idRegExp = RegExp(r'^\d{8}$'); // 아이디 정규식
  // 전화번호 정규식
  final RegExp regExpPhoneNumber = RegExp(
      r'^(02|0[3-9][0-9]{1,2})-[0-9]{3,4}-[0-9]{4}$|^(02|0[3-9][0-9]{1,2})[0-9]{7,8}$|^01[0-9]{9}$|^070-[0-9]{4}-[0-9]{4}$|^070[0-9]{8}$');

  final TextEditingController _searchIdController = TextEditingController();
  String? _searchIdErrorText; // 아이디 오류 메시지
  final TextEditingController _searchNameController = TextEditingController();
  String? _searchNameErrorText;
  final TextEditingController _searchPhoneNumberController =
      TextEditingController();
  String? _searchPhoneNumberErrorText;

  void _validateSearchId(String value) {
    if (value.isEmpty) {
      setState(() {
        _searchIdErrorText = '아이디를 입력하세요.';
      });
    } else if (!_idRegExp.hasMatch(value)) {
      setState(() {
        _searchIdErrorText = '8자리 숫자를 입력하세요.';
      });
    } else {
      setState(() {
        _searchIdErrorText = null; // 오류가 없을 경우 null로 설정
      });
      _onCheckSearchData();
    }
  }

  void _validateSearchName(String value) {
    if (value.isEmpty) {
      setState(() {
        _searchNameErrorText = '이름(실명)을 입력하세요.';
      });
    } else {
      setState(() {
        _searchNameErrorText = null;
      });
      _onCheckSearchData();
    }
  }

  void _validateSearchPhoneNumber(String value) {
    if (value.isEmpty) {
      setState(() {
        _searchPhoneNumberErrorText = '전화번호를 입력하세요.';
      });
    } else if (!regExpPhoneNumber.hasMatch(value)) {
      setState(() {
        _searchPhoneNumberErrorText = "전화번호 규칙에 맞게 입력하세요.";
      });
    } else {
      setState(() {
        _searchPhoneNumberErrorText = null;
      });
      _onCheckSearchData();
    }
  }

  @override
  void dispose() {
    _searchNameController.dispose();
    _searchPhoneNumberController.dispose();
    _searchIdController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 10,
        ),
        child: BottomButton(
          onPressed: _isSubmitted ? _onSearchPw : null,
          text: "비밀번호 재설정",
          isClicked: _isSubmitted,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const Gap(10),
                  TextFormField(
                    controller: _searchIdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.grey.shade600,
                      ),
                      labelText: '아이디',
                      errorText: _searchIdErrorText,
                      labelStyle: TextStyle(
                        color: _searchNameErrorText == null
                            ? Colors.black
                            : Colors.red,
                      ),
                    ),
                    onTap: _onChangeBarrier,
                    onChanged: _validateSearchId,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                      _onCheckSearchData();
                    },
                  ),
                  const Gap(10),
                  TextFormField(
                    controller: _searchNameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: '이름(실명)',
                      errorText: _searchNameErrorText,
                      labelStyle: TextStyle(
                        color: _searchNameErrorText == null
                            ? Colors.black
                            : Colors.red,
                      ),
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    onTap: _onChangeBarrier,
                    onChanged: _validateSearchName,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                      _onCheckSearchData();
                    },
                  ),
                  const Gap(10),
                  TextFormField(
                    controller: _searchPhoneNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '전화번호',
                      errorText: _searchPhoneNumberErrorText,
                      labelStyle: TextStyle(
                        color: _searchPhoneNumberErrorText == null
                            ? Colors.black
                            : Colors.red,
                      ),
                      prefixIcon: Icon(
                        Icons.phone_iphone_rounded,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    onTap: _onChangeBarrier,
                    onChanged: _validateSearchPhoneNumber,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).unfocus();
                      _onCheckSearchData();
                    },
                  ),
                ],
              ),
            ),
            if (_isBarrier)
              ModalBarrier(
                // color: _barrierAnimation,
                color: Colors.transparent,
                // 자신을 클릭하면 onDismiss를 실행하는지에 대한 여부
                dismissible: true,
                // 자신을 클릭하면 실행되는 함수
                onDismiss: () {
                  setState(() {
                    _isBarrier = false;
                    FocusScope.of(context).unfocus();
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
