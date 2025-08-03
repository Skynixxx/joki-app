import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Orders Collection
  CollectionReference get ordersCollection => _firestore.collection('orders');

  // Users Collection
  CollectionReference get usersCollection => _firestore.collection('users');

  // Create new task order
  Future<String?> createTaskOrder(TaskModel task) async {
    try {
      DocumentReference docRef = await ordersCollection.add(task.toMap());
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  // Get user orders
  Stream<List<TaskModel>> getUserOrders(String userId) {
    return ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList(),
        );
  }

  // Get all orders (for admin)
  Stream<List<TaskModel>> getAllOrders() {
    return ordersCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList(),
        );
  }

  // Update task status
  Future<bool> updateTaskStatus(String taskId, String status) async {
    try {
      await ordersCollection.doc(taskId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete task order
  Future<bool> deleteTaskOrder(String taskId) async {
    try {
      await ordersCollection.doc(taskId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get task by ID
  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      DocumentSnapshot doc = await ordersCollection.doc(taskId).get();
      if (doc.exists) {
        return TaskModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get statistics for dashboard
  Future<Map<String, int>> getOrderStatistics(String userId) async {
    try {
      QuerySnapshot completedQuery =
          await ordersCollection
              .where('userId', isEqualTo: userId)
              .where('status', isEqualTo: 'Selesai')
              .get();

      QuerySnapshot inProgressQuery =
          await ordersCollection
              .where('userId', isEqualTo: userId)
              .where('status', isEqualTo: 'Proses')
              .get();

      QuerySnapshot pendingQuery =
          await ordersCollection
              .where('userId', isEqualTo: userId)
              .where('status', isEqualTo: 'Menunggu')
              .get();

      return {
        'completed': completedQuery.docs.length,
        'inProgress': inProgressQuery.docs.length,
        'pending': pendingQuery.docs.length,
      };
    } catch (e) {
      return {'completed': 0, 'inProgress': 0, 'pending': 0};
    }
  }
}
