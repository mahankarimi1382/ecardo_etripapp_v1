import 'package:flutter/material.dart';
import 'package:ecardo_etrip/src/app/constants/app_colors.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/view/sub_sections/action_button_section.dart';
import 'package:ecardo_etrip/src/presentation/screens/home/view/sub_sections/user_profile_section.dart';
import 'package:ecardo_etrip/src/presentation/screens/travel/shared/travel_theme.dart';

class TopHeaderSection extends StatelessWidget {
  const TopHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 18),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.lightPrimary,
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(20),
                  bottomEnd: Radius.circular(20),
                ),
              ),
              child: const UserProfileSection(),
            ),
            Container(
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 18),
              height: 43,
              decoration: BoxDecoration(
                color: TravelTheme.backgroundFor(context),
                borderRadius: const BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(20),
                  bottomEnd: Radius.circular(20),
                ),
              ),
            ),
          ],
        ),
        const ActionButtonSection(),
      ],
    );
  }
}
