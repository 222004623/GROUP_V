import 'package:flutter/material.dart';
import 'package:group_v/routeManager/RouteManager.dart';
import 'package:group_v/views/StudentAssistantApplicationForm.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeView> {
  final supabase = Supabase.instance.client;

  List applications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) return;

      final response = await supabase
          .from('applications')
          .select()
          .eq('user_id', user.id);

      setState(() {
        applications = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;

      case 'rejected':
        return Colors.red;

      case 'pending':
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await supabase.auth.signOut();

              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // WELCOME CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          user?.email ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          "Applications Submitted: ${applications.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              RouteManager.applicationForm,
                            );

                            fetchStudents();
                          },

                          icon: const Icon(Icons.add),
                          label: const Text("Apply"),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: fetchStudents,

                          icon: const Icon(Icons.refresh),
                          label: const Text("Refresh"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "My Applications",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  // APPLICATION LIST
                  Expanded(
                    child: applications.isEmpty
                        ? const Center(
                            child: Text(
                              "No applications submitted yet",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: applications.length,

                            itemBuilder: (context, index) {
                              final app = applications[index];

                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.only(bottom: 15),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),

                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(15),

                                  leading: CircleAvatar(
                                    backgroundColor: getStatusColor(
                                      app['status'],
                                    ),

                                    child: const Icon(
                                      Icons.description,
                                      color: Colors.white,
                                    ),
                                  ),

                                  title: Text(
                                    app['position'] ?? "Student Assistant",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 8),

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          "Department: ${app['department']}",
                                        ),

                                        const SizedBox(height: 5),

                                        Text(
                                          "Status: ${app['status']}",
                                          style: TextStyle(
                                            color: getStatusColor(
                                              app['status'],
                                            ),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                  ),

                                  onTap: () {
                                    // optional details page
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                  ElevatedButton(
                    onPressed: () => StudentAssistantApp(),
                    child: Text("Apply"),
                  ),
                ],
              ),
            ),
    );
  }
}
