import 'package:flutter/material.dart';
import 'package:grock/grock.dart';

class CustomTextField extends StatefulWidget {
   CustomTextField({
    super.key,
    required this.title,
     this.isSec,
         this.enable,

    required this.controller,
    this.focusNode,
    this.onSubmitted,
    this.validator,
    this.errorText,
    this.onChanged,
    this.maxLength,
    this.hintText,
  });
  final String title;
  bool ? enable;
  final String? errorText;
  final String? hintText;

  bool ? isSec;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final int? maxLength;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Material(
          elevation: 4,
          shadowColor: Colors.grey.withOpacity(.1),
          child: TextFormField(
            enabled: widget.enable.isNull ? true : false,
            validator: widget.validator,
            focusNode: widget.focusNode,
            obscureText: widget.isSec ?? false,
            controller: widget.controller,
            onChanged: widget.onChanged,
            maxLength: widget.maxLength,
            decoration: InputDecoration(
               suffixIcon: widget.isSec != null ? IconButton(
            
          icon: Icon(
            widget.isSec! ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              widget.isSec = !widget.isSec!; 
            });
          },
        )
         : null
        
        ,  
                hintText: widget.hintText,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none),
                errorText: widget.errorText,
                labelText: widget.title),
          )),
    );
  }
}

