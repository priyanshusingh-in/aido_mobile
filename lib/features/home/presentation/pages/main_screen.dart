import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'home_screen.dart';
import '../../../schedule/presentation/pages/schedule_list_screen.dart';
import '../../../settings/presentation/pages/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ScheduleListScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          return Scaffold(
            body: Row(
              children: [
                if (isWide)
                  NavigationRail(
                    selectedIndex: _currentIndex,
                    onDestinationSelected: (i) => setState(() {
                      _currentIndex = i;
                    }),
                    extended: constraints.maxWidth >= 1200,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.schedule_outlined),
                        selectedIcon: Icon(Icons.schedule),
                        label: Text('Schedules'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings_outlined),
                        selectedIcon: Icon(Icons.settings),
                        label: Text('Settings'),
                      ),
                    ],
                  ),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _screens,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: isWide
                ? null
                : NavigationBar(
                    selectedIndex: _currentIndex,
                    onDestinationSelected: (i) => setState(() {
                      _currentIndex = i;
                    }),
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.schedule_outlined),
                        selectedIcon: Icon(Icons.schedule),
                        label: 'Schedules',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.settings_outlined),
                        selectedIcon: Icon(Icons.settings),
                        label: 'Settings',
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
