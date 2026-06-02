import 'package:hydrao_flutter_offline/constants.dart';
import 'package:hydrao_flutter_offline/models/shower_stats.dart';
import 'package:hydrao_flutter_offline/repositories/db/db_repository.dart';

class SavingsParams {
  final double waterPrice;
  final double energyPrice;
  final double heatingEnergy;

  const SavingsParams({
    required this.waterPrice,
    required this.energyPrice,
    required this.heatingEnergy,
  });
}

class SavingsStats {
  final double savedWaterVolume; // in liters
  final double savedEnergyQuantity; // in Kwh
  final double savedWaterMoney;
  final double savedEnergyMoney;
  final double savedTotalMoney;
  final double usedWaterVolume; // hydrao water consumption
  final double usedWaterMoney; // hydrao water cost
  final double usedEnergyQuantity; // hydrao energy consumption
  final double usedEnergyMoney; // hydrao energy cost
  final int showersCount;

  const SavingsStats({
    required this.savedWaterVolume,
    required this.savedEnergyQuantity,
    required this.savedWaterMoney,
    required this.savedEnergyMoney,
    required this.savedTotalMoney,
    required this.usedWaterVolume,
    required this.usedWaterMoney,
    required this.usedEnergyQuantity,
    required this.usedEnergyMoney,
    required this.showersCount,
  });

  double get oldTotalVolume => usedWaterVolume + savedWaterVolume;
  double get oldWaterMoney => usedWaterMoney + savedWaterMoney;
  double get oldEnergyQuantity => usedEnergyQuantity + savedEnergyQuantity;
  double get oldEnergyMoney => usedEnergyMoney + savedEnergyMoney;

  /// between 0 and 1
  num get savingPourcent {
    if (oldTotalVolume == 0) return 0;

    return savedWaterVolume / oldTotalVolume;
  }

  static SavingsStats from(
    Showerhead sh,
    List<Shower> showers,
    SavingsParams params,
  ) {
    if (showers.isEmpty) {
      return none();
    }

    // prepare sh ref volume
    final refDuration = sh.refShowerDuration ?? AppConstants.refShowerDuration;
    final previousFlow =
        sh.previousFlow ?? AppConstants.getDefaultFlowFromType(sh.type);

    final refVolume = (refDuration / 60) * previousFlow;
    // appLogger.d(
    //   '[SAVINGS_STATS] reference : duration=$refDuration, prevFlow=$previousFlow, volume=$refVolume',
    // );

    // prepare water volume
    final ShowerStats stats = ShowerStats.fromShowers(showers);

    double hydraoWaterVolume = stats.totalVolume.toDouble();
    final oldWaterVolume = showers.length * refVolume;

    double savedWaterVolume = oldWaterVolume - hydraoWaterVolume;
    if (savedWaterVolume < 0) savedWaterVolume = 0;

    // --- prepare water money (in liters)
    double savedWaterMoney = 0;
    if (savedWaterVolume > 0) {
      // waterPrice = price for 1 m3 (so 1000 liters)
      savedWaterMoney = (savedWaterVolume / 1000) * params.waterPrice;
    }
    double hydraoWaterMoney = (hydraoWaterVolume / 1000) * params.waterPrice;

    // --- prepare energy quantity (in Kwh)
    // heatingEnergy = Kwh needed for heating 1 liter ???
    double savedEnergyQuantity = 0;
    if (savedWaterVolume > 0) {
      savedEnergyQuantity = savedWaterVolume * params.heatingEnergy;
    }
    double hydraoEnergyQuantity = (hydraoWaterVolume > 0)
        ? hydraoWaterVolume * params.heatingEnergy
        : 0;

    // --- prepare energy money (in country currency)
    double savedEnergyMoney = 0;
    if (savedEnergyQuantity > 0) {
      savedEnergyMoney = savedEnergyQuantity * params.energyPrice;
    }
    double hydraoEnergyMoney = (hydraoEnergyQuantity > 0)
        ? hydraoEnergyQuantity * params.energyPrice
        : 0;

    // --- prepare total money (in country currency)
    double savedTotalMoney = savedWaterMoney + savedEnergyMoney;

    return SavingsStats(
      savedWaterVolume: savedWaterVolume,
      savedEnergyQuantity: savedEnergyQuantity,
      savedWaterMoney: savedWaterMoney,
      savedEnergyMoney: savedEnergyMoney,
      savedTotalMoney: savedTotalMoney,
      usedWaterVolume: hydraoWaterVolume,
      usedWaterMoney: hydraoWaterMoney,
      usedEnergyQuantity: hydraoEnergyQuantity,
      usedEnergyMoney: hydraoEnergyMoney,
      showersCount: showers.length,
    );
  }

  static SavingsStats none() {
    return const SavingsStats(
      savedWaterVolume: 0,
      savedEnergyQuantity: 0,
      savedWaterMoney: 0,
      savedEnergyMoney: 0,
      savedTotalMoney: 0,
      usedWaterVolume: 0,
      usedWaterMoney: 0,
      usedEnergyQuantity: 0,
      usedEnergyMoney: 0,
      showersCount: 0,
    );
  }

  SavingsStats add(SavingsStats otherStats) {
    return SavingsStats(
      savedWaterVolume: savedWaterVolume + otherStats.savedWaterVolume,
      savedEnergyQuantity: savedEnergyQuantity + otherStats.savedEnergyQuantity,
      savedWaterMoney: savedWaterMoney + otherStats.savedWaterMoney,
      savedEnergyMoney: savedEnergyMoney + otherStats.savedEnergyMoney,
      savedTotalMoney: savedTotalMoney + otherStats.savedTotalMoney,
      usedWaterVolume: usedWaterVolume + otherStats.usedWaterVolume,
      usedWaterMoney: usedWaterMoney + otherStats.usedWaterMoney,
      usedEnergyQuantity: usedEnergyQuantity + otherStats.usedEnergyQuantity,
      usedEnergyMoney: usedEnergyMoney + otherStats.usedEnergyMoney,
      showersCount: showersCount + otherStats.showersCount,
    );
  }
}
