# Step 1: Foundation & Architecture - Feature 004

## Overview

Establish the foundational architecture, data models, repository pattern, and Firestore configuration for the farm management system.

## Goals

- Define all data models with proper serialization
- Implement repository pattern interfaces
- Configure Firestore collections structure
- Setup dependency injection
- Create base services and utilities

## Implementation Checklist

### Data Models
- [ ] Create Farm model
  - [ ] Add all properties (name, description, capacity)
  - [ ] Implement fromJson/toJson
  - [ ] Add copyWith method
  - [ ] Extend Equatable for comparisons
  - [ ] Add validation methods
- [ ] Create Person model
  - [ ] Add all properties (name, user_id, person_type, is_admin)
  - [ ] Implement fromJson/toJson
  - [ ] Add copyWith method
  - [ ] Extend Equatable
  - [ ] Add person type enum
- [ ] Create CattleLot model
  - [ ] Add all properties (name, cattle_type, gender, dates, quantities)
  - [ ] Implement fromJson/toJson
  - [ ] Add copyWith method
  - [ ] Add computed property: currentQuantity
  - [ ] Add cattle type enum
  - [ ] Add gender enum
  - [ ] Add validation methods
- [ ] Create Transaction model
  - [ ] Add all properties (type, quantity, weight, value)
  - [ ] Implement fromJson/toJson
  - [ ] Add transaction type enum
  - [ ] Add validation methods
- [ ] Create WeightHistory model
  - [ ] Add properties (date, average_weight)
  - [ ] Implement fromJson/toJson
- [ ] Create Goal model
  - [ ] Add all properties (dates, targets)
  - [ ] Implement fromJson/toJson
  - [ ] Add goal status enum
- [ ] Create FarmServiceHistory model
  - [ ] Add all properties (type, date, value, description)
  - [ ] Implement fromJson/toJson
  - [ ] Add service type enum

### Repository Interfaces
- [ ] Create FarmRepository interface
  - [ ] Define CRUD methods
  - [ ] Define query methods (getByUserId, search)
  - [ ] Add stream methods for real-time updates
- [ ] Create PersonRepository interface
  - [ ] Define CRUD methods
  - [ ] Define query methods (getByFarmId, getByUserId)
- [ ] Create CattleLotRepository interface
  - [ ] Define CRUD methods
  - [ ] Define query methods (getByFarmId, getActive, getByType)
- [ ] Create TransactionRepository interface
  - [ ] Define CRUD methods
  - [ ] Define query methods (getByLotId, getByDateRange, getByType)
- [ ] Create WeightHistoryRepository interface
  - [ ] Define CRUD methods
  - [ ] Define query methods (getByLotId, getLatest)
- [ ] Create GoalRepository interface
  - [ ] Define CRUD methods
  - [ ] Define query methods (getByFarmId, getActive)
- [ ] Create FarmServiceRepository interface
  - [ ] Define CRUD methods
  - [ ] Define query methods (getByFarmId, getByType)

### Firebase Repository Implementations
- [ ] Create FirebaseFarmRepository
  - [ ] Implement all interface methods
  - [ ] Add proper error handling
  - [ ] Add Firestore converter
- [ ] Create FirebasePersonRepository
  - [ ] Implement all interface methods
  - [ ] Handle user-to-person linking
- [ ] Create FirebaseCattleLotRepository
  - [ ] Implement all interface methods
  - [ ] Handle subcollection queries
- [ ] Create FirebaseTransactionRepository
  - [ ] Implement all interface methods
  - [ ] Handle nested subcollections
- [ ] Create FirebaseWeightHistoryRepository
  - [ ] Implement all interface methods
- [ ] Create FirebaseGoalRepository
  - [ ] Implement all interface methods
- [ ] Create FirebaseFarmServiceRepository
  - [ ] Implement all interface methods

### Firestore Configuration
- [ ] Design collection structure
- [ ] Create Firestore indexes configuration file
- [ ] Setup composite indexes for queries
- [ ] Document collection paths
- [ ] Create Firestore converters

### Dependency Injection
- [ ] Setup GetIt service locator
- [ ] Register all repositories
- [ ] Register Firebase instances
- [ ] Create injection configuration file
- [ ] Add initialization method

### Base Services
- [ ] Create BaseRepository abstract class
  - [ ] Common error handling
  - [ ] Common converter utilities
  - [ ] Timestamp helpers
- [ ] Create FirestoreService helper
  - [ ] Connection status checking
  - [ ] Batch operation helpers
  - [ ] Transaction helpers
- [ ] Create ValidationService
  - [ ] Common validation rules
  - [ ] Error message generation

### Project Structure Setup
- [ ] Create directory structure
  - [ ] features/farm/models/
  - [ ] features/farm/repositories/
  - [ ] features/farm/services/
  - [ ] features/farm/screens/
  - [ ] features/farm/widgets/
  - [ ] features/farm/controllers/
- [ ] Create barrel files for exports
- [ ] Setup constants file
- [ ] Create enums file

### Documentation
- [ ] Document all models with inline comments
- [ ] Create repository usage examples
- [ ] Document Firestore structure
- [ ] Add README in farm feature folder

### Testing
- [ ] Write unit tests for Farm model
- [ ] Write unit tests for Person model
- [ ] Write unit tests for CattleLot model
- [ ] Write unit tests for Transaction model
- [ ] Write unit tests for WeightHistory model
- [ ] Write unit tests for Goal model
- [ ] Write unit tests for FarmServiceHistory model
- [ ] Create mock repositories for testing
- [ ] Write tests for repository implementations
- [ ] Test fromJson/toJson serialization
- [ ] Test model validation methods
- [ ] Target: 100% coverage for models

## Data Models Details

### Farm Model

```dart
class Farm extends Equatable {
  final String id;
  final String name;
  final String description;
  final int capacity;
  final String createdBy; // userId
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Farm({
    required this.id,
    required this.name,
    required this.description,
    required this.capacity,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  factory Farm.fromJson(Map<String, dynamic> json) { /* ... */ }
  Map<String, dynamic> toJson() { /* ... */ }
  Farm copyWith({ /* ... */ }) { /* ... */ }

  @override
  List<Object?> get props => [id, name, description, capacity, createdBy, createdAt, updatedAt];
}
```

### Person Model

```dart
enum PersonType { owner, manager, worker, arrendatario }

class Person extends Equatable {
  final String id;
  final String farmId;
  final String userId; // Link to User (auth)
  final String name;
  final String? description;
  final PersonType personType;
  final bool isAdmin;
  final DateTime createdAt;

  // Methods: fromJson, toJson, copyWith, validation
}
```

### CattleLot Model

```dart
enum CattleType {
  bezerro,     // até 1 ano
  novilho,     // até 2 anos
  boi3anos,    // até 3 anos
  boi4anos,    // até 4 anos
  boi5maisAnos // 5 anos ou mais
}

enum CattleGender { male, female, mixed }

class CattleLot extends Equatable {
  final String id;
  final String farmId;
  final String name;
  final CattleType cattleType;
  final CattleGender gender;
  final DateTime birthStart;
  final DateTime birthEnd;
  final int qtdAdded;
  final int qtdRemoved;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime? updatedAt;

  int get currentQuantity => qtdAdded - qtdRemoved;
  bool get isActive => endDate == null && currentQuantity > 0;

  // Methods: fromJson, toJson, copyWith, validation
}
```

### Transaction Model

```dart
enum TransactionType { buy, sell, move, die }

class Transaction extends Equatable {
  final String id;
  final String lotId;
  final String farmId;
  final TransactionType type;
  final int quantity;
  final double averageWeight; // kg
  final double value; // currency
  final String description;
  final DateTime date;
  final DateTime createdAt;
  final String createdBy; // userId

  // For Move type: link to related transaction
  final String? relatedTransactionId;

  // Methods: fromJson, toJson, copyWith, validation
}
```

### WeightHistory Model

```dart
class WeightHistory extends Equatable {
  final String id;
  final String lotId;
  final DateTime date;
  final double averageWeight; // kg per head
  final DateTime createdAt;
  final String createdBy; // userId

  // Methods: fromJson, toJson, copyWith
}
```

### Goal Model

```dart
enum GoalStatus { active, completed, overdue, cancelled }

class Goal extends Equatable {
  final String id;
  final String farmId;
  final DateTime definitionDate;
  final DateTime goalDate;
  final double? averageWeight; // target weight
  final int? birthQuantity; // expected births
  final GoalStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Methods: fromJson, toJson, copyWith, validation
}
```

### FarmServiceHistory Model

```dart
enum ServiceType {
  vaccination,
  veterinary,
  feeding,
  medicalTreatment,
  deworming,
  other
}

class FarmServiceHistory extends Equatable {
  final String id;
  final String farmId;
  final ServiceType serviceType;
  final DateTime date;
  final double value; // cost
  final String description;
  final DateTime createdAt;
  final String createdBy; // userId

  // Methods: fromJson, toJson, copyWith
}
```

## Firestore Collections Structure

```
/farms/{farmId}
  - name: string
  - description: string
  - capacity: number
  - created_by: string
  - created_at: timestamp
  - updated_at: timestamp

  /people/{personId}
    - user_id: string
    - name: string
    - description: string
    - person_type: string
    - is_admin: boolean
    - created_at: timestamp

  /cattle_lots/{lotId}
    - name: string
    - cattle_type: string
    - gender: string
    - birth_start: timestamp
    - birth_end: timestamp
    - qtd_added: number
    - qtd_removed: number
    - start_date: timestamp
    - end_date: timestamp
    - created_at: timestamp
    - updated_at: timestamp

    /transactions/{transactionId}
      - type: string
      - quantity: number
      - average_weight: number
      - value: number
      - description: string
      - date: timestamp
      - created_at: timestamp
      - created_by: string
      - related_transaction_id: string (optional)

    /weight_history/{weightId}
      - date: timestamp
      - average_weight: number
      - created_at: timestamp
      - created_by: string

  /goals/{goalId}
    - definition_date: timestamp
    - goal_date: timestamp
    - average_weight: number (optional)
    - birth_quantity: number (optional)
    - status: string
    - created_at: timestamp
    - updated_at: timestamp

  /services/{serviceId}
    - service_type: string
    - date: timestamp
    - value: number
    - description: string
    - created_at: timestamp
    - created_by: string
```

## Firestore Indexes

Create `firestore.indexes.json`:

```json
{
  "indexes": [
    {
      "collectionGroup": "farms",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "created_by", "order": "ASCENDING" },
        { "fieldPath": "created_at", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "cattle_lots",
      "queryScope": "COLLECTION_GROUP",
      "fields": [
        { "fieldPath": "farm_id", "order": "ASCENDING" },
        { "fieldPath": "cattle_type", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "transactions",
      "queryScope": "COLLECTION_GROUP",
      "fields": [
        { "fieldPath": "lot_id", "order": "ASCENDING" },
        { "fieldPath": "date", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "transactions",
      "queryScope": "COLLECTION_GROUP",
      "fields": [
        { "fieldPath": "type", "order": "ASCENDING" },
        { "fieldPath": "date", "order": "DESCENDING" }
      ]
    }
  ]
}
```

## Repository Pattern Example

### Interface

```dart
abstract class FarmRepository {
  Future<Farm> create(Farm farm);
  Future<Farm> getById(String farmId);
  Future<List<Farm>> getByUserId(String userId);
  Future<Farm> update(Farm farm);
  Future<void> delete(String farmId);
  Stream<List<Farm>> watchByUserId(String userId);
  Future<List<Farm>> search(String query);
}
```

### Firebase Implementation

```dart
class FirebaseFarmRepository implements FarmRepository {
  final FirebaseFirestore _firestore;

  FirebaseFarmRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Farm> create(Farm farm) async {
    try {
      await _firestore.collection('farms').doc(farm.id).set(farm.toJson());
      return farm;
    } catch (e) {
      throw Exception('Failed to create farm: $e');
    }
  }

  @override
  Future<Farm> getById(String farmId) async {
    try {
      final doc = await _firestore.collection('farms').doc(farmId).get();
      if (!doc.exists) throw Exception('Farm not found');
      return Farm.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get farm: $e');
    }
  }

  // Implement other methods...
}
```

## Dependency Injection Setup

```dart
// lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final getIt = GetIt.instance;

void setupFarmDependencies() {
  // Firebase
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Repositories
  getIt.registerLazySingleton<FarmRepository>(
    () => FirebaseFarmRepository(firestore: getIt()),
  );

  getIt.registerLazySingleton<PersonRepository>(
    () => FirebasePersonRepository(firestore: getIt()),
  );

  getIt.registerLazySingleton<CattleLotRepository>(
    () => FirebaseCattleLotRepository(firestore: getIt()),
  );

  // Register other repositories...
}
```

## Project Structure

```
lib/
├── features/
│   └── farm/
│       ├── models/
│       │   ├── farm_model.dart
│       │   ├── person_model.dart
│       │   ├── cattle_lot_model.dart
│       │   ├── transaction_model.dart
│       │   ├── weight_history_model.dart
│       │   ├── goal_model.dart
│       │   ├── farm_service_history_model.dart
│       │   └── models.dart (barrel file)
│       ├── repositories/
│       │   ├── farm_repository.dart
│       │   ├── firebase_farm_repository.dart
│       │   ├── person_repository.dart
│       │   ├── firebase_person_repository.dart
│       │   ├── cattle_lot_repository.dart
│       │   ├── firebase_cattle_lot_repository.dart
│       │   ├── transaction_repository.dart
│       │   ├── firebase_transaction_repository.dart
│       │   ├── weight_history_repository.dart
│       │   ├── firebase_weight_history_repository.dart
│       │   ├── goal_repository.dart
│       │   ├── firebase_goal_repository.dart
│       │   ├── farm_service_repository.dart
│       │   ├── firebase_farm_service_repository.dart
│       │   └── repositories.dart (barrel file)
│       ├── services/
│       │   ├── base_repository.dart
│       │   ├── firestore_service.dart
│       │   └── validation_service.dart
│       ├── constants/
│       │   ├── enums.dart
│       │   └── firestore_paths.dart
│       └── README.md
└── core/
    └── di/
        └── injection.dart
```

## Testing Strategy

### Unit Tests Example

```dart
// test/features/farm/models/farm_model_test.dart
void main() {
  group('Farm Model', () {
    test('fromJson creates valid Farm', () {
      final json = {
        'id': 'farm1',
        'name': 'Test Farm',
        'description': 'A test farm',
        'capacity': 1000,
        'created_by': 'user1',
        'created_at': Timestamp.now(),
      };

      final farm = Farm.fromJson(json);

      expect(farm.id, 'farm1');
      expect(farm.name, 'Test Farm');
      expect(farm.capacity, 1000);
    });

    test('toJson creates valid map', () {
      final farm = Farm(/* ... */);
      final json = farm.toJson();

      expect(json['id'], farm.id);
      expect(json['name'], farm.name);
    });

    test('copyWith updates only specified fields', () {
      final farm = Farm(/* ... */);
      final updated = farm.copyWith(name: 'New Name');

      expect(updated.name, 'New Name');
      expect(updated.id, farm.id);
    });
  });
}
```

## Validation Requirements

### Farm Validation
- Name: required, 3-100 characters
- Description: optional, max 500 characters
- Capacity: required, > 0

### Person Validation
- Name: required, 3-100 characters
- Person type: required, must be valid enum value
- User ID: required, must exist in users collection

### CattleLot Validation
- Name: required, 3-100 characters
- Birth end >= Birth start
- Quantities: >= 0
- Current quantity must be consistent

### Transaction Validation
- Quantity: > 0
- Average weight: > 0
- Value: >= 0
- Date: not in future

## Common Utilities

### Timestamp Helpers

```dart
class FirestoreHelpers {
  static Timestamp toTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }

  static DateTime fromTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return DateTime.now();
  }
}
```

### Error Handling

```dart
class RepositoryException implements Exception {
  final String message;
  final String? code;

  RepositoryException(this.message, {this.code});

  @override
  String toString() => 'RepositoryException: $message${code != null ? ' ($code)' : ''}';
}
```

## Completion Criteria

- [ ] All 7 data models created and tested
- [ ] All 7 repository interfaces defined
- [ ] All 7 Firebase repository implementations created
- [ ] Firestore indexes configured
- [ ] Dependency injection setup complete
- [ ] Project structure created
- [ ] All unit tests passing
- [ ] Documentation complete
- [ ] Code reviewed and approved

## Next Step

After completing this foundation step, proceed to:
**[Step 2: Farm CRUD & Dashboard](004-step2-farm-dashboard.md)**

---

**Step:** 1/10
**Estimated Time:** 3-4 days
**Dependencies:** Feature 003 (Authentication)
**Status:** Ready to implement
