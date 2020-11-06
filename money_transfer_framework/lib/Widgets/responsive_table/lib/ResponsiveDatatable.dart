import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_context/responsive_context.dart';

import 'DatatableHeader.dart';

class ResponsiveDatatable extends StatefulWidget {
  final bool showSelect;
  final List<DatatableHeader> headers;
  final List<Map<String, dynamic>> source;
  final List<Map<String, dynamic>> selecteds;
  final Widget title;
  final List<Widget> actions;
  final List<Widget> footers;
  final Function(bool value) onSelectAll;
  final Function(bool value, Map<String, dynamic> data) onSelect;
  final Function(dynamic value) onTabRow;
  final Function(dynamic value) onSort;
  final String sortColumn;
  final bool sortAscending;
  final bool isLoading;
  final bool autoHeight;
  final bool hideUnderline;
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry cellPadding;
  final Color headerBackColor;
  final TextStyle headerStyle;
  final TextStyle cellStyle;
  BoxBorder tableBorder;
  BoxBorder cellBorder;
  final Function(int, Map<String, dynamic>) changeHandler;

  ResponsiveDatatable({
    Key key,
    this.showSelect: false,
    this.onSelectAll,
    this.onSelect,
    this.onTabRow,
    this.onSort,
    this.headers,
    this.source,
    this.selecteds,
    this.title,
    this.actions,
    this.footers,
    this.sortColumn,
    this.sortAscending,
    this.isLoading: false,
    this.autoHeight: true,
    this.hideUnderline: true,
    this.headerPadding: const EdgeInsets.all(0),
    this.cellPadding: const EdgeInsets.all(0),
    this.headerBackColor = Colors.transparent,
    this.headerStyle,
    this.cellStyle,
    this.tableBorder,
    this.cellBorder,
    this.changeHandler,
  }) : super(key: key);

  @override
  _ResponsiveDatatableState createState() => _ResponsiveDatatableState();
}

class _ResponsiveDatatableState extends State<ResponsiveDatatable> {
  Widget mobileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Checkbox(
            value: widget.selecteds.length == widget.source.length && widget.source != null && widget.source.length > 0,
            onChanged: (value) {
              if (widget.onSelectAll != null) widget.onSelectAll(value);
            }),
        PopupMenuButton(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text("SORT BY"),
            ),
            tooltip: "SORT BY",
            initialValue: widget.sortColumn,
            itemBuilder: (_) => widget.headers
                .where((header) => header.show == true && header.sortable == true)
                .toList()
                .map((header) => PopupMenuItem(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "${header.text}",
                            textAlign: header.textAlign,
                            style: widget.headerStyle,
                          ),
                          if (widget.sortColumn != null && widget.sortColumn == header.value)
                            widget.sortAscending ? Icon(Icons.arrow_downward, size: 15) : Icon(Icons.arrow_upward, size: 15)
                        ],
                      ),
                      value: header.value,
                    ))
                .toList(),
            onSelected: (value) {
              if (widget.onSort != null) widget.onSort(value);
            })
      ],
    );
  }

  List<Widget> mobileList() {
    return widget.source.map((data) {
      return InkWell(
        onTap: widget.onTabRow != null
            ? () {
                widget.onTabRow(data);
              }
            : null,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  if (widget.showSelect && widget.selecteds != null)
                    Checkbox(
                        value: widget.selecteds.indexOf(data) >= 0,
                        onChanged: (value) {
                          if (widget.onSelect != null) widget.onSelect(value, data);
                        }),
                ],
              ),
              ...widget.headers
                  .where((header) => header.show == true)
                  .toList()
                  .map(
                    (header) => Container(
                      padding: EdgeInsets.all(11),
                      decoration: BoxDecoration(border: widget.cellBorder),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          header.headerBuilder != null
                              ? header.headerBuilder(header.value)
                              : Container(
                                  child: Text(
                                    "${header.text}",
                                    overflow: TextOverflow.clip,
                                    style: widget.headerStyle,
                                  ),
                                ),
                          Spacer(),
                          header.sourceBuilder != null
                              ? header.sourceBuilder(data[header.value], data)
                              : header.editable
                                  ? editAbleWidget(
                                      data: data,
                                      header: header,
                                      textAlign: TextAlign.end,
                                      index: -1,
                                    )
                                  : Text(
                                      "${data[header.value] != null ? data[header.value] : ''}",
                                      style: widget.cellStyle,
                                    )
                        ],
                      ),
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      );
    }).toList();
  }

  Alignment headerAlignSwitch(TextAlign textAlign) {
    switch (textAlign) {
      case TextAlign.center:
        return Alignment.center;
        break;
      case TextAlign.left:
        return Alignment.centerLeft;
        break;
      case TextAlign.right:
        return Alignment.centerRight;
        break;
      default:
        return Alignment.center;
    }
  }

  Widget desktopHeader() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showSelect && widget.selecteds != null)
            Checkbox(
                value: widget.selecteds.length == widget.source.length && widget.source != null && widget.source.length > 0,
                onChanged: (value) {
                  if (widget.onSelectAll != null) widget.onSelectAll(value);
                }),
          ...widget.headers
              .where((header) => header.show == true)
              .map(
                (header) => Expanded(
                    flex: header.flex ?? 1,
                    child: InkWell(
                      onTap: () {
                        if (widget.onSort != null && header.sortable) widget.onSort(header.value);
                      },
                      child: header.headerBuilder != null
                          ? Container(
                              child: header.headerBuilder(header.value),
                            )
                          : Container(
                              padding: this.widget.headerPadding,
                              decoration: BoxDecoration(
                                border: widget.cellBorder,
                                color: this.widget.headerBackColor,
                              ),
                              alignment: headerAlignSwitch(header.textAlign),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    "${header.text}",
                                    textAlign: header.textAlign,
                                    style: widget.headerStyle,
                                  ),
                                  if (widget.sortColumn != null && widget.sortColumn == header.value)
                                    widget.sortAscending ? Icon(Icons.arrow_downward, size: 15) : Icon(Icons.arrow_upward, size: 15)
                                ],
                              ),
                            ),
                    )),
              )
              .toList()
        ],
      ),
    );
  }

  List<Widget> desktopList() {
    List<Widget> widgets = [];
    for (var index = 0; index < widget.source.length; index++) {
      final data = widget.source[index];
      widgets.add(InkWell(
        onTap: widget.onTabRow != null
            ? () {
                widget.onTabRow(data);
              }
            : null,
        child: Container(
            child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showSelect && widget.selecteds != null)
              Checkbox(
                  value: widget.selecteds.indexOf(data) >= 0,
                  onChanged: (value) {
                    if (widget.onSelect != null) widget.onSelect(value, data);
                  }),
            ...widget.headers
                .where((header) => header.show == true)
                .map(
                  (header) => Expanded(
                    flex: header.flex ?? 1,
                    child: header.sourceBuilder != null
                        ? Container(
                            decoration: BoxDecoration(border: widget.cellBorder),
                            child: header.sourceBuilder(data[header.value], data),
                          )
                        : header.editable
                            ? editAbleWidget(
                                index: index,
                                data: data,
                                header: header,
                                textAlign: header.textAlign,
                              )
                            : Container(
                                decoration: BoxDecoration(border: widget.cellBorder),
                                padding: this.widget.cellPadding,
                                child: Text(
                                  "${data[header.value] != null ? data[header.value] : ''}",
                                  textAlign: header.textAlign,
                                  style: widget.cellStyle,
                                ),
                              ),
                  ),
                )
                .toList()
          ],
        )),
      ));
    }
    return widgets;
  }

  Widget editAbleWidget({
    @required int index,
    @required Map<String, dynamic> data,
    @required DatatableHeader header,
    TextAlign textAlign: TextAlign.center,
  }) {
    return Container(
      constraints: BoxConstraints(maxWidth: 150),
      padding: this.widget.cellPadding,
      margin: EdgeInsets.all(0),
      decoration: BoxDecoration(border: widget.cellBorder),
      child: TextField(
        decoration: InputDecoration(
          isCollapsed: true,
          isDense: true,
          contentPadding: EdgeInsets.all(0),
          border: this.widget.hideUnderline ? InputBorder.none : UnderlineInputBorder(borderSide: BorderSide(width: 1)),
          alignLabelWithHint: true,
        ),
        inputFormatters: header.inputFormatters,
        textAlign: textAlign,
        style: widget.cellStyle,
        controller: TextEditingController.fromValue(
          TextEditingValue(text: "${data[header.value] != null ? data[header.value] : ''}"),
        ),
        onChanged: (newValue) {
          data[header.value] = newValue;
          if (widget.changeHandler != null) {
            widget.changeHandler(index, data);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.tableBorder == null)
      this.widget.tableBorder = Border(
        bottom: BorderSide(color: Colors.grey[300], width: 0.5),
      );

    if (this.widget.cellBorder == null)
      this.widget.cellBorder = Border(
        bottom: BorderSide(color: Colors.grey[300], width: 0.5),
      );

    return context.isExtraSmall || context.isSmall || context.isMedium
        ?
        /**
         * for small screen
         */
        Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //title and actions
                if (widget.title != null || widget.actions != null)
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [if (widget.title != null) widget.title, if (widget.actions != null) ...widget.actions],
                    ),
                  ),

                if (widget.autoHeight)
                  Container(
                    decoration: BoxDecoration(border: widget.tableBorder),
                    child: Column(
                      children: [
                        if (widget.showSelect && widget.selecteds != null) mobileHeader(),
                        if (widget.isLoading) LinearProgressIndicator(),
                        //mobileList
                        ...mobileList(),
                      ],
                    ),
                  ),
                if (!widget.autoHeight)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(border: widget.tableBorder),
                      child: ListView(
                        // itemCount: source.length,
                        children: [
                          if (widget.showSelect && widget.selecteds != null) mobileHeader(),
                          if (widget.isLoading) LinearProgressIndicator(),
                          //mobileList
                          ...mobileList(),
                        ],
                      ),
                    ),
                  ),
                //footer
                if (widget.footers != null)
                  Container(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [...widget.footers],
                    ),
                  )
              ],
            ),
          )
        /**
          * for large screen
          */
        : Container(
            child: Column(
              children: [
                //title and actions
                if (widget.title != null || widget.actions != null)
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [if (widget.title != null) widget.title, if (widget.actions != null) ...widget.actions],
                    ),
                  ),

                Container(
                  decoration: BoxDecoration(border: widget.tableBorder),
                  child: Column(
                    children: [
                      //desktopHeader
                      if (widget.headers != null && widget.headers.isNotEmpty) desktopHeader(),

                      if (widget.isLoading) LinearProgressIndicator(),

                      if (widget.autoHeight) Column(children: desktopList()),

                      if (!widget.autoHeight)
                        // desktopList
                        if (widget.source != null && widget.source.isNotEmpty)
                          Expanded(
                            child: Container(child: ListView(children: desktopList())),
                          ),
                    ],
                  ),
                ),

                //footer
                if (widget.footers != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [...widget.footers],
                  )
              ],
            ),
          );
  }
}
