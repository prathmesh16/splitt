import 'package:flutter/material.dart';
import 'package:splitt/features/accounts/presentation/views/accounts_screen.dart';
import 'package:splitt/features/group/presentation/views/groups_dashboard_screen.dart';
import 'package:splitt/features/users/presentation/bloc/my_details_bloc.dart';
import 'package:splitt/theme/theme_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  final List<Widget> _pages = const [
    Center(child: Text("Friends")),
    Center(child: GroupDashboardScreen()),
    Center(child: Text("Activity")),
    Center(child: AccountsScreen()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final MyDetailsBloc myDetailsBloc;

  @override
  void initState() {
    super.initState();
    myDetailsBloc = MyDetailsBloc();
    myDetailsBloc.getMyDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: context.c.white,
        selectedItemColor: context.c.primaryColor,
        unselectedItemColor: context.c.secondaryTextColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            activeIcon: Icon(Icons.group),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            activeIcon: Icon(Icons.history),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Accounts',
          ),
        ],
      ),
    );
  }
}
