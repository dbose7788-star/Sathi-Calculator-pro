import 'package:flutter/material.dart';

class Skin8Shell extends StatefulWidget {
  const Skin8Shell({
    super.key,
    required this.child,
    this.selectedIndex = 0,
    this.onTabSelected,
  });

  final Widget child;
  final int selectedIndex;
  final ValueChanged<int>? onTabSelected;

  static const Color bg = Color(0xFF050A14);
  static const Color panel = Color(0xFF0B1220);
  static const Color cyan = Color(0xFF08C7E8);
  static const Color muted = Color(0xFF8492A8);

  @override
  State<Skin8Shell> createState() => _Skin8ShellState();
}

class _Skin8ShellState extends State<Skin8Shell> {
  bool isDark = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Skin8Shell.bg,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            _tabs(),
            Expanded(child: widget.child),
            _bottomBar(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Skin8Shell.cyan,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic, color: Colors.white),
            Text(
              'VOICE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      color: Skin8Shell.bg,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Skin8Shell.cyan,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text(
                '⚡',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'SATHI',
                      style: TextStyle(
                        color: Skin8Shell.cyan,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 12),
                    _SmartBadge(),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  'Smart & Goods',
                  style: TextStyle(
                    color: Skin8Shell.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Calculator',
                  style: TextStyle(
                    color: Skin8Shell.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Developer: Debasish Bose',
                  style: TextStyle(
                    color: Skin8Shell.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'DEG',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          _headerIcon(Icons.volume_up_outlined),
          const SizedBox(width: 8),
          _headerIcon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            onTap: () => setState(() => isDark = !isDark),
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon, {VoidCallback? onTap}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Skin8Shell.panel,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF1B2B40)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Icon(icon, color: Skin8Shell.cyan, size: 27),
      ),
    );
  }

  Widget _tabs() {
    const labels = [
      'CALCULATOR',
      'SCIENTIFIC',
      'GOODS / MATERIAL',
      'SOFT5G',
      'HISTORY',
      'SETTINGS',
    ];

    const icons = [
      Icons.calculate_outlined,
      Icons.science_outlined,
      Icons.inventory_2_outlined,
      Icons.signal_cellular_alt,
      Icons.history,
      Icons.settings_outlined,
    ];

    return Container(
      height: 54,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF18263A)),
          bottom: BorderSide(color: Color(0xFF18263A)),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        itemBuilder: (context, index) {
          final selected = index == widget.selectedIndex;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 7,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => widget.onTabSelected?.call(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: selected ? Skin8Shell.cyan : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: selected
                      ? const [
                          BoxShadow(
                            color: Color(0x6608C7E8),
                            blurRadius: 18,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      icons[index],
                      color: selected ? Colors.black : Skin8Shell.muted,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      labels[index],
                      style: TextStyle(
                        color: selected ? Colors.black : Skin8Shell.muted,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      height: 58,
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home_outlined, color: Colors.white, size: 30),
          Icon(Icons.bookmark_border, color: Colors.white, size: 30),
          Icon(Icons.search, color: Colors.white, size: 32),
          Icon(Icons.calendar_month_outlined, color: Colors.white, size: 30),
          Icon(Icons.more_vert, color: Colors.white, size: 32),
        ],
      ),
    );
  }
}

class _SmartBadge extends StatelessWidget {
  const _SmartBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF17263A),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        '✧ SMART',
        style: TextStyle(
          color: Color(0xFF4DB8E8),
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
