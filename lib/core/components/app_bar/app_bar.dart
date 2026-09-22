import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/app_colors/app_colors.dart';
import '../../common/app_font_style/app_font_style_global.dart';
import '../../util/localization/app_localizations.dart';
import '../app_text/app_text.dart';
import '../app_text/models/app_text_model.dart';
import 'model/app_bar_model.dart';

class CustomAppBar extends StatelessWidget {
  final CustomAppBarModel model;
  const CustomAppBar({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.grayColor.withValues(alpha: 0.4),
            blurRadius: 5,
            offset: const Offset(0, 0), // Shadow position
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (model.showBackButton == true)
            InkWell(
              onTap: model.backOnTap ?? () {},
              child: Icon(
                AppLocalizations.of(context)!.locale.languageCode == 'en'
                    ? Icons.west_outlined
                    : Icons.east_outlined,
                size: 32,
              ),
            )
          else
            const SizedBox(),
          if (model.title != null)
            Expanded(
              child: Center(
                child: AppText(
                  text: model.title!,
                  model: model.titleStyle ??
                      AppTextModel(
                        style: AppFontStyleGlobal(
                          AppLocalizations.of(context)!.locale,
                        ).subTitle1.copyWith(
                          fontSize: 20.sp,
                        ),
                      ),
                ),
              ),
            )
          else
            const SizedBox(),
          if (model.showBackButton == true)
            const SizedBox(width: 32)
          else
            const SizedBox(),

          if (model.showMenuButton == true)
            InkWell(
              onTap: model.menuOnTap ?? () {},
              child: const Icon(
                 Icons.menu,
                size: 32,
              ),
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }
}
