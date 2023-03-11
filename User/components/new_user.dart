import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:jillianpos/Models/user.dart';
import 'package:jillianpos/generated/l10n.dart';
import 'package:jillianpos/util/api.dart';
import 'package:jillianpos/util/constants.dart';
import 'package:jillianpos/util/photo_crypt.dart';
import 'package:jillianpos/widgets/button_principal.dart';
import 'package:jillianpos/User/users_screen.dart';
import 'package:jillianpos/util/local_data_controller.dart';
import 'dart:typed_data';
import 'dart:io';

class NewUser extends StatefulWidget{
  const NewUser({Key? key, this.user}) : super(key: key);
  final Users? user;

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  @override
  void initState() {
    if(widget.user != null){
      userFirstName.text = widget.user!.firstName!;
      userLastName.text = widget.user!.lastName!;
      userBirthDate = widget.user!.birthDate;
      userName.text = widget.user!.userName!;
      userEmail.text = widget.user!.email!;
      userPassword.text = widget.user!.password!;
      userRoll = widget.user!.rol;
      userStatus = widget.user!.status;
    }
    super.initState();
  }

  @override
  void dispose(){
    userFirstName.dispose();
    userLastName.dispose();
    userName.dispose();
    userEmail.dispose();
    userPassword.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  String? imageBase64;
  final picker = ImagePicker();
  final TextEditingController userFirstName = TextEditingController();
  final TextEditingController userLastName = TextEditingController();
  DateTime? userBirthDate;
  final TextEditingController userName = TextEditingController(text: "GUEST");
  final TextEditingController userEmail = TextEditingController();
  final TextEditingController userPassword = TextEditingController(text: "123456");
  Roles? userRoll = Roles(rolID: 2, rolName: "CASHIER");
  bool userStatus = true;
  bool modImage = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4 * kDefaultSize),
            child: Column(
              children: [
                const SizedBox(height: kDefaultSize * 2),
                Text(
                  S.of(context).newUser.capitalize(),
                  style: Theme.of(context).textTheme.headline5!.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: kDefaultSize * 2),
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC4C4C4),
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                      image: (widget.user == null)
                          ? (imageBase64 == null)
                            ? const AssetImage('assets/img/defaultImage.png')
                            : ImageConverter.memoryImageFromBase64String(imageBase64!) as ImageProvider
                          : (widget.user!.photoPath!.isEmpty && !modImage)
                            ? const AssetImage('assets/img/defaultImage.png')
                            : (!modImage)
                              ? FileImage(File((LocalDataController.localDirectory?.path ?? "") + constPathImages + widget.user!.photoPath!))
                              : ImageConverter.memoryImageFromBase64String(imageBase64!) as ImageProvider,
                      fit: BoxFit.cover
                    )
                  ),
                ),
                const SizedBox(height: kDefaultSize),
                ButtonPrincipal(
                  actionTap: (){
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(S.of(context).chooseOption.capitalize(), style: const TextStyle(color: kPrimaryColor),),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.photo_camera),
                                onPressed: () async {
                                  _pickImage(true);
                                  Navigator.pop(context);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.photo),
                                onPressed: () async {
                                  _pickImage(false);
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        );
                      }
                    );
                  },
                  text: (imageBase64 == null && widget.user == null) || (widget.user != null && widget.user!.photoPath!.isEmpty && !modImage)
                      ? S.of(context).addPhoto
                      : S.of(context).modifyPhoto
                ),
                const SizedBox(height: kDefaultSize * 2),
                TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: Text(S.of(context).firstName.capitalize()),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    prefixIcon: const Icon(Icons.account_circle, color: kPrimaryColor,),
                    hintText: S.of(context).dataExample(S.of(context).firstName).capitalize() + " Jhon",),
                  controller: userFirstName,
                  validator: (value) {
                    if (value == null || value.isEmpty) return S.of(context).enterSomeText.capitalize();
                    return null;
                  },
                ),
                const SizedBox(height: kDefaultSize * 2),
                TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: Text(S.of(context).lastName.capitalize()),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    prefixIcon: const Icon(Icons.account_circle, color: kPrimaryColor,),
                    hintText: S.of(context).dataExample(S.of(context).lastName).capitalize() + ' Doe',),
                  controller: userLastName,
                  validator: (value) {
                    if (value == null || value.isEmpty) return S.of(context).enterSomeText.capitalize();
                    return null;
                  },
                ),
                const SizedBox(height: kDefaultSize * 2),
                DateTimeField(
                  textInputAction: TextInputAction.next,
                  onChanged: (newTime) => setState(() => userBirthDate = newTime),
                  initialValue: userBirthDate,
                  decoration: InputDecoration(
                    label: Text(S.of(context).birthdate.capitalize()),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    prefixIcon: const Icon(Icons.calendar_today, color: kPrimaryColor,),
                    hintText: S.of(context).dataExample(S.of(context).birthdate).capitalize() + " 1999-05-21",),
                  validator: (value) {
                    if (value == null) return S.of(context).enterSomeText.capitalize();
                    if (!value.isAfter(DateTime.now())) S.of(context).enterValidData(S.of(context).birthdate).capitalize();
                    return null;
                  },
                  format: DateFormat("MM-dd-yyyy"),
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100)
                    );
                  },
                ),
                const SizedBox(height: kDefaultSize * 2),
                TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: Text(S.of(context).userName.capitalize()),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    prefixIcon: const Icon(Icons.person_outline, color: kPrimaryColor,),
                    hintText: S.of(context).dataExample(S.of(context).userName).capitalize() + ' JDoe123',),
                  controller: userName,
                  validator: (value) {
                    if (value == null || value.isEmpty) return S.of(context).enterSomeText.capitalize();
                    return null;
                  },
                ),
                const SizedBox(height: kDefaultSize * 2),
                TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: Text(S.of(context).email.capitalize()),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    prefixIcon: const Icon(Icons.alternate_email, color: kPrimaryColor,),
                    hintText: S.of(context).dataExample(S.of(context).email).capitalize() + ' email@email.com',),
                  controller: userEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) return S.of(context).enterSomeText.capitalize();
                    return null;
                  },
                ),
                const SizedBox(height: kDefaultSize * 2),
                TextFormField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    label: Text(S.of(context).password.capitalize()),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    prefixIcon: const Icon(Icons.password, color: kPrimaryColor,),
                    hintText: S.of(context).dataExample(S.of(context).password).capitalize() + ' 123456',),
                  controller: userPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) return S.of(context).enterSomeText.capitalize();
                    RegExp regex = RegExp("/d");
                    if (!regex.hasMatch(value) && value.length != 6) return S.of(context).enterValidData(S.of(context).password).capitalize();
                    return null;
                  },
                ),
                const SizedBox(height: kDefaultSize * 2),
                DropdownSearch<Roles>(
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                  ),
                  selectedItem: userRoll,
                  asyncItems: (filter) async => API.getRolesAPI(context),
                  onChanged: (value) => userRoll = value,
                  itemAsString: (item) => item.rolName!,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      label: Text(S.of(context).rol.capitalize()),
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                      prefixIcon: const Icon(Icons.folder_special, color: kPrimaryColor,),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      hintText: S.of(context).dataExample(S.of(context).rol).capitalize() + ' Admin',),
                  ),
                  validator: (value) {
                    if (value == null) return S.of(context).enterSomeText.capitalize();
                    return null;
                  },
                ),
                const SizedBox(height: kDefaultSize * 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).status.capitalize()),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: Text(S.of(context).active.capitalize()),
                            value: true,
                            groupValue: userStatus,
                            onChanged: (value) => setState(() => userStatus = value!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: Text(S.of(context).inactive.capitalize()),
                            value: false,
                            groupValue: userStatus,
                            onChanged: (value) => setState(() => userStatus = value!),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: kDefaultSize * 2),
                ButtonPrincipal(
                  text: S.of(context).save,
                  actionTap: () => createEditUser(context),
                  sizeText: 16,
                  width: 150,
                  height: 50,
                ),
                const SizedBox(height: kDefaultSize * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createEditUser(BuildContext context) async {
    try{
      if (formKey.currentState!.validate()) {
        Users user = Users(
          userName: userName.text,
          userID: widget.user?.userID,
          photoPath: widget.user == null ? (imageBase64 == null ? "" : imageBase64!) : (modImage ? (imageBase64 == null ? "" : imageBase64!) : widget.user!.photoPath),
          firstName: userFirstName.text,
          rol: userRoll!,
          email: userEmail.text,
          status: userStatus,
          lastName: userLastName.text,
          birthDate: userBirthDate,
          password: userPassword.text
        );

        if(widget.user == null){
          EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.custom);
          bool success = await API.createUserAPI(user, context);
          EasyLoading.dismiss();

          if(success){
            await kDefaultAlert(context, S.of(context).dataCreated(S.of(context).user).capitalize(), alertType: AlertType.success).show();
            Navigator.pushNamedAndRemoveUntil(context, UsersScreen.routeName, (route) => false);
          }
          else{
            kDefaultAlert(context, S.of(context).errorOccurred.capitalize(), alertType: AlertType.error).show();
          }
        }
        else{
          EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.custom);
          bool success = await API.editUserAPI(user, modImage, context);
          EasyLoading.dismiss();

          if(success){
            await kDefaultAlert(context, S.of(context).dataModify(S.of(context).user).capitalize(), alertType: AlertType.success).show();
            Navigator.pushNamedAndRemoveUntil(context, UsersScreen.routeName, (route) => false);
          }
          else{
            kDefaultAlert(context, S.of(context).errorOccurred.capitalize(), alertType: AlertType.error).show();
          }
        }
      }
    }
    catch (e){
      EasyLoading.dismiss();
      kDefaultAlert(context, e.toString(), alertType: AlertType.error).show();
    }
  }

  Future<void> _pickImage(bool camera) async {
    final pickedFile = camera ? await picker.pickImage(source: ImageSource.camera) : await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) {
      modImage = true;
      CroppedFile? cropper = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        compressQuality: 60,
        maxHeight: 500,
        maxWidth: 500,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
              toolbarColor: Colors.blue,
              toolbarTitle: S.of(context).recordImage.capitalize(),
              toolbarWidgetColor: Colors.white,
              backgroundColor: Colors.white)
        ]);

      Uint8List imgBase64 = await cropper!.readAsBytes();

      setState(() => imageBase64 = ImageConverter.base64String(imgBase64));
    }
  }
}