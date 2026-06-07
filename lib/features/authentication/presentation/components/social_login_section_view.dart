import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class SocialLoginSectionView extends StatelessWidget {
  const SocialLoginSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 24,
      children: [
        SocialLoginView(
          image: ImageUtils.google,
          label: "Google",
          onTap: () {},
        ),
        SocialLoginView(
          image: ImageUtils.facebook,
          label: "Facebook",
          onTap: () {},
        ),
      ],
    );
  }
}

class SocialLoginView extends StatelessWidget {
  final String image;
  final String label;
  final Function onTap;

  const SocialLoginView({
    super.key,
    required this.image,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TtZoomTap(
      onTap: () {
        onTap();
      },
      child: Column(
        spacing: 8,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color.fromRGBO(233, 233, 233, 1.0),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Image.asset(
                image,
                width: 25,
                height: 25,
              ),
            ),
          ),
          TtText(
            label,
            fontSize: 13,
          ),
        ],
      ),
    );
  }
}
