# **Flutter 채팅 프로젝트**

프로젝트 소개
- 채팅 프로젝트로 로그인한 사용자와 채팅을 하는 앱입니다.
- 토큰을 활용해서 자동로그인 구현

## 목차
- [개발 환경](#1-개발-환경)
- [프로젝트 구조](#2-프로젝트-구조)
- [개발 기간 및 작업 관리](#3-개발-기간-및-작업-관리)
- [페이지별 기능](#4-페이지별-기능)
- [구현하면서 경험한 이슈사항 및 신경 쓴 부분](#5-구현하면서-경험한-이슈사항-및-신경-쓴-부분)

## 1. 개발 환경
- #### App Front-end : Dart, Flutter
- #### back-end : MySQL, Node-js
- #### 사용한 라이브러리 : provider(상태관리), dio(api 통신), socket_io_client(flutter socket 통신), jsonwebtoken(서버 토큰), socket.io(node.js socket 통신)

## 2. 프로젝트 구조
📦lib <br/>
 ┣ 📂common <br/>
 ┃ ┣ 📂component <br/>
 ┃ ┃ ┣ 📜custom_appbar.dart <br/>
 ┃ ┃ ┣ 📜custom_checkbox.dart <br/>
 ┃ ┃ ┣ 📜custom_elevatedButton.dart <br/>
 ┃ ┃ ┣ 📜custom_image.dart <br/>
 ┃ ┃ ┣ 📜custom_loading.dart <br/>
 ┃ ┃ ┣ 📜custom_show_hide_text.dart <br/>
 ┃ ┃ ┣ 📜custom_showdiaLog.dart <br/>
 ┃ ┃ ┣ 📜custom_text.dart <br/>
 ┃ ┃ ┣ 📜custom_text_field.dart <br/>
 ┃ ┃ ┗ 📜custom_toast.dart <br/>
 ┃ ┣ 📂const <br/>
 ┃ ┃ ┗ 📜data.dart <br/>
 ┃ ┗ 📂function <br/>
 ┃ ┃ ┣ 📜navigator.dart <br/>
 ┃ ┃ ┣ 📜postDio.dart <br/>
 ┃ ┃ ┗ 📜sizeFn.dart <br/>
 ┣ 📂home <br/>
 ┃ ┗ 📂view <br/>
 ┃ ┃ ┗ 📜home.dart <br/>
 ┣ 📂login <br/>
 ┃ ┗ 📂view <br/>
 ┃ ┃ ┗ 📜login.dart <br/>
 ┣ 📂splash <br/>
 ┃ ┗ 📂view <br/>
 ┃ ┃ ┗ 📜splash.dart <br/>
 ┗ 📜main.dart <br/>

## 3. 개발 기간 및 작업 관리
### 개발 기간
- 2025.01.05 ~ 2025.01.12
### 작업 관리
- github desktop 을 사용해서 관리

## 4. 페이지별 기능
### 로그인

#### 로그인 성공 
- 로그인에 성공하면 채팅화면으로 이동합니다.
- 서버, 프론트(flutter)에 토큰, 이름을 shared_preferences 라이브러리를 사용해서 저장합니다.
- 토큰 유효시간은 1시간

<img src="https://github.com/user-attachments/assets/29e39b1e-1f1f-49ee-9ede-256b3bbf40de" width="300"> <br/>
#### 중복 로그인
- 이미 로그인 한 사용자가 있다면 로그인을 하지 못하도록 구현했습니다.(중복 로그인X)
- 서버에서 토큰으로 로그인한 사용자 정보를 저장하고 이미 로그인한 사용자 정보를 가지고 로그인 시도를 하면 "이미 로그인된 사용자입니다." 토스트 바를 띄우도록 했습니다.(fluttertoast 라이브러리 사용)

<img src="https://github.com/user-attachments/assets/8b68b213-9494-4afd-97af-352fd22ccf4c" width="300"> <br/>
#### 일치하는 정보가 없을 때
- DB에 저장되지 않은 정보로 로그인을 시도할 경우 로그인을 하지 못하도록 구현했습니다.

<img src="https://github.com/user-attachments/assets/395a3e84-6853-43a3-9e35-e12b5417975c" width="300"> <br/>

### 자동 로그인

#### 토큰이 유효한 경우
- splash 화면에서 토큰 유효성 검사를 해서 유효하다면 채팅 화면으로 이동

<img src="https://github.com/user-attachments/assets/c6b3ebf0-6f81-436f-90a0-1e6d206ed27d" width="300"> <br/>
#### 토큰이 유효하지 않거나, 없을 경우
- splash 화면에서 토큰 유효성 검사를 해서 유효하지 않거나 토큰을 보유하지 않을 경우 로그인 화면으로 이동

<img src="https://github.com/user-attachments/assets/a505e715-e8f9-4f42-89e9-445e2faf200e" width="300"> <br/>

### 채팅
- Node.js socket.io 라이브러리를 사용해서 채팅을 구현했습니다.
- 본인은 오른쪽 핑크 말풍선 상대방은 왼쪽 파란 말풍선으로 자신과 상대방을 구분했습니다.
- 채팅이 쌓여서 밑으로 내려갈떄 화면도 최근 채팅을 따라 가도록 구현했습니다.

![Image](https://github.com/user-attachments/assets/f8defac7-ff52-4fcf-90f4-675a1f40cbe4)
![Image](https://github.com/user-attachments/assets/6a1f69fd-a5ef-4459-abdc-05a859f0d458)

## 5. 구현하면서 경험한 이슈사항 및 신경 쓴 부분
### 구현하면서 경험한 이슈사항
- 자동 로그인 구현할 때 provider 라이브러리는 영구 저장이 아니여서 자동 로그인 구현에 이슈 발생
  - shared_preferences 라이브러리는 영구 저장 라이브러리이고 토큰, 로그인한 사용자 이름을 저장하는데 저장된 값이 변하지 않기 때문에 shared_preferences 라이브러리로 변경해서 해결

### 신경 쓴 부분
- 유지보수, 코드의 가독성
  - 많이 사용하는 위젯, 함수를 컴포넌트로 만들어서 필요할 때 마다 호출을 하도록 구현했습니다.
- UI
  - 기기마다 크기가 다르기 때문에 px가 아닌 %로 위젯, 글자 크기를 주었습니다.
- UX
  - 로그인 화면에서 아이디, 패스워드 입력창은 띄어쓰기가 안되도록 구현(채팅 입력창은 띄어쓰기 가능)
  - 비밀번호를 *로 보여주는데 아이콘 클릭 시 *이 아닌 입력한 그대로 보여주도록 구현(입력한 그대로 보여주다가 아이콘을 클릭하면 다시 *로 변경)
  - 본인이 채팅을 치거나 상대방이 채팅을 치면 채팅이 쌓이는데 화면이 상단에 그대로 있는 것이 아니라 채팅을 따라서 밑으로 이동하도록 구현
