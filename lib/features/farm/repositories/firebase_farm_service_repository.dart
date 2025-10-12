import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/enums.dart';
import '../constants/firestore_paths.dart';
import '../models/farm_service_history_model.dart';
import 'farm_service_repository.dart';

/// Firebase implementation of FarmServiceRepository
///
/// Handles all Firestore operations for FarmServiceHistory entities with proper
/// error handling and data conversion. Service history records are stored as
/// subcollections under farms.
class FirebaseFarmServiceRepository implements FarmServiceRepository {
  final FirebaseFirestore _firestore;

  FirebaseFarmServiceRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get reference to services collection for a specific farm
  CollectionReference<Map<String, dynamic>> _servicesCollection(
          String farmId) =>
      _firestore.collection(FirestorePaths.servicesCollectionPath(farmId));

  @override
  Future<FarmServiceHistory> create(
      String farmId, FarmServiceHistory service) async {
    try {
      // Validate service before creating
      final validationError = service.validate();
      if (validationError != null) {
        throw Exception('Validation failed: $validationError');
      }

      // Ensure farmId matches
      if (service.farmId != farmId) {
        throw Exception('Service farmId does not match the provided farmId');
      }

      await _servicesCollection(farmId).doc(service.id).set(service.toJson());
      return service;
    } on FirebaseException catch (e) {
      throw Exception('Failed to create service: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create service: $e');
    }
  }

  @override
  Future<FarmServiceHistory> getById(String farmId, String serviceId) async {
    try {
      final doc = await _servicesCollection(farmId).doc(serviceId).get();

      if (!doc.exists || doc.data() == null) {
        throw Exception(
            'Service not found with id: $serviceId in farm: $farmId');
      }

      return FarmServiceHistory.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception('Failed to get service: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get service: $e');
    }
  }

  @override
  Future<List<FarmServiceHistory>> getByFarmId(String farmId) async {
    try {
      final snapshot = await _servicesCollection(farmId)
          .orderBy(FirestoreFields.date, descending: true)
          .get();

      return snapshot.docs
          .map((doc) => FarmServiceHistory.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get services by farm: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get services by farm: $e');
    }
  }

  @override
  Future<List<FarmServiceHistory>> getByType(
    String farmId,
    ServiceType serviceType,
  ) async {
    try {
      final snapshot = await _servicesCollection(farmId)
          .where(FirestoreFields.serviceType, isEqualTo: serviceType.toJson())
          .orderBy(FirestoreFields.date, descending: true)
          .get();

      return snapshot.docs
          .map((doc) => FarmServiceHistory.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get services by type: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get services by type: $e');
    }
  }

  @override
  Future<List<FarmServiceHistory>> getByDateRange(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _servicesCollection(farmId)
          .where(FirestoreFields.date,
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where(FirestoreFields.date,
              isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy(FirestoreFields.date, descending: true)
          .get();

      return snapshot.docs
          .map((doc) => FarmServiceHistory.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get services by date range: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get services by date range: $e');
    }
  }

  @override
  Future<List<FarmServiceHistory>> getRecent(String farmId,
      {int days = 30}) async {
    try {
      final startDate = DateTime.now().subtract(Duration(days: days));
      final snapshot = await _servicesCollection(farmId)
          .where(FirestoreFields.date,
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .orderBy(FirestoreFields.date, descending: true)
          .get();

      return snapshot.docs
          .map((doc) => FarmServiceHistory.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get recent services: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get recent services: $e');
    }
  }

  @override
  Future<List<FarmServiceHistory>> getMedicalServices(String farmId) async {
    try {
      // Get all services and filter for medical types
      // Note: Firestore doesn't support 'in' queries with 'where' across multiple values efficiently
      // We'll fetch all and filter in memory
      final snapshot = await _servicesCollection(farmId)
          .orderBy(FirestoreFields.date, descending: true)
          .get();

      return snapshot.docs
          .map((doc) => FarmServiceHistory.fromJson(doc.data()))
          .where((service) => service.isMedical)
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get medical services: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get medical services: $e');
    }
  }

  @override
  Future<List<FarmServiceHistory>> getByCreator(
    String farmId,
    String userId,
  ) async {
    try {
      final snapshot = await _servicesCollection(farmId)
          .where(FirestoreFields.createdBy, isEqualTo: userId)
          .orderBy(FirestoreFields.date, descending: true)
          .get();

      return snapshot.docs
          .map((doc) => FarmServiceHistory.fromJson(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to get services by creator: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get services by creator: $e');
    }
  }

  @override
  Future<double> getTotalCost(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final services = await getByDateRange(farmId, startDate, endDate);
      return services.fold<double>(0.0, (total, service) => total + service.value);
    } catch (e) {
      throw Exception('Failed to get total cost: $e');
    }
  }

  @override
  Future<double> getTotalCostByType(
    String farmId,
    ServiceType serviceType,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final services = await getByDateRange(farmId, startDate, endDate);
      return services
          .where((service) => service.serviceType == serviceType)
          .fold<double>(0.0, (total, service) => total + service.value);
    } catch (e) {
      throw Exception('Failed to get total cost by type: $e');
    }
  }

  @override
  Future<FarmServiceHistory> update(
      String farmId, FarmServiceHistory service) async {
    try {
      // Validate service before updating
      final validationError = service.validate();
      if (validationError != null) {
        throw Exception('Validation failed: $validationError');
      }

      // Ensure farmId matches
      if (service.farmId != farmId) {
        throw Exception('Service farmId does not match the provided farmId');
      }

      // Check if service exists
      final exists = await this.exists(farmId, service.id);
      if (!exists) {
        throw Exception(
            'Service not found with id: ${service.id} in farm: $farmId');
      }

      await _servicesCollection(farmId)
          .doc(service.id)
          .update(service.toJson());
      return service;
    } on FirebaseException catch (e) {
      throw Exception('Failed to update service: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update service: $e');
    }
  }

  @override
  Future<void> delete(String farmId, String serviceId) async {
    try {
      // Check if service exists
      final exists = await this.exists(farmId, serviceId);
      if (!exists) {
        throw Exception(
            'Service not found with id: $serviceId in farm: $farmId');
      }

      await _servicesCollection(farmId).doc(serviceId).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete service: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete service: $e');
    }
  }

  @override
  Future<List<FarmServiceHistory>> search(String farmId, String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      // Note: Firestore doesn't support full-text search natively
      // This fetches all services and filters in memory
      // For production, consider using Algolia or similar search service
      final snapshot = await _servicesCollection(farmId)
          .orderBy(FirestoreFields.date, descending: true)
          .get();

      final services = snapshot.docs
          .map((doc) => FarmServiceHistory.fromJson(doc.data()))
          .where((service) =>
              service.description.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return services;
    } on FirebaseException catch (e) {
      throw Exception('Failed to search services: ${e.message}');
    } catch (e) {
      throw Exception('Failed to search services: $e');
    }
  }

  @override
  Stream<FarmServiceHistory> watchById(String farmId, String serviceId) {
    try {
      return _servicesCollection(farmId)
          .doc(serviceId)
          .snapshots()
          .map((snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          throw Exception(
              'Service not found with id: $serviceId in farm: $farmId');
        }
        return FarmServiceHistory.fromJson(snapshot.data()!);
      });
    } catch (e) {
      throw Exception('Failed to watch service: $e');
    }
  }

  @override
  Stream<List<FarmServiceHistory>> watchByFarmId(String farmId) {
    try {
      return _servicesCollection(farmId)
          .orderBy(FirestoreFields.date, descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => FarmServiceHistory.fromJson(doc.data()))
              .toList());
    } catch (e) {
      throw Exception('Failed to watch services by farm: $e');
    }
  }

  @override
  Stream<List<FarmServiceHistory>> watchByType(
    String farmId,
    ServiceType serviceType,
  ) {
    try {
      return _servicesCollection(farmId)
          .where(FirestoreFields.serviceType, isEqualTo: serviceType.toJson())
          .orderBy(FirestoreFields.date, descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => FarmServiceHistory.fromJson(doc.data()))
              .toList());
    } catch (e) {
      throw Exception('Failed to watch services by type: $e');
    }
  }

  @override
  Stream<List<FarmServiceHistory>> watchRecent(String farmId,
      {int days = 30}) {
    try {
      final startDate = DateTime.now().subtract(Duration(days: days));
      return _servicesCollection(farmId)
          .where(FirestoreFields.date,
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .orderBy(FirestoreFields.date, descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => FarmServiceHistory.fromJson(doc.data()))
              .toList());
    } catch (e) {
      throw Exception('Failed to watch recent services: $e');
    }
  }

  @override
  Future<bool> exists(String farmId, String serviceId) async {
    try {
      final doc = await _servicesCollection(farmId).doc(serviceId).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      throw Exception('Failed to check service existence: ${e.message}');
    } catch (e) {
      throw Exception('Failed to check service existence: $e');
    }
  }

  @override
  Future<int> count(String farmId) async {
    try {
      final snapshot = await _servicesCollection(farmId).get();
      return snapshot.docs.length;
    } on FirebaseException catch (e) {
      throw Exception('Failed to count services: ${e.message}');
    } catch (e) {
      throw Exception('Failed to count services: $e');
    }
  }

  @override
  Future<int> countByType(String farmId, ServiceType serviceType) async {
    try {
      final snapshot = await _servicesCollection(farmId)
          .where(FirestoreFields.serviceType, isEqualTo: serviceType.toJson())
          .get();
      return snapshot.docs.length;
    } on FirebaseException catch (e) {
      throw Exception('Failed to count services by type: ${e.message}');
    } catch (e) {
      throw Exception('Failed to count services by type: $e');
    }
  }

  @override
  Future<DateTime?> getLastServiceDate(
    String farmId,
    ServiceType serviceType,
  ) async {
    try {
      final snapshot = await _servicesCollection(farmId)
          .where(FirestoreFields.serviceType, isEqualTo: serviceType.toJson())
          .orderBy(FirestoreFields.date, descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final service = FarmServiceHistory.fromJson(snapshot.docs.first.data());
      return service.date;
    } on FirebaseException catch (e) {
      throw Exception('Failed to get last service date: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get last service date: $e');
    }
  }
}
