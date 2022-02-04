import 'dart:async';

import 'package:ericode2022/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _unfocusedColor = Colors.grey[600];
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User? user;
  late bool isInstructionView;
  late FirebaseAuth auth;
  late StreamSubscription<User?> _sub;

  @override
  void initState() {
    super.initState();
    isInstructionView = Global.shared.isInstructionView;

    _usernameFocusNode.addListener(() {
      setState(() {
        //Redraw so that the username label reflects the focus state
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        //Redraw so that the password label reflects the focus state
      });
    });

    _sub = _auth.userChanges().listen(
          (event) => setState(() => user = event),
        );
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    bool isOn = Global.shared.isInstructionView;
    var buttonBar = ButtonBar(
      children: <Widget>[
        ElevatedButton(
          child: const Text('Registrar'),
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(8.0),
            shape: MaterialStateProperty.all(
              const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            );
          },
        ),
        // TextButton(
        //   child: const Text('Cancelar'),
        //   style: ButtonStyle(
        //       foregroundColor: MaterialStateProperty.all(
        //           Theme.of(context).colorScheme.secondary),
        //       shape: MaterialStateProperty.all(
        //           const BeveledRectangleBorder(
        //               borderRadius:
        //                   BorderRadius.all(Radius.circular(7))))),
        //   onPressed: () {
        //     _usernameController.clear();
        //     _passwordController.clear();
        //   },
        // ),
        ElevatedButton(
          child: const Text('Entrar'),
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(8.0),
            shape: MaterialStateProperty.all(
              const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await _signInWithEmailAndPassword();
            }
          },
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('ericodigos.dev'),
        actions: <Widget>[
          IconButton(
              color: user == null ? Colors.grey : Colors.blue,
              onPressed: () {},
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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(),
                  SizedBox(
                    width: _width < 900 ? _width * 0.80 : _width / 2,
                    child: Card(
                      elevation: 8,
                      borderOnForeground: true,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 10.0),
                            Image.asset('assets/diamond.png'),
                            const SizedBox(height: 5.0),
                            Text(
                              'LOGIN',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            const SizedBox(height: 5.0),
                            user != null
                                ? _UserInfoCard(user: user)
                                : Container(),
                            const SizedBox(height: 10.0),
                            user == null
                                ? Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: CardUserPass(
                                        usernameController: _usernameController,
                                        usernameFocusNode: _usernameFocusNode,
                                        unfocusedColor: _unfocusedColor,
                                        passwordController: _passwordController,
                                        passwordFocusNode: _passwordFocusNode),
                                  )
                                : Container(),
                            user == null ? buttonBar : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  // Example code of how to sign in with email and password.
  Future<void> _signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      ))
          .user!;
      ScaffoldSnackbar.of(context).show('${user.email} conectado');
    } catch (e) {
      ScaffoldSnackbar.of(context).show('Falha ao conectar com email & senha');
    }
  }
}

class CardUserPass extends StatelessWidget {
  const CardUserPass({
    Key? key,
    required TextEditingController usernameController,
    required FocusNode usernameFocusNode,
    required Color? unfocusedColor,
    required TextEditingController passwordController,
    required FocusNode passwordFocusNode,
  })  : _usernameController = usernameController,
        _usernameFocusNode = usernameFocusNode,
        _unfocusedColor = unfocusedColor,
        _passwordController = passwordController,
        _passwordFocusNode = passwordFocusNode,
        super(key: key);

  final TextEditingController _usernameController;
  final FocusNode _usernameFocusNode;
  final Color? _unfocusedColor;
  final TextEditingController _passwordController;
  final FocusNode _passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(
              enableSuggestions: true,
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: _usernameFocusNode.hasFocus
                      ? Theme.of(context).colorScheme.secondary
                      : _unfocusedColor,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              obscureText: true,
              enableSuggestions: true,
              autocorrect: false,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: TextStyle(
                  color: _passwordFocusNode.hasFocus
                      ? Theme.of(context).colorScheme.secondary
                      : _unfocusedColor,
                ),
              ),
              focusNode: _passwordFocusNode,
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper class to show a snackbar using the passed context.
class ScaffoldSnackbar {
  ScaffoldSnackbar(this._context);
  final BuildContext _context;

  /// The scaffold of current context.
  factory ScaffoldSnackbar.of(BuildContext context) {
    return ScaffoldSnackbar(context);
  }

  /// Helper method to show a SnackBar.
  void show(String message) {
    ScaffoldMessenger.of(_context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}

class _UserInfoCard extends StatefulWidget {
  const _UserInfoCard({Key? key, this.user}) : super(key: key);

  final User? user;

  @override
  _UserInfoCardState createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<_UserInfoCard> {
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              alignment: Alignment.center,
              child: const Text(
                'Informações do usuário',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            if (widget.user != null)
              if (widget.user!.photoURL != null)
                SizedBox(
                  height: 200,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Image.network(widget.user!.photoURL!),
                  ),
                )

              else
                Align(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 8),
                    //color: Colors.black,
                    child: const Text(
                      'No image',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              Text(
              widget.user == null
                  ? 'Desconectado'
                  : '${widget.user!.isAnonymous ? 'User is anonymous\n\n' : ''}'
                      'Email: ${widget.user!.email} (verified: ${widget.user!.emailVerified})\n\n'
                      'Celular: ${widget.user!.phoneNumber}\n\n'
                      'Nome: ${widget.user!.displayName}\n\n'
                      //'ID: ${widget.user!.uid}\n\n'
                      //'Tenant ID: ${widget.user!.tenantId}\n\n'
                      //'Refresh token: ${widget.user!.refreshToken}\n\n\n'
                      'Criado em: ${widget.user!.metadata.creationTime.toString()}\n\n'
                      'Última conexão: ${widget.user!.metadata.lastSignInTime}\n\n',
              ),

            //if (widget.user != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.user!.providerData.isEmpty
                        ? 'No providers'
                        : 'Providers:',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  for (var provider in widget.user!.providerData)
                    Dismissible(
                      key: Key(provider.uid!),
                      onDismissed: (action) =>
                          widget.user!.unlink(provider.providerId),
                      child: Card(
                        color: Colors.grey[700],
                        child: ListTile(
                          leading: provider.photoURL == null
                              ? IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () =>
                                      widget.user!.unlink(provider.providerId))
                              : Image.network(provider.photoURL!),
                          title: Text(provider.providerId),
                          subtitle: Text(
                              //"${provider.uid == null ? "" : "ID: ${provider.uid}\n"}"
                              "${provider.email == null ? "" : "Email: ${provider.email}\n"}"
                              "${provider.phoneNumber == null ? "" : "Phone number: ${provider.phoneNumber}\n"}"
                              "${provider.displayName == null ? "" : "Name: ${provider.displayName}\n"}"),
                        ),
                      ),
                    ),
                ],
              ),
            Visibility(
              visible: widget.user != null,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => widget.user!.reload(),
                      icon: const Icon(Icons.refresh),
                    ),
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) =>
                            UpdateUserDialog(user: widget.user),
                      ),
                      icon: const Icon(Icons.text_snippet),
                    ),
                    IconButton(
                      onPressed: () => {
                        _auth.signOut(),
                      },
                      icon: const Icon(Icons.logout),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class UpdateUserDialog extends StatefulWidget {
  const UpdateUserDialog({Key? key, this.user}) : super(key: key);

  final User? user;

  @override
  _UpdateUserDialogState createState() => _UpdateUserDialogState();
}

class _UpdateUserDialogState extends State<UpdateUserDialog> {
  TextEditingController? _nameController;
  TextEditingController? _urlController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.user!.displayName);
    _urlController = TextEditingController(text: widget.user!.photoURL);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update profile'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            TextFormField(
              controller: _nameController,
              autocorrect: false,
              decoration: const InputDecoration(labelText: 'displayName'),
            ),
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: 'photoURL'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autocorrect: false,
              validator: (String? value) {
                if (value != null && value.isNotEmpty) {
                  var uri = Uri.parse(value);
                  if (uri.isAbsolute) {
                    //You can get the data with dart:io or http and check it here
                    return null;
                  }
                  return 'Faulty URL!';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.user!.updateDisplayName(_nameController!.text);
            widget.user!.updatePhotoURL(_urlController!.text);

            Navigator.of(context).pop();
          },
          child: const Text('Update'),
        )
      ],
    );
  }

  @override
  void dispose() {
    _nameController!.dispose();
    _urlController!.dispose();
    super.dispose();
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _unfocusedColor = Colors.grey[600];
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _success = false;
  String _error = '';
  User? user;
  bool isInstructionView = Global.shared.isInstructionView;

  @override
  void initState() {
    super.initState();

    _usernameFocusNode.addListener(() {
      setState(() {
        //Redraw so that the username label reflects the focus state
      });
    });

    _passwordFocusNode.addListener(() {
      setState(() {
        //Redraw so that the password label reflects the focus state
      });
    });

    // if (mounted){
    //   _auth.userChanges().listen(
    //     (event) => setState(() => user = event),
    //   );
    // }
  
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    var buttonBar = ButtonBar(
      children: <Widget>[
        ElevatedButton(
          child: const Text('Registrar'),
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(8.0),
            shape: MaterialStateProperty.all(
              const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await _register();
              //print(_error);
              //ScaffoldSnackbar.of(context).show(_error.replaceAll('[firebase_auth/invalid-email]',''));
            }
          },
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('ericodigos.dev'),
        actions: <Widget>[
          IconButton(
              color: user == null ? Colors.white : Colors.blue,
              onPressed: () {},
              icon: const Icon(Icons.person)),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(),
                  SizedBox(
                    width: _width < 900 ? _width * 0.80 : _width / 2,
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Image.asset('assets/diamond.png'),
                              const SizedBox(height: 5.0),
                              Text(
                                'REGISTRO',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              //const SizedBox(height: 5.0),
                              //user != null ? _UserInfoCard(user: user) : Container(),
                              //const SizedBox(height: 10.0),
                              _success == false
                                  ? CardUserPass(
                                      usernameController: _emailController,
                                      usernameFocusNode: _usernameFocusNode,
                                      unfocusedColor: _unfocusedColor,
                                      passwordController: _passwordController,
                                      passwordFocusNode: _passwordFocusNode)
                                  : Container(),
                              _success == false ? buttonBar : Container(),
                              Text(_success == false
                                  ? _error.replaceAll(
                                      '[firebase_auth/invalid-email]', '')
                                  : 'Concluído')
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }



// Example code for registration.
  Future<void> _register() async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      if (user != null) {
        if(mounted) {
          setState(() {
          _success = true;
        });
        }
      } else {
        _success = false;
      }
    } catch (e) {
      if(mounted) {
        setState(() {
        _error = e.toString();
      });
      }
    }
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
