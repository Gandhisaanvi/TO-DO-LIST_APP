import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget
{
  final int index;
  final Map item;
  final Function(Map)navigateEdit;
  final Function(String)deleteById;

  const TodoCard({super.key,required this.index, required this.item,required this.navigateEdit,required this.deleteById});
  @override
  Widget build(BuildContext context)
  {
    final id=item['_id'] as String;
    return Card(
      color: Colors.white12,
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: Colors.redAccent,
            child: Text("${index+1}",style:TextStyle(fontSize: 20,color: Colors.white),)),
        title:Text(item['title']) ,
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(
          onSelected: (value){
            if(value=='edit')
            {
              navigateEdit(item);
            }
            else if(value=='delete')
            {
              deleteById(id);
            }
          },
          itemBuilder: (context)
          {
            return[
              PopupMenuItem(child: Row(
                children: [
                  Text("Edit"),
                  SizedBox(width: 7,),
                  Icon(Icons.edit,size: 13,)
                ],
              ),value:'edit'),
              PopupMenuItem(child: Row(
                children: [
                  Text('Delete'),
                  SizedBox(width: 7,),
                  Icon(Icons.delete,size: 13,)
                ],
              ),value:'delete')
            ];

          },

        ),
      ),
    );
  }

}