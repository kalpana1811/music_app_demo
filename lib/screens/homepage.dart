import 'package:flutter/material.dart';
import 'package:spotify_app/services/songModel.dart';
import 'package:spotify_app/services/song_Client.dart';

class HOMEPAGE extends StatefulWidget {
  const HOMEPAGE({super.key});

  @override
  State<HOMEPAGE> createState() => _HOMEPAGEState();
}

class _HOMEPAGEState extends State<HOMEPAGE> {
  SongClient songClient = SongClient();
  Future<List<songsModel>> _getSongsFromApi() async {
    Map<String, dynamic> cMap = await songClient.getSongsFromITunes();
    List<dynamic> sList = cMap["results"];
    List<songsModel> finalSongList = toSongModel(sList);
    return finalSongList;
  }

  toSongModel(List<dynamic> list) {
    List<songsModel> convertedSongs = list.map((singleObject) {
      songsModel sModel = songsModel.fromJSON(singleObject);
      return sModel;
    }).toList();

    return convertedSongs;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black54,
              title: Text("Amazon Music"),
              centerTitle: true,
            ),
            body: Container(
              child: FutureBuilder(
                  future: _getSongsFromApi(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                            "some error has occured ${snapshot.error.toString()}"),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 50,
                              color: const Color.fromARGB(255, 53, 52, 52),
                              child: ListTile(
                                leading: Image.network(
                                    snapshot.data![index].artworkUrl100),
                                title: Text(
                                  snapshot.data![index].trackName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  snapshot.data![index].artistName,
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                    )),
                              ),
                            );
                          });
                    }
                    return const Placeholder();
                  }),
            )));
  }
}
