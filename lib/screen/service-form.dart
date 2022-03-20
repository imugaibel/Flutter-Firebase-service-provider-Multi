import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintenance/utils/extensions.dart';
import '../model/service-model.dart';
import '../styles/input_style.dart';
import '../utils/app_localization.dart';
import '../utils/firebase-manager.dart';
import '../widgets/alert.dart';
import '../widgets/btn-main.dart';

class ServiceForm extends StatefulWidget {

  ServiceModel? udidService;

  ServiceForm({Key? key, this.udidService}) : super(key: key);

  @override
  _ServiceFormState createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();

  late List<String> _images = [];
  late String detailsEN = "";
  late String detailsAR = "";
  late String titleEN = "";
  late String titleAR = "";
  String buttonMode = "ADD";


  @override
  void initState() {
    super.initState();
    if (widget.udidService != null) {
       _images = widget.udidService!.images;
      titleEN = widget.udidService!.titleEN;
      titleAR = widget.udidService!.titleAR;
      detailsEN = widget.udidService!.detailsEN;
      detailsAR = widget.udidService!.detailsAR;
      buttonMode = "UPDATE";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
              tooltip: AppLocalization.of(context)!.translate("Back"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            expandedHeight: MediaQuery
                .of(context)
                .size
                .height * (350 / 812),
            floating: true,
            pinned: true,
            snap: true,
            backgroundColor: Colors.transparent,
            elevation: 5,
            flexibleSpace: FlexibleSpaceBar(
              background: _renderSlider(context, images: _images),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: titleEN,
                        onSaved: (value) => titleEN = value!.trim(),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .secondary,
                        ),
                        decoration: customInputForm
                            .copyWith(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Theme
                                .of(context)
                                .primaryColor,
                          ),
                        )
                            .copyWith(hintText: "titleEN"),
                      ),
                      TextFormField(
                        initialValue: titleAR,
                        onSaved: (value) => titleAR = value!.trim(),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .secondary,
                        ),
                        decoration: customInputForm
                            .copyWith(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Theme
                                .of(context)
                                .primaryColor,
                          ),
                        )
                            .copyWith(hintText: "titleAR"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: detailsEN,
                        onSaved: (value) => detailsEN = value!.trim(),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .secondary,
                        ),
                        decoration: customInputForm
                            .copyWith(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Theme
                                .of(context)
                                .primaryColor,
                          ),
                        )
                            .copyWith(hintText: "detailsEN"),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: detailsAR,
                        onSaved: (value) => detailsAR = value!.trim(),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .secondary,
                        ),
                        decoration: customInputForm
                            .copyWith(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Theme
                                .of(context)
                                .primaryColor,
                          ),
                        )
                            .copyWith(hintText: "detailsAR"),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(
                        height: 20,
                      ),
                      BtnMain(
                          title: buttonMode,
                          onTap: () =>
                          widget.udidService != null
                              ? _section(uid: widget.udidService!.uid)
                              : _section()),

                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  bool validation() {
    return !(titleEN == "" || titleAR == "");
  }

  _section({String uid = ""}) {
    _formKey.currentState!.save();

    if (!validation()) {
      _scaffoldKey.showTosta(
          message: AppLocalization.of(context)!
              .translate("Please fill in all fields"),
          isError: true);
      return;
    }

    FirebaseManager.shared.addOrEditService(context,
        scaffoldKey: _scaffoldKey,
        uid: uid,
        images: _images,
        titleEN: titleEN,
        detailsEN: detailsEN,
        titleAR: titleAR,
        detailsAR: detailsAR);
  }

  _renderSlider(context, {required List<String> images}) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery
            .of(context)
            .size
            .height * (380 / 812),
        enableInfiniteScroll: false,
        autoPlay: true,
        viewportFraction: 1,
      ),
      items: [...images, "empty"].map((item) {
        return Builder(
          builder: (BuildContext context) {
            return item == "empty"
                ? _addImage(context)
                : InkWell(
              onTap: () {
                          showAlertDialog(context,
                              title: AppLocalization.of(context)!
                                  .translate("Delete Image"),
                             message: AppLocalization.of(context)!
                                 .translate("Are you sure to delete the image?"),
                          titleBtnOne: "Delete",
                             titleBtnTwo: "Close", actionBtnOne: () {
                              _deleteImage(item);
                              Navigator.of(context).pop();
                           }, actionBtnTwo: () {
                             Navigator.of(context).pop();
                           });
              },
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  //     image: DecorationImage(
                  //         image: item.isURL()
                  //             ? NetworkImage(item)
                  //              : FileImage(File(item)),
                  //          fit: BoxFit.cover),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _addImage(context) {
    return InkWell(
      onTap: () => _getImage(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Theme
              .of(context)
              .primaryColor),
        ),
        child: Center(
          child: Icon(
            Icons.add,
            size: 56,
            color: Theme
                .of(context)
                .primaryColor,
          ),
        ),
      ),
    );
  }

  _getImage(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
                title: Text(
                  AppLocalization.of(context)!.translate('Camera'),
                  style: TextStyle(color: Theme
                      .of(context)
                      .primaryColor),
                ),
                onTap: () => _selectImage(imageSource: ImageSource.camera),
              ),
              ListTile(
                leading: Icon(
                  Icons.image,
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
                title: Text(
                  AppLocalization.of(context)!.translate('Gallery'),
                  style: TextStyle(color: Theme
                      .of(context)
                      .primaryColor),
                ),
                onTap: () => _selectImage(imageSource: ImageSource.gallery),
              ),
            ],
          );
        });
  }

  _selectImage({required ImageSource imageSource}) async {
    PickedFile? image =
    await ImagePicker.platform.pickImage(source: imageSource);
    setState(() {
      _images.add(image!.path);
    });

    Navigator.of(context).pop();
  }

  _deleteImage(String image) {
    setState(() {
      _images.remove(image);
    });
  }
}
