import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healmob/components/rounded_button.dart';
import 'package:healmob/components/rounded_dropdown.dart';
import 'package:healmob/components/rounded_input_field.dart';
import 'package:healmob/constants.dart';
import 'package:healmob/data/anabilim_dali_api.dart';
import 'package:healmob/data/doktor_api.dart';
import 'package:healmob/data/doktor_uzmanlik_alani_api.dart';
import 'package:healmob/data/mesaj_api.dart';
import 'package:healmob/data/uzmanlik_alani_api.dart';
import 'package:healmob/models/anabilim_dali.dart';
import 'package:healmob/models/api_response/api_get_response.dart';
import 'package:healmob/models/doktor.dart';
import 'package:healmob/models/doktor_uzmanlik_alani.dart';
import 'package:healmob/models/hasta.dart';
import 'package:healmob/models/mesaj.dart';
import 'package:healmob/models/uzmanlik_alani.dart';
import 'package:healmob/screens/patient_home/message_screen.dart';

class HomePage extends StatefulWidget {
  final Hasta hasta;
  const HomePage({Key? key, required this.hasta}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AnabilimDali selectedAnabilimDali = AnabilimDali(-1, "Anabilim dalı seçiniz");
  UzmanlikAlani selectedUzmanlikAlani =
      UzmanlikAlani(-1, "Uzmanlık alanı seçiniz");
  List<AnabilimDali> anabilimDaliList = <AnabilimDali>[];
  List<UzmanlikAlani> uzmanlikAlaniList = <UzmanlikAlani>[];
  List<Doktor> doktorList = <Doktor>[];
  TextEditingController txtDoktorAdi = TextEditingController();

  @override
  void initState() {
    getAllAnabilimDaliFromApi();
    getAllUzmanlikAlaniFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      child: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [appPrimaryDarkColor, appPrimaryColor]),
            ),
            child: Column(
              children: [
                Expanded(
                    child: Stack(
                  children: [
                    Center(
                      child: Text(
                        "Hoşgeldiniz\n${widget.hasta.ad.replaceFirst(widget.hasta.ad[0], widget.hasta.ad[0].toUpperCase())} ${widget.hasta.cinsiyet ? 'Hanım' : 'Bey'}",
                        style: const TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
          DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Column(
              children: [
                TabBar(
                  labelColor: appPrimaryColor,
                  unselectedLabelColor: Colors.grey,
                  onTap: (val) {
                    setState(() {
                      doktorList.clear();
                    });
                  },
                  tabs: const [
                    Tab(
                      text: "Anabilim dalı",
                    ),
                    Tab(
                      text: "Uzmanlık alanı",
                    ),
                    Tab(text: "Doktor adı"),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  child: TabBarView(children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedDropdown<AnabilimDali>(
                          icon: Icons.assignment_ind_rounded,
                          onChanged: (value) {
                            setState(() {
                              selectedAnabilimDali = value!;
                            });
                          },
                          items: anabilimDaliList
                              .map((a) => DropdownMenuItem(
                                    child: Text(a.anabilimDaliAdi),
                                    value: a,
                                  ))
                              .toList(),
                          selectedValue: selectedAnabilimDali,
                        ),
                        RoundedButton(
                            buttonText: "Anabilim Dalına Göre Doktor Ara",
                            onPress: () {
                              if (selectedAnabilimDali.anabilimDaliNo != -1) {
                                getAllDoktorByAnabilimDaliFromApi(
                                    selectedAnabilimDali.anabilimDaliNo);
                              } else {
                                _showAlert(context, "Anabilim dalı seçiniz",
                                    "Arama yapmak için bir anabilim dalı seçiniz");
                              }
                            }),
                      ],
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          RoundedDropdown<UzmanlikAlani>(
                            icon: Icons.assignment_ind_rounded,
                            onChanged: (value) {
                              setState(() {
                                selectedUzmanlikAlani = value!;
                              });
                            },
                            items: uzmanlikAlaniList
                                .map((u) => DropdownMenuItem(
                                      child: Text(u.uzmanlikAlaniAdi),
                                      value: u,
                                    ))
                                .toList(),
                            selectedValue: selectedUzmanlikAlani,
                          ),
                          RoundedButton(
                              buttonText: "Uzmanlık Alanına Göre Doktor Ara",
                              onPress: () {
                                if (selectedUzmanlikAlani.uzmanlikAlaniId !=
                                    -1) {
                                  getAllDoktorByUzmanlikAlaniFromApi(
                                      selectedUzmanlikAlani.uzmanlikAlaniId);
                                } else {
                                  _showAlert(context, "Uzmanlık alanı seçiniz",
                                      "Arama yapmak için bir uzmanlık alanı seçiniz");
                                }
                              }),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          RoundedInputField(
                              hintText: "Doktor adını giriniz",
                              icon: Icons.drive_file_rename_outline,
                              onChanged: (value) {
                                txtDoktorAdi.text = value;
                              }),
                          RoundedButton(
                              buttonText: "Ada Göre Doktor Ara",
                              onPress: () {
                                if (txtDoktorAdi.text.isNotEmpty) {
                                  getAllDoktorByNameFromApi(txtDoktorAdi.text);
                                } else {
                                  _showAlert(context, "Doktor adı giriniz",
                                      "Arama yapmak için bir doktor adı giriniz");
                                }
                              }),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: doktorList.length,
            itemBuilder: (context, int index) {
              var selectedDoktor = doktorList[index];
              return ListTile(
                onTap: () {
                  MesajApi.getAllByHastaNo(widget.hasta.hastaNo)
                      .then((response) {
                    var apiResponse =
                        ApiGetResponse.fromJson(json.decode(response.body));
                    if (apiResponse.success) {
                      Mesaj sentMessage = Mesaj(-1, -1, -1, "", "", "");
                      for (int i = 0; i < apiResponse.data.length; i++) {
                        var mesaj = Mesaj.fromJson(apiResponse.data[i]);
                        if (mesaj.doktorNo == selectedDoktor.doktorNo) {
                          sentMessage = mesaj;
                          break;
                        }
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageScreen(
                            hasta: widget.hasta,
                            doktor: selectedDoktor,
                            mesaj: sentMessage,
                            permSendMessage: sentMessage.mesajId == -1,
                          ),
                        ),
                      );
                    }
                  });
                },
                title: Text("${selectedDoktor.ad} ${selectedDoktor.soyad}"),
                subtitle: Text(selectedDoktor.cinsiyet ? 'KADIN' : 'ERKEK'),
                leading: CircleAvatar(
                  child: SvgPicture.asset(selectedDoktor.cinsiyet
                      ? "assets/images/person-girl-flat.svg"
                      : "assets/images/person-flat.svg"),
                ),
                trailing: const Icon(Icons.message),
              );
            },
          ),
        ],
      ),
    );
  }

  getAllAnabilimDaliFromApi() {
    anabilimDaliList.clear();
    AnabilimDaliApi.getAll().then((response) {
      ApiGetResponse apiResponse =
          ApiGetResponse.fromJson(json.decode(response.body));
      if (apiResponse.success) {
        setState(() {
          anabilimDaliList =
              apiResponse.data.map((a) => AnabilimDali.fromJson(a)).toList();
          anabilimDaliList.insert(0, selectedAnabilimDali);
        });
      }
    });
  }

  getAllUzmanlikAlaniFromApi() {
    uzmanlikAlaniList.clear();
    UzmanlikAlaniApi.getAll().then((response) {
      ApiGetResponse apiResponse =
          ApiGetResponse.fromJson(json.decode(response.body));
      if (apiResponse.success) {
        setState(() {
          uzmanlikAlaniList =
              apiResponse.data.map((u) => UzmanlikAlani.fromJson(u)).toList();
          uzmanlikAlaniList.insert(0, selectedUzmanlikAlani);
        });
      }
    });
  }

  getAllDoktorByAnabilimDaliFromApi(int anabilimDaliNo) {
    doktorList.clear();
    DoktorApi.getAllByAnabilimDaliNo(anabilimDaliNo).then((response) {
      ApiGetResponse apiResponse =
          ApiGetResponse.fromJson(json.decode(response.body));
      if (apiResponse.success) {
        setState(() {
          doktorList = apiResponse.data.map((d) => Doktor.fromJson(d)).toList();
        });
      }
    });
  }

  getAllDoktorByNameFromApi(String name) {
    doktorList.clear();
    DoktorApi.getAllByName(name).then((response) {
      ApiGetResponse apiResponse =
          ApiGetResponse.fromJson(json.decode(response.body));
      if (apiResponse.success) {
        setState(() {
          doktorList = apiResponse.data.map((d) => Doktor.fromJson(d)).toList();
        });
      }
    });
  }

  getAllDoktorByUzmanlikAlaniFromApi(int uzmanlikAlaniId) {
    doktorList.clear();
    DoktorUzmanlikAlaniApi.getAllByUzmanlikAlaniId(uzmanlikAlaniId)
        .then((response1) {
      ApiGetResponse apiResponse1 =
          ApiGetResponse.fromJson(json.decode(response1.body));
      if (apiResponse1.success) {
        if (apiResponse1.data.isEmpty) {
          setState(() {
            doktorList.clear();
            return;
          });
        }
        for (int i = 0; i < apiResponse1.data.length; i++) {
          var doktorUzmanlikAlani =
              DoktorUzmanlikAlani.fromJson(apiResponse1.data[i]);
          DoktorApi.getByDoktorNo(doktorUzmanlikAlani.doktorNo)
              .then((response2) {
            ApiGetResponse apiResponse2 =
                ApiGetResponse.fromJson(json.decode(response2.body));
            if (apiResponse2.success) {
              setState(() {
                doktorList.add(
                  Doktor.fromJson(apiResponse2.data[0]),
                );
              });
            }
          });
        }
      }
    });
  }

  void _showAlert(BuildContext context, String title, String message) {
    var alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }
}
