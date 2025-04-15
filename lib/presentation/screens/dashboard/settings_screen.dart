import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/logic/sync_logic/sync_bloc.dart';
import 'package:pos_app/widgets/custom_dialogue.dart';
import 'package:pos_app/widgets/custom_snackbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SyncDataBloc, SyncDataState>(
      listener: (context, state) {
        if (state is SyncSuccessDataState) {
          CustomDialog.hideLoading(context);
          CustomSnackBar.showSuccess(message: 'Synced Successfully!');
        }

        if (state is SyncingSaleDataState) {
          CustomDialog.showLoading(context, loadingText: 'Syncing Sale Data');
        }
        if (state is SyncingCrmDataState) {
          CustomDialog.updateLoadingText('Syncing CRM Data');
        }
      },
      builder: (context, state) {
        return GridView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200, mainAxisExtent: 50),
            children: [
              InkWell(
                onTap: () {
                  BlocProvider.of<SyncDataBloc>(context).add(StartSyncDataEvent());
                },
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(7), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sync,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Sync data',
                        style: AppStyles.getMediumTextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
              )
            ]);
      },
    );
  }
}
