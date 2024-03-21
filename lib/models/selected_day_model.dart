import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:habitmaker/models/habit_model.dart';
part 'selected_day_model.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class SelectedDay with _$SelectedDay {
  const factory SelectedDay({
    required DateTime selectedDay,
    required List<Habit> habits,
  }) = _SelectedDay;
}