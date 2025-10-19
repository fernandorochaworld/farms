import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/enums.dart';
import '../constants/firestore_paths.dart';
import '../models/cattle_lot_model.dart';
import '../models/transaction_model.dart' as model;
import '../repositories/cattle_lot_repository.dart';
import '../repositories/transaction_repository.dart';

class TransactionService {
  final CattleLotRepository _lotRepository;
  final TransactionRepository _transactionRepository;
  final FirebaseFirestore _firestore;

  TransactionService({
    required CattleLotRepository lotRepository,
    required TransactionRepository transactionRepository,
    required FirebaseFirestore firestore,
  })  : _lotRepository = lotRepository,
        _transactionRepository = transactionRepository,
        _firestore = firestore;

  Future<void> createTransaction(model.Transaction transaction) async {
    return _firestore.runTransaction((firestoreTransaction) async {
      final lotRef = _firestore.doc(
        FirestorePaths.cattleLotDocument(transaction.farmId, transaction.lotId),
      );

      final lotSnapshot = await firestoreTransaction.get(lotRef);
      if (!lotSnapshot.exists) {
        throw Exception('Lot not found');
      }

      final lot = CattleLot.fromJson(lotSnapshot.data()!);

      int newQtdAdded = lot.qtdAdded;
      int newQtdRemoved = lot.qtdRemoved;

      if (transaction.type.addsQuantity) {
        newQtdAdded += transaction.quantity;
      } else if (transaction.type.removesQuantity) {
        if (transaction.quantity > lot.currentQuantity) {
          throw Exception('Insufficient quantity in lot');
        }
        newQtdRemoved += transaction.quantity;
      }

      final updatedLot = lot.copyWith(
        qtdAdded: newQtdAdded,
        qtdRemoved: newQtdRemoved,
        updatedAt: DateTime.now(),
      );

      firestoreTransaction.update(lotRef, updatedLot.toJson());

      final transactionRef = _firestore.doc(
        FirestorePaths.transactionDocument(
          transaction.farmId,
          transaction.lotId,
          transaction.id,
        ),
      );
      firestoreTransaction.set(transactionRef, transaction.toJson());
    });
  }
}
