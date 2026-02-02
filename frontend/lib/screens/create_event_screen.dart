import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class CreateEventScreen extends StatefulWidget {
  final Map<String, dynamic>? event;
  const CreateEventScreen({super.key, this.event});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _descriptionController;

  String _category = "Academic";
  bool _pushNotification = true;
  bool _enableRSVP = false;
  bool _isSubmitting = false;
  XFile? _image;
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?['title']);
    _locationController = TextEditingController(
      text: widget.event?['location'],
    );
    _dateController = TextEditingController(text: widget.event?['date']);
    _timeController = TextEditingController(text: widget.event?['time']);
    _descriptionController = TextEditingController(
      text: widget.event?['description'],
    );
    if (widget.event != null) {
      _category = widget.event!['category'] ?? "Academic";
      // Assuming other fields might be in event data
      _pushNotification = widget.event!['pushNotification'] ?? true;
      _enableRSVP = widget.event!['rsvp'] ?? false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? selected = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (selected != null) {
      if (kIsWeb) {
        final bytes = await selected.readAsBytes();
        setState(() {
          _image = selected;
          _webImage = bytes;
        });
      } else {
        setState(() => _image = selected);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7F9),
      appBar: _appBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _uploadPoster(),
              const SizedBox(height: 24),

              _section("General Info"),
              _label("Event Title"),
              _input(_titleController, "e.g. Annual Tech Symposium"),
              const SizedBox(height: 16),

              _label("Category"),
              _categorySelector(),
              const SizedBox(height: 24),

              _section("Logistics"),
              Row(
                children: [
                  Expanded(child: _dateField()),
                  const SizedBox(width: 12),
                  Expanded(child: _timeField()),
                ],
              ),
              const SizedBox(height: 16),

              _label("Location"),
              _input(
                _locationController,
                "Student Union, Room 204",
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 24),

              _section("Description"),
              _descriptionBox(),
              const SizedBox(height: 24),

              _toggle(
                title: "Send Push Notification",
                subtitle: "Alert students immediately",
                value: _pushNotification,
                onChanged: (v) => setState(() => _pushNotification = v),
              ),
              _toggle(
                title: "Enable RSVP",
                subtitle: "Collect attendance headcount",
                value: _enableRSVP,
                onChanged: (v) => setState(() => _enableRSVP = v),
              ),

              const SizedBox(height: 32),
              _bottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // ================= APP BAR =================
  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close, color: Colors.black),
      ),
      title: Text(
        widget.event == null ? "Create Event" : "Update Event",
        style: const TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      actions: [
        if (widget.event != null)
          IconButton(
            onPressed: _deleteEvent,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        TextButton(
          onPressed: _isSubmitting ? null : _submit,
          child: Text(
            widget.event == null ? "Publish" : "Save",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // ================= UPLOAD POSTER =================
  Widget _uploadPoster() {
    return GestureDetector(
      onTap: _pickImage,
      child: DottedBorder(
        dashPattern: const [6, 4],
        color: Colors.grey.shade400,
        borderType: BorderType.RRect,
        radius: const Radius.circular(16),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: kIsWeb
                      ? (_webImage != null
                            ? Image.memory(
                                _webImage!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : const Center(child: CircularProgressIndicator()))
                      : Image.file(
                          File(_image!.path),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFF3A4F9B).withOpacity(0.1),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Color(0xFF3A4F9B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Upload Event Poster",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Recommended size: 1200 x 630px",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3A4F9B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _pickImage,
                      child: const Text(
                        "Add Image",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // ================= CATEGORY =================
  Widget _categorySelector() {
    return Row(
      children: ["Academic", "Social", "Sports"].map((c) {
        final selected = _category == c;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(c),
            selected: selected,
            onSelected: (_) => setState(() => _category = c),
            backgroundColor: Colors.white,
            selectedColor: Color(0xFF3A4F9B).withOpacity(0.15),
            side: BorderSide(
              color: selected ? Color(0xFF3A4F9B) : Colors.grey.shade300,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelStyle: TextStyle(
              color: selected ? Color(0xFF3A4F9B) : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  // ================= DATE & TIME =================
  Widget _dateField() {
    return _input(
      _dateController,
      "Oct 24, 2023",
      icon: Icons.calendar_today_outlined,
      readOnly: true,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (date != null) {
          _dateController.text = "${date.month}/${date.day}/${date.year}";
        }
      },
    );
  }

  Widget _timeField() {
    return _input(
      _timeController,
      "10:00 AM",
      icon: Icons.access_time,
      readOnly: true,
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time != null && mounted) {
          _timeController.text = time.format(context);
        }
      },
    );
  }

  // ================= DESCRIPTION =================
  Widget _descriptionBox() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 5,
      validator: (v) => v!.isEmpty ? "Required" : null,
      decoration: _decoration("Share the details about the event..."),
    );
  }

  // ================= TOGGLE =================
  Widget _toggle({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  // ================= BOTTOM BUTTONS =================
  Widget _bottomButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            child: const Text("Save Draft"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _submit,
            child: const Text("Publish Event"),
          ),
        ),
      ],
    );
  }

  void _deleteEvent() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Event"),
        content: const Text("Are you sure you want to delete this event?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isSubmitting = true);
    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      await eventProvider.deleteEvent(widget.event!['_id']);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ================= SUBMIT =================
  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);

      String? imageUrl = widget.event?['imageUrl'];
      if (_image != null) {
        final bytes = _webImage ?? await _image!.readAsBytes();
        imageUrl = await eventProvider.uploadImage(bytes, _image!.name);
      }

      if (!mounted) return;

      final eventData = {
        "title": _titleController.text,
        "category": _category,
        "date": _dateController.text,
        "time": _timeController.text,
        "location": _locationController.text,
        "description": _descriptionController.text,
        "pushNotification": _pushNotification,
        "rsvp": _enableRSVP,
        "imageUrl": imageUrl,
      };

      if (widget.event == null) {
        await eventProvider.addEvent(eventData);
      } else {
        await eventProvider.updateEvent(widget.event!['_id'], eventData);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ================= HELPERS =================
  Widget _section(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      t,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  Widget _label(String t) =>
      Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(t));

  Widget _input(
    TextEditingController c,
    String h, {
    IconData? icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: c,
      readOnly: readOnly,
      onTap: onTap,
      validator: (v) => v!.isEmpty ? "Required" : null,
      decoration: _decoration(h, icon: icon),
    );
  }

  InputDecoration _decoration(String h, {IconData? icon}) {
    return InputDecoration(
      hintText: h,
      filled: true,
      fillColor: Colors.white,
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
