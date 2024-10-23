import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../const/model/model_court.dart';
import '../../../../../../const/value/colors.dart';
import '../../../../../../const/value/text_style.dart';
import '../../../service/provider/providers.dart';
import '../home/court_search/court_information.dart';

class CourtFavorite extends StatefulWidget {
  const CourtFavorite({super.key});

  @override
  State<CourtFavorite> createState() => _CourtFavoriteState();
}

class _CourtFavoriteState extends State<CourtFavorite> {
  final ValueNotifier<List<ModelCourt>> vnListModelCourt = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    getListModelCourt();
  }

  Future<void> getListModelCourt() async {
    final myFavoriteCourtIds = userNotifier.value!.favorites;
    final listFuture = myFavoriteCourtIds.map((id) => FirebaseFirestore.instance.collection('court').doc(id).get()).toList();
    final courtDocs = await Future.wait(listFuture);
    final List<ModelCourt> listModelCourt = courtDocs.map((courtDoc) {
      return ModelCourt.fromJson(courtDoc.data()!);
    }).toList();
    vnListModelCourt.value = listModelCourt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:  const Color(0xffe8e8e8),
        centerTitle: true,
        title: Text(
          'FAVORITE COURT',
          style: GoogleFonts.anton(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              color: colorGreen900,
              fontSize: 24,
            ),
          ),
        ),
      ),
      body:
      Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: vnListModelCourt,
              builder: (context, List<ModelCourt> listModelCourt, child) {
                if (listModelCourt.isEmpty) {
                  return const Center(child: Text('No favorite courts found'));
                }
                return ListView.separated(
                  itemCount: listModelCourt.length,
                  separatorBuilder: (context, index) => const Divider(indent: 8,endIndent: 8,color: colorGreen900),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourtInformation(courtId: listModelCourt[index].id),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    listModelCourt[index].name,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    listModelCourt[index].location,
                                    style: const TS.s12w400(colorGray600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
