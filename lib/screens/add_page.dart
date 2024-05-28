import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/screens/TodoListpage.dart';
import'package:http/http.dart'as http;
import 'package:todo_app/helpers/Snackbar_helpers.dart';
import 'package:todo_app/services/todo_services.dart';

class addpage extends StatefulWidget
{   final Map? todo;
  @override
  State<addpage> createState() => _addpageState();
  const addpage({super.key,
  this.todo,});
}

class _addpageState extends State<addpage> {
  var textcontroller1=TextEditingController();
  var textcontroller2=TextEditingController();
  bool isEdit=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo=widget.todo;
    if(todo!=null)
      {
        isEdit=true;
        final title=todo['title'];
        final description=todo['description'];
        textcontroller1.text=title;
        textcontroller2.text=description;
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text( isEdit? "Edit Todo":"Add Todo",
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,
            ),),
            backgroundColor: Colors.red.shade400,
      ),


      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              controller: textcontroller1,
              decoration: InputDecoration(
                  hintText: 'Title'
              ),
              keyboardType: TextInputType.text,


            ),
            TextField(
              controller: textcontroller2,
              decoration: InputDecoration(
                  hintText: "Description"
              ),
              keyboardType: TextInputType.multiline,
              minLines: 4,
              maxLines: 20,

            ),
            SizedBox(height: 12,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.red.shade400
                ),
                onPressed: () {
                 isEdit? updateData(): submitData();

                },
                child: Text(isEdit? "Update":"Add", style: TextStyle(fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),))

          ],
        ),
      ),



    );
  }
  Future<void>updateData() async {
    final todo=widget.todo;
    final id = todo?['_id'];

    if(todo==null)
      {
        print('You cannot call update todo Data');
        return;
      }
    final title=textcontroller1.text;
    final description=textcontroller2.text;
    final  body={
    "title": title,
    "description": description,
    "is_completed": false
    };
     final isSuccess= await TodoService.UpdateTodo(id, body);
    if(isSuccess)
      {
        showSuccessMessage(context,msg: "Updation succesful");

      }
    else{
      showErrorMessage(context,msg:'Updation failed');
    }

  }
  Future<void>submitData() async
  {
    final title= textcontroller1.text;
    final description=textcontroller2.text;
    final body={
      "title": title,
      "description": description,
      "is_completed": false
    };
     final isSuccess= await TodoService.addTodo(body);
      if(isSuccess)

      {  textcontroller1.text="";
         textcontroller2.text="";
         showSuccessMessage(context,msg: "Creation Successful");
      }
      else
      {   textcontroller1.text="";
          textcontroller2.text="";
         showErrorMessage(context,msg:"Creation Failed");
      }
    }


  }
