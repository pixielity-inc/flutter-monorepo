import '../entities/example_item.dart';
import '../repositories/example_repository.dart';

/// Use case: fetch all [ExampleItem]s from the repository.
///
/// Use cases encapsulate a single piece of business logic. They accept a
/// repository interface (injected via constructor), perform one operation,
/// and return a result. They must NOT contain UI logic, HTTP calls, or
/// state management.
///
/// Example:
/// ```dart
/// final useCase = GetExampleItems(repository: myRepo);
/// final items = await useCase.execute();
/// ```
final class GetExampleItems {
  /// Creates a [GetExampleItems] use case.
  ///
  /// [repository] must be a concrete implementation of [ExampleRepository],
  /// typically provided by a Riverpod provider or service locator.
  const GetExampleItems({required ExampleRepository repository})
    : _repository = repository;

  /// The repository used to fetch items.
  final ExampleRepository _repository;

  /// Executes the use case and returns all [ExampleItem]s.
  ///
  /// Delegates directly to [ExampleRepository.getAll].
  Future<List<ExampleItem>> execute() => _repository.getAll();
}
