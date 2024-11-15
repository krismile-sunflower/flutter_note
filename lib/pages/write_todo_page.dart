import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:note_flutter/inject.dart';
import 'package:uuid/uuid.dart';

import '../model/todo.dart';
import '../state/todo_state.dart';

class WriteTodoPage extends ConsumerStatefulWidget {
  final String? id;

  const WriteTodoPage({super.key, this.id});

  @override
  ConsumerState createState() => _WriteTodoPageState();
}

class _WriteTodoPageState extends ConsumerState<WriteTodoPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });

    if (widget.id != null) {
      final todo = ref.read(todoListProvider).firstWhere((element) => element.id == widget.id);
      _controller.text = todo.title;
    }
  }

  Future<bool> _onWillPop() async {
    if (_controller.text.isNotEmpty) {
      final shouldSave = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('是否保存?'),
          content: const Text('离开当前页面前是否保存数据?'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(true);
              },
              child: const Text('否'),
            ),
            TextButton(
              onPressed: () {
                _save();
                context.pop(true);
              },
              child: const Text('是'),
            ),
          ],
        ),
      );
      return shouldSave ?? false;
    }
    return true;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _save() {
    String text = _controller.text;
    logger.d(text);
    if (text.isNotEmpty) {
      Todo todo = Todo(
        id: uuid.v4(),
        title: text,
        description: text,
        done: false,
      );

      if(widget.id != null) {
        todo.id = widget.id!;
        ref.read(todoListProvider.notifier).update(todo);
      } else {
        ref.read(todoListProvider.notifier).add(todo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '待办中心',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: TextField(
              focusNode: _focusNode,
              controller: _controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              cursorWidth: 3,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ),
        ),
      ),
    );
  }
}
