import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:what_is_new/components/widgets.dart';
import 'package:what_is_new/models/model.dart';
import 'package:what_is_new/services/realm_services.dart';

enum MenuOption { edit, delete }

class ElementItem extends StatelessWidget {
  final Item item;

  const ElementItem(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context);
    return item.isValid
        ? ListTile(
            // leading: Checkbox(
            //   value: item.isComplete,
            //   onChanged: (bool? value) async {
            //     if (isMine) {
            //       await realmServices.updateItem(item, isComplete: value ?? false);
            //     } else {
            //       errorMessageSnackBar(context, "Change not allowed!", "You are not allowed to change the status of \n tasks that don't belog to you.")
            //           .show(context);
            //     }
            //   },
            // ),
            title: Text(item.content),
            subtitle: Text("${item.group?.version?.product?.name} Version: ${item.group!.version!.version} ${item.group!.name}"),
            trailing: SizedBox(
              width: 25,
              child: PopupMenuButton<MenuOption>(
                onSelected: (menuItem) => handleMenuClick(context, menuItem, item, realmServices),
                itemBuilder: (context) => [
                  const PopupMenuItem<MenuOption>(
                    value: MenuOption.edit,
                    child: ListTile(leading: Icon(Icons.edit), title: Text("Edit item")),
                  ),
                  const PopupMenuItem<MenuOption>(
                    value: MenuOption.delete,
                    child: ListTile(leading: Icon(Icons.delete), title: Text("Delete item")),
                  ),
                ],
              ),
            ),
            shape: const Border(bottom: BorderSide()),
          )
        : Container();
  }

  void handleMenuClick(BuildContext context, MenuOption menuItem, Item item, RealmServices realmServices) {
    bool isMine = true;
    switch (menuItem) {
      // case MenuOption.edit:
      //   if (isMine) {
      //     showModalBottomSheet(
      //       context: context,
      //       isScrollControlled: true,
      //       builder: (_) => Wrap(children: [ModifyItemForm(item)]),
      //     );
      //   } else {
      //     errorMessageSnackBar(context, "Edit not allowed!", "You are not allowed to edit tasks \nthat don't belog to you.").show(context);
      //   }
      //   break;
      case MenuOption.delete:
        if (isMine) {
          realmServices.deleteItem(item);
        } else {
          errorMessageSnackBar(context, "Delete not allowed!", "You are not allowed to delete tasks \n that don't belog to you.").show(context);
        }
        break;
    }
  }
}
