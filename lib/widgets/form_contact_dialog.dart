import 'package:contacts/models/contact_model.dart';
import 'package:contacts/services/contact_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormContactDialog extends StatefulWidget {
  String? docId;
  Contact? contact;
  FormContactDialog({super.key, this.contact, this.docId});

  @override
  State<FormContactDialog> createState() => _FormContactDialogState();
}

class _FormContactDialogState extends State<FormContactDialog> {
  final fullnameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final User user = FirebaseAuth.instance.currentUser!;
  final ContactService contactService = ContactService();
  String error = "";
  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      fullnameController.text = widget.contact!.fullname;
      phoneNumberController.text = widget.contact!.phoneNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.40,
          width: MediaQuery.sizeOf(context).width * 0.80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: _buildUI(context),
        ),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Fullname",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7.0),
              TextField(
                controller: fullnameController,
                decoration: const InputDecoration(
                  labelText: "Fullname",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Phone Number",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7.0),
              TextField(
                controller: phoneNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          Text(error,
              style: const TextStyle(color: Colors.red, fontSize: 13.0)),
          _submitContactButton(),
        ],
      ),
    );
  }

  Widget _submitContactButton() {
    return MaterialButton(
      onPressed: () {
        if (fullnameController.text.isEmpty) {
          setState(() {
            error = "Fullname cannot be empty";
          });
          return;
        }
        if (phoneNumberController.text.isEmpty) {
          setState(() {
            error = "Phone number cannot be empty";
          });
          return;
        }
        if (!phoneNumberController.text.startsWith("08")) {
          setState(() {
            error = "Phone number must be start with '08'";
          });
          return;
        }
        if (phoneNumberController.text.length < 9 ||
            phoneNumberController.text.length > 14) {
          setState(() {
            error = "Phone number length must be between 9 to 14";
          });
          return;
        }
        Contact contact = Contact(
          fullname: fullnameController.text,
          phoneNumber: phoneNumberController.text,
          uid: user.uid,
        );
        if (widget.contact == null) {
          contactService.addContact(contact);
        } else {
          contactService.updateContact(widget.docId!, contact);
        }
        Get.back(
          closeOverlays: true,
        );
      },
      color: Theme.of(context).colorScheme.primary,
      child: const Text(
        "Add Contact",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
