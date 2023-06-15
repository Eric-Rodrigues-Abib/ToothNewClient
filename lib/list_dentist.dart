import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dentist_timer.dart';

class ListDentist extends StatefulWidget {
  final String? emergenciaId;
  const ListDentist({required this.emergenciaId});

  @override
  State<ListDentist> createState() => _ListDentistState();
}

class _ListDentistState extends State<ListDentist> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('ResultadoEmergencias')
              .where("status", isEqualTo: "true")
              .where("emergenciaID", isEqualTo: widget.emergenciaId)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((documents) {
                return ListTile(
                  leading: Icon(Icons.person),
                  title : Text(documents['nome']),
                  subtitle: Row(
                    children:
                    [Text(documents['telefone']),
                      Spacer(),
                      ElevatedButton(
                        child: Text('Aceitar',
                          style: TextStyle(
                            fontFamily: 'InterFonte',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: (/*Adicionar aqui a lógica ao aceitar o dentista */) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TimerScreenDentist(emergenciaId: widget.emergenciaId)));
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.purple,
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                )
                            )
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

