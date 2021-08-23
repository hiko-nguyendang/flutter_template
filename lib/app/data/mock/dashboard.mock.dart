import 'package:faker/faker.dart';
import 'package:agree_n/app/data/models/dashboard.model.dart';

abstract class DashboardMock {
  static List<MarketPriceModel> getMarketPrice() {
    final List<MarketPriceModel> prices = [];
    final extractData = [
      [
        "KCH21",
        126.5,
        -1.6,
        0,
        19142,
        128.8,
        126.5,
        135.15,
        135.15,
        faker.randomGenerator.integer(110000, min: 15000),
        0,
        0,
        0,
        0,
        "08:42:36",
        "05/21"
      ],
      [
        "KCH21",
        128.55,
        -1.45,
        0,
        8855,
        130.8,
        128.55,
        135.15,
        135.15,
        faker.randomGenerator.integer(110000, min: 15000),
        0,
        0,
        0,
        0,
        "08:42:36",
        "07/21"
      ],
      [
        "KCH21",
        130.5,
        -1.1,
        0,
        7005,
        132.7,
        130.5,
        135.15,
        135.15,
        faker.randomGenerator.integer(110000, min: 15000),
        0,
        0,
        0,
        0,
        "08:42:36",
        "09/21"
      ],
      [
        "KCH21",
        132.75,
        -1.1,
        0,
        4248,
        1134.85,
        132.65,
        135.15,
        135.15,
        faker.randomGenerator.integer(110000, min: 15000),
        0,
        0,
        0,
        0,
        "08:42:36",
        "12/21"
      ],
      [
        "KCH21",
        1366,
        -11,
        0,
        6121,
        1388,
        1365,
        135.15,
        135.15,
        faker.randomGenerator.integer(110000, min: 15000),
        0,
        0,
        0,
        0,
        "08:42:36",
        "05/21"
      ],
      [
        "KCH21",
        1390,
        8,
        0,
        3589,
        1410,
        1389,
        135.15,
        135.15,
        faker.randomGenerator.integer(110000, min: 15000),
        0,
        0,
        0,
        0,
        "08:42:36",
        "07/21"
      ],
      [
        "KCH21",
        1409,
        -9,
        0,
        1118,
        1427,
        1408,
        135.15,
        135.15,
        faker.randomGenerator.integer(110000, min: 15000),
        0,
        0,
        0,
        0,
        "08:42:36",
        "09/21"
      ],
      [
        "KCH21",
        1425,
        -9,
        0,
        459,
        1441,
        1424,
        135.15,
        135.15,
        faker.randomGenerator.integer(110000, min: 15000),
        0,
        0,
        0,
        0,
        "08:42:36",
        "11/21"
      ],
    ];

    for (var item in extractData) {
      final priceItem = new MarketPriceModel();
      priceItem.name = item[0];
      priceItem.last = double.parse(item[1].toString());
      priceItem.change = double.parse(item[2].toString());
      priceItem.changePercent = double.parse(item[3].toString());
      priceItem.volume = double.parse(item[4].toString());
      priceItem.high = double.parse(item[5].toString());
      priceItem.low = double.parse(item[6].toString());
      priceItem.open = double.parse(item[7].toString());
      priceItem.previous = double.parse(item[8].toString());
      priceItem.opInt = double.parse(item[9].toString());
      priceItem.bid = double.parse(item[10].toString());
      priceItem.bidSize = double.parse(item[11].toString());
      priceItem.ask = double.parse(item[12].toString());
      priceItem.askSize = double.parse(item[13].toString());
      priceItem.time = item[14];
      priceItem.month = item[15];

      prices.add(priceItem);
    }
    return prices;
  }
}
