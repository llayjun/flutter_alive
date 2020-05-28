import 'package:app/models/dto/adress/address_info_dto.dart';
import 'package:app/models/view/base_vmodel.dart';
import 'package:app/services/edit_addressdetail_service.dart';

class EditAddressDetailVModel extends BaseViewModel {

  final AddressService _addressService = AddressService();

  AddressInfoDTO _addressInfoDTO;
  AddressInfoDTO get addressInfoDTO => _addressInfoDTO;

  /// 获取地址信息
  Future<AddressInfoDTO> getAddressInfo() async {
    _addressInfoDTO = await _addressService.getAddressInfo();
    notifyListeners();
    return _addressInfoDTO;
  }

  /// 修改地址信息
  Future<bool> changeaddress(AddressInfoDTO infoDTO) async{
    return await _addressService.updateUserInfo(infoDTO);
  }

  void setAddressInfo(){

  }

}