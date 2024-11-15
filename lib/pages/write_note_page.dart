import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_flutter/inject.dart';
import 'package:note_flutter/state/note_state.dart';
import 'package:uuid/uuid.dart';

import '../model/note.dart';

class WriteNotePage extends ConsumerStatefulWidget {
  final String? id;

  const WriteNotePage({super.key, this.id});

  @override
  ConsumerState createState() => _WriteNotePageState();
}

class _WriteNotePageState extends ConsumerState<WriteNotePage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _titleController = TextEditingController();
  final QuillController _controller = QuillController.basic();
  final uuid = const Uuid();
  bool _showToolbar = false;
  late Note currentNote = Note(id: '', title: '', content: '', showContent: '', date: '');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
      _controller.updateSelection(
        TextSelection.collapsed(offset: _controller.document.length),
        ChangeSource.local,
      ); // 焦点聚集在最后一个字符
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          _showToolbar = true;
        }); // Trigger a rebuild to show the toolbar
      });
    });

    _focusNode.addListener(() {
      setState(() {
        _showToolbar = _focusNode.hasFocus;
      });
    });

    if (widget.id != null) {
      final note = ref.read(noteListProvider).firstWhere((element) => element.id == widget.id);

      setState(() {
        currentNote = note;
      });
      _titleController.text = note.title;
      logger.d(jsonDecode(note.content) as List);
      _controller.document = Document.fromJson(jsonDecode(note.content) as List);
    }


  }

  _save() {
    String title = _titleController.text;
    String content = jsonEncode(_controller.document.toDelta().toJson());
    Note note = Note(
      id: uuid.v4(),
      content: content,
      showContent: _controller.document.toPlainText(),
      date: DateTime.now().toString(),
      title: title.isEmpty ? _controller.document.toPlainText().substring(0, 10) : title,
    );

    logger.d(note.toString());
    if (widget.id != null) {
      note.id = widget.id!;
      ref.read(noteListProvider.notifier).update(note);
    } else {
      ref.read(noteListProvider.notifier).add(note);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if(!_controller.document.isEmpty()) {
          _save();
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '笔记中心',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
          // backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
              child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: '标题',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(currentNote.id.isEmpty? '' : '${DateTime.parse(currentNote.date).year}-${DateTime.parse(currentNote.date).month}-${DateTime.parse(currentNote.date).day}', style: const TextStyle(color: Colors.grey),),
              ),
              SizedBox.fromSize(size: const Size.fromHeight(16)),

              Expanded(
                child: QuillEditor.basic(
                  controller: _controller,
                  focusNode: _focusNode,
                  configurations: const QuillEditorConfigurations(
                    expands: true,
                    padding: EdgeInsets.zero,
                  ),
                  scrollController: ScrollController(),
                ),
              ),
              Container(
                child: _showToolbar ? QuillSimpleToolbar(
                  controller: _controller,
                  configurations: const QuillSimpleToolbarConfigurations(
                    showFontFamily: false,
                    showFontSize: false,
                    showBoldButton: false,
                    showItalicButton: false,
                    showSmallButton: false,
                    showUnderLineButton: false,
                    showLineHeightButton: false,
                    showStrikeThrough: false,
                    showInlineCode: true,
                    showColorButton: false,
                    showBackgroundColorButton: false,
                    showClearFormat: false,
                    showAlignmentButtons: false,
                    showLeftAlignment: false,
                    showRightAlignment: false,
                    showJustifyAlignment: false,
                    showHeaderStyle: false,
                    showListNumbers: false,
                    showListBullets: true,
                    showListCheck: false,
                    showCodeBlock: true,
                    showQuote: true,
                    showIndent: false,
                    showLink: true,
                    showUndo: false,
                    showRedo: false,
                    showDirection: false,
                    showSearchButton: false,
                    showSubscript: false,
                    showSuperscript: false,
                    showClipboardCut: false,
                    showClipboardCopy: false,
                    showClipboardPaste: false,
                  ),
                ) : null,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
