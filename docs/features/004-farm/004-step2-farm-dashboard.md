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
- [ ] Create FarmCreateScreen UI
  - [ ] Add farm name input field with validation
  - [ ] Add description text area
  - [ ] Add capacity number input
  - [ ] Add form validation
  - [ ] Add submit button with loading state
  - [ ] Add cancel button
- [ ] Implement FarmCreateController/Bloc
  - [ ] Handle form submission
  - [ ] Validate form data
  - [ ] Call repository to create farm
  - [ ] Automatically create Person record (Owner, is_admin=true)
  - [ ] Handle success/error states
  - [ ] Navigate to dashboard on success
- [ ] Add internationalization strings
- [ ] Create widget tests for form

### Farm Listing
- [ ] Create FarmListScreen UI
  - [ ] Display list of farms
  - [ ] Add search bar
  - [ ] Add filter options (sort by name, date, capacity)
  - [ ] Add pull-to-refresh
  - [ ] Add floating action button to create farm
  - [ ] Show empty state when no farms
  - [ ] Add skeleton loading state
- [ ] Implement FarmListController/Bloc
  - [ ] Fetch farms by user ID
  - [ ] Implement search functionality
  - [ ] Implement filtering
  - [ ] Handle real-time updates
  - [ ] Handle pagination (if needed)
- [ ] Create FarmCard widget
  - [ ] Display farm name
  - [ ] Display farm description (truncated)
  - [ ] Display cattle count (placeholder for now)
  - [ ] Add tap to view details
  - [ ] Add swipe actions (edit, delete)
- [ ] Add widget tests

### Farm Details
- [ ] Create FarmDetailsScreen UI
  - [ ] Display farm information
  - [ ] Display farm statistics (placeholder)
  - [ ] Add edit button
  - [ ] Add delete button (with confirmation)
  - [ ] Show people count
  - [ ] Show lots count (placeholder)
  - [ ] Add navigation to sections
- [ ] Implement FarmDetailsController/Bloc
  - [ ] Fetch farm by ID
  - [ ] Handle real-time updates
  - [ ] Handle navigation to edit screen
  - [ ] Handle delete operation
- [ ] Add confirmation dialog for delete
- [ ] Add widget tests

### Farm Editing
- [ ] Create FarmEditScreen UI
  - [ ] Pre-populate form with farm data
  - [ ] Allow editing name, description, capacity
  - [ ] Add form validation
  - [ ] Add save button with loading state
  - [ ] Add cancel button
- [ ] Implement FarmEditController/Bloc
  - [ ] Load current farm data
  - [ ] Handle form submission
  - [ ] Validate form data
  - [ ] Call repository to update farm
  - [ ] Handle success/error states
  - [ ] Navigate back on success
- [ ] Add widget tests

### Farm Deletion
- [ ] Implement delete confirmation dialog
  - [ ] Show warning message
  - [ ] List what will be deleted (people, lots, etc.)
  - [ ] Add confirm and cancel buttons
- [ ] Implement delete logic in controller
  - [ ] Delete farm document
  - [ ] Handle subcollections (discuss cascade vs archive)
  - [ ] Handle errors
  - [ ] Navigate to dashboard on success
- [ ] Add proper error messages
- [ ] Add widget tests

### Dashboard
- [ ] Create DashboardScreen UI
  - [ ] Add app bar with title
  - [ ] Add welcome message with user name
  - [ ] Add "Create Farm" button prominently
  - [ ] Display grid/list of FarmSummaryCard widgets
  - [ ] Add pull-to-refresh
  - [ ] Add skeleton loading state
  - [ ] Handle empty state (no farms)
- [ ] Create FarmSummaryCard widget
  - [ ] Display farm name
  - [ ] Display total cattle count (basic calculation)
  - [ ] Display active lots count
  - [ ] Display capacity usage percentage
  - [ ] Add visual indicators (progress bar, icons)
  - [ ] Add tap to navigate to farm details
  - [ ] Make responsive for different screen sizes
- [ ] Implement DashboardController/Bloc
  - [ ] Fetch all farms for user
  - [ ] Calculate summary data per farm
  - [ ] Handle real-time updates
  - [ ] Handle errors
- [ ] Create FarmSummaryService
  - [ ] Calculate total cattle count per farm
  - [ ] Count active lots per farm
  - [ ] Calculate capacity usage
  - [ ] Prepare for future enhancements
- [ ] Add internationalization strings
- [ ] Add widget tests

### Navigation
- [ ] Setup navigation routes
  - [ ] Dashboard route (/)
  - [ ] Farm list route
  - [ ] Farm create route
  - [ ] Farm edit route (/farm/:id/edit)
  - [ ] Farm details route (/farm/:id)
- [ ] Implement navigation guards
  - [ ] Check authentication
  - [ ] Verify farm access permissions
- [ ] Add deep linking support (optional)

### Person Auto-Creation
- [ ] Implement auto-creation logic
  - [ ] When farm is created, create Person record
  - [ ] Set person_type = Owner
  - [ ] Set is_admin = true
  - [ ] Link to current user (user_id)
  - [ ] Copy user name to person name
  - [ ] Handle transaction (both operations must succeed)
- [ ] Add error handling for failed person creation
- [ ] Add rollback logic if person creation fails
- [ ] Test auto-creation flow

### State Management
- [ ] Create FarmState (Bloc/Cubit states)
  - [ ] FarmInitial
  - [ ] FarmLoading
  - [ ] FarmLoaded
  - [ ] FarmError
  - [ ] FarmOperationInProgress
  - [ ] FarmOperationSuccess
  - [ ] FarmOperationFailure
- [ ] Create FarmEvent (Bloc events)
  - [ ] LoadFarms
  - [ ] CreateFarm
  - [ ] UpdateFarm
  - [ ] DeleteFarm
  - [ ] SearchFarms
  - [ ] FilterFarms
- [ ] Implement FarmBloc
  - [ ] Handle all events
  - [ ] Emit appropriate states
  - [ ] Call repository methods
  - [ ] Handle errors gracefully

### Error Handling
- [ ] Create error message mapping
  - [ ] Network errors
  - [ ] Permission errors
  - [ ] Validation errors
  - [ ] Not found errors
- [ ] Implement error display
  - [ ] Show snackbar for transient errors
  - [ ] Show dialog for critical errors
  - [ ] Show inline errors for form validation
- [ ] Add retry mechanisms where appropriate
- [ ] Log errors for debugging

### Form Validation
- [ ] Farm name validation
  - [ ] Required field
  - [ ] Min 3 characters
  - [ ] Max 100 characters
  - [ ] No special characters (optional)
- [ ] Description validation
  - [ ] Optional field
  - [ ] Max 500 characters
- [ ] Capacity validation
  - [ ] Required field
  - [ ] Must be number > 0
  - [ ] Max reasonable value (e.g., 100000)
- [ ] Real-time validation feedback
- [ ] Form-level validation before submit

### Internationalization
- [ ] Add translation keys
  - [ ] `farm_create_title`
  - [ ] `farm_edit_title`
  - [ ] `farm_list_title`
  - [ ] `farm_details_title`
  - [ ] `farm_name_label`
  - [ ] `farm_description_label`
  - [ ] `farm_capacity_label`
  - [ ] `farm_create_button`
  - [ ] `farm_update_button`
  - [ ] `farm_delete_button`
  - [ ] `farm_delete_confirm_message`
  - [ ] `farm_empty_state_message`
  - [ ] `dashboard_title`
  - [ ] `dashboard_welcome_message`
  - [ ] Error messages
  - [ ] Validation messages
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
