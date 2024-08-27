import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/provider/data_provider.dart';

class LibraryCommentContainer extends StatelessWidget {
  const LibraryCommentContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, myType, child) {
        return ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 300,
          ),
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
            ),
            child: Column(
              children: <Widget>[
                const Text(
                  "Comment",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (myType.selectedLibraryId != -1)
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      controller: myType.libraryCommentController
                        ..text = getCommentFromLibrary(myType),
                      decoration: const InputDecoration.collapsed(
                          hintText: "Enter comment"),
                      maxLines: 8,
                      onChanged: (value) {
                        myType.libraryData
                            .firstWhere((element) =>
                                element.id == myType.selectedLibraryId)
                            .comment = value;
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String getCommentFromLibrary(DataProvider myType) {
    return myType.libraryData
        .firstWhere((element) => element.id == myType.selectedLibraryId)
        .comment;
  }
}
