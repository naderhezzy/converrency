import 'package:flutter/material.dart';
import 'package:new_app/constants/app_colors.dart';
import 'package:new_app/widgets/converter_control.dart';

class SettingsDialog extends StatelessWidget {
  final Function onSubmit;

  SettingsDialog({Key? key, required this.onSubmit}) : super(key: key);

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const ModalBarrier(),
        Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Center(
                      child: Text(
                    "Settings",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: appColors.shade500),
                  )),
                  const SizedBox(height: 40),
                  const Center(child: Text("Set default currencies")),
                  const SizedBox(height: 15),
                  const ConverterControl(),
                  const SizedBox(height: 40),
                  const Center(child: Text("Change your username")),
                  const SizedBox(height: 15),
                  TextField(
                    maxLines: 1,
                    controller: _controller,
                    decoration: InputDecoration(
                      constraints: const BoxConstraints(maxHeight: 40),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      hintText: "New username",
                      filled: true,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide.none),
                      hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0.0),
                              backgroundColor: MaterialStateProperty.all(
                                const Color.fromRGBO(62, 70, 133, 0.05),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Close",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () => onSubmit(_controller.text),
                            child: const FittedBox(
                              child: Text("Change Username"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
