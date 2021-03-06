import 'package:flutter/material.dart';
import 'package:nocd/model/model_data_collection.dart';
import 'package:nocd/page/data_collection/page_data_collection.dart';
import 'package:nocd/ui/ui_bubble_title.dart';
import 'package:nocd/ui/ui_next_button.dart';
import 'package:nocd/ui/ui_page_wrapper.dart';
import 'package:nocd/ui/ui_yes_no_button.dart';
import 'package:nocd/utils/bloc_provider.dart';

class DataCollectionCollegePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DataCollectionBloc dataCollectionBloc =
        BlocProvider.of<DataCollectionBloc>(context);

    return StreamBuilder(
        stream: dataCollectionBloc.getModel,
        initialData: dataCollectionBloc.model,
        builder: (context, snapshot) {
          DataCollectionModel model = (snapshot.data as DataCollectionModel);
          bool enableNextButton = false;
          if (model.collegeEnrollment == false) {
            enableNextButton = true;
          } else if (model.collegeEnrollment == true &&
              model.collegeName != null &&
              model.collegeName != "") {
            enableNextButton = true;
          }

          return PageWrapper(
            child: SingleChildScrollView(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => {FocusScope.of(context).unfocus()},
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DataCollectionHeaderWrapper(dataCollectionBloc),
                      BubbleTitle("Are you currently enrolled in college?", 1),
                      Container(
                        height: 90,
                        margin: EdgeInsets.only(left: 25, right: 25, top: 45),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                                child: SelectableButton(
                                    "Yes", (model.collegeEnrollment ?? false),
                                    () {
                              dataCollectionBloc.updateCollegeEnrollment(true);
                            })),
                            Container(width: 25),
                            Expanded(
                                child: SelectableButton(
                                    "No", !(model.collegeEnrollment ?? true),
                                    () {
                              dataCollectionBloc.updateCollegeEnrollment(false);
                            })),
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 30, right: 30, top: 45),
                          child: Visibility(
                            child: TextField(
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              onChanged: (text) =>
                                  {dataCollectionBloc.updateCollegeName(text)},
                              decoration:
                                  InputDecoration(labelText: 'School Name'),
                              textCapitalization: TextCapitalization.sentences,
                            ),
                            visible: model.collegeEnrollment ?? false,
                          )),
                      NextButtonWithDisclaimer(
                          NextButton(enableNextButton,
                              () => dataCollectionBloc.nextPage()),
                          "Through partnerships with colleges, we are sometimes able to offer NOCD Therapy at a discounted price. We're working to partner with more institutions."),
                      Container(
                        height: 56,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
