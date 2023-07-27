import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homeowners_app/providers/data_provider.dart';
import 'package:homeowners_app/utils/enum.dart';
import 'package:homeowners_app/widgets/column_tile.dart';

class HomeOwnersPage extends ConsumerWidget {
  const HomeOwnersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeBuyers = ref.watch(homeBuyersProvider);
    final execution = ref.watch(executeProvider);
    final neighborhood = ref.watch(neighborhoodProvider);
    final status = ref.watch(statusProvider);
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (status == Status.finished) {
            showModalBottomSheet(
                context: context,
                builder: (context) => AnimatedPadding(
                      padding: MediaQuery.of(context).viewInsets,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.decelerate,
                      child: Container(
                        height: size.height * 0.5,
                        width: size.width,
                        padding: const EdgeInsets.all(26),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Results',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: execution.when(
                                data: (data) => ListView(
                                    children: data.map((e) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.neightborhood,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 50,
                                        width: size.width,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: e.data.map((e) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: Text(
                                                e,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  );
                                }).toList()),
                                error: (e, s) => const Center(
                                  child: Text(
                                    'Error loading data',
                                  ),
                                ),
                                loading: () => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
          } else {
            ref.read(executeProvider.future);
          }
        },
        label: status == Status.running
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Text(status == Status.finished ? 'Show Result' : 'Execute'),
      ),
      appBar: AppBar(
        title: const Text(
          'Home Owners',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(26),
        child: Row(
          children: [
            ColumnTile(title: 'Home Buyers', asyncData: homeBuyers),
            ColumnTile(title: 'Neighborhoods', asyncData: neighborhood),
          ],
        ),
      ),
    );
  }
}
