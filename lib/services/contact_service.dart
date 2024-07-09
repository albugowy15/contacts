import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/models/contact_model.dart';

const String contactsCollectionRef = "contacts";

class ContactService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _contactsRef;

  ContactService() {
    _contactsRef = _firestore.collection(contactsCollectionRef);
  }

  void addContact(Contact contact) async {
    contact.timestamp = Timestamp.now();
    await _contactsRef.add(contact.toJson());
  }

  Stream<QuerySnapshot> getContacts(String uid) {
    return _contactsRef
        .where("uid", isEqualTo: uid)
        .orderBy('fullname')
        .snapshots();
  }

  Future<void> updateContact(String docId, Contact contact) {
    return _contactsRef.doc(docId).update({
      'fullname': contact.fullname,
      'phoneNumber': contact.phoneNumber,
    });
  }

  Future<void> deleteContact(String docId) {
    return _contactsRef.doc(docId).delete();
  }
}
