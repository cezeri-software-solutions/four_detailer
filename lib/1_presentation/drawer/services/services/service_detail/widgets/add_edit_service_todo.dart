import 'package:flutter/material.dart';

import '/3_domain/models/models.dart';
import '/constants.dart';
import '/core/core.dart';

class AddEditServiceTodo extends StatefulWidget {
  final ServiceTodo? serviceTodo;
  final void Function(ServiceTodo)? onServiceTodoChanged;

  const AddEditServiceTodo({this.serviceTodo, this.onServiceTodoChanged, super.key});

  @override
  State<AddEditServiceTodo> createState() => _AddEditServiceTodoState();
}

class _AddEditServiceTodoState extends State<AddEditServiceTodo> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    if (widget.serviceTodo != null) {
      _nameController = TextEditingController(text: widget.serviceTodo!.name);
      _descriptionController = TextEditingController(text: widget.serviceTodo!.description);
    } else {
      _nameController = TextEditingController();
      _descriptionController = TextEditingController();
    }

    _nameController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextFormField(
          controller: _nameController,
          fieldTitle: context.l10n.title,
          isMandatory: true,
          textCapitalization: TextCapitalization.sentences,
          validator: (value) {
            if (value == null || value.isEmpty) return context.l10n.mandatory;
            return null;
          },
        ),
        Gaps.h16,
        MyTextFormField(
          controller: _descriptionController,
          fieldTitle: context.l10n.description,
          textCapitalization: TextCapitalization.sentences,
          minLines: 4,
          maxLines: null,
        ),
      ],
    );
  }

  void _onFieldChanged() {
    if (widget.onServiceTodoChanged != null) {
      widget.onServiceTodoChanged!(_std);
    }
  }

  ServiceTodo get _std => (widget.serviceTodo ?? ServiceTodo.empty()).copyWith(
        name: _nameController.text,
        description: _descriptionController.text,
      );
}
