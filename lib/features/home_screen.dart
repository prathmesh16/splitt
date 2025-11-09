import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:splitt/features/accounts/presentation/views/accounts_screen.dart';
import 'package:splitt/features/friends/presentation/bloc/friends_dashboard_bloc.dart';
import 'package:splitt/features/friends/presentation/views/friends_dashboard_screen.dart';
import 'package:splitt/features/group/presentation/bloc/group_dashboard_bloc.dart';
import 'package:splitt/features/group/presentation/views/groups_dashboard_screen.dart';
import 'package:splitt/features/group/presentation/views/groups_dashboard_shimmer.dart';
import 'package:splitt/features/users/presentation/bloc/my_details_bloc.dart';
import 'package:splitt/theme/theme_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  List<Widget> get _pages => [
        Center(
          child: BlocProvider.value(
            value: friendsDashboardBloc,
            child: const FriendsDashboardScreen(),
          ),
        ),
        Center(
          child: BlocProvider.value(
            value: groupDashboardBloc,
            child: const GroupDashboardScreen(),
          ),
        ),
        const Center(child: Text("Activity")),
        const Center(child: AccountsScreen()),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final MyDetailsBloc myDetailsBloc;
  late final FriendsDashboardBloc friendsDashboardBloc;
  late final GroupDashboardBloc groupDashboardBloc;

  @override
  void initState() {
    super.initState();
    myDetailsBloc = MyDetailsBloc();
    myDetailsBloc.getMyDetails();
    friendsDashboardBloc = FriendsDashboardBloc();
    groupDashboardBloc = GroupDashboardBloc();
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
