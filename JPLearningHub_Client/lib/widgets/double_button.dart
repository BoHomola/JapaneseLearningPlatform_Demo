import 'package:flutter/material.dart';

class DoubleButton extends StatefulWidget {
  final String leftButtonText;
  final String rightButtonText;
  final Function(bool) onLeftButtonPressed;
  final Function(bool) onRightButtonPressed;

  const DoubleButton({
    super.key,
    required this.leftButtonText,
    required this.rightButtonText,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
  });

  @override
  DoubleButtonState createState() => DoubleButtonState();
}

class DoubleButtonState extends State<DoubleButton> {
  bool _isLeftSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
    height: 75,
    width: 600,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildButton(
              text: widget.leftButtonText,
              isSelected: _isLeftSelected,
              onPressed: () => _handleButtonPress(true),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
            ),
          ),
          Container(
            width: 1,
            color: Colors.grey[300],
          ),
          Expanded(
            child: _buildButton(
              text: widget.rightButtonText,
              isSelected: !_isLeftSelected,
              onPressed: () => _handleButtonPress(false),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required bool isSelected,
    required VoidCallback onPressed,
    required BorderRadius borderRadius,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[500] : Colors.white,
          borderRadius: borderRadius,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _handleButtonPress(bool isLeft) {
    setState(() {
      _isLeftSelected = isLeft;
    });
    if (isLeft) {
      widget.onLeftButtonPressed(_isLeftSelected);
    } else {
      widget.onRightButtonPressed(!_isLeftSelected);
    }
  }
}
