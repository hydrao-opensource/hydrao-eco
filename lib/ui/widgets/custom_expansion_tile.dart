import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/theme.dart';
import 'package:hydrao_flutter_offline/ui/widgets/click_tooltip.dart';

const _kAnimDuration = Duration(milliseconds: 200);

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final String? titleHelp;
  final Function? onTitleHelpClicked;
  final bool expanded;
  final bool expandable;
  final Widget? trailingButton;
  final List<Widget> children;
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry contentPadding;
  final double globalPadding;
  final Color backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final bool titleCentered;
  final bool contentScrollable;
  final double? contentHeight;
  final CrossAxisAlignment contentAlignement;

  const CustomExpansionTile({
    super.key,
    required this.title,
    this.titleHelp,
    this.onTitleHelpClicked,
    this.expanded = false,
    this.expandable = true,
    this.trailingButton,
    required this.children,
    this.headerPadding = const EdgeInsets.only(top: 10, bottom: 5),
    this.contentPadding = const EdgeInsets.only(top: 5.0),
    this.titleCentered = false,
    this.contentScrollable = false,
    this.contentHeight,
    this.globalPadding = 8.0,
    this.backgroundColor = Colors.white,
    this.foregroundColor,
    this.borderColor,
    this.contentAlignement = CrossAxisAlignment.center,
  }) : assert(
         titleHelp == null || onTitleHelpClicked == null,
         'titleHelp and onTitleHelpClicked cannot both be set',
       );

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;
  late ScrollController _scrollController;
  bool _hasScroll = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateHasScroll);
    _isExpanded = widget.expanded;
  }

  @override
  void didUpdateWidget(CustomExpansionTile old) {
    super.didUpdateWidget(old);
    if (old.expanded != widget.expanded) {
      setState(() => _isExpanded = widget.expanded);
    }
  }

  void _updateHasScroll() {
    if (!_scrollController.hasClients) return;
    final newValue = _scrollController.position.maxScrollExtent > 0;
    if (newValue != _hasScroll) {
      setState(() => _hasScroll = newValue);
    }
  }

  void _toggleExpanded() {
    if (!widget.expandable) return;
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateHasScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildExpandIcon() => AnimatedRotation(
    turns: _isExpanded ? 0 : -0.25,
    duration: _kAnimDuration,
    child: Icon(
      Icons.expand_more,
      color: widget.foregroundColor ?? AppTheme.sectionTitleColor,
    ),
  );

  Widget _buildHeader() => InkWell(
    onTap: _toggleExpanded,
    child: Padding(
      padding: widget.headerPadding,
      child: Row(
        mainAxisAlignment: widget.titleCentered
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          if (!widget.titleCentered && widget.expandable) ...[
            _buildExpandIcon(),
            const SizedBox(width: 8),
          ],
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    widget.title.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: widget.foregroundColor ?? AppTheme.sectionTitleColor,
                      fontSize: AppTheme.sectionTitleFontSize,
                    ),
                    softWrap: true,
                    maxLines: 3,
                  ),
                ),
                if (widget.titleHelp != null || widget.onTitleHelpClicked != null)
                  const SizedBox(width: 3),
                if (widget.titleHelp != null)
                  ClickTooltip(
                    message: widget.titleHelp!,
                    child: Icon(Icons.help_outline),
                  ),
                if (widget.onTitleHelpClicked != null)
                  InkWell(
                    onTap: () => widget.onTitleHelpClicked!(),
                    child: Icon(Icons.help_outline),
                  ),
              ],
            ),
          ),
          if (widget.trailingButton != null) ...[
            Spacer(),
            widget.trailingButton!,
          ],
          if (widget.titleCentered && widget.expandable) ...[
            const SizedBox(width: 8),
            _buildExpandIcon(),
          ],
        ],
      ),
    ),
  );

  BoxDecoration get _decoration => BoxDecoration(
    color: widget.backgroundColor,
    borderRadius: BorderRadius.circular(8),
    border: widget.borderColor != null
        ? BoxBorder.all(color: widget.borderColor!, width: 1)
        : null,
  );

  EdgeInsets get _outerPadding => EdgeInsets.symmetric(
    vertical: widget.globalPadding,
    horizontal: widget.globalPadding,
  );

  @override
  Widget build(BuildContext context) {
    // When contentScrollable, the tile must live inside a parent that provides
    // a bounded height (e.g. Expanded in DashboardScreen). The Column fills
    // that bounded space and Expanded gives SingleChildScrollView a finite
    // constraint so it can scroll — no GlobalKey or post-frame measurement needed.
    if (widget.contentScrollable) {
      final scrollable = NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) {
          _updateHasScroll();
          return true;
        },
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: _isExpanded,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: EdgeInsets.only(right: _hasScroll ? 12 : 0),
              child: Column(
                crossAxisAlignment: widget.contentAlignement,
                mainAxisSize: MainAxisSize.min,
                children: widget.children,
              ),
            ),
          ),
        ),
      );

      return Container(
        padding: _outerPadding,
        decoration: _decoration,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildHeader(),
            if (_isExpanded)
              Expanded(
                child: Padding(
                  padding: widget.contentPadding,
                  child: scrollable,
                ),
              ),
          ],
        ),
      );
    }

    // Default: natural height, animated expand/collapse.
    final content = Column(
      crossAxisAlignment: widget.contentAlignement,
      children: widget.children,
    );

    return Container(
      padding: _outerPadding,
      decoration: _decoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: widget.contentPadding,
              child: content,
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: _kAnimDuration,
          ),
        ],
      ),
    );
  }
}
