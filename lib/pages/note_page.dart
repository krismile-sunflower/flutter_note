import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:note_flutter/state/note_state.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../inject.dart';
import '../model/note.dart';

class NotePage extends ConsumerWidget {
  const NotePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteList = ref.watch(noteListProvider);
    logger.d(noteList.length);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('笔记'),
            IconButton(
                onPressed: () {
                  ref.read(noteListProvider.notifier).clear();
                },
                icon: const Icon(Icons.delete))
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: WaterfallFlow(
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            lastChildLayoutTypeBuilder: (int index) => index.isEven
                ? LastChildLayoutType.fullCrossAxisExtent
                : LastChildLayoutType.none,
          ),
          children: noteList.map((note) {
            return Dismissible(
                key: Key(note.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  ref.read(noteListProvider.notifier).delete(note);
                },
                movementDuration: const Duration(milliseconds: 500),
                background: Container(
                  color: Colors.red,
                ),
                child: NoteItem(note: note));
          }).toList(),
        ),
        // child: ListView(
        //   children: noteList.map((note) {
        //     return Dismissible(
        //         key: Key(note.id),
        //         direction: DismissDirection.endToStart,
        //         onDismissed: (direction) {
        //           ref.read(noteListProvider.notifier).delete(note);
        //         },
        //         movementDuration: const Duration(milliseconds: 500),
        //         background: Container(
        //           color: Colors.red,
        //         ),
        //         child: NoteItem(note: note));
        //   }).toList(),
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/note');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteItem extends ConsumerWidget {
  final Note note;
  const NoteItem({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Flex(
        direction: Axis.vertical,
        children: [
          ListTile(
            title: Text(note.title),
            subtitle: Text(note.showContent),
            onTap: () {
              context.go('/note/${note.id}');
            },
          ),
        ],
      ),
    );
  }
}
