import 'package:flutter/material.dart';
import 'package:just_expenses_clone/screens/analysis/analysis_detail_page.dart';
import 'package:just_expenses_clone/screens/model/cat_transaction.dart';

class AnalysisCatListing extends StatelessWidget {
  List<CatTransaction> listCatTransaction;
  AnalysisCatListing(this.listCatTransaction, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.white,
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: listCatTransaction.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnalysisDetailPage(
                            listCatTransaction[index].catId!,
                            listCatTransaction[index].color!,
                            listCatTransaction[index].categoryTitle!),
                      ));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                height: 30,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        listCatTransaction[index]
                                            .color!
                                            .replaceAll('#', '0xff'))),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      listCatTransaction[index].icon!,
                                      width: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      listCatTransaction[index].categoryTitle!,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                (listCatTransaction[index].currencySymbol ??
                                        "") +
                                    listCatTransaction[index]
                                        .totalAmount
                                        .toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        if (index != listCatTransaction.length - 1)
                          Container(
                            margin: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                            height: 0.5,
                            color: Colors.grey,
                          )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
