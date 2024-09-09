import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/provider/data_provider.dart';
import 'package:webapp/widget/attribute_container.dart';
import 'package:webapp/widget/entity_container.dart';
import 'package:webapp/widget/library_comment_container.dart';
import 'package:webapp/widget/library_container.dart';
import 'package:webapp/widget/system_comment_container.dart';
import 'package:webapp/widget/system_container.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
            ),
            child: const Center(
              child: Text(
                'Start Ontology',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Consumer<DataProvider>(
            builder: (context, myType, child) {
              return Row(
                children: <Widget>[
                  if (myType.selectedLibraryId != -1)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          " ${getLibraryName(myType)} Library selected",
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold
                              //fontSize: 20.0,
                              ),
                        ),
                        IconButton(
                            onPressed: () {
                              myType.setLibraryId(-1);
                              myType.setSystemId(-1);
                              myType.setEntityId(-1);
                              myType.setSuperEntityId(-1);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  if (myType.selectedSystemId != -1)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${getSystemName(myType)} System selected",
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold
                              //fontSize: 20.0,
                              ),
                        ),
                        IconButton(
                            onPressed: () {
                              myType.setSystemId(-1);
                              myType.setEntityId(-1);
                              myType.setSuperEntityId(-1);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  if (myType.selectedEntityId != -1)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Entity selected",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold
                              //fontSize: 20.0,
                              ),
                        ),
                        IconButton(
                            onPressed: () {
                              myType.setEntityId(-1);
                              myType.setSuperEntityId(-1);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            )),
                      ],
                    ),

                  if (myType.selectedSuperEntityId != -1)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Super Entity selected",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          //fontSize: 20.0,),
                        ),
                        IconButton(
                            onPressed: () {
                              myType.setSuperEntityId(-1);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  if (myType.selectedLibraryId == -1 && myType.libraryData.isNotEmpty)
                    const Text(
                      "Select a Library to proceed",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold
                          //fontSize: 20.0,
                          ),
                    ),
                  if (myType.selectedSystemId == -1 && myType.systemData.isNotEmpty)
                    const Text(
                      "Select a System to proceed",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold
                          //fontSize: 20.0,
                          ),
                    ),
                  //  if (myType.selectedLibraryId != -1) const Text("Deselect library to add a new one",style: TextStyle(
                  // color: Colors.red,
                  // fontWeight: FontWeight.bold
                  //fontSize: 20.0,
                  //),),
                  // if (myType.selectedSystemId != -1) const Text("Deselect system to add a new one",style: TextStyle(
                  // color: Colors.red,
                  // fontWeight: FontWeight.bold
                  //fontSize: 20.0,
                  // ),),
                ],
              );
            },
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: <Widget>[
                  LibraryContainer(),
                  LibraryCommentContainer(),
                ],
              ),
              Column(
                children: <Widget>[
                  SystemContainer(),
                  SystemCommentContainer(),
                ],
              ),
              Column(
                children: <Widget>[
                  EntityContainer(),
                ],
              ),
              AttributeContainerV2(),
            ],
          ),
        ],
      ),
    );
  }

  getLibraryName(DataProvider myType) {
    return myType.libraryData.where((element) => element.id == myType.selectedLibraryId).first.libraryName;
  }

  getSystemName(DataProvider myType) {
    return myType.systemData.where((element) => element.id == myType.selectedSystemId).first.systemName;
  }
}
