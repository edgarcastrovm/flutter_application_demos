import 'package:app_firebase/model/person_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

void enableOfflinePersistence() async {
  db.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
}

Future<bool> addPerson(String name, String surname) async {
  try {
    await db.collection('persona').add({'name': name, 'surname': surname});
    print("Person added successfully");
    return true;
  } catch (e) {
    print("Error adding Person: $e");
    return false;
  }
}

Future<List<PersonWithId>> getPerson() async {
  List<PersonWithId> personList = [];
  try {
    QuerySnapshot querySnapshot = await db.collection('persona').get();
    for (var doc in querySnapshot.docs) {
      print("Person: ${doc.data()} ${doc.id}");
      personList.add(PersonWithId.fromJson(doc.id,doc.data() as Map<String, dynamic>));
    }
  } catch (e) {
    print("Error getting Persons: $e");
  }
  return personList;
}

Future<bool> updatePerson(String id, String name, String surname) async {
  try {
    await db.collection('persona').doc(id).update({
      'name': name,
      'surname': surname,
    });
    print("Person updated successfully");
    return true;
  } catch (e) {
    print("Error updating Person: $e");
    return false;
  }
}

Future<bool> deletePerson(String id) async {
  try {
    await db.collection('persona').doc(id).delete();
    print("Person deleted successfully");
    return true;
  } catch (e) {
    print("Error deleting Person: $e");
    return false;
  }
}
