# Farm Management System - Feature 004

A comprehensive farm management system for tracking cattle operations, managing lots, recording transactions, and monitoring farm performance.

## Overview

This feature provides complete farm management capabilities including:

- Farm creation and management
- Personnel management with role-based access
- Cattle lot tracking by type, gender, and age
- Transaction recording (buy, sell, move, mortality)
- Weight history tracking
- Goal setting and monitoring
- Service history (veterinary, vaccination, etc.)
- Reports and analytics

## Architecture

This feature follows clean architecture principles with a clear separation of concerns:

```
lib/features/farm/
├── models/           # Data models with business logic
├── repositories/     # Data access layer (interfaces + implementations)
├── services/         # Business logic and utilities
├── constants/        # Enums, paths, and constants
├── screens/          # UI screens (to be implemented in future steps)
├── widgets/          # Reusable UI components (to be implemented)
└── controllers/      # State management (to be implemented)
```

## Data Models

### 1. Farm Model
Represents a livestock farm with capacity management.

**Properties:**
- `id`: Unique identifier
- `name`: Farm name (3-100 characters)
- `description`: Optional description (max 500 characters)
- `capacity`: Maximum cattle capacity
- `createdBy`: User ID of farm creator
- `createdAt`: Creation timestamp
- `updatedAt`: Last update timestamp

**Validation:**
- Name: Required, 3-100 characters
- Capacity: Must be > 0
- Description: Optional, max 500 characters

### 2. Person Model
Represents farm personnel with role-based access.

**Properties:**
- `id`: Unique identifier
- `farmId`: Associated farm ID
- `userId`: Link to authenticated user
- `name`: Person's name
- `description`: Optional description
- `personType`: Role (owner, manager, worker, arrendatario)
- `isAdmin`: Admin privileges flag
- `createdAt`: Creation timestamp

**Person Types:**
- **Owner**: Full control over farm and all operations
- **Manager**: Manage operations, lots, and transactions
- **Worker**: Add transactions and basic lot operations
- **Arrendatario**: Limited access - view and add transactions only

### 3. CattleLot Model
Represents a group of cattle with similar characteristics.

**Properties:**
- `id`: Unique identifier
- `farmId`: Associated farm ID
- `name`: Lot name
- `cattleType`: Age classification (bezerro, novilho, boi3anos, boi4anos, boi5maisAnos)
- `gender`: Male, female, or mixed
- `birthStart`: Birth date range start
- `birthEnd`: Birth date range end
- `qtdAdded`: Total cattle added
- `qtdRemoved`: Total cattle removed
- `startDate`: Lot start date
- `endDate`: Lot end date (null if active)
- `createdAt`: Creation timestamp
- `updatedAt`: Last update timestamp

**Computed Properties:**
- `currentQuantity`: qtdAdded - qtdRemoved
- `isActive`: endDate is null and currentQuantity > 0

### 4. Transaction Model
Records cattle movements and operations.

**Properties:**
- `id`: Unique identifier
- `lotId`: Associated lot ID
- `farmId`: Associated farm ID
- `type`: Transaction type (buy, sell, move, die)
- `quantity`: Number of cattle
- `averageWeight`: Weight per head in kg
- `value`: Transaction value
- `description`: Transaction description
- `date`: Transaction date
- `createdAt`: Creation timestamp
- `createdBy`: User ID who created transaction
- `relatedTransactionId`: For move transactions, links to the paired transaction

**Transaction Types:**
- **Buy**: Purchase cattle and add to lot
- **Sell**: Sell cattle and remove from lot
- **Move**: Transfer cattle between lots (creates two linked transactions)
- **Die**: Record mortality

### 5. WeightHistory Model
Tracks weight measurements over time.

**Properties:**
- `id`: Unique identifier
- `lotId`: Associated lot ID
- `date`: Measurement date
- `averageWeight`: Average weight per head in kg
- `createdAt`: Creation timestamp
- `createdBy`: User ID who recorded weight

### 6. Goal Model
Tracks farm goals and targets.

**Properties:**
- `id`: Unique identifier
- `farmId`: Associated farm ID
- `definitionDate`: When goal was set
- `goalDate`: Target completion date
- `averageWeight`: Target average weight (optional)
- `birthQuantity`: Expected births (optional)
- `status`: Goal status (active, completed, overdue, cancelled)
- `createdAt`: Creation timestamp
- `updatedAt`: Last update timestamp

### 7. FarmServiceHistory Model
Records farm services and maintenance.

**Properties:**
- `id`: Unique identifier
- `farmId`: Associated farm ID
- `serviceType`: Type of service (vaccination, veterinary, feeding, etc.)
- `date`: Service date
- `value`: Service cost
- `description`: Service description
- `createdAt`: Creation timestamp
- `createdBy`: User ID who recorded service

## Repository Pattern

All data access is handled through repository interfaces, allowing for easy testing and future data source changes.

### Repository Interfaces

Each entity has a corresponding repository interface defining CRUD operations:

- `FarmRepository`
- `PersonRepository`
- `CattleLotRepository`
- `TransactionRepository`
- `WeightHistoryRepository`
- `GoalRepository`
- `FarmServiceRepository`

### Firebase Implementations

Firebase implementations handle Firestore operations with proper error handling:

- `FirebaseFarmRepository`
- `FirebasePersonRepository`
- `FirebaseCattleLotRepository`
- `FirebaseTransactionRepository`
- `FirebaseWeightHistoryRepository`
- `FirebaseGoalRepository`
- `FirebaseFarmServiceRepository`

## Services

### BaseRepository
Abstract class providing common functionality:
- Firestore error handling
- Timestamp conversion utilities
- Common validation patterns
- Type-safe field extraction

### FirestoreService
Helper service for Firestore operations:
- Connection status checking
- Batch write operations
- Transaction helpers
- Collection group queries
- Pagination support

### ValidationService
Centralized validation logic:
- Field validation (strings, numbers, dates)
- Business rule validation
- Error message generation
- Complex validation patterns

## Firestore Structure

```
/farms/{farmId}
  ├── /people/{personId}
  ├── /cattle_lots/{lotId}
  │   ├── /transactions/{transactionId}
  │   └── /weight_history/{weightId}
  ├── /goals/{goalId}
  └── /services/{serviceId}
```

### Collection Details

**farms** (Root Collection)
- Stores farm information
- Indexed by: created_by, created_at

**people** (Subcollection)
- Stores farm personnel
- Indexed by: farm_id, person_type, user_id

**cattle_lots** (Subcollection)
- Stores cattle lot information
- Indexed by: farm_id, cattle_type, gender, end_date

**transactions** (Sub-subcollection)
- Stores cattle transactions
- Indexed by: lot_id, farm_id, type, date, created_by

**weight_history** (Sub-subcollection)
- Stores weight measurements
- Indexed by: lot_id, date

**goals** (Subcollection)
- Stores farm goals
- Indexed by: farm_id, status, goal_date

**services** (Subcollection)
- Stores service history
- Indexed by: farm_id, service_type, date

## Usage Examples

### Creating a Farm

```dart
import 'package:farms/core/di/injection.dart';
import 'package:farms/features/farm/repositories/repositories.dart';
import 'package:farms/features/farm/models/models.dart';

final farmRepo = getIt<FarmRepository>();

final farm = Farm(
  id: 'farm_123',
  name: 'My Farm',
  description: 'A productive cattle farm',
  capacity: 1000,
  createdBy: 'user_123',
  createdAt: DateTime.now(),
);

await farmRepo.create(farm);
```

### Creating a Cattle Lot

```dart
final lotRepo = getIt<CattleLotRepository>();

final lot = CattleLot(
  id: 'lot_123',
  farmId: 'farm_123',
  name: 'Lot A',
  cattleType: CattleType.novilho,
  gender: CattleGender.male,
  birthStart: DateTime(2023, 1, 1),
  birthEnd: DateTime(2023, 12, 31),
  qtdAdded: 100,
  qtdRemoved: 0,
  startDate: DateTime.now(),
  createdAt: DateTime.now(),
);

await lotRepo.create(lot);
```

### Recording a Transaction

```dart
final transactionRepo = getIt<TransactionRepository>();

final transaction = TransactionModel(
  id: 'tx_123',
  lotId: 'lot_123',
  farmId: 'farm_123',
  type: TransactionType.buy,
  quantity: 50,
  averageWeight: 300.0,
  value: 75000.0,
  description: 'Purchased 50 head',
  date: DateTime.now(),
  createdAt: DateTime.now(),
  createdBy: 'user_123',
);

await transactionRepo.create(transaction);
```

### Querying Data

```dart
// Get all farms for a user
final farms = await farmRepo.getByUserId('user_123');

// Get active lots for a farm
final activeLots = await lotRepo.getActiveLotsByFarmId('farm_123');

// Get transactions for a date range
final transactions = await transactionRepo.getByDateRange(
  'farm_123',
  startDate,
  endDate,
);

// Stream real-time updates
farmRepo.watchByUserId('user_123').listen((farms) {
  // Handle farm updates
});
```

## Dependency Injection

All repositories are registered in `lib/core/di/injection.dart`:

```dart
import 'package:farms/core/di/injection.dart';

// In main.dart
void main() {
  setupDependencies();
  runApp(MyApp());
}

// Access repositories anywhere
final farmRepo = getIt<FarmRepository>();
```

## Validation

Use `ValidationService` for consistent validation:

```dart
import 'package:farms/features/farm/services/validation_service.dart';

// Validate farm name
final nameError = ValidationService.validateFarmName(name);
if (nameError != null) {
  print('Error: $nameError');
}

// Validate capacity
final capacityError = ValidationService.validateCapacity(capacity);

// Validate date range
final dateError = ValidationService.validateDateRange(
  startDate,
  endDate,
  'Start Date',
  'End Date',
);

// Combine validations
final error = ValidationService.combineValidations([
  ValidationService.validateFarmName(name),
  ValidationService.validateCapacity(capacity),
]);
```

## Error Handling

All repository operations use proper error handling:

```dart
try {
  final farm = await farmRepo.getById('farm_123');
} catch (e) {
  // Error is already formatted as user-friendly message
  print('Error loading farm: $e');
}
```

Common error messages:
- Permission denied
- Resource not found
- Network unavailable
- Invalid data
- etc.

## Constants and Enums

Import from the barrel file:

```dart
import 'package:farms/features/farm/constants/constants.dart';

// Use enums
final type = PersonType.owner;
final cattleType = CattleType.novilho;
final gender = CattleGender.male;
final txType = TransactionType.buy;
final status = GoalStatus.active;

// Use Firestore paths
final farmPath = FirestorePaths.farmDocument(farmId);
final lotPath = FirestorePaths.cattleLotDocument(farmId, lotId);

// Use field names
final field = FirestoreFields.createdAt;
```

## Testing

Each model and repository should have comprehensive unit tests:

```dart
// test/features/farm/models/farm_model_test.dart
void main() {
  group('Farm Model', () {
    test('fromJson creates valid Farm', () {
      // Test fromJson
    });

    test('toJson creates valid map', () {
      // Test toJson
    });

    test('validation works correctly', () {
      // Test validation
    });
  });
}
```

## Next Steps

After completing Step 1 (Foundation & Architecture), the next steps are:

1. **Step 2**: Farm CRUD & Dashboard
2. **Step 3**: People Management
3. **Step 4**: Cattle Lots Management
4. **Step 5**: Transaction Recording
5. **Step 6**: Weight Tracking
6. **Step 7**: Goals Management
7. **Step 8**: Services Management
8. **Step 9**: Reports & Analytics
9. **Step 10**: Security & Permissions

## Contributing

When contributing to this feature:

1. Follow the established architecture patterns
2. Add comprehensive tests for new code
3. Update this README when adding new functionality
4. Use the ValidationService for all input validation
5. Handle errors properly using BaseRepository methods
6. Follow Flutter/Dart best practices
7. Document complex business logic

## License

This is part of the Farms application. See the main LICENSE file for details.

## Support

For questions or issues related to the farm management feature, refer to:
- Main documentation: `docs/features/004-farm/`
- Step-by-step guide: `docs/features/004-farm/004-steps-summary.md`
- Architecture decisions: `docs/features/004-farm/004-farm.md`
