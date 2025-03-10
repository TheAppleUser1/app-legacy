import 'package:i18n_extension/i18n_extension.dart';

extension ScreensLocalization on String {
  static final _t = Translations.byLocale("hu_hu") +
      {
        "en_en": {
          "notes": "Notes",
          "empty": "You don't have any notes",
          "todo": "Tasks",
          "homework": "Homework",
          "new_note": "New Note",
          "edit_note": "Edit Note",
          "hint": "Note content...",
          "hint_t": "Note title...",
          "your_notes": "Your Notes",
          "new_image": "New Image",
          "no_title": "No title",
          "task_content": "Task content...",
          "task_name": "Task title...",
          "new_task": "New Task",
          "next": "Next",
          "cancel": "Cancel",
        },
        "hu_hu": {
          "notes": "Füzet",
          "empty": "Nincsenek jegyzeteid",
          "todo": "Feladatok",
          "homework": "Házi feladat",
          "new_note": "Új jegyzet",
          "edit_note": "Jegyzet szerkesztése",
          "hint": "Jegyzet tartalma...",
          "hint_t": "Jegyzet címe...",
          "your_notes": "Jegyzeteid",
          "new_image": "Új kép",
          "no_title": "Nincs cím",
          "task_content": "Feladat tartalma...",
          "task_name": "Feladat címe...",
          "new_task": "Új feladat",
          "next": "Tovább",
          "cancel": "Mégse",
        },
        "de_de": {
          "notes": "Broschüre",
          "empty": "Sie haben keine Notizen",
          "todo": "Aufgaben",
          "homework": "Hausaufgaben",
          "new_note": "Neue Notiz",
          "edit_note": "Notiz bearbeiten",
          "hint": "Inhalt beachten...",
          "hint_t": "Titel notieren...",
          "your_notes": "Deine Noten",
          "new_image": "Neues Bild",
          "no_title": "Kein Titel",
          "task_content": "Aufgabeninhalt...",
          "task_name": "Aufgabentitel...",
          "new_task": "Neue Aufgabe",
          "next": "Weiter",
          "cancel": "Abbrechen",
        },
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
  String plural(int value) => localizePlural(value, this, _t);
  String version(Object modifier) => localizeVersion(modifier, this, _t);
}
