import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dentist_timer.dart';

class ListDentist extends StatefulWidget {
  const ListDentist({Key? key}) : super(key: key);

  @override
  State<ListDentist> createState() => _ListDentistState();
}

class _ListDentistState extends State<ListDentist> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                        child: Text('Aceitar'),
                        onPressed: (/*Adicionar aqui a lógica ao aceitar o dentista */) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TimerScreen()));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          elevation: 15
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

