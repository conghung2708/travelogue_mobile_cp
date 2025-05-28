// 📁 hobby_screen.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:travelogue_mobile/model/hobby_test_model.dart';
import 'package:travelogue_mobile/representation/hobby/widgets/hobby_button.dart';
import 'package:travelogue_mobile/representation/hobby/widgets/hobby_chip.row.dart';
import 'package:travelogue_mobile/representation/hobby/widgets/hobby_header.dart';
import 'package:travelogue_mobile/representation/hobby/widgets/hobby_image_card.dart';

class HobbyScreen extends StatefulWidget {
  const HobbyScreen({super.key});

  @override
  State<HobbyScreen> createState() => _HobbyScreenState();
}

class _HobbyScreenState extends State<HobbyScreen> {
  final Set<int> selectedHobbyIds = {};

  final List<List<HobbyTestModel>> heartRows = [
    mockHobbies.sublist(0, 2),
    mockHobbies.sublist(2, 6),
    mockHobbies.sublist(6, 10),
    mockHobbies.sublist(11, 15),
    mockHobbies.sublist(15, 18),
    mockHobbies.sublist(18, 20),
    [mockHobbies[10 % mockHobbies.length]],
  ];

  final List<MainAxisAlignment> alignments = [
    MainAxisAlignment.center,
    MainAxisAlignment.spaceEvenly,
    MainAxisAlignment.spaceEvenly,
    MainAxisAlignment.center,
    MainAxisAlignment.center,
    MainAxisAlignment.center,
    MainAxisAlignment.center,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const BackButton(color: Colors.blueAccent),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0F8FF), Color(0xFFE1F5FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 11.h),
            const HobbyHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(
                      heartRows.length,
                      (i) => HobbyChipRow(
                        hobbies: heartRows[i],
                        alignment: alignments[i],
                        selectedIds: selectedHobbyIds,
                        onSelectionChanged: (id, selected) {
                          setState(() {
                            selected
                                ? selectedHobbyIds.add(id)
                                : selectedHobbyIds.remove(id);
                          });
                        },
                      ),
                    ),
                    const HobbyImageCard(),
                  ],
                ),
              ),
            ),
            HobbySaveButton(
                selectedCount: selectedHobbyIds.length, onTap: () {}),
          ],
        ),
      ),
    );
  }
}
