# Step 5: Transaction Management - Feature 004

## Overview

Implement complete transaction management for cattle lots, including Buy, Sell, Move, and Die transactions with automatic quantity updates and financial tracking.

## Goals

- Create CRUD operations for transactions
- Implement four transaction types (Buy, Sell, Move, Die)
- Automatic lot quantity updates
- Handle Move transactions (two-transaction logic)
- Financial tracking and reporting
- Transaction history and timeline

## Implementation Checklist

### Transaction Listing
- [x] Create TransactionListScreen UI
  - [x] Display transactions for a lot
  - [ ] Show transaction type with icon
  - [x] Display quantity, weight, value
  - [x] Show transaction date
  - [x] Add floating action button to add transaction
  - [ ] Add filter by type
  - [ ] Add date range filter
  - [ ] Add sort options (date, value, type)
  - [x] Show empty state
  - [x] Add pull-to-refresh
- [x] Create TransactionTile widget
  - [x] Display transaction info
  - [x] Show type badge with color
  - [x] Show quantity with +/- indicator
  - [x] Display value and weight
  - [ ] Add tap to view details
  - [ ] Add swipe actions (edit, delete)
  - [ ] Show linked transaction indicator (for Move)
- [x] Implement TransactionListController/Bloc
  - [x] Fetch transactions by lot ID
  - [ ] Handle real-time updates
  - [ ] Implement filtering
  - [ ] Handle pagination if needed
- [ ] Add widget tests

### Transaction Creation - Buy
- [x] Create TransactionFormScreen (Buy mode) UI
  - [x] Add quantity input (required)
  - [x] Add average weight input (required)
  - [x] Add value/price input (required)
  - [x] Add date picker
  - [x] Add description/notes field
  - [ ] Show calculation: total value = quantity × price per head
  - [x] Add form validation
  - [x] Add submit button
- [x] Implement Buy transaction logic
  - [x] Create transaction record
  - [x] Increment lot.qtd_added
  - [ ] Create weight history entry
  - [x] Handle success/error states
  - [x] Show confirmation message
- [ ] Add widget tests

### Transaction Creation - Sell
- [x] Create TransactionFormScreen (Sell mode) UI
  - [x] Add quantity input (validate <= current quantity)
  - [x] Add average weight input (required)
  - [x] Add value/price input (required)
  - [x] Add date picker
  - [x] Add description/notes field
  - [ ] Show current lot quantity
  - [ ] Show remaining quantity after sell
  - [x] Add form validation
  - [x] Add submit button
- [x] Implement Sell transaction logic
  - [x] Validate quantity available
  - [x] Create transaction record
  - [x] Increment lot.qtd_removed
  - [ ] Auto-close lot if current_quantity = 0
  - [x] Handle success/error states
  - [x] Show confirmation message
- [ ] Add widget tests

### Transaction Creation - Move
- [x] Create TransactionFormScreen (Move mode) UI
  - [ ] Add source lot selector (current lot)
  - [ ] Add destination lot selector
  - [x] Add quantity input (validate <= current quantity)
  - [x] Add average weight input (required)
  - [x] Add date picker
  - [x] Add description/notes field
  - [ ] Show both lot quantities
  - [ ] Show impact preview
  - [x] Add form validation
  - [x] Add submit button
- [ ] Implement Move transaction logic
  - [ ] Validate quantity available in source
  - [ ] Create two linked transactions atomically
  - [ ] Transaction 1: Remove from source (Move out)
  - [ ] Transaction 2: Add to destination (Move in)
  - [ ] Link transactions via related_transaction_id
  - [ ] Update both lot quantities
  - [ ] Auto-close source lot if quantity = 0
  - [ ] Handle rollback on failure
  - [ ] Handle success/error states
- [ ] Add widget tests

### Transaction Creation - Die
- [x] Create TransactionFormScreen (Die mode) UI
  - [x] Add quantity input (validate <= current quantity)
  - [x] Add average weight input (optional)
  - [x] Add loss value input (optional)
  - [ ] Add cause of death field
  - [x] Add date picker
  - [x] Add description/notes field
  - [ ] Show mortality impact
  - [x] Add form validation
  - [x] Add submit button
- [x] Implement Die transaction logic
  - [x] Validate quantity available
  - [x] Create transaction record
  - [x] Increment lot.qtd_removed
  - [ ] Track for mortality statistics
  - [ ] Auto-close lot if current_quantity = 0
  - [x] Handle success/error states
  - [x] Show confirmation message
- [ ] Add widget tests

### Transaction Type Selection
- [x] Create TransactionTypeSelector screen
  - [x] Display all four types with icons
  - [x] Buy: + icon, green color
  - [x] Sell: $ icon, blue color
  - [x] Move: ↔ icon, orange color
  - [x] Die: ✝ icon, red color
  - [x] Add descriptions for each type
  - [x] Handle selection
  - [x] Navigate to appropriate form
- [ ] Add widget tests

### Transaction Details
- [ ] Create TransactionDetailsScreen UI
  - [ ] Display transaction information
  - [ ] Show type prominently
  - [ ] Display quantity, weight, value
  - [ ] Show date and description
  - [ ] Display lot information
  - [ ] Show linked transaction (for Move)
  - [ ] Add edit button
  - [ ] Add delete button (with confirmation)
  - [ ] Show calculations (value per head)
- [ ] Implement TransactionDetailsController/Bloc
  - [ ] Fetch transaction by ID
  - [ ] Fetch related lot info
  - [ ] Fetch linked transaction (for Move)
  - [ ] Handle real-time updates
- [ ] Add widget tests

### Transaction Editing
- [ ] Create TransactionFormScreen (edit mode) UI
  - [ ] Pre-populate form with transaction data
  - [ ] Allow editing quantity (with validation)
  - [ ] Allow editing weight, value, date
  - [ ] Allow editing description
  - [ ] Cannot change type
  - [ ] Cannot change lot (except Move destination)
  - [ ] Show impact of changes
  - [ ] Add form validation
  - [ ] Add save button
- [ ] Implement edit logic
  - [ ] Calculate quantity delta
  - [ ] Update transaction record
  - [ ] Adjust lot quantities
  - [ ] Handle linked transactions (Move)
  - [ ] Validate lot quantities remain valid
  - [ ] Handle success/error states
- [ ] Add widget tests

### Transaction Deletion
- [ ] Implement deletion confirmation dialog
  - [ ] Show warning message
  - [ ] Show impact on lot quantity
  - [ ] For Move: warn about linked transaction
  - [ ] Add confirm and cancel buttons
- [ ] Implement deletion logic
  - [ ] Reverse lot quantity changes
  - [ ] Delete transaction record
  - [ ] Handle linked transaction (Move)
  - [ ] Reopen lot if was closed
  - [ ] Validate lot quantities
  - [ ] Handle success/error states
- [ ] Add widget tests

### Quantity Update Service
- [x] Create TransactionService
  - [x] updateLotQuantities method
  - [ ] calculateQuantityDelta method
  - [x] validateQuantityChange method
  - [ ] autoCloseLot method
  - [ ] reopenLot method
- [x] Implement atomic updates
  - [x] Use Firestore transactions
  - [x] Ensure consistency
  - [ ] Handle rollback on failure
- [x] Add comprehensive error handling
- [ ] Add unit tests

### Move Transaction Service
- [ ] Create MoveTransactionService
  - [ ] createMoveTransaction method
  - [ ] Create both transactions atomically
  - [ ] Link transactions via related_transaction_id
  - [ ] Update both lot quantities
  - [ ] Validate both lots
  - [ ] Handle rollback on failure
- [ ] Implement linked transaction queries
  - [ ] Find related transaction
  - [ ] Display both transactions together
- [ ] Add unit tests

### Financial Tracking
- [ ] Calculate financial metrics
  - [ ] Total purchases (Buy transactions)
  - [ ] Total sales (Sell transactions)
  - [ ] Net profit/loss
  - [ ] Average purchase price
  - [ ] Average sale price
  - [ ] Profit per head
- [ ] Create FinancialService
  - [ ] Aggregate transaction values
  - [ ] Calculate metrics by date range
  - [ ] Calculate metrics by lot
  - [ ] Generate financial reports
- [ ] Display financial data
  - [ ] In lot details
  - [ ] In farm dashboard
  - [ ] In reports section
- [ ] Add unit tests

### Transaction History Timeline
- [ ] Create TransactionTimelineWidget
  - [ ] Display chronological timeline
  - [ ] Group by date
  - [ ] Show transaction cards
  - [ ] Add icons for transaction types
  - [ ] Add expand/collapse
  - [ ] Show running quantity total
- [ ] Add date grouping
  - [ ] Today
  - [ ] Yesterday
  - [ ] This week
  - [ ] This month
  - [ ] By month/year
- [ ] Add widget tests

### Validation & Business Rules
- [x] Transaction quantity validation
  - [x] > 0 for all types
  - [x] <= current quantity for Sell, Move, Die
- [x] Weight validation
  - [x] > 0 if provided
  - [ ] Reasonable range (e.g., 50-1000 kg)
- [x] Value validation
  - [x] >= 0
  - [ ] Reasonable range
- [x] Date validation
  - [x] Not in future
  - [x] After lot start date
  - [ ] Before lot end date (if closed)
- [x] Lot validation
  - [x] Lot must be active for new transactions
  - [ ] Cannot exceed capacity
- [ ] Move transaction validation
  - [ ] Source and destination must be different
  - [ ] Both lots must exist
  - [ ] Destination lot must be active
  - [ ] Cattle types should match (warning)

### Permission Checks
- [ ] Implement transaction permission checks
  - [x] Create: All person types can create
  - [ ] Edit: Owner, Manager can edit
  - [ ] Delete: Owner, Manager can delete
  - [x] View: All can view
  - [ ] Admin can override
- [ ] Add UI permission guards
- [ ] Add backend validation

### State Management
- [x] Create TransactionState
  - [x] TransactionInitial
  - [x] TransactionLoading
  - [x] TransactionLoaded
  - [ ] TransactionDetailsLoaded
  - [x] TransactionError
  - [ ] TransactionOperationInProgress
  - [x] TransactionOperationSuccess
  - [x] TransactionOperationFailure
- [x] Create TransactionEvent
  - [x] LoadTransactions
  - [ ] LoadTransactionDetails
  - [x] CreateBuyTransaction
  - [x] CreateSellTransaction
  - [ ] CreateMoveTransaction
  - [x] CreateDieTransaction
  - [ ] UpdateTransaction
  - [ ] DeleteTransaction
  - [ ] FilterTransactions
- [x] Implement TransactionBloc
  - [x] Handle all events
  - [x] Emit appropriate states
  - [x] Call service methods
  - [x] Handle errors

### Internationalization
- [x] Add translation keys
  - [x] transaction_list_title
  - [x] transaction_create_title
  - [ ] transaction_details_title
  - [x] transaction_type_buy
  - [x] transaction_type_sell
  - [x] transaction_type_move
  - [x] transaction_type_die
  - [x] transaction_quantity_label
  - [x] transaction_weight_label
  - [x] transaction_value_label
  - [x] transaction_date_label
  - [ ] Validation messages
  - [ ] Confirmation messages
  - [ ] Error messages

### Testing
- [ ] Unit tests for TransactionBloc
  - [ ] Test all transaction types
  - [ ] Test state transitions
  - [ ] Mock repositories and services
- [ ] Unit tests for TransactionService
  - [ ] Test quantity updates
  - [ ] Test validation logic
  - [ ] Test auto-close logic
- [ ] Unit tests for MoveTransactionService
  - [ ] Test linked transaction creation
  - [ ] Test atomic updates
  - [ ] Test rollback scenarios
- [ ] Unit tests for FinancialService
  - [ ] Test calculations
  - [ ] Test aggregations
- [ ] Widget tests for screens
  - [ ] Test TransactionListScreen
  - [ ] Test TransactionFormScreen (all types)
  - [ ] Test TransactionDetailsScreen
- [ ] Integration tests
  - [ ] Test complete Buy flow
  - [ ] Test complete Sell flow
  - [ ] Test complete Move flow
  - [ ] Test complete Die flow
  - [ ] Test lot auto-close
  - [ ] Test quantity consistency
- [ ] Target: >70% coverage

## UI Screens

### Transaction List

```
┌─────────────────────────────────┐
│  ←  Transactions             [+]│
├─────────────────────────────────┤
│  [All] [Buy] [Sell] [Move] [Die]│
│                                 │
│  Today                          │
│  ┌─────────────────────────┐   │
│  │ ⊕ Buy              +10  │   │
│  │ 220 kg avg • R$ 5,000   │   │
│  │ 10:30 AM                │   │
│  └─────────────────────────┘   │
│                                 │
│  Yesterday                      │
│  ┌─────────────────────────┐   │
│  │ ↔ Move Out          -5  │   │
│  │ 240 kg avg • To Lot B   │   │
│  │ 02:15 PM                │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ $ Sell             -15  │   │
│  │ 280 kg avg • R$ 12,600  │   │
│  │ 09:00 AM                │   │
│  └─────────────────────────┘   │
│                                 │
│  This Week                      │
│  ┌─────────────────────────┐   │
│  │ ✝ Die               -2  │   │
│  │ Disease outbreak        │   │
│  │ Mon 11:45 AM            │   │
│  └─────────────────────────┘   │
│                                 │
└─────────────────────────────────┘
```

### Transaction Type Selection

```
┌─────────────────────────────────┐
│  ←  New Transaction             │
├─────────────────────────────────┤
│                                 │
│  Select Transaction Type:       │
│                                 │
│  ┌─────────────────────────┐   │
│  │  ⊕  Buy Cattle          │   │
│  │  Purchase new cattle    │   │
│  │  and add to lot         │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │  $  Sell Cattle         │   │
│  │  Sell cattle and        │   │
│  │  remove from lot        │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │  ↔  Move Cattle         │   │
│  │  Transfer between       │   │
│  │  lots in farm           │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │  ✝  Record Death        │   │
│  │  Register cattle        │   │
│  │  mortality              │   │
│  └─────────────────────────┘   │
│                                 │
└─────────────────────────────────┘
```

### Buy Transaction Form

```
┌─────────────────────────────────┐
│  ←  Buy Transaction             │
├─────────────────────────────────┤
│                                 │
│  Lot: Bezerros 2025-1           │
│  Current: 45 head               │
│                                 │
│  Quantity (head) *              │
│  ┌─────────────────────────┐   │
│  │ 10                      │   │
│  └─────────────────────────┘   │
│  After: 55 head                 │
│                                 │
│  Average Weight (kg) *          │
│  ┌─────────────────────────┐   │
│  │ 220                     │   │
│  └─────────────────────────┘   │
│                                 │
│  Total Value (R$) *             │
│  ┌─────────────────────────┐   │
│  │ 5,000.00                │   │
│  └─────────────────────────┘   │
│  R$ 500.00 per head             │
│                                 │
│  Date *                         │
│  [2025-10-07 10:30]             │
│                                 │
│  Description                    │
│  ┌─────────────────────────┐   │
│  │ Bought from Farm XYZ    │   │
│  └─────────────────────────┘   │
│                                 │
│           [Cancel]  [Buy]       │
│                                 │
└─────────────────────────────────┘
```

### Move Transaction Form

```
┌─────────────────────────────────┐
│  ←  Move Transaction            │
├─────────────────────────────────┤
│                                 │
│  From Lot *                     │
│  ┌─────────────────────────┐   │
│  │ Bezerros 2025-1 (45)    ▼│  │
│  └─────────────────────────┘   │
│                                 │
│  To Lot *                       │
│  ┌─────────────────────────┐   │
│  │ Novilhos Q1 (30)        ▼│  │
│  └─────────────────────────┘   │
│                                 │
│  Quantity (head) *              │
│  ┌─────────────────────────┐   │
│  │ 5                       │   │
│  └─────────────────────────┘   │
│                                 │
│  Impact Preview:                │
│  • Bezerros 2025-1: 45 → 40    │
│  • Novilhos Q1: 30 → 35        │
│                                 │
│  Average Weight (kg) *          │
│  ┌─────────────────────────┐   │
│  │ 240                     │   │
│  └─────────────────────────┘   │
│                                 │
│  Date *                         │
│  [2025-10-07 14:15]             │
│                                 │
│  Reason                         │
│  ┌─────────────────────────┐   │
│  │ Age-appropriate lot     │   │
│  └─────────────────────────┘   │
│                                 │
│           [Cancel]  [Move]      │
│                                 │
└─────────────────────────────────┘
```

## Code Examples

### TransactionService

```dart
class TransactionService {
  final TransactionRepository _transactionRepo;
  final CattleLotRepository _lotRepo;
  final FirebaseFirestore _firestore;

  TransactionService({
    required TransactionRepository transactionRepo,
    required CattleLotRepository lotRepo,
    FirebaseFirestore? firestore,
  })  : _transactionRepo = transactionRepo,
        _lotRepo = lotRepo,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Transaction> createBuyTransaction({
    required String lotId,
    required int quantity,
    required double averageWeight,
    required double value,
    required DateTime date,
    required String createdBy,
    String? description,
  }) async {
    return await _firestore.runTransaction((firestoreTransaction) async {
      // Create transaction
      final transaction = Transaction(
        id: uuid.v4(),
        lotId: lotId,
        farmId: '', // Get from lot
        type: TransactionType.buy,
        quantity: quantity,
        averageWeight: averageWeight,
        value: value,
        description: description ?? '',
        date: date,
        createdAt: DateTime.now(),
        createdBy: createdBy,
      );

      // Get current lot
      final lot = await _lotRepo.getById(lotId);

      // Update lot quantity
      final updatedLot = lot.copyWith(
        qtdAdded: lot.qtdAdded + quantity,
        updatedAt: DateTime.now(),
      );

      // Save both atomically
      await _transactionRepo.create(transaction);
      await _lotRepo.update(updatedLot);

      return transaction;
    });
  }

  Future<Transaction> createSellTransaction({
    required String lotId,
    required int quantity,
    required double averageWeight,
    required double value,
    required DateTime date,
    required String createdBy,
    String? description,
  }) async {
    return await _firestore.runTransaction((firestoreTransaction) async {
      // Get current lot
      final lot = await _lotRepo.getById(lotId);

      // Validate quantity available
      if (quantity > lot.currentQuantity) {
        throw Exception('Insufficient quantity in lot');
      }

      // Create transaction
      final transaction = Transaction(
        id: uuid.v4(),
        lotId: lotId,
        farmId: lot.farmId,
        type: TransactionType.sell,
        quantity: quantity,
        averageWeight: averageWeight,
        value: value,
        description: description ?? '',
        date: date,
        createdAt: DateTime.now(),
        createdBy: createdBy,
      );

      // Update lot quantity
      final newQtdRemoved = lot.qtdRemoved + quantity;
      final newCurrentQty = lot.qtdAdded - newQtdRemoved;

      final updatedLot = lot.copyWith(
        qtdRemoved: newQtdRemoved,
        updatedAt: DateTime.now(),
        // Auto-close if quantity reaches 0
        endDate: newCurrentQty == 0 ? DateTime.now() : lot.endDate,
      );

      // Save both atomically
      await _transactionRepo.create(transaction);
      await _lotRepo.update(updatedLot);

      return transaction;
    });
  }

  Future<MoveTrans actionResult> createMoveTransaction({
    required String sourceLotId,
    required String destinationLotId,
    required int quantity,
    required double averageWeight,
    required DateTime date,
    required String createdBy,
    String? description,
  }) async {
    return await _firestore.runTransaction((firestoreTransaction) async {
      // Get both lots
      final sourceLot = await _lotRepo.getById(sourceLotId);
      final destLot = await _lotRepo.getById(destinationLotId);

      // Validate
      if (quantity > sourceLot.currentQuantity) {
        throw Exception('Insufficient quantity in source lot');
      }
      if (!destLot.isActive) {
        throw Exception('Destination lot is closed');
      }

      // Create transaction IDs
      final sourceTransId = uuid.v4();
      final destTransId = uuid.v4();

      // Create source transaction (removal)
      final sourceTransaction = Transaction(
        id: sourceTransId,
        lotId: sourceLotId,
        farmId: sourceLot.farmId,
        type: TransactionType.move,
        quantity: -quantity, // Negative for removal
        averageWeight: averageWeight,
        value: 0,
        description: description ?? 'Moved to ${destLot.name}',
        date: date,
        createdAt: DateTime.now(),
        createdBy: createdBy,
        relatedTransactionId: destTransId,
      );

      // Create destination transaction (addition)
      final destTransaction = Transaction(
        id: destTransId,
        lotId: destinationLotId,
        farmId: destLot.farmId,
        type: TransactionType.move,
        quantity: quantity, // Positive for addition
        averageWeight: averageWeight,
        value: 0,
        description: description ?? 'Moved from ${sourceLot.name}',
        date: date,
        createdAt: DateTime.now(),
        createdBy: createdBy,
        relatedTransactionId: sourceTransId,
      );

      // Update source lot
      final updatedSourceLot = sourceLot.copyWith(
        qtdRemoved: sourceLot.qtdRemoved + quantity,
        updatedAt: DateTime.now(),
        endDate: (sourceLot.qtdAdded - (sourceLot.qtdRemoved + quantity)) == 0
            ? DateTime.now()
            : sourceLot.endDate,
      );

      // Update destination lot
      final updatedDestLot = destLot.copyWith(
        qtdAdded: destLot.qtdAdded + quantity,
        updatedAt: DateTime.now(),
      );

      // Save all atomically
      await _transactionRepo.create(sourceTransaction);
      await _transactionRepo.create(destTransaction);
      await _lotRepo.update(updatedSourceLot);
      await _lotRepo.update(updatedDestLot);

      return MoveTransactionResult(
        sourceTransaction: sourceTransaction,
        destinationTransaction: destTransaction,
      );
    });
  }

  // Implement createDieTransaction similar to createSellTransaction
}

class MoveTransactionResult {
  final Transaction sourceTransaction;
  final Transaction destinationTransaction;

  MoveTransactionResult({
    required this.sourceTransaction,
    required this.destinationTransaction,
  });
}
```

## Validation Rules

### Business Rules
1. Buy: Always increases lot quantity
2. Sell: Quantity must be <= current quantity
3. Move: Creates two linked transactions atomically
4. Die: Quantity must be <= current quantity
5. Auto-close lot when current_quantity = 0
6. Cannot add transactions to closed lot
7. Transaction date cannot be in future
8. Quantity must be > 0 for all types
9. Move: Source and destination must be different lots

### Financial Rules
1. Value >= 0 for all types
2. Buy and Sell must have value > 0
3. Move transactions have value = 0
4. Die transactions can have loss value (optional)

## Completion Criteria

- [ ] All four transaction types working (Buy, Sell, Move, Die)
- [ ] Automatic lot quantity updates functional
- [ ] Move transaction creates linked transactions
- [ ] Auto-close lot when quantity = 0
- [ ] Financial tracking working
- [ ] Transaction history display working
- [ ] All validation rules enforced
- [ ] All tests passing (>70% coverage)
- [ ] Internationalization complete
- [ ] Code reviewed

## Next Step

After completing this step, proceed to:
**[Step 6: Weight Tracking](004-step6-weight-tracking.md)**

---

**Step:** 5/10
**Estimated Time:** 4-5 days
**Dependencies:** Steps 1-4
**Status:** Ready to implement
