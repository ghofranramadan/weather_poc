import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/base/depindancy_injection.dart';
import '../../../../core/common/app_colors/app_colors.dart';
import '../../../../core/common/app_component_style/component_style.dart';
import '../../../../core/components/app_bar/app_bar.dart';
import '../../../../core/components/app_bar/model/app_bar_model.dart';
import '../../../../core/components/text_form_field/app_text_field.dart';
import '../../../../core/components/text_form_field/models/app_text_field_model.dart';
import '../../../../core/util/constants.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../components/weather_body_widget.dart';
import '../controller/weather_view_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  static const String routeName = 'Weather screen';

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final viewModel = sl<WeatherViewModel>();
  @override
  void initState() {
    super.initState();
    viewModel.searchController.text = "egypt";
    // Localization resolved here in the UI layer — ViewModel never needs context.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.getWeatherData(
        value: viewModel.searchController.text,
        emptyErrorMessage: AppLocalizations.of(context)!.translate('no_data_found'),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Constants.appBarSize,
        child: CustomAppBar(
          model: CustomAppBarModel(
            title: AppLocalizations.of(context)!.translate('app_name'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 50, left: 24.w, top: 24, right: 24.w),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
              child: AppTextField(
                model: AppTextFieldModel(
                  controller: viewModel.searchController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  borderRadius: BorderRadius.circular(12.r),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primaryColor,
                  ),
                  decoration: ComponentStyle.inputDecoration(
                    AppLocalizations.of(context)!.locale,
                  ).copyWith(
                    hintText: AppLocalizations.of(context)!.translate('search'),
                  ),
                  onChangeInput: (val) {
                    const duration = Duration(milliseconds: 700);
                    viewModel.debouncer.debounce(
                      duration: duration,
                      onDebounce: () => viewModel.getWeatherData(
                        value: val,
                        // Resolved here, in the UI layer where context lives.
                        emptyErrorMessage: AppLocalizations.of(context)!.translate('no_data_found'),
                      ),
                    );
                  }

                ),
              ),
            ),

            WeatherBodyWidget(viewModel: viewModel),
          ],
        ),
      ),
    );
  }
}
