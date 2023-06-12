import 'package:barterit_asgm2/user.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MessageSceen extends StatefulWidget {
  const MessageSceen({super.key, required User user});

  @override
  State<MessageSceen> createState() => _MessageSceenState();
}

class _MessageSceenState extends State<MessageSceen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
