import 'package:flutter/cupertino.dart';
import '../core/load_state.dart';
import '../models/pharmacy_model.dart';
import '../services/analytics_service.dart';
import '../services/google_sheets_service.dart';
import '../widgets/app_footer.dart';
import '../widgets/common_widgets.dart';

class PharmaciesScreen extends StatefulWidget { const PharmaciesScreen({super.key,required this.service}); final GoogleSheetsService service; @override State<PharmaciesScreen> createState()=>_PharmaciesScreenState(); }
class _PharmaciesScreenState extends State<PharmaciesScreen>{LoadState<List<PharmacyModel>> state=LoadState.loading(); @override void initState(){super.initState();AnalyticsService.instance.viewPharmacies();_load();} Future<void> _load() async {final r=await widget.service.fetchPharmacies();if(mounted)setState(()=>state=r);} @override Widget build(BuildContext context)=>CupertinoPageScaffold(navigationBar:const CupertinoNavigationBar(middle:Text('الصيدليات المناوبة')),child:SafeArea(child:StateView(state:state,onRetry:_load,builder:(items,cached){PharmacyModel? day,night;for(final p in items){if(day==null&&p.time.contains('ظهر'))day=p;if(night==null&&p.time.contains('ليل'))night=p;}final selected=[if(day!=null)day,if(night!=null)night];return ListView(padding:const EdgeInsets.all(16),children:[CachedBanner(visible:cached),...selected.map((p)=>Padding(padding:const EdgeInsets.only(bottom:12),child:GlassCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[const Icon(CupertinoIcons.bandage),const SizedBox(width:8),Expanded(child:Text(p.name,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w700))),Text(p.time)]),const SizedBox(height:10),Text(p.address.isEmpty?'العنوان غير متوفر':p.address)])))),if(selected.isEmpty)const Padding(padding:EdgeInsets.all(30),child:Center(child:Text('لا توجد مناوبات نهارية/ليلية مطابقة'))),const AppFooter()];}))));}
