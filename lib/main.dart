// ███████ ██████  ██  ██████  ██████  ██████  ██  ██████   ██████  ███████
// ██      ██   ██ ██ ██      ██    ██ ██   ██ ██ ██       ██    ██ ██
// █████   ██████  ██ ██      ██    ██ ██   ██ ██ ██   ███ ██    ██ ███████
// ██      ██   ██ ██ ██      ██    ██ ██   ██ ██ ██    ██ ██    ██      ██
// ███████ ██   ██ ██  ██████  ██████  ██████  ██  ██████   ██████  ███████
// 18 - JAN - 22
// Application for professional information display

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:ericode2022/rootPages.dart';

void main() {
  runApp(const MyApp());
}

// Theme
final ThemeData KIOSTheme = ThemeData(
  primarySwatch: Colors.green,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
  colorScheme: const ColorScheme.dark(
    onPrimary: Colors.amber,
    secondary: Colors.orange,
    onSecondary: Colors.pink,
    primary: Colors.blue,
    background: Colors.cyan,
    brightness: Brightness.dark,
    primaryVariant: Colors.greenAccent,
    onBackground: Colors.purple,
    onSurface: Colors.green,
    secondaryVariant: Colors.black12,
    surface: Colors.black38,
    error: Colors.red,
    onError: Colors.redAccent
  ),
);

final ThemeData KDefaultTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(secondary: Colors.greenAccent[400])
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ericódigos',
      theme: defaultTargetPlatform == TargetPlatform.iOS ? KDefaultTheme : KIOSTheme,
      //home: ChatScreen(),
      home: const LandingPage(),
      //home: const MyHomePage(title: 'ericódigos'),
    );
  }
}




class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  final List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  void _handleSubmitted(String text){
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
  Widget _buildTextComposer(){
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
              decoration: const InputDecoration.collapsed(hintText: 'Send a message'),
              focusNode: _focusNode,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconTheme(
              data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isComposing ?
                      () => _handleSubmitted(_textController.text):null),
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
      appBar: AppBar(
        title: const Text('FriendlyChat')
      ),
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
                  itemBuilder: (_,index) => _messages[index],
                  itemCount: _messages.length,
              ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: Theme.of(context).platform == TargetPlatform.iOS ?
            BoxDecoration(
                color: Theme.of(context).cardColor) : null,
            child: _buildTextComposer(),
            ),
        ],
      )
    );
  }

  @override
  void dispose() {
    for (var message in _messages){
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
  final String _name = 'Eric O Lima';

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
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,8,0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: CircleAvatar(child: Text(_name[0])),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_name, style: Theme.of(context).textTheme.headline4,),
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




