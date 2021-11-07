import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.title,
    required TextEditingController controller,
    this.inputFormatters,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final String title;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
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
          TextField(
            controller: _controller,
            style: const TextStyle(color: Color(0xffdbdbdb), fontSize: 20),
            cursorColor: const Color(0xffede6d6),
            decoration: const InputDecoration(
              errorMaxLines: 3,
              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
            ),
            inputFormatters: inputFormatters,
          ),
        ],
      ),
    );
  }
}
