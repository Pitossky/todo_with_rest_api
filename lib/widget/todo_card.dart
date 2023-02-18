import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deleteTodo;
  const TodoCard({
    Key? key,
    required this.index,
    required this.item,
    required this.navigateEdit,
    required this.deleteTodo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = item['_id'];
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(
          onSelected: (value) async {
            if (value == 'edit') {
              navigateEdit(item);
            } else if(value == 'delete') {
              await deleteTodo(id);
            }
          },
          itemBuilder: (_) {
            return [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ];
          },
        ),
      ),
    );
  }
}
