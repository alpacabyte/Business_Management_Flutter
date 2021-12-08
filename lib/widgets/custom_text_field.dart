import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.title,
    required TextEditingController controller,
    this.inputFormatters,
    this.width = 300,
    this.textFieldWidth = 300,
    this.onChanged,
    this.hintText,
    this.trailing,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final String title;
  final List<TextInputFormatter>? inputFormatters;
  final double width;
  final Function(String)? onChanged;
  final String? hintText;
  final Widget? trailing;
  final double textFieldWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              SizedBox(
                width: textFieldWidth,
                child: TextField(
                  onChanged: onChanged,
                  controller: _controller,
                  style: const TextStyle(
                    color: Color(0xffdbdbdb),
                    fontSize: 20,
                  ),
                  cursorColor: const Color(0xffede6d6),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Colors.grey),
                    errorMaxLines: 3,
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  inputFormatters: inputFormatters,
                ),
              ),
              if (trailing != null) ...[
                const Spacer(),
                trailing!,
                const Spacer(),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
