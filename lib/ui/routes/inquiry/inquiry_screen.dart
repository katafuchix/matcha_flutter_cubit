import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../model/inquiry/inquiry.dart';
import '../../../model/master/master_data.dart';
import '../../../repository/master_repository.dart';
import '../../../repository/user_repository.dart';
import '../../base/base_stateful_widget.dart';
import '../../components/buttons.dart';
import '../../components/containers.dart';
import '../../components/snack_bar.dart';
import '../../components/texts.dart';
import '../../helper/image_util.dart';
import '../home/app_bars.dart';

class InquiryScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InquirySate();
  }
}

class InquiryScreenResult {
  final String message;
  InquiryScreenResult(this.message);
}

class _InquirySate extends BaseState<InquiryScreen> {
  _InquirySate() : super(null);

  final MasterRepository _masterRepository = MasterRepository();
  final UserRepository _userRepository = UserRepository();
  final List<MasterData> _inquiryData = [];
  String? _selectedKey;
  String? _base64Image;
  TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _masterRepository.getInquiryMaster().then((value) {
      if (!value.isError()) {
        final data = value.getData();
        if (data != null) {
          _inquiryData.addAll(data);
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Scaffold s = Scaffold(
        appBar: buildNormalAppBar(context, 'お問い合わせ'),
        body: GestureDetector(
          onTap: () {
            final FocusScopeNode currentScope = FocusScope.of(context);
            if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  buildNormalText('カテゴリ'),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedKey,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedKey = newValue;
                      });
                    },
                    items: _inquiryData
                        .map((e) => DropdownMenuItem<String>(
                              value: e.name,
                              child: buildNormalText(e.name),
                            ))
                        .toList(),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                      controller: _editingController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          labelText: "お問い合わせ内容",
                          hintText: "例) ○○がわからない。")),
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    children: [
                      buildNormalButton(
                          onPressed: () async {
                            _base64Image = await ImageUtil.base64ImagePicker(
                                context: context);
                            setState(() {});
                          },
                          label: '画像を選択'),
                      _base64Image == null
                          ? Container()
                          : const SizedBox(
                              width: 16,
                            ),
                      _base64Image == null
                          ? Container()
                          : Container(
                              width: 80,
                              height: 80,
                              child: Stack(
                                children: [
                                  Image.memory(
                                    base64Decode(_base64Image!),
                                    width: 80,
                                    height: 80,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _base64Image = null;
                                        });
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                    ],
                  ),
                  buildSmallerText('※画像の添付は任意です。'),
                  const SizedBox(
                    height: 32,
                  ),
                  buildSettingHorizontalFullSizeButton(
                      onPressed: () async {
                        final data = _inquiryData
                            .where((element) => element.name == _selectedKey);
                        if (data.isEmpty) {
                          showErrorSnackBar(context, text: 'カテゴリを選択してください');
                          return;
                        }

                        if (_editingController.text.isEmpty) {
                          showErrorSnackBar(context, text: 'お問い合わせ内容を入力してください');
                          return;
                        }

                        final id = data.first.id;

                        showProgress(context);

                        final result =
                            await _userRepository.postCreateInquiries(Inquiry(
                                id, _editingController.text,
                                base64Image: _base64Image));

                        closeProgressIfNeed(context);

                        if (result.isError()) {
                          showErrorSnackBar(context,
                              text: result.getErrorMessage()!);
                          return;
                        }

                        Navigator.pop(
                            context, InquiryScreenResult('お問い合わせを送信しました'));
                      },
                      label: '送信')
                ],
              ),
            ),
          ),
        ));
    return Containers.createScreenContainer(context, s);
  }
}
