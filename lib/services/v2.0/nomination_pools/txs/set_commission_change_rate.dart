import 'package:karma_coin/services/v2.0/nomination_pools/types.dart';
import 'package:karma_coin/services/v2.0/txs/tx.dart';

class KC2SetCommissionChangeRateTxV1 extends KC2Tx {
  PoolId poolId;
  CommissionChangeRate commissionChangeRate;

  KC2SetCommissionChangeRateTxV1(
      {required this.poolId,
      required this.commissionChangeRate,
      required super.args,
      required super.chainError,
      required super.timestamp,
      required super.hash,
      required super.blockNumber,
      required super.blockIndex,
      required super.transactionEvents,
      required super.rawData,
      required super.signer});
}
