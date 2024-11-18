import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jplearninghub/provider/students_state.dart';
import 'package:provider/provider.dart';

class SearchQueryProvider extends ChangeNotifier {
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}

class DesktopStudentScreen extends StatelessWidget {
  const DesktopStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchQueryProvider(),
      child: const _DesktopStudentScreenContent(),
    );
  }
}

class _DesktopStudentScreenContent extends StatelessWidget {
  const _DesktopStudentScreenContent();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 300,
                  child: Consumer<SearchQueryProvider>(
                    builder: (context, searchProvider, child) {
                      return TextField(
                        onChanged: (value) {
                          searchProvider.setSearchQuery(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by name',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      StudentsState studentsState =
                          Provider.of<StudentsState>(context, listen: false);
                      studentsState.reloadStudents();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.refresh),
                        SizedBox(width: 15),
                        Text('Reload Students'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      Consumer2<StudentsState, SearchQueryProvider>(
        builder: (context, studentsState, searchProvider, child) {
          studentsState.loadStudents();
          final filteredStudents = studentsState.students.where((student) {
            final fullName =
                "${student.user.firstName} ${student.user.lastName}"
                    .toLowerCase();
            return fullName.contains(searchProvider.searchQuery.toLowerCase());
          }).toList();

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final student = filteredStudents[index];
                return Column(
                  children: [
                    Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[200],
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  cacheKey: student.user.avatarKey,
                                  imageUrl: student.user.avatarUrl,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.person),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 200,
                              child: Text(
                                "${student.user.firstName} ${student.user.lastName}",
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: 200,
                              child: Text("Credits: ${student.credits}"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
              childCount: filteredStudents.length,
            ),
          );
        },
      ),
    ]);
  }
}
