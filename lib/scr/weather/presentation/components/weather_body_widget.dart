import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/components/app_text/app_text.dart';
import '../../../../core/components/app_text/models/app_text_model.dart';
import '../../../../core/components/custom_network_image.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../domain/entities/weather_entity.dart';
import '../controller/weather_view_model.dart';

/// SRP: responsible only for rendering the weather data UI.
/// Date/time formatting is extracted to private helpers so build() only
/// describes the widget tree.
class WeatherBodyWidget extends StatelessWidget {
  final WeatherViewModel viewModel;
  const WeatherBodyWidget({super.key, required this.viewModel});

  /// SRP helper: converts an API datetime string to a display date.
  String _formatDate(String? rawDateTime) {
    if (rawDateTime == null) return '';
    try {
      final datePart = rawDateTime.split(' ').first;
      return DateFormat('MMM d, yyyy').format(DateTime.parse(datePart));
    } catch (_) {
      return '';
    }
  }

  /// SRP helper: extracts just the time portion from an API datetime string.
  String _formatTime(String? rawDateTime) {
    if (rawDateTime == null) return '';
    final parts = rawDateTime.split(' ');
    return parts.length > 1 ? parts[1] : '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<WeatherEntity>,
      GenericCubitState<WeatherEntity>
    >(
      bloc: viewModel.weatherDetails,
      builder: (context, weatherState) {
        if (weatherState is GenericLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }
        else if (weatherState is GenericErrorState) {
          return Center(
            child: AppText(
              text: "${weatherState.responseError?.errorMessage}",
              model: AppTextModel(
                style: AppFontStyleGlobal(
                  AppLocalizations.of(context)!.locale,
                ).bodyRegular1.copyWith(color: AppColors.error),
              ),
            ),
          );
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.71,
          padding: EdgeInsets.only(
            top: 50,
            bottom: 20,
            right: 15.w,
            left: 15.w,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(color: AppColors.primaryColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText(
                text: "${weatherState.data.location?.name}",
                model: AppTextModel(
                  style: AppFontStyleGlobal(
                    AppLocalizations.of(context)!.locale,
                  ).bodyRegular1.copyWith(color: AppColors.black),
                ),
              ),
              SizedBox(height: 10.h),
              AppText(
                text: "${weatherState.data.current?.condition?.text}",
                model: AppTextModel(
                  style: AppFontStyleGlobal(
                    AppLocalizations.of(context)!.locale,
                  ).subTitle1.copyWith(color: AppColors.black),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    text: "${weatherState.data.current?.tempC} °C",
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                        AppLocalizations.of(context)!.locale,
                      ).bodyRegular1.copyWith(color: AppColors.black),
                    ),
                  ),
                  SizedBox(width: 10.h),
                  AppText(
                    text: "${weatherState.data.current?.tempF} °F",
                    model: AppTextModel(
                      style: AppFontStyleGlobal(
                        AppLocalizations.of(context)!.locale,
                      ).bodyRegular1.copyWith(color: AppColors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              CustomNetworkImage(
                url: 'https:${weatherState.data.current?.condition?.icon}',
                fit: BoxFit.fill,
                width: 50,
                height: 50,
              ),
              SizedBox(height: 5.h),
              AppText(
                text: _formatDate(weatherState.data.current?.lastUpdated),
                model: AppTextModel(
                  style: AppFontStyleGlobal(
                    AppLocalizations.of(context)!.locale,
                  ).bodyRegular1.copyWith(color: AppColors.black),
                ),
              ),
              SizedBox(height: 10.h),
              AppText(
                text: _formatTime(weatherState.data.current?.lastUpdated),
                model: AppTextModel(
                  style: AppFontStyleGlobal(
                    AppLocalizations.of(context)!.locale,
                  ).bodyRegular1.copyWith(color: AppColors.black),
                ),
              ),
              SizedBox(height: 5.h),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.green),
                onPressed: () => viewModel.getWeatherData(
                  value: viewModel.searchController.text,
                  emptyErrorMessage: AppLocalizations.of(context)!.translate('no_data_found'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
