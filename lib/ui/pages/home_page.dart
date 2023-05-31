import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme.dart';
import '/controllers/task_controller.dart';
import '/models/task.dart';
import '/services/theme_services.dart';
import '/ui/widgets/button.dart';
import '/ui/widgets/task_tile.dart';
import 'add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _taskController.getTasks();
  }

  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
          setState((){ThemeServices().switchTheme();});



          },
          icon: Icon(
            ThemeServices().loadThemeFromBox()? Icons.wb_sunny : Icons.nightlight_round,
          ),
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 18,
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat.yMMMMd().format(DateTime.now()),
                        style: subHeadingStyle),
                    Text('Today', style: headingStyle),
                  ],
                ),
                MyButton(
                  label: '+ Add Task',
                  onTap: () async {
                    await Get.to(() => const AddTaskPage());
                    _taskController.getTasks();
                  },
                ),
              ],
            ),
          ),
          _addDateBar(),
          const SizedBox(height: 18),
          _showTasks(),
        ],
      ),
    );
  }


  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 80,
        height: 120,
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        selectionColor: Colors.indigo,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (newDate) => setState(() => _selectedDate = newDate),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMsg();
        } else   {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                var task = _taskController.taskList[index];

                if (task.repeat == 'Daily' ||
                    task.date == DateFormat.yMd().format(_selectedDate) ||
                    (task.repeat == 'Weekly' &&
                        _selectedDate
                                    .difference(
                                        DateFormat.yMd().parse(task.date!))
                                    .inDays %
                                7 ==
                            0) ||
                    (task.repeat == 'Monthly' &&
                        DateFormat.yMd().parse(task.date!).day ==
                            _selectedDate.day)) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1375),
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () => showBottomSheet(context, task),
                          child: TaskTile(task),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
              itemCount: _taskController.taskList.length,
            ),
          );
        }
      }),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.vertical,
                children: [
                  const SizedBox(height: 160),
                  SvgPicture.asset(
                    'images/task.svg',
                    color: Colors.indigo.withOpacity(0.5),
                    height: 120,
                    semanticsLabel: 'Task',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 22),
                    child: Text(
                      'You do not have any tasks yet!\nAdd new tasks to make your days productive',
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 200),

                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
          height: task.isCompleted == 1
                  ?  250
                  : 300,
          color: Get.isDarkMode ? Colors.black : Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheet(
                      label: Text(
                        'Task complete',
                        style: titleStyle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {

                        _taskController.markTaskCompleted(task.id!);
                        Get.back();
                      },
                      clr: Colors.green,
                    ),
              _buildBottomSheet(
                label: Text(
                  'delete Task ',
                  style: titleStyle.copyWith(
                    color: Colors.white,
                  ),
                ),
                onTap: () {

                  _taskController.deleteTasks(task);
                  Get.back();
                },
                clr: Colors.red,
              ),
              const SizedBox(
                height: 16,
              ),
              _buildBottomSheet(
                label: Text(
                  'Cancel',
                  style: titleStyle.copyWith(
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  Get.back();
                },
                clr: Get.isDarkMode ? Colors.black : Colors.white,
              ),

            ],
          ),
        ),
      ),
    );
  }

  _buildBottomSheet({
    required Text label,
    required Function() onTap,
    required Color clr,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: clr,
        ),
        child: Center(child: label),
      ),
    );
  }
}
