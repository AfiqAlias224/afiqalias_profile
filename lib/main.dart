import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AfiqAlias | Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A192F),
        useMaterial3: true,
      ),
      home: const ProfilePage(),
    );
  }
}

// ─────────────────────────────────────────────
//  SCROLL-REVEAL WRAPPER
// ─────────────────────────────────────────────
class RevealOnScroll extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const RevealOnScroll({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _tryAnimate(BuildContext context) {
    if (_hasAnimated) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) return;
      final pos = box.localToGlobal(Offset.zero);
      final screenH = MediaQuery.of(context).size.height;
      if (pos.dy < screenH * 0.95) {
        _hasAnimated = true;
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _tryAnimate(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (_) {
        _tryAnimate(context);
        return false;
      },
      child: FadeTransition(
        opacity: _opacity,
        child: SlideTransition(position: _slide, child: widget.child),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PROFILE PAGE
// ─────────────────────────────────────────────
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenWidth > 700 ? 500 : double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth > 700 ? 0 : 20,
              vertical: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Avatar
                const AnimatedAvatarSection(),
                const SizedBox(height: 40),

                // Name Card
                RevealOnScroll(
                  delay: const Duration(milliseconds: 100),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF112240),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'AFIQ ALIAS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth > 700 ? 40 : 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const TypingText(
                          texts: [
                            'Software Engineering Student',
                            'Flutter Developer',
                            'UI/UX Enthusiast',
                            'Web & Mobile Coder',
                          ],
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              131,
                              64,
                              64,
                            ).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_fire_department,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Proud Perakian',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Divider(
                          color: Colors.white.withOpacity(0.1),
                          thickness: 1,
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          '"Passionate about turning ideas into clean code and building modern digital experiences."',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF00E5FF),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Info Cards
                RevealOnScroll(
                  delay: const Duration(milliseconds: 200),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.cake,
                          title: 'Date of Birth',
                          value: '01 Dec 2004',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.location_on,
                          title: 'Hometown',
                          value: 'Seri Manjung, Perak',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Skills
                RevealOnScroll(
                  delay: const Duration(milliseconds: 300),
                  child: _buildSkillsSection(),
                ),

                const SizedBox(height: 20),

                // Contact
                RevealOnScroll(
                  delay: const Duration(milliseconds: 400),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF112240),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFF00E5FF),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Catch me here!',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            _buildSocialSquare(
                              icon: Icons.email_outlined,
                              tooltip: 'Email Me',
                              onPressed: () => _launchURL(
                                'mailto:afiqalias224@gmail.com',
                              ),
                            ),
                            _buildSocialSquare(
                              icon: Icons.phone_outlined,
                              tooltip: 'Call Me',
                              onPressed: () =>
                                  _launchURL('tel:+601136414519'),
                            ),
                            _buildSocialSquare(
                              icon: FontAwesomeIcons.tiktok,
                              tooltip: 'TikTok',
                              onPressed: () => _launchURL(
                                'https://www.tiktok.com/',
                              ),
                            ),
                            _buildSocialSquare(
                              icon: FontAwesomeIcons.instagram,
                              tooltip: 'Instagram',
                              onPressed: () => _launchURL(
                                'https://www.instagram.com/',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

  // ── Skills Section builder ──
  Widget _buildSkillsSection() {
    const cyan = Color(0xFF00E5FF);

    final techTags = [
      'Flutter',
      'Dart',
      'Firebase',
      'Git',
      'Figma',
      'Python',
      'REST APIs',
      'UI/UX',
    ];

    final skills = [
      _SkillData('Flutter / Dart', 0.85),
      _SkillData('UI / UX Design', 0.75),
      _SkillData('Firebase', 0.65),
      _SkillData('Python', 0.60),
      _SkillData('Git & Version Control', 0.80),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF112240),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: cyan,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Skills & Tech Stack',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Animated skill bars
          ...skills.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: AnimatedSkillBar(skill: s),
            ),
          ),

          const SizedBox(height: 20),
          Divider(color: Colors.white.withOpacity(0.1), thickness: 1),
          const SizedBox(height: 16),

          // Tech tag chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: techTags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: cyan.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: cyan.withOpacity(0.35),
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: cyan,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF112240),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF00E5FF), size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.white54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialSquare({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      decoration: BoxDecoration(
        color: const Color(0xFF00E5FF).withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        color: Color(0xFF0A192F),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      verticalOffset: 40,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF1A2A4A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF00E5FF).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00E5FF).withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(icon),
          color: const Color(0xFF00E5FF),
          iconSize: 30,
          onPressed: onPressed,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TYPING TEXT WIDGET
// ─────────────────────────────────────────────
class TypingText extends StatefulWidget {
  final List<String> texts;
  final TextStyle style;

  const TypingText({super.key, required this.texts, required this.style});

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  int _textIndex = 0;
  String _displayed = '';
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _tick();
  }

  Future<void> _tick() async {
    while (mounted) {
      final full = widget.texts[_textIndex];

      if (!_isDeleting) {
        // Type forward
        for (int i = _displayed.length + 1; i <= full.length; i++) {
          if (!mounted) return;
          await Future.delayed(const Duration(milliseconds: 65));
          setState(() => _displayed = full.substring(0, i));
        }
        // Pause at end
        await Future.delayed(const Duration(milliseconds: 1800));
        _isDeleting = true;
      } else {
        // Delete backward
        for (int i = _displayed.length - 1; i >= 0; i--) {
          if (!mounted) return;
          await Future.delayed(const Duration(milliseconds: 35));
          setState(() => _displayed = full.substring(0, i));
        }
        _isDeleting = false;
        _textIndex = (_textIndex + 1) % widget.texts.length;
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_displayed, style: widget.style),
        // Blinking cursor
        _BlinkingCursor(color: widget.style.color ?? Colors.white),
      ],
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  final Color color;
  const _BlinkingCursor({required this.color});

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 530),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Text(
        '|',
        style: TextStyle(
          color: widget.color,
          fontSize: 18,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  ANIMATED SKILL BAR
// ─────────────────────────────────────────────
class _SkillData {
  final String name;
  final double level; // 0.0 – 1.0
  const _SkillData(this.name, this.level);
}

class AnimatedSkillBar extends StatefulWidget {
  final _SkillData skill;
  const AnimatedSkillBar({super.key, required this.skill});

  @override
  State<AnimatedSkillBar> createState() => _AnimatedSkillBarState();
}

class _AnimatedSkillBarState extends State<AnimatedSkillBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _widthAnim = Tween<double>(
      begin: 0,
      end: widget.skill.level,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    // Slight delay so scroll-reveal fires first
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const cyan = Color(0xFF00E5FF);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.skill.name,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            AnimatedBuilder(
              animation: _widthAnim,
              builder: (_, __) => Text(
                '${(_widthAnim.value * 100).round()}%',
                style: const TextStyle(
                  color: cyan,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 8,
            color: cyan.withOpacity(0.12),
            child: AnimatedBuilder(
              animation: _widthAnim,
              builder: (context, _) => FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _widthAnim.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00B4D8), cyan],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: cyan.withOpacity(0.4),
                        blurRadius: 6,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  ANIMATED AVATAR SECTION  (unchanged logic)
// ─────────────────────────────────────────────
class AnimatedAvatarSection extends StatefulWidget {
  const AnimatedAvatarSection({super.key});

  @override
  State<AnimatedAvatarSection> createState() => _AnimatedAvatarSectionState();
}

class _AnimatedAvatarSectionState extends State<AnimatedAvatarSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF00E5FF), width: 3.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E5FF).withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 70,
              backgroundColor: Colors.white12,
              backgroundImage: AssetImage('assets/Afiq.jpg'),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 90,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0A192F), width: 4),
              ),
            ),
          ),
          Positioned(
            left: 5,
            top: 70,
            child: _buildFloatingBadge(
              text: 'Code',
              icon: Icons.code,
              offsetDelay: 0.0,
            ),
          ),
          Positioned(
            right: 0,
            top: 20,
            child: _buildFloatingBadge(
              text: 'Design',
              icon: Icons.palette,
              offsetDelay: 1.5,
            ),
          ),
          Positioned(
            right: 15,
            bottom: 40,
            child: _buildFloatingBadge(
              text: 'Ideas',
              icon: Icons.lightbulb_outline,
              offsetDelay: 3.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingBadge({
    required String text,
    required IconData icon,
    required double offsetDelay,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double yOffset =
            math.sin((_controller.value * 2 * math.pi) + offsetDelay) * 8.0;
        return Transform.translate(offset: Offset(0, yOffset), child: child);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF112240).withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF00E5FF).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: const Color(0xFF00E5FF)),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
