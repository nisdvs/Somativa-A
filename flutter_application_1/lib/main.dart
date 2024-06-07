import 'package:flutter/material.dart';
import 'package:flutter_application_1/telafilme.dart';
import 'package:flutter_application_1/register.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert'; 



void main() {
  runApp(MaterialApp(home: Login(),));
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> {
  TextEditingController user = TextEditingController();
  TextEditingController senha = TextEditingController();
  bool exibir = false;
  _verificarlogin() async{

   String url = "http://10.109.83.18:3000/usuarios";
   http.Response resposta = await http.get(Uri.parse(url));
   bool encuser= false;
   List clientes = <Usuario>[];
   clientes = json.decode(resposta.body) ;
   for (int i=0; i<clientes.length; i++){
    if(user.text == clientes[i]["nome"] && senha.text == clientes[i]["senha"]){
      encuser =true;
      break;
    }  
    
   }

   if(encuser ==true){
      print("Usuario encontrado");
      encuser = false;
      user.text="";
      senha.text="";
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Telafilme()));

    }

    else{
      print("Usuario nao encontrado, realize o cadastro");
       ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Usuário não cadastrado"),duration: Duration(seconds: 2),),);
        encuser = false;
        showDialog(
          context: context,
          builder: (BuildContext) {
            return AlertDialog(
              content: Text('Usuário inválido'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Fechar'))
              ],
            );
          });
    }
    

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "TOPFLIX",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      style: TextStyle(color: Colors.white), 
                      cursorColor: Colors.white,
                      decoration: InputDecoration(border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      icon: Icon(Icons.people_alt_outlined),iconColor: Colors.blue[900],
                      hintText: "Digite seu nome:",
                      hintStyle: TextStyle(color: Colors.white),
                      
                      ),
                      controller: user,
                      
                        
                        
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.name, 
                      style: TextStyle(color: Colors.white), 
                      cursorColor: Colors.white,
                      decoration: InputDecoration(border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      icon: Icon(Icons.key),iconColor: Colors.blue[900],
                      hintText: "Digite sua senha:",
                      hintStyle: TextStyle(color: Colors.white),
                      suffixIcon: IconButton(icon: Icon(exibir? Icons.visibility:Icons.visibility_off,
                       ),onPressed: (){
                        setState(() {
                          exibir =!exibir;
                        });
                      },
                       
                       ),                  
                      ),
                      obscureText: exibir ,
                      obscuringCharacter: "*",
                      controller: senha,
                      
                        
                    
                    ),
                  ),
      
                ],
              ),
      
            ),
           ElevatedButton(onPressed: _verificarlogin, child: Text("Entrar", style: TextStyle(color: Colors.blue[900]),
           ),
           ),

            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
            }, child: Text("Registrar", style: TextStyle(color: Colors.blue[900]),
            ),
            ),
          ],
         
        ),
      ),
    );
  }
}

class Usuario{
  String id;
  String login;
  String senha;
  Usuario(this.id, this.login, this.senha);
  factory Usuario.fromJson(Map<String,dynamic> json){
    return Usuario(json["id"],json["nome"],json["senha"]);
  }
}