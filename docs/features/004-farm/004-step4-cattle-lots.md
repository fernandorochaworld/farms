# Step 4: Cattle Lot Management - Feature 004

## Overview

Implement cattle lot management with full lifecycle tracking, including creation, editing, quantity management, and lot status monitoring.

## Goals

- Create CRUD operations for cattle lots
- Implement cattle type classification
- Track lot quantities (added/removed/current)
- Manage lot lifecycle (active/closed)
- Handle birth date ranges for age calculation
- Display lot statistics and history

## Implementation Checklist

### Lot Listing
- [x] Create LotListScreen UI
  - [x] Display list of lots for a farm
  - [x] Show lot name, type, quantity, status
  - [x] Add floating action button to create lot
  - [ ] Add search functionality
  - [ ] Add filter by cattle type, gender, status
  - [ ] Add sort options (name, date, quantity)
  - [x] Show empty state
  - [x] Add pull-to-refresh
  - [ ] Add skeleton loading
- [x] Create LotCard widget
  - [x] Display lot name and type
  - [x] Show current quantity with icon
  - [x] Display cattle type badge
  - [x] Show gender indicator
  - [x] Show status indicator (active/closed)
  - [x] Add tap to view details
  - [ ] Add swipe actions (edit, close)
- [x] Implement LotListController/Bloc
  - [x] Fetch lots by farm ID
  - [ ] Handle real-time updates
  - [x] Implement search and filter
  - [ ] Handle pagination if needed
- [ ] Add widget tests

### Lot Creation
- [x] Create LotFormScreen (create mode) UI
  - [x] Add lot name input field
  - [x] Add cattle type selector
  - [x] Add gender selector (Male, Female, Mixed)
  - [x] Add birth start date picker
  - [x] Add birth end date picker
  - [x] Add initial quantity input
  - [x] Add average weight input (optional)
  - [ ] Add notes/description field
  - [x] Add form validation
  - [x] Add submit button
- [x] Create CattleTypeSelector widget
  - [x] List all cattle types with descriptions
  - [x] Bezerro (até 1 ano)
  - [x] Novilho (até 2 anos)
  - [x] Boi 3 anos (até 3 anos)
  - [x] Boi 4 anos (até 4 anos)
  - [x] Boi 5+ anos (5 anos ou mais)
  - [ ] Add icons for each type
  - [x] Handle selection
- [x] Create GenderSelector widget
  - [x] Male option with icon
  - [x] Female option with icon
  - [x] Mixed option with icon
  - [x] Handle selection
- [x] Implement LotController/Bloc
  - [x] Handle form submission
  - [x] Validate data
  - [x] Create lot record
  - [x] Create initial transaction (Buy) with quantity
  - [x] Create initial weight history if provided
  - [x] Handle success/error states
- [ ] Add widget tests

### Lot Details
- [x] Create LotDetailsScreen UI
  - [x] Display lot information
  - [x] Show current quantity prominently
  - [x] Display cattle type and gender
  - [x] Show birth date range
  - [x] Calculate and display age range
  - [ ] Show start/end dates
  - [x] Display status (Active/Closed)
  - [x] Add edit button
  - [ ] Add close lot button
  - [x] Show statistics section
  - [ ] Show recent transactions list
  - [ ] Show weight history chart
  - [ ] Add quick action buttons
- [ ] Create LotStatisticsCard widget
  - [ ] Total added quantity
  - [ ] Total removed quantity
  - [ ] Current quantity
  - [ ] Transaction count
  - [ ] Average weight (latest)
  - [ ] Days active
  - [ ] Mortality count (Die transactions)
- [x] Implement LotDetailsController/Bloc
  - [x] Fetch lot by ID
  - [ ] Fetch transactions for lot
  - [ ] Fetch weight history
  - [ ] Calculate statistics
  - [ ] Handle real-time updates
- [ ] Add widget tests

### Lot Editing
- [x] Create LotFormScreen (edit mode) UI
  - [x] Pre-populate form with lot data
  - [x] Allow editing name, description
  - [x] Allow editing cattle type (with validation)
  - [x] Allow editing gender (with validation)
  - [x] Allow editing birth dates (with validation)
  - [ ] Cannot edit quantities directly (use transactions)
  - [x] Add form validation
  - [x] Add save button
- [x] Implement edit logic in controller
  - [x] Update lot record
  - [x] Validate changes
  - [x] Handle success/error states
- [ ] Add widget tests

### Lot Closure
- [x] Implement lot closure logic
  - [ ] Automatic closure when current_quantity = 0
  - [x] Manual closure option (with confirmation)
  - [x] Set end_date to closure date
  - [ ] Prevent new transactions after closure
  - [x] Allow reopening if needed
- [x] Create closure confirmation dialog
  - [ ] Show warning message
  - [ ] Confirm all cattle removed/sold
  - [x] Add confirm and cancel buttons
- [x] Implement reopening logic
  - [x] Clear end_date
  - [ ] Validate can be reopened
  - [ ] Add confirmation dialog
- [ ] Add widget tests

### Quantity Calculations
- [x] Implement currentQuantity getter
  - [x] Formula: qtd_added - qtd_removed
  - [x] Display in UI with icon
  - [ ] Color-code based on capacity
- [ ] Create QuantityService
  - [ ] Calculate total added
  - [ ] Calculate total removed
  - [ ] Calculate current quantity
  - [ ] Validate quantity consistency
  - [ ] Handle edge cases (negative values)
- [x] Add quantity validation
  - [x] Current quantity >= 0
  - [ ] Quantities match transaction sums
  - [ ] Alert on discrepancies
- [ ] Add unit tests for calculations

### Age Calculation
- [x] Implement age calculation logic
  - [x] Use birth_start for minimum age
  - [x] Use birth_end for maximum age
  - [x] Display age range (e.g., "8-10 months")
  - [x] Handle null birth dates
- [x] Create AgeCalculator service
  - [x] Calculate age in months/years
  - [x] Validate cattle type matches age
  - [x] Suggest type changes based on age
  - [ ] Add warnings for age discrepancies
- [x] Display age information in UI
  - [x] Age range in lot details
  - [ ] Age validation warnings
  - [ ] Age-based type suggestions
- [ ] Add unit tests

### Lot Statistics
- [x] Calculate lot statistics
  - [x] Total transactions count
  - [x] Buy transactions count
  - [x] Sell transactions count
  - [x] Move transactions count
  - [x] Die transactions count
  - [ ] Total value (buy - sell)
  - [ ] Average weight progression
  - [x] Days since creation
  - [x] Mortality rate
- [x] Create StatisticsService
  - [x] Aggregate transaction data
  - [ ] Calculate financial metrics
  - [ ] Calculate performance metrics
  - [ ] Generate trend data
- [x] Display statistics in UI
  - [x] Statistics cards
  - [ ] Charts and graphs
  - [ ] Trend indicators
- [ ] Add unit tests

### Lot History
- [ ] Create LotHistoryScreen
  - [ ] Display timeline of all events
  - [ ] Show transactions chronologically
  - [ ] Show weight records
  - [ ] Show lot changes (edits)
  - [ ] Add date filtering
  - [ ] Add event type filtering
- [ ] Create HistoryTimeline widget
  - [ ] Timeline layout
  - [ ] Event cards with icons
  - [ ] Date grouping
  - [ ] Expand/collapse details
- [ ] Add widget tests

### Validation & Business Rules
- [x] Lot name validation
  - [x] Required, 3-100 characters
  - [ ] Unique within farm
- [x] Birth date validation
  - [x] birth_end >= birth_start
  - [ ] Dates not in future
  - [ ] Reasonable date range
- [x] Cattle type validation
  - [x] Required, valid enum value
  - [x] Matches age range (suggestion)
- [x] Quantity validation
  - [x] Initial quantity > 0
  - [x] Current quantity >= 0
  - [ ] Cannot go negative
- [x] Lot status validation
  - [ ] Cannot add transactions to closed lot
  - [x] Auto-close when quantity = 0
  - [ ] Validate before manual closure

### Permission Checks
- [x] Implement lot permission checks
  - [x] Create: All person types can create
  - [x] Edit: Owner, Manager, Worker can edit
  - [x] Close: Owner, Manager can close
  - [x] Delete: Owner, Manager can delete
  - [x] View: All can view
  - [x] Admin can override
- [x] Add UI permission guards
- [ ] Add backend validation

### State Management
- [x] Create LotState
  - [x] LotInitial
  - [x] LotLoading
  - [x] LotLoaded
  - [x] LotDetailsLoaded
  - [x] LotError
  - [x] LotOperationInProgress
  - [x] LotOperationSuccess
  - [x] LotOperationFailure
- [x] Create LotEvent
  - [x] LoadLots
  - [x] LoadLotDetails
  - [x] CreateLot
  - [x] UpdateLot
  - [x] CloseLot
  - [x] ReopenLot
  - [x] SearchLots
  - [x] FilterLots
- [x] Implement LotBloc
  - [x] Handle all events
  - [x] Emit appropriate states
  - [x] Call repository methods
  - [x] Handle errors

### Internationalization
- [x] Add translation keys
  - [x] lot_list_title
  - [x] lot_create_title
  - [x] lot_details_title
  - [x] lot_edit_title
  - [x] lot_name_label
  - [x] lot_cattle_type_label
  - [x] lot_gender_label
  - [x] lot_birth_dates_label
  - [x] lot_quantity_label
  - [x] lot_status_active
  - [x] lot_status_closed
  - [x] Cattle type labels
  - [x] Gender labels
  - [x] Validation messages
  - [x] Confirmation messages

### Testing
- [ ] Unit tests for LotBloc
  - [ ] Test all events
  - [ ] Test state transitions
  - [ ] Mock repositories
- [ ] Unit tests for calculations
  - [ ] Test currentQuantity
  - [ ] Test age calculation
  - [ ] Test statistics calculation
- [ ] Widget tests for screens
  - [ ] Test LotListScreen
  - [ ] Test LotFormScreen
  - [ ] Test LotDetailsScreen
- [ ] Widget tests for components
  - [ ] Test LotCard
  - [ ] Test CattleTypeSelector
  - [ ] Test GenderSelector
  - [ ] Test StatisticsCard
- [ ] Integration tests
  - [ ] Test create lot flow
  - [ ] Test edit lot flow
  - [ ] Test close lot flow
  - [ ] Test quantity calculations
- [ ] Target: >70% coverage

## UI Screens

### Lot List

```
┌─────────────────────────────────┐
│  ←  Cattle Lots (5)        [+]  │
├─────────────────────────────────┤
│  🔍 Search lots...              │
│  [All] [Bezerro] [Novilho]...  │
│                                 │
│  ┌─────────────────────────┐   │
│  │ Bezerros 2025-1   ✓     │   │
│  │ Bezerro • Male          │   │
│  │ 🐄 45 head              │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ Novilhos Q1       ✓     │   │
│  │ Novilho • Mixed         │   │
│  │ 🐄 30 head              │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ Vendidos 2024     ✗     │   │
│  │ Boi 3 anos • Male       │   │
│  │ 🐄 0 head (Closed)      │   │
│  └─────────────────────────┘   │
│                                 │
└─────────────────────────────────┘
```

### Lot Creation Form

```
┌─────────────────────────────────┐
│  ←  Create Lot                  │
├─────────────────────────────────┤
│                                 │
│  Lot Name *                     │
│  ┌─────────────────────────┐   │
│  │ Bezerros 2025-1         │   │
│  └─────────────────────────┘   │
│                                 │
│  Cattle Type *                  │
│  ┌─────────────────────────┐   │
│  │ ◉ Bezerro (até 1 ano)   │   │
│  │ ○ Novilho (até 2 anos)  │   │
│  │ ○ Boi 3 anos            │   │
│  │ ○ Boi 4 anos            │   │
│  │ ○ Boi 5+ anos           │   │
│  └─────────────────────────┘   │
│                                 │
│  Gender *                       │
│  [♂ Male] [♀ Female] [⚥ Mixed] │
│                                 │
│  Birth Date Range               │
│  From: [2024-01-01]             │
│  To:   [2024-03-31]             │
│                                 │
│  Initial Quantity *             │
│  ┌─────────────────────────┐   │
│  │ 50                      │   │
│  └─────────────────────────┘   │
│                                 │
│  Average Weight (kg)            │
│  ┌─────────────────────────┐   │
│  │ 180                     │   │
│  └─────────────────────────┘   │
│                                 │
│           [Cancel]  [Create]    │
│                                 │
└─────────────────────────────────┘
```

### Lot Details

```
┌─────────────────────────────────┐
│  ←  Bezerros 2025-1   [Edit][⋮]│
├─────────────────────────────────┤
│                                 │
│  🐄 Current Quantity            │
│  ┌─────────────────────────┐   │
│  │        45 head          │   │
│  │   ✓ Active              │   │
│  └─────────────────────────┘   │
│                                 │
│  📊 Information                 │
│  Type:        Bezerro           │
│  Gender:      Male              │
│  Age Range:   8-10 months       │
│  Birth Range: 2024-01-01 to     │
│               2024-03-31        │
│  Started:     2025-01-15        │
│  Days Active: 85 days           │
│                                 │
│  📈 Statistics                  │
│  ┌───────────┬───────────┐     │
│  │ Added: 50 │ Removed: 5│     │
│  ├───────────┼───────────┤     │
│  │ Buys: 2   │ Sells: 1  │     │
│  ├───────────┼───────────┤     │
│  │ Dies: 2   │ Moves: 2  │     │
│  └───────────┴───────────┘     │
│                                 │
│  Latest Weight: 220 kg          │
│  Weight Gain: +40 kg            │
│                                 │
│  [View Transactions]            │
│  [View Weight History]          │
│  [Close Lot]                    │
│                                 │
└─────────────────────────────────┘
```

## Code Examples

### CattleLot Model with Computed Properties

```dart
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

  const CattleLot({
    required this.id,
    required this.farmId,
    required this.name,
    required this.cattleType,
    required this.gender,
    required this.birthStart,
    required this.birthEnd,
    required this.qtdAdded,
    required this.qtdRemoved,
    required this.startDate,
    this.endDate,
    required this.createdAt,
    this.updatedAt,
  });

  // Computed properties
  int get currentQuantity => qtdAdded - qtdRemoved;
  bool get isActive => endDate == null && currentQuantity > 0;
  bool get isClosed => endDate != null || currentQuantity == 0;

  int get daysActive {
    final end = endDate ?? DateTime.now();
    return end.difference(startDate).inDays;
  }

  AgeRange get ageRange {
    final now = DateTime.now();
    final minAge = _calculateAge(birthEnd, now);
    final maxAge = _calculateAge(birthStart, now);
    return AgeRange(min: minAge, max: maxAge);
  }

  int _calculateAge(DateTime birthDate, DateTime currentDate) {
    return currentDate.difference(birthDate).inDays ~/ 30;
  }

  // ... fromJson, toJson, copyWith
}
```

### LotCard Widget

```dart
class LotCard extends StatelessWidget {
  final CattleLot lot;
  final VoidCallback? onTap;

  const LotCard({
    Key? key,
    required this.lot,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      lot.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  _buildStatusIcon(),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildTypeChip(),
                  const SizedBox(width: 8),
                  _buildGenderChip(),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.pets, size: 20, color: Colors.brown),
                  const SizedBox(width: 4),
                  Text(
                    '${lot.currentQuantity} head',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (lot.isClosed) ...[
                    const SizedBox(width: 12),
                    Text(
                      '(Closed)',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    return Icon(
      lot.isActive ? Icons.check_circle : Icons.cancel,
      color: lot.isActive ? Colors.green : Colors.grey,
      size: 20,
    );
  }

  Widget _buildTypeChip() {
    return Chip(
      label: Text(_getCattleTypeLabel()),
      avatar: Icon(_getCattleTypeIcon(), size: 16),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildGenderChip() {
    return Chip(
      label: Text(_getGenderLabel()),
      avatar: Icon(_getGenderIcon(), size: 16),
      visualDensity: VisualDensity.compact,
    );
  }

  // Helper methods for labels and icons...
}
```

### CattleTypeSelector Widget

```dart
class CattleTypeSelector extends StatelessWidget {
  final CattleType? selectedType;
  final ValueChanged<CattleType> onChanged;

  const CattleTypeSelector({
    Key? key,
    this.selectedType,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: CattleType.values.map((type) {
        return RadioListTile<CattleType>(
          title: Text(_getTypeLabel(type)),
          subtitle: Text(_getTypeDescription(type)),
          value: type,
          groupValue: selectedType,
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        );
      }).toList(),
    );
  }

  String _getTypeLabel(CattleType type) {
    switch (type) {
      case CattleType.bezerro:
        return 'Bezerro';
      case CattleType.novilho:
        return 'Novilho';
      case CattleType.boi3anos:
        return 'Boi 3 anos';
      case CattleType.boi4anos:
        return 'Boi 4 anos';
      case CattleType.boi5maisAnos:
        return 'Boi 5+ anos';
    }
  }

  String _getTypeDescription(CattleType type) {
    switch (type) {
      case CattleType.bezerro:
        return 'Até 1 ano de idade';
      case CattleType.novilho:
        return 'Até 2 anos de idade';
      case CattleType.boi3anos:
        return 'Até 3 anos de idade';
      case CattleType.boi4anos:
        return 'Até 4 anos de idade';
      case CattleType.boi5maisAnos:
        return '5 anos ou mais';
    }
  }
}
```

### Age Calculator Service

```dart
class AgeCalculator {
  static AgeRange calculateAgeRange(
    DateTime birthStart,
    DateTime birthEnd, [
    DateTime? referenceDate,
  ]) {
    final ref = referenceDate ?? DateTime.now();

    // Calculate minimum age (from birthEnd)
    final minMonths = _monthsBetween(birthEnd, ref);

    // Calculate maximum age (from birthStart)
    final maxMonths = _monthsBetween(birthStart, ref);

    return AgeRange(min: minMonths, max: maxMonths);
  }

  static int _monthsBetween(DateTime start, DateTime end) {
    final months = (end.year - start.year) * 12 + end.month - start.month;
    return months;
  }

  static String formatAgeRange(AgeRange age) {
    if (age.min == age.max) {
      return _formatAge(age.min);
    }
    return '${_formatAge(age.min)} - ${_formatAge(age.max)}';
  }

  static String _formatAge(int months) {
    if (months < 12) {
      return '$months ${months == 1 ? 'month' : 'months'}';
    }
    final years = months ~/ 12;
    final remainingMonths = months % 12;
    if (remainingMonths == 0) {
      return '$years ${years == 1 ? 'year' : 'years'}';
    }
    return '$years years $remainingMonths months';
  }

  static CattleType suggestCattleType(int ageInMonths) {
    if (ageInMonths <= 12) return CattleType.bezerro;
    if (ageInMonths <= 24) return CattleType.novilho;
    if (ageInMonths <= 36) return CattleType.boi3anos;
    if (ageInMonths <= 48) return CattleType.boi4anos;
    return CattleType.boi5maisAnos;
  }

  static bool validateTypeMatchesAge(CattleType type, int ageInMonths) {
    return type == suggestCattleType(ageInMonths);
  }
}

class AgeRange {
  final int min;
  final int max;

  AgeRange({required this.min, required this.max});
}
```

## Validation Rules

### Business Rules
1. Lot name must be unique within farm
2. birth_end >= birth_start
3. Initial quantity > 0
4. Current quantity >= 0 (enforced by transactions)
5. Cannot add transactions to closed lot
6. Auto-close lot when current_quantity = 0
7. Cattle type should match age range (warning, not error)

### Form Validation
- Lot name: Required, 3-100 characters
- Cattle type: Required
- Gender: Required
- Birth dates: Required, valid date range
- Initial quantity: Required, > 0

## Completion Criteria

- [ ] All lot CRUD operations working
- [ ] Cattle type and gender selection working
- [ ] Quantity calculations accurate
- [ ] Lot lifecycle (active/closed) working
- [ ] Age calculation functional
- [ ] Statistics display working
- [ ] All tests passing (>70% coverage)
- [ ] Internationalization complete
- [ ] Code reviewed

## Next Step

After completing this step, proceed to:
**[Step 5: Transaction Management](004-step5-transactions.md)**

---

**Step:** 4/10
**Estimated Time:** 4-5 days
**Dependencies:** Steps 1-3
**Status:** Ready to implement
