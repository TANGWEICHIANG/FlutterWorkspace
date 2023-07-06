import 'package:barterit_asgm2/user.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key, required User user});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
