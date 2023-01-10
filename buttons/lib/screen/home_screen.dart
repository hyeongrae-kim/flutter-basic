import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                // Material State
                // button 뿐만 아니라 전반적인 것들 상태
                // hovered - 마우스 커서를 올려놓은 상태(모바일에선 존재 하지않음)
                // focused - 포커스 됐을때 (텍스트 필드) (버튼 해당 없음)
                // pressed - 눌렸을때
                // dragged - 드래그 됐을때
                // selected - 선택 됐을때 (체크박스, 라디오 버튼)
                // scrollUnder - 다른 컴포넌트 밑으로 스크롤링 됐을때
                // disabled - 비활성화 됐을때, onPressed: null
                // error - 에러상태
                backgroundColor: MaterialStateProperty.all(
                  Colors.black,
                ),
                foregroundColor: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states){
                      if (states.contains(MaterialState.pressed)){
                        return Colors.white;
                      }
                      return Colors.red;
                    }
                ),
                padding: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states){
                      return EdgeInsets.all(20.0);
                    }
                ),
              ),
              child: Text('ButtonStyle'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                //styleFrom = ButtonStyle 쉽게 사용 위한 함수
                // main color
                primary: Colors.red,
                // text color, animation effect color
                onPrimary: Colors.black,
                // shadow color
                shadowColor: Colors.green,
                // z axis, 입체감 주는 설정
                elevation: 10.0,
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
                //text padding
                padding: EdgeInsets.all(32.0),
                // 테두리 설정
                side: BorderSide(
                  color: Colors.black,
                  width: 4.0,
                ),
              ),
              child: Text('ElevatedButton'),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                // text, animation color 변경
                primary: Colors.green,
                // background 색상 가능하지만, 쓸거면 그냥 elevated 쓰자
                backgroundColor: Colors.yellow,
                // z axis, 입체감 설정
                elevation: 10.0,
                // Outlined button 속성은 primary, background빼고는 elevated랑 똑같음
              ),
              child: Text('OutlinedButton'),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                primary: Colors.brown,
                backgroundColor: Colors.blue,
                // 얘도 primary, backgroundColor 빼고는 elevated랑 똑같음
              ),
              child: Text('TextButton'),
            ),
          ],
        ),
      ),
    );
  }
}
