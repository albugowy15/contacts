import 'package:contacts/models/contact_model.dart';
import 'package:contacts/services/contact_service.dart';
import 'package:contacts/widgets/form_contact_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = FirebaseAuth.instance.currentUser;
  final ContactService contactService = ContactService();

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      // Handle the case where the user is null (optional)
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(context),
      body: _buildUI(context),
      floatingActionButton: _floatButton(context),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: const Text("My Contacts"),
      actions: [
        IconButton(
          onPressed: signUserOut,
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.03,
        ),
        child: StreamBuilder(
            stream: contactService.getContacts(user?.uid ?? ""),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text("Empty"),
                );
              }
              List contacts = snapshot.data?.docs ?? [];
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        contacts[index]["fullname"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      subtitle: Text(contacts[index]["phoneNumber"]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Contact contact = Contact(
                                  fullname: contacts[index]["fullname"],
                                  phoneNumber: contacts[index]["phoneNumber"],
                                  uid: "",
                                );
                                Get.dialog(FormContactDialog(
                                  contact: contact,
                                  docId: contacts[index].id,
                                ));
                              },
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                _showDeleteDialog(context, contacts[index].id);
                              },
                              icon: const Icon(Icons.delete)),
                        ],
                      ),
                      onTap: () {
                        //Get.to(
                        //  () {
                        //    return DetailsPage(
                        //        coin: assetsController
                        //            .getCoinData(trackedAsset.name!)!);
                        //  },
                        //);
                      },
                    ),
                  );
                },
              );
            }),
      ),
    );
  }

  Widget _floatButton(BuildContext context) {
    return FloatingActionButton.extended(
      label: const Text("Add contact"),
      icon: const Icon(Icons.add),
      onPressed: () {
        Get.dialog(FormContactDialog());
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this contact?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Add delete logic here
                await contactService.deleteContact(docId);
                Navigator.of(context).pop(); // Close the dialog after deletion
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
