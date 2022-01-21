// ███████ ██████  ██  ██████  ██████  ██████  ██  ██████   ██████  ███████
// ██      ██   ██ ██ ██      ██    ██ ██   ██ ██ ██       ██    ██ ██
// █████   ██████  ██ ██      ██    ██ ██   ██ ██ ██   ███ ██    ██ ███████
// ██      ██   ██ ██ ██      ██    ██ ██   ██ ██ ██    ██ ██    ██      ██
// ███████ ██   ██ ██  ██████  ██████  ██████  ██  ██████   ██████  ███████
// 21 - JAN - 22
// Application for professional information display

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ericodigos.dev'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "https://avatars2.githubusercontent.com/u/32937165?s=460&v=4")))),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'Arquiteto de sistemas de informação, desenvolvedor e mantenedor de ecossistemas digitais. Atuação em projetos web com Dart/Flutter, Java Spring e .NET Core/MVC. Conhecimento em Bootstrap, JQuery, SQL, NoSQL, Integration Services (ETL), Oracle, Python e Jupyter Notebooks.  Atualizações de certificados de segurança de domínio e criptografia OpenSSL. Implementações de microserviços com Docker, Kubernetes/Portainer em nuvens públicas e privadas.',
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style:
                      TextStyle(fontSize: 26, height: 1.3, color: Colors.blue[100]),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.ac_unit),
                label: 'Home'
            )
          ],

        ),
      ),
    );
  }
}
