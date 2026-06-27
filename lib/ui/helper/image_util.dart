import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:extended_image/extended_image.dart' as ex;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as dart_image;
import 'package:image_picker/image_picker.dart';

import '../../core/colors.dart';
import '../../core/my_logger.dart';
import '../../core/my_platform.dart';
import '../../ui/base/base_stateful_widget.dart';
import '../../ui/components/buttons.dart';
import '../../ui/components/containers.dart';
import '../components/widget_circular_progress.dart';
import '../routes/home/app_bars.dart';

class ImageUtil {
  static Future<String?> base64ImagePicker({BuildContext? context}) async {
    AppColors colors = getAppColors();
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return null;
    }
    if (context != null) {
      final bytes = await pickedFile.readAsBytes();
      final result =
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ImageEditorScreen(bytes);
      }));
      if (result is CroppedResult) {
        return base64Encode(result.data);
      }
      return null;
    }
    return null;
  }
}

class CroppedResult {
  final Uint8List data;

  CroppedResult(this.data);
}

class ImageEditorScreen extends BaseStatefulWidget {
  final Uint8List imageBinary;

  ImageEditorScreen(this.imageBinary);

  @override
  State<StatefulWidget> createState() {
    return _ImageEditorState(imageBinary);
  }
}

class _ImageEditorState extends BaseState<ImageEditorScreen> {
  final GlobalKey<ex.ExtendedImageEditorState> editorKey =
      GlobalKey<ex.ExtendedImageEditorState>();
  final Uint8List imageBinary;
  bool _showProgress = false;

  _ImageEditorState(this.imageBinary);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Containers.createScreenContainer(context, _buildMainWidget());
  }

  Widget _buildMainWidget() {
    final c = Container(
      child: Material(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(child: _buildEditor()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildNormalButton(onPressed: _onPressOk, label: '決定'),
                  buildNormalButton(
                      onPressed: _onPressRest, label: 'リセット', alert: true),
                  IconButton(
                      onPressed: _onPressRotateLeft,
                      icon: Icon(Icons.rotate_left_outlined)),
                  IconButton(
                      onPressed: _onPressRotateRight,
                      icon: Icon(Icons.rotate_right_outlined)),
                ],
              )
            ],
          ),
        ),
      ),
    );

    final s = Scaffold(
      appBar: buildNormalAppBar(context, 'リサイズ'),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          c,
          _showProgress ? buildWidgetCircularProgress() : Container(),
        ],
      ),
    );

    return s;
  }

  Widget _buildEditor() {
    // return ex.ExtendedImage(
    //   image: ex.ExtendedResizeImage(
    //     ex.ExtendedMemoryImageProvider(imageBinary, cacheRawData: false),
    //     compressionRatio: 0.9,
    //     maxBytes: null,
    //     width: null,
    //     height: null,
    //   ),
    //   fit: BoxFit.contain,
    //   mode: ex.ExtendedImageMode.editor,
    //   extendedImageEditorKey: editorKey,
    //   initEditorConfigHandler: (state) {
    //     return ex.EditorConfig(
    //         maxScale: 8.0,
    //         cropRectPadding: EdgeInsets.all(20.0),
    //         hitTestSize: 20.0,
    //         cropAspectRatio: 1);
    //   },
    // );
    return ex.ExtendedImage.memory(
      imageBinary,
      fit: BoxFit.contain,
      cacheRawData: true,
      maxBytes: MyPlatform.isMobileApp ? 1024 * 1024 /* 1MB */ : null,
      // compressionRatio: 0.5,
      mode: ex.ExtendedImageMode.editor,
      extendedImageEditorKey: editorKey,
      initEditorConfigHandler: (state) {
        return ex.EditorConfig(
            maxScale: 8.0,
            cropRectPadding: EdgeInsets.all(20.0),
            hitTestSize: 20.0,
            cropAspectRatio: 1);
      },
    );
  }

  Future _onPressOk() async {
    _showProgressImpl();

    await Future.delayed(Duration(milliseconds: 300));

    final Uint8List? data =
        await cropImageDataWithDartLibrary(state: editorKey.currentState!);

    _closeProgressImpl();

    if (data == null) {
      MyLogger.d('画像 is null');
      Navigator.pop(context);
      return;
    }
    MyLogger.d('画像 返す');
    Navigator.pop(context, CroppedResult(data));
  }

  _onPressRest() {
    editorKey.currentState?.reset();
  }

  _onPressRotateLeft() {
    editorKey.currentState?.rotate(right: false);
  }

  _onPressRotateRight() {
    editorKey.currentState?.rotate(right: true);
  }

  _showProgressImpl() {
    setState(() {
      _showProgress = true;
    });
  }

  _closeProgressImpl() {
    setState(() {
      _showProgress = false;
    });
  }

  Future<Uint8List?> cropImageDataWithDartLibrary(
      {required ex.ExtendedImageEditorState state}) async {
    print('dart library start cropping');

    if (state.widget.extendedImageState.imageWidget.image
        is ex.ExtendedNetworkImageProvider) return null;

    ///crop rect base on raw image
    final Rect? cropRect = state.getCropRect();

    print('getCropRect : $cropRect');

    // in web, we can't get rawImageData due to .
    // using following code to get imageCodec without download it.
    // final Uri resolved = Uri.base.resolve(key.url);
    // // This API only exists in the web engine implementation and is not
    // // contained in the analyzer summary for Flutter.
    // return ui.webOnlyInstantiateImageCodecFromUrl(
    //     resolved); //

    final Uint8List? data = MyPlatform.isWeb
        ? state.rawImageData
        :

        ///toByteData is not work on web
        ///https://github.com/flutter/flutter/issues/44908
        (await state.image?.toByteData(format: ImageByteFormat.png))
            ?.buffer
            .asUint8List();

    if (data == null) return null;

    final ex.EditActionDetails editAction = state.editAction!;

    final DateTime time1 = DateTime.now();

    // image v4: decodeImage handles both single frames and animations
    dart_image.Image? src;
    if (MyPlatform.isWeb) {
      src = dart_image.decodeImage(data);
    } else {
      src = await compute(dart_image.decodeImage, data);
    }

    if (src != null) {
      final DateTime time2 = DateTime.now();

      src = dart_image.bakeOrientation(src);

      if (editAction.needCrop && cropRect != null) {
        src = dart_image.copyCrop(
            src,
            x: cropRect.left.toInt(),
            y: cropRect.top.toInt(),
            width: cropRect.width.toInt(),
            height: cropRect.height.toInt());
      }

      if (editAction.needFlip) {
        late dart_image.FlipDirection direction;
        if (editAction.flipY && editAction.flipX) {
          direction = dart_image.FlipDirection.both;
        } else if (editAction.flipY) {
          direction = dart_image.FlipDirection.horizontal;
        } else {
          direction = dart_image.FlipDirection.vertical;
        }
        src = dart_image.flip(src, direction: direction);
      }

      if (editAction.hasRotateAngle) {
        src = dart_image.copyRotate(src, angle: editAction.rotateAngle);
      }

      final DateTime time3 = DateTime.now();
      print('${time3.difference(time2)} : crop/flip/rotate');
    }

    List<int>? fileData;
    print('start encode');
    final DateTime time4 = DateTime.now();
    if (src != null) {
      if (kIsWeb) {
        fileData = dart_image.encodeJpg(src);
      } else {
        fileData = await compute(dart_image.encodeJpg, src);
      }
    }
    final DateTime time5 = DateTime.now();
    print('${time5.difference(time4)} : encode');
    print('${time5.difference(time1)} : total time');
    return Uint8List.fromList(fileData!);
  }
}
