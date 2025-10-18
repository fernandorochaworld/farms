# Step 2: Farm CRUD & Dashboard - Feature 004

## Overview

Implement farm creation, reading, updating, and deletion operations, along with the main dashboard that displays farm summaries for all farms the user has access to.

## Goals

- Create farm management screens (list, create, edit, details)
- Implement basic dashboard with farm summary cards
- Setup navigation structure
- Automatic Person record creation when farm is created
- Real-time farm data updates

## Implementation Checklist

### Farm Creation
- [x] Create FarmCreateScreen UI
  - [x] Add farm name input field with validation
  - [x] Add description text area
  - [x] Add capacity number input
  - [x] Add form validation
  - [x] Add submit button with loading state
  - [x] Add cancel button
- [x] Implement FarmCreateController/Bloc
  - [x] Handle form submission
  - [x] Validate form data
  - [x] Call repository to create farm
  - [x] Automatically create Person record (Owner, is_admin=true)
  - [x] Handle success/error states
  - [x] Navigate to dashboard on success
- [x] Add internationalization strings
- [ ] Create widget tests for form

### Farm Listing
- [x] Create FarmListScreen UI
  - [x] Display list of farms
  - [x] Add search bar
  - [x] Add filter options (sort by name, date, capacity)
  - [x] Add pull-to-refresh
  - [x] Add floating action button to create farm
  - [x] Show empty state when no farms
  - [x] Add skeleton loading state
- [x] Implement FarmListController/Bloc
  - [x] Fetch farms by user ID
  - [x] Implement search functionality
  - [x] Implement filtering
  - [x] Handle real-time updates
  - [ ] Handle pagination (if needed)
- [x] Create FarmCard widget
  - [x] Display farm name
  - [x] Display farm description (truncated)
  - [x] Display cattle count (placeholder for now)
  - [x] Add tap to view details
  - [x] Add swipe actions (edit, delete)
- [ ] Add widget tests

### Farm Details
- [x] Create FarmDetailsScreen UI
  - [x] Display farm information
  - [x] Display farm statistics (placeholder)
  - [x] Add edit button
  - [x] Add delete button (with confirmation)
  - [x] Show people count
  - [x] Show lots count (placeholder)
  - [x] Add navigation to sections
- [x] Implement FarmDetailsController/Bloc
  - [x] Fetch farm by ID
  - [ ] Handle real-time updates
  - [x] Handle navigation to edit screen
  - [x] Handle delete operation
- [x] Add confirmation dialog for delete
- [ ] Add widget tests

### Farm Editing
- [x] Create FarmEditScreen UI
  - [x] Pre-populate form with farm data
  - [x] Allow editing name, description, capacity
  - [x] Add form validation
  - [x] Add save button with loading state
  - [x] Add cancel button
- [x] Implement FarmEditController/Bloc
  - [x] Load current farm data
  - [x] Handle form submission
  - [x] Validate form data
  - [x] Call repository to update farm
  - [x] Handle success/error states
  - [x] Navigate back on success
- [ ] Add widget tests

### Farm Deletion
- [x] Implement delete confirmation dialog
  - [x] Show warning message
  - [x] List what will be deleted (people, lots, etc.)
  - [x] Add confirm and cancel buttons
- [x] Implement delete logic in controller
  - [x] Delete farm document
  - [ ] Handle subcollections (discuss cascade vs archive)
  - [x] Handle errors
  - [x] Navigate to dashboard on success
- [x] Add proper error messages
- [ ] Add widget tests

### Dashboard
- [x] Create DashboardScreen UI
  - [x] Add app bar with title
  - [x] Add welcome message with user name
  - [x] Add "Create Farm" button prominently
  - [x] Display grid/list of FarmSummaryCard widgets
  - [x] Add pull-to-refresh
  - [x] Add skeleton loading state
  - [x] Handle empty state (no farms)
- [x] Create FarmSummaryCard widget
  - [x] Display farm name
  - [x] Display total cattle count (basic calculation)
  - [x] Display active lots count
  - [x] Display capacity usage percentage
  - [x] Add visual indicators (progress bar, icons)
  - [x] Add tap to navigate to farm details
  - [x] Make responsive for different screen sizes
- [x] Implement DashboardController/Bloc
  - [x] Fetch all farms for user
  - [x] Calculate summary data per farm
  - [ ] Handle real-time updates
  - [x] Handle errors
- [x] Create FarmSummaryService
  - [x] Calculate total cattle count per farm
  - [x] Count active lots per farm
  - [x] Calculate capacity usage
  - [x] Prepare for future enhancements
- [x] Add internationalization strings
- [ ] Add widget tests

### Navigation
- [x] Setup navigation routes
  - [x] Dashboard route (/)
  - [x] Farm list route
  - [x] Farm create route
  - [x] Farm edit route (/farm/:id/edit)
  - [x] Farm details route (/farm/:id)
- [x] Implement navigation guards
  - [x] Check authentication
  - [ ] Verify farm access permissions
- [ ] Add deep linking support (optional)

### Person Auto-Creation
- [x] Implement auto-creation logic
  - [x] When farm is created, create Person record
  - [x] Set person_type = Owner
  - [x] Set is_admin = true
  - [x] Link to current user (user_id)
  - [x] Copy user name to person name
  - [ ] Handle transaction (both operations must succeed)
- [x] Add error handling for failed person creation
- [ ] Add rollback logic if person creation fails
- [ ] Test auto-creation flow

### State Management
- [x] Create FarmState (Bloc/Cubit states)
  - [x] FarmInitial
  - [x] FarmLoading
  - [x] FarmLoaded
  - [x] FarmError
  - [x] FarmOperationInProgress
  - [x] FarmOperationSuccess
  - [x] FarmOperationFailure
- [x] Create FarmEvent (Bloc events)
  - [x] LoadFarms
  - [x] CreateFarm
  - [x] UpdateFarm
  - [x] DeleteFarm
  - [x] SearchFarms
  - [x] FilterFarms
- [x] Implement FarmBloc
  - [x] Handle all events
  - [x] Emit appropriate states
  - [x] Call repository methods
  - [x] Handle errors gracefully

### Error Handling
- [x] Create error message mapping
  - [x] Network errors
  - [x] Permission errors
  - [x] Validation errors
  - [x] Not found errors
- [x] Implement error display
  - [x] Show snackbar for transient errors
  - [ ] Show dialog for critical errors
  - [x] Show inline errors for form validation
- [ ] Add retry mechanisms where appropriate
- [ ] Log errors for debugging

### Form Validation
- [x] Farm name validation
  - [x] Required field
  - [x] Min 3 characters
  - [x] Max 100 characters
  - [ ] No special characters (optional)
- [x] Description validation
  - [x] Optional field
  - [x] Max 500 characters
- [x] Capacity validation
  - [x] Required field
  - [x] Must be number > 0
  - [x] Max reasonable value (e.g., 100000)
- [x] Real-time validation feedback
- [x] Form-level validation before submit

### Internationalization
- [x] Add translation keys
  - [x] `farm_create_title`
  - [x] `farm_edit_title`
  - [x] `farm_list_title`
  - [x] `farm_details_title`
  - [x] `farm_name_label`
  - [x] `farm_description_label`
  - [x] `farm_capacity_label`
  - [x] `farm_create_button`
  - [x] `farm_update_button`
  - [x] `farm_delete_button`
  - [x] `farm_delete_confirm_message`
  - [x] `farm_empty_state_message`
  - [x] `dashboard_title`
  - [x] `dashboard_welcome_message`
  - [x] Error messages
  - [x] Validation messages
- [ ] Add translations for all supported languages

### Testing
- [ ] Unit tests for FarmBloc/Controller
  - [ ] Test all events/actions
  - [ ] Test state transitions
  - [ ] Test error handling
  - [ ] Mock repository
- [ ] Unit tests for FarmSummaryService
  - [ ] Test calculations
  - [ ] Test edge cases
- [ ] Widget tests for all screens
  - [ ] Test FarmCreateScreen
  - [ ] Test FarmEditScreen
  - [ ] Test FarmListScreen
  - [ ] Test FarmDetailsScreen
  - [ ] Test DashboardScreen
- [ ] Widget tests for components
  - [ ] Test FarmCard
  - [ ] Test FarmSummaryCard
  - [ ] Test form inputs
- [ ] Integration tests
  - [ ] Test create farm flow
  - [ ] Test edit farm flow
  - [ ] Test delete farm flow
  - [ ] Test navigation flow
- [ ] Target: >70% code coverage

### Performance Optimization
- [ ] Implement pagination for farm list (if needed)
- [ ] Add caching for farm data
- [ ] Optimize Firestore queries
  - [ ] Use proper indexes
  - [ ] Limit query results
  - [ ] Use snapshots efficiently
- [ ] Implement debouncing for search
- [ ] Use const constructors where possible

### UI/UX Enhancements
- [ ] Add animations
  - [ ] Page transitions
  - [ ] Card animations
  - [ ] Loading animations
- [ ] Add haptic feedback for actions
- [ ] Ensure responsive design
  - [ ] Phone layouts
  - [ ] Tablet layouts
  - [ ] Landscape orientation
- [ ] Follow material design guidelines
- [ ] Add proper color scheme
- [ ] Ensure accessibility
  - [ ] Semantic labels
  - [ ] Screen reader support
  - [ ] Sufficient color contrast

## Screen Designs

### Dashboard Screen Layout

```
┌─────────────────────────────────┐
│  ☰  Dashboard         [Profile] │
├─────────────────────────────────┤
│  Welcome, [User Name]!          │
│                                 │
│  [+ Create New Farm Button]     │
│                                 │
│  Your Farms:                    │
│                                 │
│  ┌───────────────────────────┐  │
│  │ Farm Name                 │  │
│  │ Description...            │  │
│  │ 🐄 150 head | 5 lots     │  │
│  │ ▓▓▓▓▓▓▓░░░ 75% capacity  │  │
│  └───────────────────────────┘  │
│                                 │
│  ┌───────────────────────────┐  │
│  │ Another Farm              │  │
│  │ Description...            │  │
│  │ 🐄 80 head | 3 lots      │  │
│  │ ▓▓▓▓░░░░░░ 40% capacity  │  │
│  └───────────────────────────┘  │
│                                 │
└─────────────────────────────────┘
```

### Farm Create/Edit Form

```
┌─────────────────────────────────┐
│  ←  Create Farm                 │
├─────────────────────────────────┤
│                                 │
│  Farm Name *                    │
│  ┌─────────────────────────┐   │
│  │ My Farm                 │   │
│  └─────────────────────────┘   │
│                                 │
│  Description                    │
│  ┌─────────────────────────┐   │
│  │ A family-owned cattle   │   │
│  │ farm in the countryside │   │
│  │                         │   │
│  └─────────────────────────┘   │
│                                 │
│  Capacity (head) *              │
│  ┌─────────────────────────┐   │
│  │ 200                     │   │
│  └─────────────────────────┘   │
│                                 │
│           [Cancel]  [Create]    │
│                                 │
└─────────────────────────────────┘
```

### Farm Details Screen

```
┌─────────────────────────────────┐
│  ←  My Farm          [Edit] [⋮] │
├─────────────────────────────────┤
│                                 │
│  📊 Overview                    │
│  ┌─────────────────────────┐   │
│  │ Total Cattle: 150       │   │
│  │ Active Lots: 5          │   │
│  │ Capacity: 75%           │   │
│  │ People: 3               │   │
│  └─────────────────────────┘   │
│                                 │
│  Quick Actions                  │
│  [Add Transaction] [Add Lot]    │
│                                 │
│  Sections                       │
│  ▸ Cattle Lots (5)              │
│  ▸ People (3)                   │
│  ▸ Transactions (Recent)        │
│  ▸ Goals (2 active)             │
│  ▸ Services History             │
│  ▸ Reports                      │
│                                 │
└─────────────────────────────────┘
```

## Code Examples

### FarmSummaryCard Widget

```dart
class FarmSummaryCard extends StatelessWidget {
  final Farm farm;
  final int cattleCount;
  final int activeLots;

  const FarmSummaryCard({
    Key? key,
    required this.farm,
    required this.cattleCount,
    required this.activeLots,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final capacityPercent = (cattleCount / farm.capacity * 100).clamp(0, 100);

    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => _navigateToDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                farm.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                farm.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.pets, size: 20),
                  const SizedBox(width: 4),
                  Text('$cattleCount head'),
                  const SizedBox(width: 16),
                  Icon(Icons.category, size: 20),
                  const SizedBox(width: 4),
                  Text('$activeLots lots'),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: capacityPercent / 100,
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(height: 4),
              Text(
                '${capacityPercent.toStringAsFixed(0)}% capacity',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.pushNamed(context, '/farm/${farm.id}');
  }
}
```

### FarmBloc Example

```dart
class FarmBloc extends Bloc<FarmEvent, FarmState> {
  final FarmRepository _farmRepository;
  final PersonRepository _personRepository;

  FarmBloc({
    required FarmRepository farmRepository,
    required PersonRepository personRepository,
  })  : _farmRepository = farmRepository,
        _personRepository = personRepository,
        super(FarmInitial()) {
    on<LoadFarms>(_onLoadFarms);
    on<CreateFarm>(_onCreateFarm);
    on<UpdateFarm>(_onUpdateFarm);
    on<DeleteFarm>(_onDeleteFarm);
  }

  Future<void> _onLoadFarms(LoadFarms event, Emitter<FarmState> emit) async {
    emit(FarmLoading());
    try {
      final farms = await _farmRepository.getByUserId(event.userId);
      emit(FarmLoaded(farms: farms));
    } catch (e) {
      emit(FarmError(message: e.toString()));
    }
  }

  Future<void> _onCreateFarm(CreateFarm event, Emitter<FarmState> emit) async {
    emit(FarmOperationInProgress());
    try {
      // Create farm
      final farm = await _farmRepository.create(event.farm);

      // Automatically create Person record (Owner, admin)
      final person = Person(
        id: event.userId,
        farmId: farm.id,
        userId: event.userId,
        name: event.userName,
        personType: PersonType.owner,
        isAdmin: true,
        createdAt: DateTime.now(),
      );
      await _personRepository.create(person);

      emit(FarmOperationSuccess(farm: farm));
      add(LoadFarms(userId: event.userId));
    } catch (e) {
      emit(FarmOperationFailure(message: e.toString()));
    }
  }

  // Implement other event handlers...
}
```

### FarmSummaryService

```dart
class FarmSummaryService {
  final CattleLotRepository _lotRepository;
  final TransactionRepository _transactionRepository;

  FarmSummaryService({
    required CattleLotRepository lotRepository,
    required TransactionRepository transactionRepository,
  })  : _lotRepository = lotRepository,
        _transactionRepository = transactionRepository;

  Future<FarmSummary> getSummary(String farmId) async {
    // Get all lots for farm
    final lots = await _lotRepository.getByFarmId(farmId);

    // Calculate total cattle
    final totalCattle = lots.fold<int>(
      0,
      (sum, lot) => sum + lot.currentQuantity,
    );

    // Count active lots
    final activeLots = lots.where((lot) => lot.isActive).length;

    // Get recent transactions (last 5)
    final recentTransactions =
        await _transactionRepository.getRecentByFarmId(farmId, limit: 5);

    return FarmSummary(
      totalCattle: totalCattle,
      activeLots: activeLots,
      recentTransactions: recentTransactions,
    );
  }
}

class FarmSummary {
  final int totalCattle;
  final int activeLots;
  final List<Transaction> recentTransactions;

  FarmSummary({
    required this.totalCattle,
    required this.activeLots,
    required this.recentTransactions,
  });
}
```

## Firestore Queries

### Get farms by user ID

```dart
Future<List<Farm>> getByUserId(String userId) async {
  // Query farms where user is a person
  final peopleQuery = await _firestore
      .collectionGroup('people')
      .where('user_id', isEqualTo: userId)
      .get();

  // Extract farm IDs
  final farmIds = peopleQuery.docs.map((doc) => doc.reference.parent.parent!.id).toSet();

  // Fetch farms
  final farms = <Farm>[];
  for (final farmId in farmIds) {
    final farm = await getById(farmId);
    farms.add(farm);
  }

  return farms;
}
```

## Testing Examples

### Unit Test for FarmBloc

```dart
void main() {
  late FarmBloc farmBloc;
  late MockFarmRepository mockFarmRepository;
  late MockPersonRepository mockPersonRepository;

  setUp(() {
    mockFarmRepository = MockFarmRepository();
    mockPersonRepository = MockPersonRepository();
    farmBloc = FarmBloc(
      farmRepository: mockFarmRepository,
      personRepository: mockPersonRepository,
    );
  });

  tearDown(() {
    farmBloc.close();
  });

  group('CreateFarm', () {
    test('emits [OperationInProgress, OperationSuccess, Loading, Loaded]', () async {
      final farm = Farm(/* test data */);
      final person = Person(/* test data */);

      when(() => mockFarmRepository.create(any())).thenAnswer((_) async => farm);
      when(() => mockPersonRepository.create(any())).thenAnswer((_) async => person);
      when(() => mockFarmRepository.getByUserId(any())).thenAnswer((_) async => [farm]);

      expectLater(
        farmBloc.stream,
        emitsInOrder([
          isA<FarmOperationInProgress>(),
          isA<FarmOperationSuccess>(),
          isA<FarmLoading>(),
          isA<FarmLoaded>(),
        ]),
      );

      farmBloc.add(CreateFarm(farm: farm, userId: 'user1', userName: 'Test User'));
    });
  });
}
```

## Completion Criteria

- [ ] All farm CRUD operations working
- [ ] Dashboard displaying farm summaries
- [ ] Person auto-creation working
- [ ] Navigation between screens working
- [ ] Form validation working
- [ ] Error handling implemented
- [ ] All tests passing (>70% coverage)
- [ ] Internationalization complete
- [ ] Code reviewed and approved
- [ ] UI/UX approved

## Next Step

After completing this step, proceed to:
**[Step 3: People Management](004-step3-people.md)**

---

**Step:** 2/10
**Estimated Time:** 4-5 days
**Dependencies:** Step 1 (Foundation)
**Status:** Ready to implement
