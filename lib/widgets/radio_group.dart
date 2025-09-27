import 'package:flutter/material.dart';

class CustomRadioGroup<T> extends StatefulWidget {
  final T value;
  final ValueChanged<T?> onChanged;
  final List<T> items;
  final Widget Function(T) itemBuilder;

  const CustomRadioGroup({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.items,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  State<CustomRadioGroup<T>> createState() => _CustomRadioGroupState<T>();
}

class _CustomRadioGroupState<T> extends State<CustomRadioGroup<T>> {
  late T _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(CustomRadioGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _selectedValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.items.map((item) {
        return InkWell(
          onTap: () {
            setState(() {
              _selectedValue = item;
            });
            widget.onChanged(item);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                Icon(
                  _selectedValue == item 
                      ? Icons.radio_button_checked 
                      : Icons.radio_button_unchecked,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(child: widget.itemBuilder(item)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
