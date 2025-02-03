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
- [후기](#6-후기)

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

## 4. 실제 동작 영상

### 로그인
- 로그인을 성공하지 못했을 때는 실패한 이유를 토스트 바로 띄었습니다.(fluttertoast 라이브러리 사용)
- 이미 로그인 한 사용자가 있다면 로그인을 하지 못하도록 구현했습니다.(중복 로그인X)
- DB에 저장되지 않은 정보로 로그인을 시도할 경우 로그인을 하지 못하도록 구현했습니다.

로그인 성공했을 떄 <br/>
<img src="https://github.com/user-attachments/assets/29e39b1e-1f1f-49ee-9ede-256b3bbf40de" width="300"> <br/>
중복 로그인일 때 <br/>
<img src="https://github.com/user-attachments/assets/8b68b213-9494-4afd-97af-352fd22ccf4c" width="300"> <br/>
일치하는 정보가 없을 때 <br/>
<img src="https://github.com/user-attachments/assets/395a3e84-6853-43a3-9e35-e12b5417975c" width="300"> <br/>

