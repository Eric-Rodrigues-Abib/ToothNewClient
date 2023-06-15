import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toothnow_pacient/list_dentist.dart';
import 'package:permission_handler/permission_handler.dart';

import 'maps.dart';
import 'rating.dart';

class TelaConsultaAndamento extends StatefulWidget {
  final String? emergenciaId;
  const TelaConsultaAndamento({required this.emergenciaId});

  @override
  State<TelaConsultaAndamento> createState() => _TelaConsultaAndamentoState();
}

class _TelaConsultaAndamentoState extends State<TelaConsultaAndamento> {

  /*

  TAVA TENTANDO FAZER ESSA LÓGICA MAS EU NÃO CONSEGUI POR NADA
  var nome;
  var numero;


  Future<void> fetchDataFromFirebase() async {
    Query<Map<String, dynamic>> collectionRef = FirebaseFirestore.instance.collection('ResultadoEmergencias')
    .where("emergenciaID", isEqualTo: widget.emergenciaId);
    QuerySnapshot querySnapshot = await collectionRef.get();

    if (querySnapshot.docs.isNotEmpty) {
      // Itera sobre os documentos retornados
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        // Acessa os dados do documento
        Object? data = documentSnapshot.data();
        nome = data['nome'];
        numero = data['numero'];
      }
    } else {
      // Caso não haja documentos na coleção
      print('Não há documentos na coleção.');
    }
    //peguei esse código do chatGPT
  }

*/

  @override
  Widget build(BuildContext context) {


    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('ResultadoEmergencias')
              .where("emergenciaID", isEqualTo: widget.emergenciaId)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              children: snapshot.data!.docs.map((documents)
                return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person,
                    size: 30),
                    text


                  ],
                ),

              )
            ),
          },
        ),
      ),
    );
  }
}
