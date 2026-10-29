import 'package:flutter/cupertino.dart';
import '../core/load_state.dart';
import '../models/lost_found_model.dart';
import '../services/analytics_service.dart';
import '../services/google_sheets_service.dart';
import '../widgets/app_footer.dart';
import '../widgets/common_widgets.dart';
import '../widgets/lost_found_post_card.dart';

class LostFoundScreen extends StatefulWidget { const LostFoundScreen({super.key, required this.service}); final GoogleSheetsService service; @override State<LostFoundScreen> createState() => _LostFoundScreenState(); }
class _LostFoundScreenState extends State<LostFoundScreen> {
  LoadState<List<LostFoundModel>> state = LoadState.loading(); LostFoundCategory category = LostFoundCategory.lost;
  @override void initState(){super.initState(); AnalyticsService.instance.viewLostFound(); _load();}
  Future<void> _load() async { if (mounted) setState(() => state = LoadState.loading()); final r = await widget.service.fetchLostFound(); if (mounted) setState(() => state = r); }
  @override Widget build(BuildContext context) => CupertinoPageScaffold(navigationBar: const CupertinoNavigationBar(middle: Text('المفقودات والموجودات')), child: SafeArea(child: StateView(state: state, onRetry: _load, builder: (items, cached) {
    final filtered = items.where((e) => e.category == category).toList();
    return CustomScrollView(slivers: [CupertinoSliverRefreshControl(onRefresh: _load), SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(14, 14, 14, 4), child: Column(children: [CachedBanner(visible: cached), CupertinoSlidingSegmentedControl<LostFoundCategory>(groupValue: category, children: const {LostFoundCategory.lost: Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8), child: Text('المفقودات')), LostFoundCategory.found: Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8), child: Text('الموجودات'))}, onValueChanged: (v){if(v!=null)setState(()=>category=v);})]))), if(filtered.isEmpty) const SliverFillRemaining(hasScrollBody: false, child: Center(child: Text('لا توجد منشورات في هذه الفئة حالياً'))), SliverList.builder(itemCount: filtered.length, itemBuilder: (_, i) => LostFoundPostCard(post: filtered[i])), const SliverToBoxAdapter(child: AppFooter())]);
  })));
}
