// ███████ ██████  ██  ██████  ██████  ██████  ██  ██████   ██████  ███████
// ██      ██   ██ ██ ██      ██    ██ ██   ██ ██ ██       ██    ██ ██
// █████   ██████  ██ ██      ██    ██ ██   ██ ██ ██   ███ ██    ██ ███████
// ██      ██   ██ ██ ██      ██    ██ ██   ██ ██ ██    ██ ██    ██      ██
// ███████ ██   ██ ██  ██████  ██████  ██████  ██  ██████   ██████  ███████
// 18 - JAN - 22
// Application for professional information display

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ericode2022/firebase_config.dart';
import 'package:get/get.dart';
import 'loginAndRegister.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

final FirebaseAuth _auth = FirebaseAuth.instance;

// Change to false to use live database instance.
const USE_DATABASE_EMULATOR = true;
// The port we've set the Firebase Database emulator to run on via the
// `firebase.json` configuration file.
const emulatorPort = 9000;
// Android device emulators consider localhost of the host machine as 10.0.2.2
// so let's use that if running on Android.
final emulatorHost =
    (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
        ? '10.0.2.2'
        : 'localhost';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(const RootNavigator());
}

// Theme Dark
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

// Theme Light
final ThemeData _lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
      primary: Colors.green,
      onPrimary: Colors.white,
      secondary: Colors.green,
      onSecondary: Colors.pink,
      background: Colors.cyan,
      brightness: Brightness.light,
      primaryVariant: Colors.greenAccent,
      //onBackground: Colors.purple,
      onSurface: Colors.green,
      //secondaryVariant: Colors.blueGrey,
      surface: Colors.grey,
      error: Colors.red,
      onError: Colors.redAccent),
);

class RootNavigator extends StatefulWidget {
  const RootNavigator({
    Key? key,
  }) : super(key: key);

  @override
  State<RootNavigator> createState() => _RootNavigatorState();
}

class _RootNavigatorState extends State<RootNavigator> {
  //ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: <String, WidgetBuilder>{
        '/a': (BuildContext context) => FullPageHome(),
        '/b': (BuildContext context) => ChatPage(),
        '/c': (BuildContext context) => LoginPage(),
        '/register': (BuildContext context) => RegisterPage(),
      },
      initialRoute: '/a',
      debugShowCheckedModeBanner: false,
      title: 'ericódigos',
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: ThemeMode.system,
      //home:
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
  @override
  void initState() {
    isInstructionView = Global.shared.isInstructionView;
    _auth.userChanges().listen(
          (event) => setState(() => user = event),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText2!,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ericodigos.dev'),
          actions: <Widget>[
            IconButton(
                color: user == null ? Colors.white : Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
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
              icon: Icon(Global.shared.isInstructionView ? Icons.dark_mode : Icons.light_mode)),
          ],
        ),
        body: Center(
          child: BodyFrontPage(width: _width),
        ),
      ),
    );
  }
}

class BodyFrontPage extends StatelessWidget {
  const BodyFrontPage({
    Key? key,
    required double width,
  })  : _width = width,
        super(key: key);

  final double _width;

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
                    width: _width < 900 ? _width * 0.80 : _width / 2,
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
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SizedBox(
                    width: _width < 900 ? _width * 0.80 : _width / 2,
                    child: const Card(
                      elevation: 8,
                      child: Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text(
                            'Arquiteto de sistemas de informação, desenvolvedor e mantenedor de ecossistemas digitais. Atuação em projetos web com Dart/Flutter, Java Spring e .NET Core/MVC. Conhecimento em Bootstrap, JQuery, SQL, NoSQL, Integration Services (ETL), Oracle, Python e Jupyter Notebooks.  Atualizações de certificados de segurança de domínio e criptografia OpenSSL. Implementações de microserviços com Docker, Kubernetes/Portainer em nuvens públicas e privadas.',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 16),
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
                      IconButton(onPressed: () {}, icon: Icon(Icons.home)),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ChatPage()),
                            );
                          },
                          icon: Icon(Icons.business)),
                      IconButton(onPressed: () {}, icon: Icon(Icons.school))
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
