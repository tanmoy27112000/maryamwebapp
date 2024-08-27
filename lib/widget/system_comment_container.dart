import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webapp/provider/data_provider.dart';

class SystemCommentContainer extends StatelessWidget {
  const SystemCommentContainer({
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
                if (myType.selectedSystemId != -1)
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
                      controller: myType.systemCommentController
                        ..text = getCommentFromSystem(myType),
                      decoration: const InputDecoration.collapsed(
                          hintText: "Enter comment"),
                      maxLines: 8,
                      onChanged: (value) {
                        myType.systemData
                            .firstWhere((element) =>
                                element.id == myType.selectedSystemId)
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

  String getCommentFromSystem(DataProvider myType) {
    if (myType.selectedSystemId != -1) {
      return myType.systemData
          .firstWhere((element) => element.id == myType.selectedSystemId)
          .comment;
    }
    return '';
  }
}
