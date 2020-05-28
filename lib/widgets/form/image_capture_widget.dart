import 'dart:io';

import 'package:app/constants/app_theme.dart';
import 'package:app/constants/images.dart';
import 'package:app/utils/custom_toast.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/widgets/basic/iconfont_widget.dart';
import 'package:app/widgets/common/lifecycle_listener_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_crop/image_crop.dart';

const num MAX_SIZE = 2 * 1024 * 1024;

class ImageCapture extends StatefulWidget {
  ImageCapture({
    Key key,
    this.widthScale = 1,
    this.heightScale = 1,
    this.tips = '',
    this.onChange,
    this.onSecondChange,
    this.initImg,
  }) : super(key: key);

  final double widthScale;
  final double heightScale;
  final String tips;
  final ValueChanged<File> onChange;
  final ValueChanged<File> onSecondChange;
  final File initImg;

  @override
  _ImageCaptrueState createState() => _ImageCaptrueState();
}

class _ImageCaptrueState extends State<ImageCapture> {
  File _img;

  final cropKey = GlobalKey<CropState>();

  @override
  void initState() {
    super.initState();
    if (widget.initImg != null) {
      setState(() {
        _img = widget.initImg;
      });
    }
  }

  void _cropImage(File imageFile) async {
    File croppedFileV = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(
            ratioX: 9, ratioY: 16),
        maxWidth: 512,
        maxHeight: 512
      // statusBarColor: Color(0xFFF95259)
    );
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(
            ratioX: widget.widthScale, ratioY: widget.heightScale),
        maxWidth: 512,
        maxHeight: 512
      // statusBarColor: Color(0xFFF95259)
    );
    if (croppedFile != null) {
      setState(() {
        _img = croppedFile;
      });
      widget.onChange(croppedFile);
      widget.onSecondChange(croppedFileV);
    }

//    final permissionsGranted = await ImageCrop.requestPermissions();
//    if (!permissionsGranted)
    // 无文件操作权限
//      setState(() {
//        _img = imageFile;
//      });
//      widget.onChange(imageFile);
//      CustomToast.showToast(msg: '没有文件操作权限', gravity: ToastGravity.CENTER);
//      return;
//    }
//    showCupertinoDialog(
//      context: context,
//      builder: (context) {
//        return LifecycleListener(
//          onMounted: () {
//            SystemChrome.setEnabledSystemUIOverlays([
//              SystemUiOverlay.bottom,
//            ]);
//          },
//          onDestory: () {
//            SystemChrome.setEnabledSystemUIOverlays([
//              SystemUiOverlay.top,
//              SystemUiOverlay.bottom,
//            ]);
//          },
//          child: Container(
//            color: AppColors.black,
//            child: Stack(
//              fit: StackFit.expand,
//              children: <Widget>[
//                Crop(
//                  key: cropKey,
//                  image: FileImage(
//                    imageFile,
//                  ),
//                  aspectRatio: widget.widthScale / widget.heightScale,
//                ),
//                Positioned(
//                  bottom: ScreenAdapter.height(10.0),
//                  left: ScreenAdapter.height(12.0),
//                  right: ScreenAdapter.height(12.0),
//                  child: GestureDetector(
//                    behavior: HitTestBehavior.deferToChild,
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        FlatButton(
//                          child: Text(
//                            '取消',
//                            style: TextStyle(
//                              color: AppColors.white,
//                            ),
//                          ),
//                          onPressed: () {
//                            Navigator.of(context).pop();
//                          },
//                        ),
//                        MaterialButton(
//                          color: AppColors.primaryRed,
//                          child: Text(
//                            '确定',
//                            style: TextStyle(
//                              color: AppColors.white,
//                            ),
//                          ),
//                          onPressed: () {
//                            ImageCrop.cropImage(
//                              file: imageFile,
//                              area: cropKey.currentState.area,
//                            ).then((image) {
//                              setState(() {
//                                _img = image;
//                              });
//                              widget.onChange(image);
//                              Navigator.of(context).pop();
//                            });
//                          },
//                        )
//                      ],
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
//        );
//      },
//    );
  }

  void _pickImage(ImageSource _source) async {
    Navigator.of(context).pop();
    File _image = await ImagePicker.pickImage(
      source: _source,
      imageQuality: 50, // 降低图片质量
    );
    if (_image != null) {
      var _enc = await _image.readAsBytes();
      if (_enc.length > MAX_SIZE) {
        CustomToast.showToast(
          msg: '图片过大，请重新选择', gravity: ToastGravity.CENTER
        );
      } else {
        _cropImage(_image);
      }
    }
  }

  Widget _buttonBuilt(@required String text, VoidCallback onPressed) {
    return Container(
      height: ScreenAdapter.height(55.0),
      child: FlatButton(
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.black43,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _imageView;
    if (this._img == null) {
      _imageView = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            Images.icon_round_add,
            width: ScreenAdapter.width(33.0),
            height: ScreenAdapter.width(33.0),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              '${widget.tips}',
              style: TextStyle(
                fontSize: ScreenAdapter.fontSize(14.0),
                color: AppColors.black999,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      );
    } else {
      _imageView = Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.file(
          this._img,
        ),
      );
    }

    final _ActionList = <Widget>[
      _buttonBuilt(
        '拍照',
        () => _pickImage(ImageSource.camera),
      ),
      _buttonBuilt(
        '从相册选择',
        () => _pickImage(ImageSource.gallery),
      ),
    ];
    if (this._img != null) {
      _ActionList.insert(
        0,
        _buttonBuilt(
          '裁剪',
          () {
            Navigator.of(context).pop();
            _cropImage(this._img);
          },
        ),
      );
    }
    return AspectRatio(
      aspectRatio: widget.widthScale / widget.heightScale,
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(6.0 / MediaQuery.of(context).devicePixelRatio),
          ),
          child: FlatButton(
            padding: EdgeInsets.all(0.0),
            color: AppColors.greyF3,
            child: _imageView,
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoActionSheet(
                    cancelButton: _buttonBuilt(
                      '取消',
                      () {
                        Navigator.of(context).pop();
                      },
                    ),
                    actions: _ActionList,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
