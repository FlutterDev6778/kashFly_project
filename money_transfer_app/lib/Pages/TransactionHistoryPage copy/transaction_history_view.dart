// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:keicy_cupertino_indicator/keicy_cupertino_indicator.dart';
// import 'package:money_transfer_app/Pages/CreditCardPage/index.dart';
// import 'package:money_transfer_app/Pages/RecipientViewPage/recipient_view_page.dart';
// import 'package:money_transfer_app/Providers/TransactionHistoryProvider/transaction_history_provider.dart';
// import 'package:money_transfer_framework/money_transfer_framework.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
// import 'package:provider/provider.dart';

// import 'package:keicy_inkwell/keicy_inkwell.dart';
// import 'package:keicy_avatar_image/keicy_avatar_image.dart';
// import 'package:keicy_progress_dialog/keicy_progress_dialog.dart';
// import 'package:keicy_raised_button/keicy_raised_button.dart';
// import 'package:keicy_utils/date_time_convert.dart';

// import 'package:money_transfer_app/Pages/App/index.dart';
// import 'package:money_transfer_app/Providers/index.dart';

// import 'index.dart';

// class TransactionHistoryView extends StatefulWidget {
//   final TransactionHistoryPageStyles transactionHistoryPageStyles;

//   const TransactionHistoryView({
//     Key key,
//     this.transactionHistoryPageStyles,
//   }) : super(key: key);

//   @override
//   _TransferViewState createState() => _TransferViewState();
// }

// class _TransferViewState extends State<TransactionHistoryView> with TickerProviderStateMixin {
//   TransactionHistoryProvider _transactionHistoryProvider;
//   KeicyProgressDialog _keicyProgressDialog;

//   TabController _tabController;

//   @override
//   void initState() {
//     super.initState();

//     _transactionHistoryProvider = TransactionHistoryProvider.of(context);

//     _tabController = TabController(length: 2, initialIndex: 0, vsync: this);

//     _transactionHistoryProvider.setTransactionHistoryState(
//       _transactionHistoryProvider.transactionHistoryState.update(progressState: 0, errorString: ""),
//       isNotifiable: false,
//     );

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _transactionHistoryProvider.addListener(_transactionHistoryProviderListener);

//       _keicyProgressDialog = KeicyProgressDialog.of(
//         context,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         layout: Layout.Column,
//         padding: EdgeInsets.zero,
//         width: widget.transactionHistoryPageStyles.widthDp * 120,
//         height: widget.transactionHistoryPageStyles.widthDp * 120,
//         progressWidget: Container(
//           width: widget.transactionHistoryPageStyles.widthDp * 120,
//           height: widget.transactionHistoryPageStyles.widthDp * 120,
//           padding: EdgeInsets.all(widget.transactionHistoryPageStyles.widthDp * 20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(widget.transactionHistoryPageStyles.widthDp * 10),
//           ),
//           child: SpinKitFadingCircle(
//             color: AppColors.primaryColor,
//             size: widget.transactionHistoryPageStyles.widthDp * 80,
//           ),
//         ),
//         message: "",
//       );

//       if (_transactionHistoryProvider.transactionHistoryState.pendingTransactionListStream == null)
//         _transactionHistoryProvider.getPendingTransactioinStream(UserProvider.of(context).userState.userModel.id);
//       if (_transactionHistoryProvider.transactionHistoryState.receivedTransactionListStream == null)
//         _transactionHistoryProvider.getReceivedTransactioinStream(UserProvider.of(context).userState.userModel.id);
//     });
//   }

//   @override
//   void dispose() {
//     _transactionHistoryProvider.removeListener(_transactionHistoryProviderListener);

//     super.dispose();
//   }

//   void _transactionHistoryProviderListener() async {
//     if (_transactionHistoryProvider.transactionHistoryState.progressState != 1 && _keicyProgressDialog.isShowing()) {
//       await _keicyProgressDialog.hide();
//     }

//     switch (_transactionHistoryProvider.transactionHistoryState.progressState) {
//       case 0:
//         break;
//       case 1:
//         break;
//       case 2:
//         break;
//       case -1:
//         break;
//       default:
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           brightness: Brightness.dark,
//           backgroundColor: AppColors.primaryColor,
//           title: Text(TransactionHistoryPageString.title, style: widget.transactionHistoryPageStyles.title2Style),
//           bottom: TabBar(
//             controller: _tabController,
//             labelStyle: widget.transactionHistoryPageStyles.tabItemStyle,
//             indicatorSize: TabBarIndicatorSize.tab,
//             labelColor: AppColors.whiteColor,
//             unselectedLabelColor: Colors.white.withAlpha(100),
//             indicatorColor: AppColors.whiteColor,
//             labelPadding: EdgeInsets.only(bottom: widget.transactionHistoryPageStyles.widthDp * 10),
//             indicatorWeight: 5,
//             tabs: [
//               Text(TransactionHistoryPageString.tabItem1),
//               Text(TransactionHistoryPageString.tabItem2),
//             ],
//           ),
//         ),
//         body: KeicyInkWell(
//           child: Container(
//             height: widget.transactionHistoryPageStyles.mainHeight,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // SizedBox(height: widget.transactionHistoryPageStyles.statusbarHeight),
//                 // SizedBox(height: widget.transactionHistoryPageStyles.primaryVerticalPadding),
//                 // Container(
//                 //   padding: EdgeInsets.symmetric(
//                 //     horizontal: widget.transactionHistoryPageStyles.primaryHorizontalPadding,
//                 //   ),
//                 //   child: _containerHeader(context),
//                 // ),
//                 // SizedBox(height: widget.transactionHistoryPageStyles.widthDp * 20),
//                 // _containerTabs(context),
//                 SizedBox(height: widget.transactionHistoryPageStyles.widthDp * 20),
//                 Expanded(
//                   child: _containerTabView(context),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _containerHeader(BuildContext context) {
//     return RichText(
//       text: TextSpan(
//         children: <TextSpan>[
//           TextSpan(text: TransactionHistoryPageString.title.split(' ')[0].substring(0, 1), style: widget.transactionHistoryPageStyles.title1Style),
//           TextSpan(text: TransactionHistoryPageString.title.split(' ')[0].substring(1), style: widget.transactionHistoryPageStyles.title2Style),
//           TextSpan(text: " ", style: widget.transactionHistoryPageStyles.title2Style),
//           TextSpan(text: TransactionHistoryPageString.title.split(' ')[1].substring(0, 1), style: widget.transactionHistoryPageStyles.title1Style),
//           TextSpan(text: TransactionHistoryPageString.title.split(' ')[1].substring(1), style: widget.transactionHistoryPageStyles.title2Style),
//         ],
//       ),
//     );
//   }

//   Widget _containerTabs(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             spreadRadius: 0,
//             blurRadius: widget.transactionHistoryPageStyles.widthDp * 2,
//             offset: Offset(0, widget.transactionHistoryPageStyles.widthDp * 2), // changes position of shadow
//           ),
//         ],
//       ),
//       child: TabBar(
//         controller: _tabController,
//         labelStyle: widget.transactionHistoryPageStyles.tabItemStyle,
//         indicatorSize: TabBarIndicatorSize.tab,
//         labelColor: AppColors.blackColor,
//         unselectedLabelColor: Colors.grey.withAlpha(200),
//         indicatorColor: AppColors.primaryColor,
//         labelPadding: EdgeInsets.only(bottom: widget.transactionHistoryPageStyles.widthDp * 10),
//         indicatorWeight: 5,
//         tabs: [
//           Text(TransactionHistoryPageString.tabItem1),
//           Text(TransactionHistoryPageString.tabItem2),
//         ],
//       ),
//     );
//   }

//   Widget _containerTabView(BuildContext context) {
//     return KeicyInkWell(
//       child: TabBarView(
//         controller: _tabController,
//         children: [
//           _containerPendingTransaction(context),
//           _containerReceivedTransaction(context),
//         ],
//       ),
//     );
//   }

//   Widget _containerPendingTransaction(BuildContext context) {
//     return Consumer<TransactionHistoryProvider>(builder: (context, transactionHistoryProvider, _) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: StreamBuilder<List<Stream<Map<String, dynamic>>>>(
//                 stream: transactionHistoryProvider.transactionHistoryState.pendingTransactionListStream,
//                 builder: (context, transactionSnapshot) {
//                   if (!transactionSnapshot.hasData) {
//                     return Center(
//                       child: KeicyCupertinoIndicator(),
//                     );
//                   }

//                   if (transactionSnapshot.data.length == 0) {
//                     return Center(
//                       child: Text("No Pending Transaction", style: widget.transactionHistoryPageStyles.textStyle),
//                     );
//                   }

//                   return ListView.builder(
//                     padding: EdgeInsets.zero,
//                     addRepaintBoundaries: false,
//                     itemBuilder: (context, index) {
//                       return StreamBuilder<Map<String, dynamic>>(
//                           stream: transactionSnapshot.data[index],
//                           builder: (context, snapshot) {
//                             if (!snapshot.hasData) {
//                               return Container(
//                                 height: widget.transactionHistoryPageStyles.historyCardHeight,
//                                 child: Center(child: KeicyCupertinoIndicator()),
//                               );
//                             }

//                             if (snapshot.data == null) {
//                               return SizedBox();
//                             }

//                             TransactionModel transactionModel = snapshot.data["transactionModel"];
//                             RecipientModel recipientModel = snapshot.data["recipientModel"];

//                             return Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: widget.transactionHistoryPageStyles.historyCardHorizontalPadding,
//                               ),
//                               child: GestureDetector(
//                                 onTap: () {},
//                                 child: Container(
//                                   height: widget.transactionHistoryPageStyles.historyCardHeight,
//                                   margin: EdgeInsets.all(widget.transactionHistoryPageStyles.widthDp * 5),
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: widget.transactionHistoryPageStyles.widthDp * 20,
//                                     vertical: widget.transactionHistoryPageStyles.widthDp * 20,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: AppColors.whiteColor,
//                                     borderRadius: BorderRadius.circular(widget.transactionHistoryPageStyles.widthDp * 15),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey.withOpacity(0.5),
//                                         spreadRadius: 0,
//                                         blurRadius: widget.transactionHistoryPageStyles.widthDp * 5,
//                                         offset: Offset(0, 0), // changes position of shadow
//                                       ),
//                                     ],
//                                   ),
//                                   alignment: Alignment.center,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: <Widget>[
//                                       Row(
//                                         children: [
//                                           KeicyAvatarImage(
//                                             url: recipientModel.avatarUrl,
//                                             userName: recipientModel.firstName,
//                                             width: widget.transactionHistoryPageStyles.historyCardHeight * 0.6,
//                                             height: widget.transactionHistoryPageStyles.historyCardHeight * 0.6,
//                                           ),
//                                           SizedBox(width: widget.transactionHistoryPageStyles.widthDp * 10),
//                                           Text(
//                                             recipientModel.firstName,
//                                             style: widget.transactionHistoryPageStyles.textStyle,
//                                             overflow: TextOverflow.ellipsis,
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ],
//                                       ),
//                                       Column(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "\$${transactionModel.amount}",
//                                             style: widget.transactionHistoryPageStyles.amountStyle,
//                                             overflow: TextOverflow.ellipsis,
//                                             textAlign: TextAlign.center,
//                                           ),
//                                           Text(
//                                             "${KeicyDateTime.convertMillisecondsToDateString(ms: transactionModel.ts)}",
//                                             style: widget.transactionHistoryPageStyles.textStyle,
//                                             overflow: TextOverflow.ellipsis,
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           });
//                     },
//                     // separatorBuilder: (context, index) {
//                     //   return SizedBox(width: widget.transactionHistoryPageStyles.widthDp * 10);
//                     // },
//                     itemCount: transactionSnapshot.data.length,
//                   );
//                 }),
//           ),
//         ],
//       );
//     });
//   }

//   Widget _containerReceivedTransaction(BuildContext context) {
//     return Consumer<TransactionHistoryProvider>(builder: (context, transactionHistoryProvider, _) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: StreamBuilder<List<Stream<Map<String, dynamic>>>>(
//                 stream: transactionHistoryProvider.transactionHistoryState.receivedTransactionListStream,
//                 builder: (context, transactionSnapshot) {
//                   if (!transactionSnapshot.hasData) {
//                     return Center(
//                       child: KeicyCupertinoIndicator(),
//                     );
//                   }

//                   if (transactionSnapshot.data.length == 0) {
//                     return Center(
//                       child: Text("No Received Transaction", style: widget.transactionHistoryPageStyles.textStyle),
//                     );
//                   }

//                   return ListView.builder(
//                     padding: EdgeInsets.zero,
//                     addRepaintBoundaries: false,
//                     itemBuilder: (context, index) {
//                       return StreamBuilder<Map<String, dynamic>>(
//                           stream: transactionSnapshot.data[index],
//                           builder: (context, snapshot) {
//                             if (!snapshot.hasData) {
//                               return Container(
//                                 height: widget.transactionHistoryPageStyles.historyCardHeight,
//                                 child: Center(child: KeicyCupertinoIndicator()),
//                               );
//                             }

//                             if (snapshot.data == null) {
//                               return SizedBox();
//                             }

//                             TransactionModel transactionModel = snapshot.data["transactionModel"];
//                             RecipientModel recipientModel = snapshot.data["recipientModel"];

//                             return Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: widget.transactionHistoryPageStyles.historyCardHorizontalPadding,
//                               ),
//                               child: GestureDetector(
//                                 onTap: () {},
//                                 child: Container(
//                                   height: widget.transactionHistoryPageStyles.historyCardHeight,
//                                   margin: EdgeInsets.all(widget.transactionHistoryPageStyles.widthDp * 5),
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: widget.transactionHistoryPageStyles.widthDp * 20,
//                                     vertical: widget.transactionHistoryPageStyles.widthDp * 20,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: AppColors.whiteColor,
//                                     borderRadius: BorderRadius.circular(widget.transactionHistoryPageStyles.widthDp * 15),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey.withOpacity(0.5),
//                                         spreadRadius: 0,
//                                         blurRadius: widget.transactionHistoryPageStyles.widthDp * 5,
//                                         offset: Offset(0, 0), // changes position of shadow
//                                       ),
//                                     ],
//                                   ),
//                                   alignment: Alignment.center,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: <Widget>[
//                                       Row(
//                                         children: [
//                                           KeicyAvatarImage(
//                                             url: recipientModel.avatarUrl,
//                                             userName: recipientModel.firstName,
//                                             width: widget.transactionHistoryPageStyles.historyCardHeight * 0.6,
//                                             height: widget.transactionHistoryPageStyles.historyCardHeight * 0.6,
//                                           ),
//                                           SizedBox(width: widget.transactionHistoryPageStyles.widthDp * 10),
//                                           Text(
//                                             recipientModel.firstName,
//                                             style: widget.transactionHistoryPageStyles.textStyle,
//                                             overflow: TextOverflow.ellipsis,
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ],
//                                       ),
//                                       Column(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             "\$${transactionModel.amount}",
//                                             style: widget.transactionHistoryPageStyles.amountStyle,
//                                             overflow: TextOverflow.ellipsis,
//                                             textAlign: TextAlign.center,
//                                           ),
//                                           Text(
//                                             "${KeicyDateTime.convertMillisecondsToDateString(ms: transactionModel.ts)}",
//                                             style: widget.transactionHistoryPageStyles.textStyle,
//                                             overflow: TextOverflow.ellipsis,
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           });
//                     },
//                     // separatorBuilder: (context, index) {
//                     //   return SizedBox(width: widget.transactionHistoryPageStyles.widthDp * 10);
//                     // },
//                     itemCount: transactionSnapshot.data.length,
//                   );
//                 }),
//           ),
//         ],
//       );
//     });
//   }
// }
