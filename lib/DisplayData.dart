import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayData extends StatefulWidget {
  final String documentId;

  const DisplayData({super.key, required this.documentId});

  @override
  State<DisplayData> createState() => _DisplayDataState();
}

class _DisplayDataState extends State<DisplayData> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.documentId)
          .get();

      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        titleController.text = data['Title'];
        descController.text = data['Description'];
      }
    } catch (e) {
      print("Failed to fetch data: $e");
    }
  }

  void updateData(String docId, String title, String desc) async {
    if (title.isEmpty || desc.isEmpty) {
      _showErrorDialog("Enter Required Fields");
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Update"),
          content: const Text("Are you sure you want to update this data?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Update"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _performUpdate(docId, title, desc);
              },
            ),
          ],
        );
      },
    );
  }

  void _performUpdate(String docId, String title, String desc) async {
    try {
      await FirebaseFirestore.instance.collection("Users").doc(docId).update({
        "Title": title,
        "Description": desc,
      });
      _showSuccessDialog("Data Updated Successfully");
      print("Data Updated");
    } catch (e) {
      _showErrorDialog("Failed to update data: $e");
      print("Failed to update data: $e");
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Update Data",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              updateData(
                widget.documentId,
                titleController.text.trim(),
                descController.text.trim(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter title",
                suffixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                hintText: "Enter description",
                suffixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
