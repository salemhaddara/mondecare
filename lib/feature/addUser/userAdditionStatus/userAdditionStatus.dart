abstract class userAdditionStatus {}

class waitingrequest extends userAdditionStatus {}

class loadingrequest extends userAdditionStatus {}

class successInsertion extends userAdditionStatus {}

class failedInsertion extends userAdditionStatus {
  String exception;
  failedInsertion(this.exception);
}
