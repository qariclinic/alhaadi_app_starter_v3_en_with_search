
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String,dynamic>? quran;
  List<Map<String,dynamic>> searchResults = [];
  TextEditingController controller = TextEditingController();

  @override void initState(){ super.initState(); loadData(); }
  Future<void> loadData() async {
    final s = await rootBundle.loadString('assets/data/quran.json');
    setState(()=> quran = json.decode(s));
  }

  void doSearch(String query){
    if(quran==null){ return; }
    List<Map<String,dynamic>> results=[];
    for(var surah in quran!['surahs']){
      for(var ayah in surah['ayahs']){
        if(ayah['arabic'].toString().contains(query) || ayah['english'].toString().toLowerCase().contains(query.toLowerCase())){
          results.add({'surah': surah['name'], 'number': ayah['number'], 'arabic': ayah['arabic'], 'english': ayah['english']});
        }
      }
    }
    setState(()=> searchResults = results);
  }

  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text('الہادی - Quran Search')),
      body: quran==null ? const Center(child:CircularProgressIndicator()) : Column(
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Search Quran (Arabic/English)', border: OutlineInputBorder()),
            onChanged: doSearch,
          )),
          Expanded(child: searchResults.isEmpty ? ListView(
            children:[
              ListTile(title: const Text('قرآن'), subtitle: Text('سورتیں: ${quran!['surahs'].length}')),
              ListTile(title: const Text('حدیث'), subtitle: const Text('Demo hadith included'))
            ]) : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder:(c,i){
                final r=searchResults[i];
                return ListTile(title: Text("${r['surah']} - ${r['number']}"), subtitle: Text("${r['arabic']}
${r['english']}"));
              }
          ))
        ],
      ),
    );
  }
}
