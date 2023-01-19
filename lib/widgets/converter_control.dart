import 'package:flutter/material.dart';
import 'package:new_app/constants/app_colors.dart';
import 'package:new_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ConverterControl extends StatelessWidget {
  final Function? onSwap;

  const ConverterControl({
    Key? key,
    this.onSwap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        DropdownButton<String>(
          value: context.watch<UserProvider>().fromCurrency,
          icon: Icon(Icons.arrow_downward, color: appColors.shade500),
          iconSize: 14,
          elevation: 16,
          style: const TextStyle(color: Colors.black, fontSize: 24),
          underline: Container(
            height: 2,
            color: appColors.shade500,
          ),
          onChanged: (String? newValue) {
            context.read<UserProvider>().setFromCurrency(newValue!);
            if (onSwap != null) onSwap!();
          },
          items: context
              .read<UserProvider>()
              .currencies
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        FloatingActionButton(
          onPressed: () {
            context.read<UserProvider>().swapCurrencies();
            if (onSwap != null) onSwap!();
          },
          child: const Icon(Icons.swap_horiz),
        ),
        DropdownButton<String>(
          value: context.watch<UserProvider>().toCurrency,
          icon: Icon(Icons.arrow_downward, color: appColors.shade500),
          iconSize: 14,
          elevation: 16,
          style: const TextStyle(color: Colors.black87, fontSize: 24),
          underline: Container(
            height: 2,
            color: appColors.shade500,
          ),
          onChanged: (String? newValue) {
            context.read<UserProvider>().setToCurrency(newValue!);
            if (onSwap != null) onSwap!();
          },
          items: context
              .read<UserProvider>()
              .currencies
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
