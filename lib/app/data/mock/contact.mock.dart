import 'package:agree_n/app/data/models/contact.model.dart';

abstract class ContactMock {
  static ContactRateModel getTenant() {
    return ContactRateModel(
      id: 1,
      contactName: "VINH HIEP CO.LTD",
      createdDate: new DateTime(2020, 01, 01),
      numberOfContracts: 20,
      contactScore: 98.0,
      contactRates: [
        new ContactScoreModel(scoreTypeId: 1, value: 82.0),
        new ContactScoreModel(scoreTypeId: 2, value: 85.0),
        new ContactScoreModel(scoreTypeId: 3, value: 99.0),
        new ContactScoreModel(scoreTypeId: 4, value: 100.0),
        new ContactScoreModel(scoreTypeId: 5, value: 100.0)
      ],
    );
  }
}
