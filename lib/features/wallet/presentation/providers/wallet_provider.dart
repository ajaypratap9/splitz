import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/wallet_remote_datasource.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';

final walletDsProvider = Provider((ref) => WalletRemoteDataSource());
final walletRepoProvider = Provider<WalletRepository>((ref) => WalletRepositoryImpl(ref.read(walletDsProvider)));

final walletBalanceProvider = FutureProvider.family<int, String>((ref, groupId) async => ref.read(walletRepoProvider).getBalance(groupId));

final walletTransactionsProvider = FutureProvider.family<List<WalletTransactionEntity>, String>((ref, groupId) async => ref.read(walletRepoProvider).getTransactions(groupId));

final walletNotifierProvider = Provider.family<WalletNotifier, String>((ref, groupId) => WalletNotifier(ref.read(walletRepoProvider), groupId, ref));

class WalletNotifier {
  final WalletRepository _repo;
  final String groupId;
  final Ref _ref;
  WalletNotifier(this._repo, this.groupId, this._ref);

  Future<void> addMoney(int amount, String? note) async {
    await _repo.addMoney(groupId, amount, note);
    _ref.invalidate(walletBalanceProvider(groupId));
    _ref.invalidate(walletTransactionsProvider(groupId));
  }
}
