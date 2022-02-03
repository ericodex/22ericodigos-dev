// ███████ ██████  ██  ██████  ██████  ██████  ██  ██████   ██████  ███████
// ██      ██   ██ ██ ██      ██    ██ ██   ██ ██ ██       ██    ██ ██
// █████   ██████  ██ ██      ██    ██ ██   ██ ██ ██   ███ ██    ██ ███████
// ██      ██   ██ ██ ██      ██    ██ ██   ██ ██ ██    ██ ██    ██      ██
// ███████ ██   ██ ██  ██████  ██████  ██████  ██  ██████   ██████  ███████
// 18 - JAN - 22
// Application for professional information display

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ericode2022/firebase_config.dart';
import 'package:get/get.dart';
import 'login_register.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kDebugMode, kIsWeb;

final FirebaseAuth _auth = FirebaseAuth.instance;

// Change to false to use live database instance.
const useDatabaseEmulator = true;
const emulatorPort = 9000;
final emulatorHost =
    (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
        ? '10.0.2.2'
        : 'localhost';

Future<void> main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  if (useDatabaseEmulator) {
    FirebaseDatabase.instance.useDatabaseEmulator(emulatorHost, emulatorPort);
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const RootNavigator());
}

// Theme dark and light
final ThemeData _darkTheme = ThemeData(
  //primarySwatch: Colors.green,
  //primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
      onPrimary: Colors.white,
      secondary: Colors.green,
      onSecondary: Colors.pink,
      primary: Colors.green,
      background: Colors.cyan,
      brightness: Brightness.dark,
      primaryVariant: Colors.greenAccent,
      onBackground: Colors.purple,
      onSurface: Colors.green,
      secondaryVariant: Colors.black12,
      surface: Colors.black38,
      error: Colors.red,
      onError: Colors.redAccent),
);
final ThemeData _lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
      primary: Colors.red,
      // onPrimary: Colors.white,
      // secondary: Colors.white,
      // onSecondary: Colors.pink,
      // background: Colors.cyan,
      // brightness: Brightness.light,
      // primaryVariant: Colors.greenAccent,
      // //onBackground: Colors.purple,
      // onSurface: Colors.green,
      // //secondaryVariant: Colors.blueGrey,
      // surface: Colors.grey,
      // error: Colors.red,
      // onError: Colors.redAccent
      ),
);

class RootNavigator extends StatefulWidget {
  const RootNavigator({
    Key? key,
  }) : super(key: key);

  @override
  State<RootNavigator> createState() => _RootNavigatorState();
}

class _RootNavigatorState extends State<RootNavigator> {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const FullPageHome(),
        '/b': (BuildContext context) => const ChatPage(),
        '/c': (BuildContext context) => const LoginPage(),
        '/register': (BuildContext context) => const RegisterPage(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      title: 'ericódigos',
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}

class Global {
  static final shared = Global();
  bool isInstructionView = false;
}

class FullPageHome extends StatefulWidget {
  const FullPageHome({Key? key}) : super(key: key);

  @override
  State<FullPageHome> createState() => _FullPageHomeState();
}

class _FullPageHomeState extends State<FullPageHome> {
  bool isOn = Global.shared.isInstructionView;
  late bool isInstructionView;
  User? user;
  String _frontMsg = '';
  //late DatabaseReference _frontMsgRef;
  bool initialized = false;
  //late FirebaseAuth _auth;
  //late DatabaseReference _messagesRef;
  //late StreamSubscription<DatabaseEvent> _counterSubscription;
  //late StreamSubscription<DatabaseEvent> _messagesSubscription;

  //--------- inset ----------
  final _databaseInst = FirebaseDatabase.instance;
  final _database = FirebaseDatabase.instance.ref();
  late StreamSubscription _dataBaseStream;
  //final DatabaseReference _frontMsgRef = FirebaseDatabase.instance.ref('frontMsg');

  @override
  void initState() {
    isInstructionView = Global.shared.isInstructionView;
    _auth.userChanges().listen(
          (event) => setState(() => user = event),
        );
    init();
    setState(() {
      initialized = true;
    });
    super.initState();
    _activateListeners();
  }

  void _activateListeners(){
    _dataBaseStream = _database.child('/frontMsg/').onValue.listen((event) {
      final String _frontPageMsg = event.snapshot.value.toString();

      
      setState(() {
        _frontMsg = _frontPageMsg;
      });
    });

  }

  Future<void> init() async {
    try {
      //final frontMsgSnapshot = await _frontMsgRef.get();

     // _frontMsg = frontMsgSnapshot.value.toString();
      if (kDebugMode) {
        print(_frontMsg);
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }

    _databaseInst.setLoggingEnabled(false);

    if (!kIsWeb) {
      _databaseInst.setPersistenceEnabled(true);
      _databaseInst.setPersistenceCacheSizeBytes(10000000);
    }

    if (!kIsWeb) {
     // await _frontMsgRef.keepSynced(true);
    }
    
  }
refresh() {
  setState(() {});
}
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    if (!initialized) return Container();
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText2!,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ericodigos.dev'),
          actions: <Widget>[
            IconButton(
                //color: user == null ? Colors.white : Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                color: user == null ? Colors.grey : Colors.green,
                icon: const Icon(Icons.person)),
            IconButton(
                onPressed: () {
                  setState(() {
                    isOn
                        ? Get.changeThemeMode(ThemeMode.dark)
                        : Get.changeThemeMode(ThemeMode.light);
                    isOn = !isOn;
                    Global.shared.isInstructionView = isOn;
                  });
                },
                color: Colors.white,
                icon: Icon(Global.shared.isInstructionView
                    ? Icons.dark_mode
                    : Icons.light_mode)),
          ],
        ),
        body: Center(
          child: BodyFrontPage(width: _width, frontMsg: _frontMsg, notifyParent: refresh),
        ),
        
      ),
    );
  }

  @override
  void deactivate() {
    _dataBaseStream.cancel();
    super.deactivate();
  }

}

class BodyFrontPage extends StatefulWidget {
  final Function() notifyParent;
  const BodyFrontPage({
    Key? key,
    required double width,
    required String frontMsg, required this.notifyParent,
  })  : _width = width,
        _frontMsg = frontMsg,
        super(key: key);

  final double _width;
  final String _frontMsg;
  

  @override
  State<BodyFrontPage> createState() => _BodyFrontPageState();
}

class _BodyFrontPageState extends State<BodyFrontPage> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //double _height = MediaQuery.of(context).size.height;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
              //maxHeight: _height
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SizedBox(
                    width: widget._width < 900
                        ? widget._width * 0.80
                        : widget._width / 2,
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 18, 0, 18),
                        child: Column(
                          children: [
                            Container(
                                width: 270.0,
                                height: 290.0,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.fitHeight,
                                        image: NetworkImage(
                                            "https://avatars2.githubusercontent.com/u/32937165?s=460&v=4")))),
                            Card(
                              elevation: 12,
                              color: Theme.of(context).colorScheme.secondary,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('ERIC OLIVEIRA LIMA'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //Text(widget._frontMsg),
                
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SizedBox(
                    width: widget._width < 900
                        ? widget._width * 0.80
                        : widget._width / 2,
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                            widget._frontMsg,
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize: 16),
                            softWrap: true),
                      ),
                    ),
                  ),
                ),
                //Divider(),
                Card(
                  elevation: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ChatPage()),
                            );
                          },
                          icon: const Icon(Icons.business)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.school))
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  void _handleSubmitted(String text) {
    _textController.clear();

    setState(() {
      _isComposing = false;
    });

    // When the user sends a chat message from the text field, the app should add the new message to the message list.
    var message = ChatMessage(
      text: text,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
    _focusNode.requestFocus();
  }

  // Private method, configures TextField widget
  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              // Callback method
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: _isComposing ? _handleSubmitted : null,
              decoration:
                  const InputDecoration.collapsed(hintText: 'Send a message'),
              focusNode: _focusNode,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconTheme(
              data:
                  IconThemeData(color: Theme.of(context).colorScheme.secondary),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _isComposing
                        ? () => _handleSubmitted(_textController.text)
                        : null),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Flexible(
          //The ListView.builder factory method builds a list on demand by providing a function that is called once per
          //item in the list. The function returns a new widget at each call. The builder also automatically detects mutations of
          //its children parameter and initiates a rebuild.
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            reverse: true,
            //itemBuilder provides the function that builds each widget in [index]. Because you don't need the current build context,
            // you can ignore the first argument of IndexedWidgetBuilder. Naming the argument with an underscore (_) and nothing else is
            // a convention indicating that the argument won't be used.
            itemBuilder: (_, index) => _messages[index],
            itemCount: _messages.length,
          ),
        ),
        //const Divider(height: 1.0),
        Container(
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(color: Theme.of(context).cardColor)
              : null,
          child: _buildTextComposer(),
        ),
      ],
    ));
  }

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  // Variable and constructors
  const ChatMessage({
    required this.text,
    required this.animationController,
    Key? key,
  }) : super(key: key);

  final String text;
  final AnimationController animationController;
  final String _name = '>';

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutCubicEmphasized,
      ),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: CircleAvatar(child: Text(_name[0])),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _name,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(text),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
