import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/content_models.dart';

class DataService {
  static VelvetDatabase? _cachedDatabase;

  static Future<VelvetDatabase> loadDatabase() async {
    if (_cachedDatabase != null) {
      return _cachedDatabase!;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/data/velvet_content.json');
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      _cachedDatabase = VelvetDatabase.fromJson(jsonData);
      return _cachedDatabase!;
    } catch (e) {
      // Fallback empty structure
      return VelvetDatabase(
        version: '4.0',
        courses: [],
        sosCards: [],
        beliefLibrary: [],
      );
    }
  }

  static List<Course> getCourses() {
    return _cachedDatabase?.courses ?? [];
  }

  static List<SosCard> getSosCards() {
    return _cachedDatabase?.sosCards ?? [];
  }

  static List<BeliefCard> getBeliefLibrary() {
    return _cachedDatabase?.beliefLibrary ?? [];
  }

  static Course? getCourseById(String id) {
    try {
      return _cachedDatabase?.courses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  static Lesson? getLessonById(String id) {
    if (_cachedDatabase == null) return null;
    for (final course in _cachedDatabase!.courses) {
      for (final lesson in course.lessons) {
        if (lesson.id == id) return lesson;
      }
    }
    return null;
  }
}
