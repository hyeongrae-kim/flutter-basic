import 'package:calendar_scheduler/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String initialValue;

  // true - 시간 / false - 내용
  final bool isTime;
  final FormFieldSetter<String> onSaved;

  const CustomTextField({
    required this.label,
    required this.isTime,
    required this.onSaved,
    required this.initialValue,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isTime) renderTextField(),
        if (!isTime)
          Expanded(
            child: renderTextField(),
          ),
      ],
    );
  }

  Widget renderTextField() {
    return TextFormField(
      // 상위에 있는 Form Widget에서 save가 불리면 아래 함수가 불리게됨.
      onSaved: onSaved,
      // Form -> n개의 텍스트 필드 동시에 관리하기 위해서 사용
      // null이 return되면 에러가 없다.
      // 에러가 있으면 에러를 String 값으로 return 해준다.
      // val에는 텍스트 폼 필드에 입력한 string이 저장됨.
      validator: (String? val){
        if(val == null || val.isEmpty){
          return '값을 입력해주세요';
        }
        if(isTime){
          int time = int.parse(val);

          if(time < 0){
            return '0 이상의 숫자를 입력해주세요.';
          }
          if(time > 24){
            return '24 이하의 숫자를 입력해주세요.';
          }
        }else{
          if(val.length > 500){  // 하지만 maxLength를 설정했으면 의미가 없음.
            return '500자 이하의 글자를 입력해주세요.';
          }
        }
        return null;
      },
      cursorColor: Colors.grey,
      maxLines: isTime ? 1 : null, // null -> 줄바꿈 무한 가능
      expands: !isTime,  // 문자 치는 공간에서는 textfield사이즈 최대로
      initialValue: initialValue,
      maxLength: 500,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      inputFormatters: isTime
          ? [
              FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 받게 함
            ]
          : [],
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
        suffixText: isTime ? '시' : null,
      ),
    );
  }
}
