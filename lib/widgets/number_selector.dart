import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NumberSelector extends StatefulWidget {
  final String title;
  final int currentValue;
  final int minValue;
  final int maxValue;
  final Function(int) onValueChanged;
  
  const NumberSelector({
    Key? key,
    required this.title,
    required this.currentValue,
    required this.minValue,
    required this.maxValue,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  State<NumberSelector> createState() => _NumberSelectorState();
}

class _NumberSelectorState extends State<NumberSelector> {
  late int _selectedValue;
  
  @override
  void initState() {
    super.initState();
    _selectedValue = widget.currentValue;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: AppTheme.subheadingStyle,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                icon: Icons.remove,
                onPressed: _decrementValue,
                isEnabled: _selectedValue > widget.minValue,
              ),
              SizedBox(
                width: 80,
                child: Text(
                  _selectedValue.toString(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              _buildButton(
                icon: Icons.add,
                onPressed: _incrementValue,
                isEnabled: _selectedValue < widget.maxValue,
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                widget.onValueChanged(_selectedValue);
                Navigator.pop(context);
              },
              style: AppTheme.primaryButtonStyle,
              child: const Text('CONFIRM'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isEnabled ? AppTheme.secondaryColor : AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isEnabled ? Colors.white : AppTheme.textSecondaryColor,
        ),
      ),
    );
  }

  void _incrementValue() {
    if (_selectedValue < widget.maxValue) {
      setState(() {
        _selectedValue++;
      });
    }
  }

  void _decrementValue() {
    if (_selectedValue > widget.minValue) {
      setState(() {
        _selectedValue--;
      });
    }
  }
}