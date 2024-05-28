
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_page.dart';
import'package:http/http.dart'as http;
import 'package:todo_app/services/todo_services.dart';
import 'package:todo_app/helpers/Snackbar_helpers.dart';
import 'package:todo_app/widget/todo_card.dart';

class TodoListpage extends StatefulWidget {
  const TodoListpage({super.key});
  @override
  State<TodoListpage> createState() => _TodoListpageState();
}

class _TodoListpageState extends State<TodoListpage> {
  bool isLoading=false;
  List items=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {

   return Scaffold(
     appBar: AppBar(
       title: Center(child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Text("Todo List",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
           SizedBox(width:10,),
           Icon(Icons.line_style_outlined,color: Colors.black54,)
         ],
       )),
       backgroundColor: Colors.red.shade400,
       

     ),
     body: Visibility(
       visible: isLoading,
       child: Center(child: CircularProgressIndicator()),
       replacement:RefreshIndicator(
         onRefresh:fetchTodo ,
         child: Visibility(
           visible: items.isNotEmpty,
           replacement: Center(child: Text("No items",style: TextStyle(fontSize: 30,color: Colors.grey.shade700),)),
           child: ListView.builder(
               itemCount:items.length ,
               itemBuilder: (context,index)
               {
                 final item=items[index]as Map;
                 return TodoCard(
                     index: index,
                     item: item,
                     navigateEdit: navigatetoEditpage,
                     deleteById: deleteById
                 );
               }),
         ),
       ),
     ),
     floatingActionButton: FloatingActionButton.extended(
       backgroundColor: Colors.redAccent,
         onPressed:
     (){
       navigatetoaddpage();

     }, label: Text("Add Todo",style: TextStyle(fontSize: 18,color: Colors.white),)),


   );
  }
  void navigatetoEditpage(Map item) async
  {
    final route =MaterialPageRoute(builder: (context)=>addpage(todo: item,));
    await Navigator.push(context, route);
    setState(() {
      isLoading=true;
    });
    fetchTodo();

  }
  Future<void>navigatetoaddpage()async
  {
    final route= MaterialPageRoute(builder:(context)=>addpage(),
    );
     await Navigator.push(context,route);
     setState(() {
       isLoading=true;
     });
     fetchTodo();

  }
  Future<void>deleteById(String id) async
  {
    final isSuccess= await TodoService.deleteById(id);

    if(isSuccess)
      {
        final filtered=items.where((element) => element['_id']!=id).toList();
        setState(() {
          items=filtered;
        });
      }
    else{
      showErrorMessage(context,msg: "Unable to delete");
    }
  }
  Future<void> fetchTodo()async
  {
    final response=await TodoService.fetchtodos();
    if(response!=null){
        setState(() {
          items=response;
        });
      }
    else
      {
        showErrorMessage(context,msg:"Something went wrong");
      }
    setState(() {
      isLoading=false;
    });

  }

}
