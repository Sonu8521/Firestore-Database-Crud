import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'DisplayDataList.dart';

class Adddata extends StatefulWidget {
  const Adddata({Key? key}) : super(key: key);

  @override
  State<Adddata> createState() => _AdddataState();
}

class _AdddataState extends State<Adddata> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  void addData(String title, String desc) async {
    if (title.isEmpty || desc.isEmpty) {
      print("Enter Required Fields");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection("Users").doc(title).set({
        "Title": title,
        "Description": desc,
      });
      print("Data Inserted");
      _showSuccessDialog("Data Inserted Successfully");

      // Navigate to DisplayDataList screen after adding data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayDataList(),
        ),
      );

      clearTextFields();
    } catch (e) {
      print("Failed to add data: $e");
      _showErrorDialog("Failed to add data: $e");
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

  void clearTextFields() {
    titleController.clear();
    descController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Data",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue, // Set app bar background color
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
                fillColor: Colors.grey[200], // Set text field background color
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
                fillColor: Colors.grey[200], // Set text field background color
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addData(
                  titleController.text.trim(),
                  descController.text.trim(),
                );
              },
              child: Text("Add Data"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // Set text color
              ),
            ),
            const SizedBox(height: 20,),

            ElevatedButton(
              onPressed: () {
                addData(
                  titleController.text.trim(),
                  descController.text.trim(),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayDataList(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // Set text color
              ),

              child: const Text("Show all Data"),
            ),
          ],
        ),
      ),
    );
  }
}
