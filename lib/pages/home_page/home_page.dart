import 'package:arignar_app_task/pages/question_page/question_page.dart';
import 'package:arignar_app_task/utils/constant/questions.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Questions questions = Questions();
  late List questionCategory = [
    {
      "title": "Read and Select picture",
      "subTitle": "House Animals",
      "data": questions.homeAnimalsWithRead
    },
    {
      "title": "Listen and Choose picture",
      "subTitle": "House Animals",
      "data": questions.homeAnimalsWithRead
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              color: const Color(0xff7abeb0),
              height: MediaQuery.of(context).size.height * 0.2,
              child: const Center(
                child: Text(
                  "Mari Selvan",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text("Change Profile"),
            ),
            const ListTile(
              leading: Icon(Icons.list),
              title: Text("Change Subject"),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
            ),
            const ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xff7abeb0),
        title: const Text("Domestic Animals"),
      ),
      body: Container(
          padding: const EdgeInsets.only(top: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color(0xffc9f2ea),
          child: Center(
            child: Column(
              children: [
                const Text(
                  "Questions",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                ),
                ...questionCategory.map((item) => Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      margin: const EdgeInsets.only(top: 20),
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ListTile(
                        title: Text(item['title']),
                        titleAlignment: ListTileTitleAlignment.center,
                        subtitle: Text(item['subTitle']),
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    QuestionPage(questions: item['data'])),
                          )
                        },
                      ),
                    ))
              ],
            ),
          )),
    );
  }
}
