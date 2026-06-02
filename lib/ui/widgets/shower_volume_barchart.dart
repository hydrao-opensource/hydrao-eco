import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hydrao_flutter_offline/conversions.dart';
import 'package:hydrao_flutter_offline/l10n/app_localizations.dart';
import 'package:hydrao_flutter_offline/models/shower_data.dart';
import 'package:hydrao_flutter_offline/utils.dart';

class ShowerVolumeBarChart extends StatefulWidget {
  final List<ShowerData> showers;
  final int? selectedShowerId;
  final String unit;
  final ValueChanged<ShowerData?>? onBarSelected;
  final bool showIds;

  const ShowerVolumeBarChart({
    super.key,
    required this.showers,
    required this.unit,
    this.selectedShowerId,
    this.onBarSelected,
    this.showIds = true,
  });

  @override
  State<ShowerVolumeBarChart> createState() => _ShowerVolumeBarChartState();
}

class _ShowerVolumeBarChartState extends State<ShowerVolumeBarChart> {
  final ScrollController _scrollController = ScrollController();
  bool _canScrollLeft = false;
  bool _canScrollRight = false;

  static const double _barWidth = 16.0;
  static const double _leftAxisWidth = 32.0;
  late double _groupsSpace;

  @override
  void initState() {
    super.initState();

    _groupsSpace = (widget.showIds == true) ? 24.0 : 16.0;

    _scrollController.addListener(_updateScrollIndicators);

    // Attendre la première frame pour scroller complètement à droite
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });
  }

  @override
  void didUpdateWidget(covariant ShowerVolumeBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    // On détecte un changement de liste de douches
    final bool lengthChanged =
        widget.showers.length != oldWidget.showers.length;

    // Optionnel : si tu veux être plus robuste que la longueur
    int? oldLastId = oldWidget.showers.isNotEmpty
        ? oldWidget.showers.last.entity.id
        : null;
    int? newLastId = widget.showers.isNotEmpty
        ? widget.showers.last.entity.id
        : null;
    final bool lastChanged = oldLastId != newLastId;

    if (lengthChanged || lastChanged) {
      // On attend la fin du layout avant de scroller
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToEnd();
      });
    } else if (widget.selectedShowerId != oldWidget.selectedShowerId &&
        widget.selectedShowerId != null) {
      // Si la sélection a changé et n'est pas nulle, on vérifie la visibilité
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelected();
      });
    }
  }

  void _scrollToSelected() {
    if (!_scrollController.hasClients || widget.selectedShowerId == null) {
      return;
    }

    // 1. Trouver l'index de la douche sélectionnée
    final index = widget.showers.indexWhere(
      (s) => s.entity.id == widget.selectedShowerId,
    );
    if (index == -1) return;

    // 2. Calculer la position X théorique de la barre
    // La largeur d'un groupe est (_barWidth + _groupsSpace)
    // On ajoute un petit décalage pour centrer ou au moins voir la barre
    final double itemWidth = _barWidth + _groupsSpace;
    final double selectedBarX = index * itemWidth;

    final double currentScroll = _scrollController.offset;
    final double viewportWidth = _scrollController.position.viewportDimension;

    // 3. Vérifier si la barre est hors champ
    // On laisse une petite marge de sécurité (buffer) de 20 pixels
    const double buffer = 20.0;

    bool isOffRight =
        (selectedBarX + itemWidth) > (currentScroll + viewportWidth - buffer);
    bool isOffLeft = selectedBarX < (currentScroll + buffer);

    if (isOffRight || isOffLeft) {
      // Calcul de la cible : on essaie de centrer la barre dans le viewport
      double targetScroll =
          selectedBarX - (viewportWidth / 2) + (itemWidth / 2);

      // On borne la valeur entre 0 et le max scrollable
      targetScroll = targetScroll.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );

      _scrollController.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToEnd() {
    if (!_scrollController.hasClients) return;

    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    _updateScrollIndicators();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollIndicators);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleBarTap(int index) {
    if (index < 0 || index >= widget.showers.length) {
      widget.onBarSelected?.call(null);
      return;
    }

    final tapped = widget.showers[index];

    if (tapped.entity.id == widget.selectedShowerId) {
      widget.onBarSelected?.call(null);
    } else {
      widget.onBarSelected?.call(tapped);
    }
  }

  void _updateScrollIndicators() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;

    final canLeft = offset > 1.0;
    final canRight = offset < maxScroll - 1.0;

    if (canLeft != _canScrollLeft || canRight != _canScrollRight) {
      setState(() {
        _canScrollLeft = canLeft;
        _canScrollRight = canRight;
      });
    }
  }

  Future<void> _scrollByPage({required bool toRight}) async {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final viewport = position.viewportDimension;
    final current = position.pixels;

    final delta = toRight ? viewport * 0.8 : -viewport * 0.8;
    double target = current + delta;

    target = math.max(0, math.min(target, position.maxScrollExtent));

    await _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );

    _updateScrollIndicators();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (widget.showers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(t.showerVolumeBarchartNoShowerTitle),
            SizedBox(height: 30),
            Text(
              t.showerVolumeBarchartNoShowerMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
      );
    }

    final maxVolume = widget.showers
        .map((s) => s.entity.volume.toDouble())
        .fold<double>(0, (prev, v) => v > prev ? v : prev);

    final size = MediaQuery.of(context).size;

    final totalChartWidth =
        widget.showers.length * (_barWidth + _groupsSpace) + _leftAxisWidth;
    final chartWidth = math.max(size.width - 72, totalChartWidth);
    // -72 ≈ marge + axe Y

    return SizedBox(
      height: 260,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            // Axe Y fixe à gauche
            SizedBox(width: 35, child: _buildStaticYAxis(maxVolume)),
            // Petite barre verticale pour séparer
            Container(width: 1, height: double.infinity, color: Colors.grey),
            const SizedBox(width: 4),

            // Zone graphique scrollable
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    child: SizedBox(
                      width: chartWidth,
                      child: BarChart(
                        duration: Duration.zero,
                        BarChartData(
                          maxY: maxVolume == 0 ? 1 : maxVolume * 1.1,
                          barGroups: _buildBarGroups(),
                          barTouchData: BarTouchData(
                            enabled: true,
                            handleBuiltInTouches: false,
                            touchTooltipData: BarTouchTooltipData(
                              fitInsideVertically: true,
                              fitInsideHorizontally: true,
                              tooltipPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              tooltipMargin: 2,
                              // rotateAngle: -90,
                              getTooltipColor: (BarChartGroupData data) =>
                                  Colors.transparent,
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                final index = group.x.toInt();
                                if (index < 0 ||
                                    index >= widget.showers.length) {
                                  return null;
                                }
                                final shower = widget.showers[index];
                                String fixedVolume = formatVolume(
                                  getVolumeForUnit(
                                    shower.entity.volume.toDouble(),
                                    widget.unit,
                                  ),
                                );
                                // if (shower.entity.isReference == true) {
                                //   fixedVolume = "$fixedVolume (*)";
                                // }

                                Color textColor = Colors.black.lighten(0.2);
                                if (shower.entity.isReference == true) {
                                  textColor = Colors.black;
                                } else if (shower.entity.isIgnored == true) {
                                  textColor = Colors.black.lighten(0.6);
                                }
                                // if ()
                                return BarTooltipItem(
                                  '',
                                  const TextStyle(), // base ignorée, tout passe par children
                                  children: [
                                    TextSpan(
                                      text: fixedVolume,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight:
                                            shower.entity.isReference == true
                                            ? FontWeight.bold
                                            : FontWeight.w400,
                                        color: textColor,
                                        // backgroundColor:
                                        //     shower.entity.isReference == true
                                        //     ? Colors.white
                                        //     : Colors.transparent,
                                      ),
                                    ),
                                    if (shower.entity.isReference)
                                      TextSpan(
                                        text: "*",
                                        style: TextStyle(
                                          fontSize: 10, // plus petit
                                          height:
                                              0.5, // remonte artificiellement
                                        ),
                                      ),

                                    // const TextSpan(
                                    //   text: '\n',
                                    // ), // retour à la ligne
                                    // TextSpan(
                                    //   text: widget.unit,
                                    //   style: const TextStyle(
                                    //     fontSize: 8,
                                    //     fontWeight: FontWeight.w500,
                                    //     color: Colors.grey,
                                    //   ),
                                    // ),
                                  ],
                                );
                              },
                            ),
                            touchCallback: (event, response) {
                              if (!event.isInterestedForInteractions ||
                                  response == null ||
                                  response.spot == null) {
                                widget.onBarSelected?.call(null);
                                return;
                              }
                              final index = response.spot!.touchedBarGroupIndex;
                              _handleBarTap(index);
                            },
                          ),
                          titlesData: FlTitlesData(
                            // On désactive les titres de gauche : l’axe Y ne scrolle plus.
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: widget.showIds,
                                reservedSize: 32,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < 0 ||
                                      index >= widget.showers.length) {
                                    return const SizedBox.shrink();
                                  }

                                  final shower = widget.showers[index];
                                  final isSelected =
                                      shower.entity.id ==
                                      widget.selectedShowerId;

                                  return SideTitleWidget(
                                    meta: meta,
                                    space: 4,
                                    child: GestureDetector(
                                      onTap: () => _handleBarTap(index),
                                      child: Text(
                                        shower.entity.id.toString(),
                                        style: TextStyle(
                                          fontSize: isSelected ? 12 : 10,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? Colors.purpleAccent
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: const Border(
                              // plus de bord gauche : c’est la colonne fixe
                              bottom: BorderSide(color: Colors.grey),
                              right: BorderSide(color: Colors.transparent),
                              top: BorderSide(color: Colors.transparent),
                              left: BorderSide(color: Colors.transparent),
                            ),
                          ),
                          groupsSpace: _groupsSpace,
                        ),
                      ),
                    ),
                  ),

                  // Bouton + hint à gauche
                  if (_canScrollLeft)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: _buildScrollHintButton(
                        t: t,
                        isLeft: true,
                        icon: Icons.chevron_left,
                        onTap: () => _scrollByPage(toRight: false),
                      ),
                    ),

                  // Bouton + hint à droite
                  if (_canScrollRight)
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: _buildScrollHintButton(
                        t: t,
                        isLeft: false,
                        icon: Icons.chevron_right,
                        onTap: () => _scrollByPage(toRight: true),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Axe Y fixe : quelques repères (0, milieu, max)
  Widget _buildStaticYAxis(double maxVolume) {
    final fixedMaxVolume = getVolumeForUnit(maxVolume, widget.unit);
    final effectiveMax = fixedMaxVolume == 0 ? 1.0 : fixedMaxVolume.toDouble();
    final step = effectiveMax / 3;

    // 0 -> bas, max -> haut
    final labels = [0.0, step, step * 2, effectiveMax];

    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;

          // si très peu de place, on sera en colonne (valeur au-dessus, unité dessous)
          final bool isNarrow = maxWidth < 30;

          // tailles de base, ajustées si étroit
          final double valueFontSize = isNarrow ? 7 : 8;
          final double unitFontSize = isNarrow ? 5.5 : 6;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: labels.reversed.map((v) {
              final fixedVolume = formatVolume(
                getVolumeForUnit(v, widget.unit),
              );

              if (isNarrow) {
                // 💡 Version empilée : valeur sur une ligne, unité en dessous
                return SizedBox(
                  width: maxWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          fixedVolume,
                          style: TextStyle(
                            fontSize: valueFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          widget.unit,
                          style: TextStyle(
                            fontSize: unitFontSize,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // 💡 Version en ligne : valeur + unité côte à côte,
                // avec FittedBox pour réduire si vraiment trop long
                return SizedBox(
                  width: maxWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            fixedVolume,
                            style: TextStyle(
                              fontSize: valueFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          widget.unit,
                          style: TextStyle(
                            fontSize: unitFontSize,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildScrollHintButton({
    required AppLocalizations t,
    required bool isLeft,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 40,
      child: Stack(
        children: [
          // Gradient purement visuel : ne bloque pas les interactions
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
                  end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
                  colors: [
                    Colors.white.withValues(alpha: 0.9),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Seul ce bouton intercepte les taps
          Align(
            alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1), // ombre légère
                    blurRadius: 6, // adoucit l’ombre
                    offset: const Offset(0, 2), // décale verticalement
                  ),
                ],
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ), // réduit un peu la zone cliquable
                icon: Icon(icon, size: 22, color: Colors.grey[700]),
                onPressed: onTap,
                tooltip: isLeft
                    ? t.showerVolumeBarchartSeePreviousShowers
                    : t.showerVolumeBarchartSeeNextShowers,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(widget.showers.length, (index) {
      final shower = widget.showers[index];
      final isSelected = shower.entity.id == widget.selectedShowerId;

      final colorScheme = Theme.of(context).colorScheme;

      // add specific color for volume > max thresholds
      double? maxVolume;
      if (shower.entity.threshold != null) {
        maxVolume = getThresholdsMaxVolume(
          thresholdsFromJson(shower.entity.threshold!)!,
        );
      }

      Color exceededColor = Colors.red;
      double stopValue = 1.0;
      if (maxVolume != null && shower.entity.volume > maxVolume) {
        stopValue =
            (maxVolume / (shower.entity.volume > 0 ? shower.entity.volume : 1))
                .clamp(0.0, 1.0);
      }

      Color barColor = colorScheme.primary.lighten(0.4);
      Color? borderColor = (isSelected) ? Colors.white : Colors.transparent;
      if (shower.isLive == false && shower.entity.isIgnored) {
        barColor = (isSelected)
            ? colorScheme.primary.withValues(alpha: 0.3)
            : colorScheme.primary.withValues(alpha: 0.1);
        exceededColor = (isSelected)
            ? exceededColor.withValues(alpha: 0.3)
            : exceededColor.withValues(alpha: 0.1);
      } else if (shower.isLive == true) {
        barColor = (isSelected)
            ? Colors.green.withValues(alpha: 0.5)
            : Colors.green.withValues(alpha: 0.3);
        exceededColor = (isSelected)
            ? exceededColor.withValues(alpha: 0.5)
            : exceededColor.withValues(alpha: 0.3);
      } else {
        barColor = (isSelected)
            ? colorScheme.primary.lighten(0.1)
            : colorScheme.primary.lighten(0.4);
        exceededColor = (isSelected)
            ? exceededColor.lighten(0.1)
            : exceededColor.lighten(0.2);
      }

      return BarChartGroupData(
        x: index,
        // <- demande à fl_chart d’afficher le tooltip de cette barre
        showingTooltipIndicators: const [0],
        barRods: [
          BarChartRodData(
            toY: shower.entity.volume.toDouble(),
            width: isSelected ? _barWidth + 2 : _barWidth,
            // color: stopValue == null ? barColor : null,
            gradient: LinearGradient(
              colors: [
                barColor, // Couleur sous le seuil
                exceededColor, // Couleur au-dessus du seuil
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [
                stopValue, // Le point de transition (ex: 5 / 10 = 0.5)
                stopValue,
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
        ],
      );
    });
  }
}
