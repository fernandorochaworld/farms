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
- [ ] Create LotListScreen UI
  - [ ] Display list of lots for a farm
  - [ ] Show lot name, type, quantity, status
  - [ ] Add floating action button to create lot
  - [ ] Add search functionality
  - [ ] Add filter by cattle type, gender, status
  - [ ] Add sort options (name, date, quantity)
  - [ ] Show empty state
  - [ ] Add pull-to-refresh
  - [ ] Add skeleton loading
- [ ] Create LotCard widget
  - [ ] Display lot name and type
  - [ ] Show current quantity with icon
  - [ ] Display cattle type badge
  - [ ] Show gender indicator
  - [ ] Show status indicator (active/closed)
  - [ ] Add tap to view details
  - [ ] Add swipe actions (edit, close)
- [ ] Implement LotListController/Bloc
  - [ ] Fetch lots by farm ID
  - [ ] Handle real-time updates
  - [ ] Implement search and filter
  - [ ] Handle pagination if needed
- [ ] Add widget tests

### Lot Creation
- [ ] Create LotFormScreen (create mode) UI
  - [ ] Add lot name input field
  - [ ] Add cattle type selector
  - [ ] Add gender selector (Male, Female, Mixed)
  - [ ] Add birth start date picker
  - [ ] Add birth end date picker
  - [ ] Add initial quantity input
  - [ ] Add average weight input (optional)
  - [ ] Add notes/description field
  - [ ] Add form validation
  - [ ] Add submit button
- [ ] Create CattleTypeSelector widget
  - [ ] List all cattle types with descriptions
  - [ ] Bezerro (até 1 ano)
  - [ ] Novilho (até 2 anos)
  - [ ] Boi 3 anos (até 3 anos)
  - [ ] Boi 4 anos (até 4 anos)
  - [ ] Boi 5+ anos (5 anos ou mais)
  - [ ] Add icons for each type
  - [ ] Handle selection
- [ ] Create GenderSelector widget
  - [ ] Male option with icon
  - [ ] Female option with icon
  - [ ] Mixed option with icon
  - [ ] Handle selection
- [ ] Implement LotController/Bloc
  - [ ] Handle form submission
  - [ ] Validate data
  - [ ] Create lot record
  - [ ] Create initial transaction (Buy) with quantity
  - [ ] Create initial weight history if provided
  - [ ] Handle success/error states
- [ ] Add widget tests

### Lot Details
- [ ] Create LotDetailsScreen UI
  - [ ] Display lot information
  - [ ] Show current quantity prominently
  - [ ] Display cattle type and gender
  - [ ] Show birth date range
  - [ ] Calculate and display age range
  - [ ] Show start/end dates
  - [ ] Display status (Active/Closed)
  - [ ] Add edit button
  - [ ] Add close lot button
  - [ ] Show statistics section
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
- [ ] Implement LotDetailsController/Bloc
  - [ ] Fetch lot by ID
  - [ ] Fetch transactions for lot
  - [ ] Fetch weight history
  - [ ] Calculate statistics
  - [ ] Handle real-time updates
- [ ] Add widget tests

### Lot Editing
- [ ] Create LotFormScreen (edit mode) UI
  - [ ] Pre-populate form with lot data
  - [ ] Allow editing name, description
  - [ ] Allow editing cattle type (with validation)
  - [ ] Allow editing gender (with validation)
  - [ ] Allow editing birth dates (with validation)
  - [ ] Cannot edit quantities directly (use transactions)
  - [ ] Add form validation
  - [ ] Add save button
- [ ] Implement edit logic in controller
  - [ ] Update lot record
  - [ ] Validate changes
  - [ ] Handle success/error states
- [ ] Add widget tests

### Lot Closure
- [ ] Implement lot closure logic
  - [ ] Automatic closure when current_quantity = 0
  - [ ] Manual closure option (with confirmation)
  - [ ] Set end_date to closure date
  - [ ] Prevent new transactions after closure
  - [ ] Allow reopening if needed
- [ ] Create closure confirmation dialog
  - [ ] Show warning message
  - [ ] Confirm all cattle removed/sold
  - [ ] Add confirm and cancel buttons
- [ ] Implement reopening logic
  - [ ] Clear end_date
  - [ ] Validate can be reopened
  - [ ] Add confirmation dialog
- [ ] Add widget tests

### Quantity Calculations
- [ ] Implement currentQuantity getter
  - [ ] Formula: qtd_added - qtd_removed
  - [ ] Display in UI with icon
  - [ ] Color-code based on capacity
- [ ] Create QuantityService
  - [ ] Calculate total added
  - [ ] Calculate total removed
  - [ ] Calculate current quantity
  - [ ] Validate quantity consistency
  - [ ] Handle edge cases (negative values)
- [ ] Add quantity validation
  - [ ] Current quantity >= 0
  - [ ] Quantities match transaction sums
  - [ ] Alert on discrepancies
- [ ] Add unit tests for calculations

### Age Calculation
- [ ] Implement age calculation logic
  - [ ] Use birth_start for minimum age
  - [ ] Use birth_end for maximum age
  - [ ] Display age range (e.g., "8-10 months")
  - [ ] Handle null birth dates
- [ ] Create AgeCalculator service
  - [ ] Calculate age in months/years
  - [ ] Validate cattle type matches age
  - [ ] Suggest type changes based on age
  - [ ] Add warnings for age discrepancies
- [ ] Display age information in UI
  - [ ] Age range in lot details
  - [ ] Age validation warnings
  - [ ] Age-based type suggestions
- [ ] Add unit tests

### Lot Statistics
- [ ] Calculate lot statistics
  - [ ] Total transactions count
  - [ ] Buy transactions count
  - [ ] Sell transactions count
  - [ ] Move transactions count
  - [ ] Die transactions count
  - [ ] Total value (buy - sell)
  - [ ] Average weight progression
  - [ ] Days since creation
  - [ ] Mortality rate
- [ ] Create StatisticsService
  - [ ] Aggregate transaction data
  - [ ] Calculate financial metrics
  - [ ] Calculate performance metrics
  - [ ] Generate trend data
- [ ] Display statistics in UI
  - [ ] Statistics cards
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
- [ ] Lot name validation
  - [ ] Required, 3-100 characters
  - [ ] Unique within farm
- [ ] Birth date validation
  - [ ] birth_end >= birth_start
  - [ ] Dates not in future
  - [ ] Reasonable date range
- [ ] Cattle type validation
  - [ ] Required, valid enum value
  - [ ] Matches age range (suggestion)
- [ ] Quantity validation
  - [ ] Initial quantity > 0
  - [ ] Current quantity >= 0
  - [ ] Cannot go negative
- [ ] Lot status validation
  - [ ] Cannot add transactions to closed lot
  - [ ] Auto-close when quantity = 0
  - [ ] Validate before manual closure

### Permission Checks
- [ ] Implement lot permission checks
  - [ ] Create: All person types can create
  - [ ] Edit: Owner, Manager, Worker can edit
  - [ ] Close: Owner, Manager can close
  - [ ] Delete: Owner, Manager can delete
  - [ ] View: All can view
  - [ ] Admin can override
- [ ] Add UI permission guards
- [ ] Add backend validation

### State Management
- [ ] Create LotState
  - [ ] LotInitial
  - [ ] LotLoading
  - [ ] LotLoaded
  - [ ] LotDetailsLoaded
  - [ ] LotError
  - [ ] LotOperationInProgress
  - [ ] LotOperationSuccess
  - [ ] LotOperationFailure
- [ ] Create LotEvent
  - [ ] LoadLots
  - [ ] LoadLotDetails
  - [ ] CreateLot
  - [ ] UpdateLot
  - [ ] CloseLot
  - [ ] ReopenLot
  - [ ] SearchLots
  - [ ] FilterLots
- [ ] Implement LotBloc
  - [ ] Handle all events
  - [ ] Emit appropriate states
  - [ ] Call repository methods
  - [ ] Handle errors

### Internationalization
- [ ] Add translation keys
  - [ ] lot_list_title
  - [ ] lot_create_title
  - [ ] lot_details_title
  - [ ] lot_edit_title
  - [ ] lot_name_label
  - [ ] lot_cattle_type_label
  - [ ] lot_gender_label
  - [ ] lot_birth_dates_label
  - [ ] lot_quantity_label
  - [ ] lot_status_active
  - [ ] lot_status_closed
  - [ ] Cattle type labels
  - [ ] Gender labels
  - [ ] Validation messages
  - [ ] Confirmation messages

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
