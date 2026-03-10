import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Utils/AppDrawer.dart';


class GuardsScreen extends StatefulWidget{
  @override
  State<GuardsScreen> createState() => GuardsCrud();


}
class GuardsCrud extends State<GuardsScreen>{
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final _formKey = GlobalKey<FormState>();

    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    String? editingUid;

    // ================= CREATE GUARD =================
    Future<void> createGuard() async {
    try {
    UserCredential userCredential =
    await _auth.createUserWithEmailAndPassword(
    email: emailController.text.trim(),
    password: passwordController.text.trim(),
    );

    String uid = userCredential.user!.uid;

    await _firestore.collection('Users').doc(uid).set({
    "userId": uid,
    "name": nameController.text.trim(),
    "email": emailController.text.trim(),
    "role": "Security",
    });
    } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
    }

    // ================= UPDATE GUARD =================
    Future<void> updateGuard() async {
    await _firestore.collection('Users').doc(editingUid).update({
    "name": nameController.text.trim(),
    "email": emailController.text.trim(),
    });
    }

    // ================= DELETE GUARD =================
    Future<void> deleteGuard(String uid) async {
    await _firestore.collection('Users').doc(uid).delete();

    // Optional: Delete Auth user (only works if current user == that uid)
    // Otherwise must be done via Firebase Admin SDK (backend)
    }

    // ================= SAVE =================
    void saveGuard() async {
    if (_formKey.currentState!.validate()) {
    if (editingUid == null) {
    await createGuard();
    } else {
    await updateGuard();
    }

    clearForm();
    Navigator.pop(context);
    }
    }

    void clearForm() {
    editingUid = null;
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    }

    // ================= DIALOG =================
    void showGuardDialog({
    String? uid,
    String? name,
    String? email,
    }) {
    if (uid != null) {
    editingUid = uid;
    nameController.text = name!;
    emailController.text = email!;
    }

    showDialog(
    context: context,
    builder: (_) => AlertDialog(
    title: Text(editingUid == null ? "Add Guard" : "Edit Guard"),
    content: Form(
    key: _formKey,
    child: SingleChildScrollView(
    child: Column(
    children: [
    TextFormField(
    controller: nameController,
    decoration: InputDecoration(labelText: "Name"),
    validator: (value) =>
    value!.isEmpty ? "Enter name" : null,
    ),
    TextFormField(
    controller: emailController,
    decoration: InputDecoration(labelText: "Email"),
    validator: (value) =>
    value!.isEmpty ? "Enter email" : null,
    ),
    if (editingUid == null)
    TextFormField(
    controller: passwordController,
    decoration: InputDecoration(labelText: "Password"),
    obscureText: true,
    validator: (value) =>
    value!.length < 6 ? "Minimum 6 characters" : null,
    ),
    ],
    ),
    ),
    ),
    actions: [
    TextButton(
    onPressed: () {
    clearForm();
    Navigator.pop(context);
    },
    child: Text("Cancel"),
    ),
    ElevatedButton(
    onPressed: saveGuard,
    child: Text(editingUid == null ? "Create" : "Update"),
    ),
    ],
    ),
    );
    }

    // ================= UI =================
    @override
    Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text("Manage Security Guards")),

    body: StreamBuilder<QuerySnapshot>(
    stream: _firestore
        .collection('Users')
        .where("role", isEqualTo: "Security")
        .snapshots(),
    builder: (context, snapshot) {
    if (!snapshot.hasData) {
    return Center(child: CircularProgressIndicator());
    }

    var guards = snapshot.data!.docs;

    if (guards.isEmpty) {
    return Center(child: Text("No Guards Found"));
    }

    return ListView.builder(
    itemCount: guards.length,
    itemBuilder: (context, index) {
    var guard = guards[index];

    return Card(
    margin: EdgeInsets.all(10),
    child: ListTile(
    title: Text(guard["name"]),
    subtitle: Text(guard["email"]),
    trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
    IconButton(
    icon: Icon(Icons.edit, color: Colors.blue),
    onPressed: () => showGuardDialog(
    uid: guard.id,
    name: guard["name"],
    email: guard["email"],
    ),
    ),
    IconButton(
    icon: Icon(Icons.delete, color: Colors.red),
    onPressed: () => deleteGuard(guard.id),
    ),
    ],
    ),
    ),
    );
    },
    );
    },
    ),
    floatingActionButton: FloatingActionButton(
    onPressed: () => showGuardDialog(),
    child: Icon(Icons.add),
    ),
    );
    }
    }

