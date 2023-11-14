import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_box/core/constants/icons.dart';
import 'package:brain_box/feature/test/presentation/pages/test_result_page.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  List vars = ['Large','Fresh','Small','Orange'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tests'),
        actions: [
          const Text('300',style: TextStyle(fontSize: 17),),
          Image.asset(AppIcons.coin),
          IconButton(onPressed: (){

          },icon: const Icon(Icons.settings)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10,right: 20,left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Book test 1'),
                Text('60 s')
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 0,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                )
              ),
              child: const SizedBox(
                width: double.maxFinite,
                height: 150,
                child: Stack(
                  children: [
                    Positioned(
                        child: Text('1/10'),
                      right: 10,
                      top: 10,
                    ),
                    Center(
                      child: AutoSizeText(
                          'Kichik',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Text('Choose one of the answers:',textAlign: TextAlign.center,),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: vars.length,
                itemBuilder: (context, index) => Container(
                  width: double.maxFinite,
                  height: 50,
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.only(left: 15,right: 15,top: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      const Text('A)'),
                      const SizedBox(width: 10,),
                      Text(vars[index])
                    ],
                  ),
                ),
            ),
          ),
          const Expanded(child: SizedBox.shrink()),
          Padding(
            padding: const EdgeInsets.only(left: 15.0,right: 15,top: 10),
            child: SizedBox(height: 50,child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                      )
                  )
              ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TestResultPage(),));
                }, child: const Text('Next question'))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0,right: 15,top: 10,bottom: 10),
            child: SizedBox(height: 50,child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )
                    )
                ),
                onPressed: (){}, child: const Text('leave test'))),
          ),
        ],
      ),
    );
  }
}
