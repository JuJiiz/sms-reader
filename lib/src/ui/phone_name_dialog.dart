import 'package:flutter/material.dart';

class PhoneNameDialog extends StatefulWidget {
  final String currentPhoneName;
  final Function(String) onSavePhoneName;

  const PhoneNameDialog({Key key, this.onSavePhoneName, this.currentPhoneName})
      : super(key: key);

  @override
  _PhoneNameDialogState createState() => _PhoneNameDialogState();
}

class _PhoneNameDialogState extends State<PhoneNameDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.currentPhoneName != null)
      controller.text = widget.currentPhoneName;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Colors.white,
      title: Text(
        'Phone name',
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.black,
        ),
      ),
      content: TextField(
        controller: controller,
        maxLines: 1,
        maxLength: 100,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Submit',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          onPressed: () {
            var name = controller.text;
            if (name != null && name.isNotEmpty) {
              widget.onSavePhoneName(name);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
