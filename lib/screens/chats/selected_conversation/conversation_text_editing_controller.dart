import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:base_flutter/models/api/customer_info.dart";

class ConversationTextEditingController extends TextEditingController {
  ConversationTextEditingController(this.customers)
      : includedCustomerNames =
            "(${customers.map((customer) => RegExp.escape("~" + customer.name)).join("|")})";

  List<CustomerInfo> customers;

  String includedCustomerNames;

  List<CustomerInfo> get getCustomers {
    return customers;
  }

  set setCustomers(List<CustomerInfo> customerList) {
    customers = customerList;

    includedCustomerNames =
        "(${customers.map((customer) => RegExp.escape("~" + customer.name)).join("|")})";
  }

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    List<TextSpan> texts = <TextSpan>[];

    if (includedCustomerNames == "()") {
      texts.add(TextSpan(text: text, style: style));
    } else {
      text.splitMapJoin(RegExp(includedCustomerNames), onMatch: (Match match) {
        texts.add(TextSpan(
            text: match[0], style: TextStyle(backgroundColor: Colors.amber)));

        return "";
      }, onNonMatch: (String text) {
        texts.add(TextSpan(text: text, style: style));

        return "";
      });
    }

    return TextSpan(style: style, children: texts);
  }
}
