import '../entities/wallet_entity.dart';
abstract class WalletRepository {
  Future<List<WalletTransactionEntity>> getTransactions(String groupId);
  Future<int> getBalance(String groupId);
  Future<void> addMoney(String groupId, int amount, String? note);
}
