import 'package:flutter/material.dart';
class AppText      extends StatelessWidget {
  const AppText(this.data,{super.key, this.color=Colors.black,
    this.textDecoration=TextDecoration.none,
    this.fontWeight=FontWeight.bold,this.fontSize=20});
  final String data;
  final Color color;
  final TextDecoration textDecoration;
  final FontWeight fontWeight;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Text(data,style: TextStyle(
        fontWeight:fontWeight,
        fontSize: fontSize,
        color: color,
        decoration: textDecoration,
        decorationColor: Colors.blue,
        decorationThickness: 2
    ));
  }

}
class AppContainer extends StatelessWidget {
  const AppContainer({ Key? key, this.child,
    this.width,
    this.height,
    this.color=Colors.white,
    this.radius=1,
    this.padding=1,
    this.alignment=Alignment.center,
    this.borderColor=Colors.white
  }) : super(key: key);
  final Widget? child;
  final Alignment alignment;
  final double? width,height;
  final double padding,radius;
  final Color color,borderColor;

  @override
  Widget build(BuildContext context) {
    return  Container(
        alignment:alignment,
        padding:  EdgeInsets.all(padding),
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: color,
            border:Border.all(width: 1,color: borderColor),
            borderRadius: BorderRadius.all(Radius.circular(radius))
        ),
        child:child
    );
  }
}
class AppTextField extends StatelessWidget {
  const AppTextField({Key? key, this.controller,
    required this.label,
    required this.hint,
    this.radius=10,  this.borderColor=Colors.teal, this.filledColor,
    this.icon,  this.isPassword=false, this.showPassword=false,
    this.filled, this.onShowPassword,this.isFocused=false,
    this.onTap, this.onChanged, this.onValidate, this.floatingLabelBehavior}) : super(key: key);
  final TextEditingController? controller;
  final String label,hint;
  final double radius;
  final Color borderColor;
  final Color? filledColor;
  final IconData? icon;
  final bool isPassword,showPassword,isFocused;
  final bool? filled;
  final void Function()? onShowPassword;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final String? Function(String?)? onValidate;
  final FloatingLabelBehavior? floatingLabelBehavior;
  @override
  Widget build(BuildContext context) {
    return
      TextFormField(
        validator: onValidate,
        controller: controller,
        onTap: onTap,
        onChanged: onChanged,
        decoration: InputDecoration(
            fillColor:filledColor,
            filled:filled,
            suffixIcon: showPassword?IconButton(onPressed:onShowPassword,
                icon: Icon(icon)) :Icon(icon),
            border:  OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(radius)),
                borderSide: BorderSide(color:borderColor )),
            labelText: label,
            hintText: hint,
            floatingLabelBehavior: floatingLabelBehavior
        ),
        obscureText: isPassword,
        autofocus: isFocused,

      );
  }
}
class AppSpacer    extends StatelessWidget {
  const AppSpacer({Key? key, this.width=double.infinity, this.height=10}) : super(key: key);
  final double width,height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
class AppButton    extends StatelessWidget {
  const AppButton({Key? key, required this.data,
    this.backGroundColor=Colors.blue, this.textColor=Colors.white,  this.onTap,
    this.onDoubleTap,  this.onLongPress,this.width,this.height}) : super(key: key);
  final String data;
  final Color backGroundColor,textColor;
  final double? width,height;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()?onLongPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: AppContainer(
          width: width,
          height:height,
          color: backGroundColor,
          radius: 10,
          child: AppText(data,color: textColor,)
      ),
    );
  }
}

