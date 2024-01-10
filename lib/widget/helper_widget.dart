import 'package:flutter/material.dart';
class AppText extends StatelessWidget
{
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


Widget WrapableContainer({required Widget child,double width=400,
  double height=50,Color color=Colors.white,
  int alpha=0,
  double radius=1,
  double padding=1,
  Alignment alignment=Alignment.center,
  Color borderColor=const Color(0xFF000000)
})
{
  return Container(
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
Widget AnotherWrapableContainer(
    {required Widget child,double? width,
      double? height,Color color=Colors.white,
      int alpha=0,
      double radius=1,
      double padding=1,
      Alignment alignment=Alignment.center
    })
{
  return Container(
      alignment:alignment,
      padding:  EdgeInsets.all(padding),
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: color,
          border:Border.all(width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(radius))
      ),
      child:child
  );
}
Widget AppTextField({required TextEditingController controller,
  required String label,required String hint,double radius=10,
  Color borderColor=Colors.teal,
  IconData? icon,
  bool isPassword=false,
  bool showPassword=false,
  void Function()? onshowPassword,
  void Function()? onTap,
  void Function(String)? onChanged,
  String? Function(String?)? onValidate,
  bool? filled,
  Color? filledColor,
  FloatingLabelBehavior? floatingLabelBehavior,
  void Function(String)? onSubmit
})
{
  return
    TextFormField(
      onFieldSubmitted:onSubmit ,
      validator: onValidate,
      controller: controller,
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
          fillColor:filledColor,
          filled:filled,
          suffixIcon: showPassword?IconButton(onPressed:onshowPassword,
              icon: Icon(icon)) :Icon(icon),
          border:  OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              borderSide: BorderSide(color:borderColor )),
          labelText: label,
          hintText: hint,
          floatingLabelBehavior: floatingLabelBehavior
      ),

      obscureText: isPassword,

    );
}
Widget AppSizedBox({double width=double.infinity,double height=10})
{
  return SizedBox(
    width: width,
    height: height,
  );
}


