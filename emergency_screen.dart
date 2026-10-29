import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/load_state.dart';
import '../models/emergency_model.dart';
import '../services/analytics_service.dart';
import '../services/google_sheets_service.dart';
import '../widgets/app_footer.dart';
import '../widgets/common_widgets.dart';
class EmergencyScreen extends StatefulWidget{const EmergencyScreen({super.key,required this.service});final GoogleSheetsService service;@override State<EmergencyScreen> createState()=>_EmergencyScreenState();}
class _EmergencyScreenState extends State<EmergencyScreen>{LoadState<List<EmergencyModel>> state=LoadState.loading();@override void initState(){super.initState();_load();}Future<void> _load()async{final r=await widget.service.fetchEmergency();if(mounted)setState(()=>state=r);}Future<void> _call(EmergencyModel e)async{await AnalyticsService.instance.emergencyCall(e.department);final p=e.phoneNumber.replaceAll(RegExp(r'[^0-9+]'),'');if(p.isNotEmpty)await launchUrl(Uri(scheme:'tel',path:p));}@override Widget build(BuildContext context)=>CupertinoPageScaffold(navigationBar:const CupertinoNavigationBar(middle:Text('أرقام الطوارئ')),child:SafeArea(child:StateView(state:state,onRetry:_load,builder:(items,cached)=>ListView(padding:const EdgeInsets.all(16),children:[CachedBanner(visible:cached),...items.map((e)=>Padding(padding:const EdgeInsets.only(bottom:10),child:GlassCard(child:Row(children:[Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(e.department,style:const TextStyle(fontWeight:FontWeight.w700,fontSize:17)),const SizedBox(height:5),Text(e.phoneNumber)])),CupertinoButton(onPressed:()=>_call(e),child:const Icon(CupertinoIcons.phone_fill))]))),const AppFooter()]))));}
