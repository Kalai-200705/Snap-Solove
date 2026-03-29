import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'citizen_report_issue_screen.dart';

void main() => runApp(const CitizenApp());

class CitizenApp extends StatelessWidget {
  const CitizenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient/Image
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE0F2F1), Color(0xFFE3F2FD), Colors.white],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                _buildHeader(),
                const SliverToBoxAdapter(child: SizedBox(height: 30)),
                _buildWelcomeSection(),
                _buildMainAction(context),
                _buildCategoryGrid(),
                _buildRecentComplaintsHeader(),
                _buildComplaintsList(),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
          // Bottom Navigation
          const Positioned(
              bottom: 0, left: 0, right: 0, child: CustomBottomNav()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      NetworkImage('https://i.pravatar.cc/150?u=david'),
                ),
                const SizedBox(width: 12),
                Text(
                  "Hi, David R.",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.verified, color: Colors.blue, size: 18),
              ],
            ),
            _glassContainer(
              padding: const EdgeInsets.all(10),
              child: const Badge(
                label: Text("3"),
                child: Icon(Icons.notifications_none_outlined, size: 26),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome back!",
                style: GoogleFonts.poppins(
                    fontSize: 28, fontWeight: FontWeight.bold)),
            Text("Wednesday, October 25, 2023",
                style:
                    GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildMainAction(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CitizenReportIssueScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.blue.withValues(alpha: 0.4),
          ).copyWith(
            backgroundColor: MaterialStateProperty.resolveWith(
              (states) => null,
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF40C4FF), Color(0xFF00B0FF)],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Container(
              alignment: Alignment.center,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Report New Issue",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  SizedBox(width: 10),
                  Icon(Icons.add_circle_outline, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {
        'name': 'Road',
        'icon': Icons.edit_road,
        'color': Colors.blue,
        'type': 'road'
      },
      {
        'name': 'Water',
        'icon': Icons.water_drop,
        'color': Colors.cyan,
        'type': 'water'
      },
      {
        'name': 'Electricity',
        'icon': Icons.bolt,
        'color': Colors.orange,
        'type': 'electricity'
      },
      {
        'name': 'Garbage',
        'icon': Icons.delete_outline,
        'color': Colors.green,
        'type': 'garbage'
      },
    ];

    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 2.2,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                String type = categories[index]['type'] as String;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CitizenReportIssueScreen(),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: _glassContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(categories[index]['icon'] as IconData,
                          color: categories[index]['color'] as Color),
                      const SizedBox(width: 10),
                      Text(categories[index]['name'] as String,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: 4,
        ),
      ),
    );
  }

  Widget _buildRecentComplaintsHeader() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Recent Complaints",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("View All",
                style: TextStyle(
                    color: Colors.blue[700], fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintsList() {
    final complaints = [
      {
        'title': 'Pothole - Main St',
        'status': 'In Progress',
        'progress': 0.65,
        'category': 'Road'
      }
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/complaint-detail');
            },
            child: _glassContainer(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.blue[50], shape: BoxShape.circle),
                        child: const Icon(Icons.location_on,
                            color: Colors.blue, size: 20),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              complaints[index]['title'] as String,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "[STATUS: ${complaints[index]['status']} | ${((complaints[index]['progress'] as double) * 100).toInt()}%]",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(complaints[index]['category'] as String,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: complaints[index]['progress'] as double,
                    backgroundColor: Colors.blue[100],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  )
                ],
              ),
            ),
          ),
        ),
        childCount: complaints.length,
      ),
    );
  }

  Widget _glassContainer({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.home_filled, color: Colors.blue),
          Icon(Icons.description_outlined, color: Colors.grey),
          Icon(Icons.map_outlined, color: Colors.grey),
          Icon(Icons.person_outline, color: Colors.grey),
        ],
      ),
    );
  }
}
