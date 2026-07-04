import 'package:get/get.dart';
import 'package:volume_key_board/volume_key_board.dart';

import 'jh_service.dart';

VolumeService volumeService = VolumeService();

class VolumeService extends GetxService with JHLifeCircleBeanErrorCatch implements JHLifeCircleBean {
  Function(VolumeEventType)? _onData;
  bool _isIntercepting = false;

  @override
  Future<void> doInitBean() async {
    Get.put(this, permanent: true);
  }

  @override
  Future<void> doAfterBeanReady() async {}

  @override
  void onClose() {
    super.onClose();
    cancelListen();
  }

  Future<void> setInterceptVolumeEvent(bool value) async {
    _isIntercepting = value;
    if (value && _onData != null) {
      VolumeKeyBoard.instance.addListener(_onVolumeKeyEvent);
    } else {
      VolumeKeyBoard.instance.removeListener();
    }
  }

  void _onVolumeKeyEvent(VolumeKey event) {
    if (event == VolumeKey.up) {
      _onData?.call(VolumeEventType.volumeUp);
    } else if (event == VolumeKey.down) {
      _onData?.call(VolumeEventType.volumeDown);
    }
  }

  void listen(Function(VolumeEventType)? onData) {
    _onData = onData;
    if (_isIntercepting) {
      VolumeKeyBoard.instance.addListener(_onVolumeKeyEvent);
    }
  }

  void cancelListen() {
    VolumeKeyBoard.instance.removeListener();
    _onData = null;
    _isIntercepting = false;
  }
}

enum VolumeEventType { volumeUp, volumeDown }
