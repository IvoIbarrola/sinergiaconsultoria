import 'package:flutter/material.dart';


// ============================================================
// PUNTO DE ENTRADA DE LA APLICACIÓN
// ============================================================

// main() es la función que se ejecuta primero.
// En Dart, toda aplicación comienza desde esta función.
void main() {
  // runApp() recibe el Widget principal de nuestra aplicación
  // y se encarga de mostrarlo en pantalla.
  runApp(const TaskyApp());
}


// ============================================================
// APLICACIÓN PRINCIPAL
// ============================================================

// Una "class" define un objeto.
// En Flutter, prácticamente toda la interfaz está construida
// utilizando clases llamadas Widgets.
//
// StatelessWidget significa que este Widget NO tiene un estado
// interno que vaya a cambiar durante su funcionamiento.
//
// En este caso, TaskyApp se encarga principalmente de configurar
// la aplicación.
class TaskyApp extends StatelessWidget {

  // Constructor de la clase.
  //
  // "const" permite crear este objeto como una constante cuando
  // sus valores no necesitan cambiar.
  //
  // "super.key" pasa una key al Widget padre (StatelessWidget).
  const TaskyApp({super.key});


  // build() describe qué interfaz debe mostrar este Widget.
  //
  // Flutter llama a este método cuando necesita construir
  // o reconstruir la interfaz.
  @override
  Widget build(BuildContext context) {

    // MaterialApp es el Widget principal de una aplicación Flutter
    // que utiliza Material Design.
    return MaterialApp(

      // Elimina la etiqueta "DEBUG" que Flutter muestra
      // normalmente en la esquina superior derecha.
      debugShowCheckedModeBanner: false,

      // Nombre de nuestra aplicación.
      title: 'Tasky',

      // Configuración visual general de la aplicación.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),

      // Pantalla que se mostrará al iniciar la aplicación.
      home: const TaskListPage(),
    );
  }
}


// ============================================================
// MODELO DE UNA TAREA
// ============================================================

// Esta clase representa una TAREA.
//
// Acá aparece uno de los conceptos principales de POO:
//
// Una clase puede utilizarse como "molde" para crear objetos.
//
// Por ejemplo:
//
//   Task(title: 'Comprar leche')
//
// crea un objeto Task que representa una tarea concreta.
class Task {

  // "final" significa que el valor se establece una vez
  // y después no puede cambiar.
  //
  // El título de una tarea no debería cambiar directamente
  // en nuestra implementación actual.
  final String title;


  // A diferencia de title, completed NO es final.
  //
  // Esto significa que su valor puede cambiar.
  //
  // Ejemplo:
  //
  //   task.completed = true;
  //
  // Esto nos permite marcar una tarea como completada
  // o volver a dejarla pendiente.
  bool completed;


  // Constructor de Task.
  //
  // "required" significa que debemos proporcionar un título
  // cuando creemos una tarea.
  //
  // "completed = false" establece false como valor
  // predeterminado si no indicamos otro.
  Task({
    required this.title,
    this.completed = false,
  });
}


// ============================================================
// PANTALLA PRINCIPAL DE TAREAS
// ============================================================

// Esta clase representa nuestra pantalla principal.
//
// StatefulWidget significa que esta pantalla TIENE ESTADO.
//
// En nuestro caso, el estado son principalmente las tareas
// y si están completadas o no.
//
// Esto es diferente a TaskyApp, que era StatelessWidget.
class TaskListPage extends StatefulWidget {

  const TaskListPage({super.key});


  // Un StatefulWidget se divide en dos partes:
//
// 1. TaskListPage
//    Representa el Widget.
//
// 2. _TaskListPageState
//    Contiene los datos que pueden cambiar y la lógica
//    necesaria para actualizar la pantalla.
//
// createState() conecta ambas partes.
  @override
  State<TaskListPage> createState() => _TaskListPageState();
}


// ============================================================
// ESTADO DE LA PANTALLA
// ============================================================

// El "_" al principio del nombre significa que esta clase
// es privada para este archivo.
//
// Acá guardamos los datos que pueden cambiar.
//
// Por ejemplo:
// - lista de tareas
// - tareas completadas
//
// Cuando estos datos cambien, podremos indicarle a Flutter
// que vuelva a dibujar la interfaz.
class _TaskListPageState extends State<TaskListPage> {


  // Lista que contiene nuestras tareas.
  //
  // List<Task> significa:
  //
  // "Una lista cuyos elementos son objetos de tipo Task".
  //
  // Por ahora las tareas están escritas directamente en el código.
  //
  // Más adelante esta lista podría venir de:
  // - almacenamiento local
  // - una API
  // - una base de datos
  final List<Task> tasks = [

    Task(
      title: 'Aprender Flutter',
    ),

    Task(
      title: 'Crear mi primera aplicación',
    ),

    Task(
      title: 'Probar Tasky en el celular',
    ),
  ];


  // ==========================================================
  // CONSTRUCCIÓN DE LA INTERFAZ
  // ==========================================================

  // build() describe cómo debe verse esta pantalla.
  //
  // Cada vez que llamemos a setState(), Flutter volverá a
  // ejecutar este método para actualizar la interfaz.
  @override
  Widget build(BuildContext context) {

    // Scaffold proporciona una estructura básica de pantalla.
    //
    // Por ejemplo:
    // - AppBar
    // - contenido principal
    // - botón flotante
    return Scaffold(


      // ========================================================
      // BARRA SUPERIOR
      // ========================================================

      appBar: AppBar(

        // Texto que aparece en la barra superior.
        title: const Text('Tasky'),
      ),


      // ========================================================
      // CONTENIDO PRINCIPAL
      // ========================================================

      // Acá utilizamos un operador ternario.
      //
      // Es una forma corta de escribir un if/else.
      //
      // La estructura es:
      //
      // condición ? resultado_si_true : resultado_si_false
      //
      // En nuestro caso:
      //
      // Si no hay tareas -> mostrar "No hay tareas"
      //
      // Si hay tareas -> mostrar la lista.
      body: tasks.isEmpty

          ? const Center(
              child: Text(
                'No hay tareas',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )

          : ListView.builder(

              // Cantidad de elementos que tendrá la lista.
              itemCount: tasks.length,


              // itemBuilder se ejecuta para construir
              // cada elemento de la lista.
              //
              // "index" indica la posición actual.
              //
              // Ejemplo:
              //
              // index = 0 -> primera tarea
              // index = 1 -> segunda tarea
              // index = 2 -> tercera tarea
              itemBuilder: (context, index) {

                // Obtenemos la tarea correspondiente
                // a la posición actual.
                final task = tasks[index];


                // Cada tarea será representada mediante
                // un ListTile.
                return ListTile(


                  // ==================================================
                  // CHECKBOX
                  // ==================================================

                  // leading coloca un Widget al comienzo
                  // del ListTile.
                  leading: Checkbox(

                    // value indica si el checkbox está marcado.
                    //
                    // Utilizamos el valor "completed" de nuestra tarea.
                    value: task.completed,


                    // onChanged se ejecuta cuando el usuario
                    // toca el checkbox.
                    //
                    // "value" contiene el nuevo valor.
                    onChanged: (value) {

                      // =================================================
                      // setState()
                      // =================================================

                      // setState() es MUY importante en Flutter.
                      //
                      // Le estamos diciendo a Flutter:
                      //
                      // "El estado de esta pantalla cambió.
                      // Volvé a construir la interfaz."
                      //
                      // Si modificáramos task.completed sin utilizar
                      // setState(), el valor podría cambiar internamente
                      // pero Flutter no necesariamente actualizaría
                      // la pantalla.
                      setState(() {

                        // Guardamos el nuevo valor del checkbox
                        // dentro de nuestra tarea.
                        //
                        // "?? false" significa:
                        //
                        // Si value es null, utilizamos false.
                        task.completed = value ?? false;
                      });
                    },
                  ),


                  // ==================================================
                  // TÍTULO DE LA TAREA
                  // ==================================================

                  title: Text(

                    // Mostramos el título de nuestra tarea.
                    task.title,


                    // Cambiamos el estilo dependiendo de si
                    // la tarea está completada.
                    style: TextStyle(

                      // TextDecoration.lineThrough dibuja una línea
                      // atravesando el texto.
                      //
                      // Si la tarea está completada:
                      //
                      //   Aprender Flutter
                      //   ----------------
                      //
                      // Si no está completada:
                      //
                      //   Aprender Flutter
                      decoration: task.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                );
              },
            ),


      // ========================================================
      // BOTÓN FLOTANTE
      // ========================================================

      // FloatingActionButton normalmente se utiliza
      // para una acción principal de la pantalla.
      //
      // En Tasky lo utilizaremos para agregar una nueva tarea.
      floatingActionButton: FloatingActionButton(

        // onPressed se ejecuta cuando el usuario presiona
        // el botón.
        //
        // Actualmente está vacío porque todavía no
        // implementamos la creación de tareas.
        onPressed: () {},

        // Ícono "+".
        child: const Icon(Icons.add),
      ),
    );
  }
}