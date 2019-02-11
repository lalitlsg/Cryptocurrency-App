import 'package:cryptoapp/data/crypto_data.dart';
import 'package:cryptoapp/dependency_injection.dart';

abstract class CryptoListViewContract{
  void onLoadCryptoComplete(List<Crypto> items);
  void onLoadCryptoError();
}

class CryptoListPresenter {
    CryptoListViewContract _view;
    CryptoRepository _repository;

    CryptoListPresenter(this._view){
      _repository  = Injector().cryptoRepository;

    }

    void loadCurrencies(){
      _repository.fetchCurrencies()
          .then((c) => _view.onLoadCryptoComplete(c))
          .catchError((onError) => _view.onLoadCryptoError());
    }
}