import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_datasource.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource _ds;
  WalletRepositoryImpl(this._ds);
  @override Future<List<WalletTransactionEntity>> getTransactions(String groupId) => _ds.getTransactions(groupId);
  @override Future<int> getBalance(String groupId) => _ds.getBalance(groupId);
  @override Future<void> addMoney(String groupId, int amount, String? note) => _ds.addMoney(groupId, amount, note);
}
