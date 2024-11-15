import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../inject.dart';
import '../model/todo.dart';
import '../state/todo_state.dart';

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('待办'),
            IconButton(
                onPressed: () {
                  ref.read(todoListProvider.notifier).clear();
                },
                icon: const Icon(Icons.delete))
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: todoList.map((todo) {
            return Dismissible(
                key: Key(todo.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  ref.read(todoListProvider.notifier).delete(todo);
                },
                movementDuration: const Duration(milliseconds: 500),
                background: Container(
                  color: Colors.red,
                ),
                child: TodoItem(todo: todo));
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/todo');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoItem extends ConsumerWidget {
  final Todo todo;
  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Checkbox(
            value: todo.done,
            onChanged: (v) {
              todo.done = v!;
              ref.read(todoListProvider.notifier).update(todo);
            }),
        Expanded(
          child: ListTile(
            title: Text(todo.title,
                style: todo.done
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null),
            onTap: () {
              if (!todo.done) {
                context.go('/todo/${todo.id}');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('已完成的待办不能编辑'),
                ));
              }
            },
          ),
        ),
      ],
    );
  }
}
