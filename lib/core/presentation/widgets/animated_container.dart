import 'package:flutter/material.dart';
import 'package:Arkroot/core/presentation/utils/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedClickableTextContainer extends StatefulWidget {
  final bool isActive;
  final String iconSrc;
  final String title;
  final Color bgColor;
  final Color bgColorHover;
  final VoidCallback press;

  const AnimatedClickableTextContainer({
    super.key,
    required this.isActive,
    required this.iconSrc,
    required this.title,
    required this.press,
    required this.bgColor,
    required this.bgColorHover,
  });

  @override
  State createState() {
    return _AnimatedClickableTextContainerState();
  }
}

class _AnimatedClickableTextContainerState
    extends State<AnimatedClickableTextContainer> {
  bool isHover = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isHover ? 20 : 20),
        color: isHover ? widget.bgColorHover : widget.bgColor,
      ),
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(
        top: (isHover) ? 1 : 1,
        bottom: !(isHover) ? 1 : 1,
      ),

      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onHover: (val) => setState(() => isHover = val),
          onFocusChange: (val) => setState(() => isHover = val),
          onTapDown: (_) => setState(() => isHover = true),
          onTapUp: (_) => setState(() => isHover = false),
          onTapCancel: () => setState(() => isHover = false),
          onTap: widget.press,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: getMenuItem(),
          ),
        ),
      ),
    );
  }

  Widget getMenuItem() {
    return Container(
      padding: const EdgeInsets.only(bottom: 1, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isHover ? 20 : 20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.iconSrc.isNotEmpty)
            SvgPicture.asset(
              widget.iconSrc,
              height: 20,
              width: 20,
              colorFilter: ColorFilter.mode(
                (widget.isActive || isHover)
                    ? appColors.sideMenuHighlight
                    : appColors.sideMenuNormal,
                BlendMode.srcIn,
              ),
            ),
          if (widget.iconSrc.isNotEmpty) const SizedBox(width: 15),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color:
                  (widget.isActive || isHover)
                      ? appColors.buttonTextColorHover
                      : appColors.buttonTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
