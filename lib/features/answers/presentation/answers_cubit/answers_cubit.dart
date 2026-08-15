import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_teacher/features/answers/domain/enteties/answers_entity.dart';
import 'package:my_teacher/features/answers/domain/repos/answers_repo.dart';

part 'answers_state.dart';

class AnswersCubit extends Cubit<AnswersState> {
  final AnswersRepo answersRepo;

  int _page = 0;
  bool _hasMore = true;
  bool _isLoading = false;
  String _lastSearchQuery = '';
  // ignore: unused_field
  int _lastLessonId = 0;
  List<AnswersEntity> _answers = [];
  AnswersCubit({required this.answersRepo}) : super(AnswersInitial());

  void reset() {
    _page = 0;
    _hasMore = true;
    _answers = [];
    _lastSearchQuery = '';
    _lastLessonId = 0;
  }

  Future<void> getAllAnswers({
    required int lessonId,
    String? searchQuery,
    bool reset = false,
    int limit = 10,
  }) async {
    if (_isLoading) return;
    if (!_hasMore && !reset) return;
    _isLoading = true;

    if (reset) {
      _page = 0;
      _hasMore = true;
      _answers = [];
      _lastSearchQuery = searchQuery?.trim() ?? '';
      _lastLessonId = lessonId;
    }

    emit(AnswersLoading(List.from(_answers)));

    final result = await answersRepo.getAllAnswers(
      searchName: _lastSearchQuery.isEmpty ? null : _lastSearchQuery,
      page: _page,
      limit: limit,
    );

    result.fold((failure) {
      _isLoading = false;
      emit(AnswersFailure(failure.message, List.from(_answers)));
    }, (newAnswers) {
      if (newAnswers.length < limit) _hasMore = false;
      _answers.addAll(newAnswers);
      _page++;
      _isLoading = false;
      emit(AnswersSuccess(List.from(_answers)));
    });
  }

  void resetSearch() {
    _lastSearchQuery = '';
    _page = 0;
    _hasMore = true;
    _answers = [];
  }

  Future<void> clearAllAnswers() async {
    emit(AnswersLoading(List.from(_answers)));

    final result = await answersRepo.clearAllAnswers();

    result.fold(
      (failure) => emit(AnswersFailure(failure.message, List.from(_answers))),
      (_) {
        _answers.clear();
        emit(AnswersSuccess(List.from(_answers)));
      },
    );
  }
}
