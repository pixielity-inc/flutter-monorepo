import '../entities/example_item.dart';

/// Abstract contract for fetching and managing [ExampleItem] data.
///
/// Implementations must be registered via dependency injection (e.g. Riverpod)
/// so that use cases receive the correct concrete class at runtime.
///
/// Repository interfaces live in the Domain Layer and declare WHAT data
/// operations are available without specifying HOW they are implemented.
/// Concrete implementations belong in the Data Layer.
abstract interface class ExampleRepository {
  /// Retrieves all available [ExampleItem] instances.
  ///
  /// Returns a [Future] that resolves to a list of items on success.
  /// Throws an [Exception] on failure.
  Future<List<ExampleItem>> getAll();

  /// Retrieves a single [ExampleItem] by its [id].
  ///
  /// Returns `null` if no item with the given [id] exists.
  /// Throws an [Exception] on network or storage errors.
  Future<ExampleItem?> getById(String id);
}
