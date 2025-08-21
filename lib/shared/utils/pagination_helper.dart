class PaginationHelper {
  static const int defaultLimit = 20;
  
  static Map<String, dynamic> getPaginationParams({
    int? limit,
    int? offset,
  }) {
    return {
      'limit': limit ?? defaultLimit,
      'offset': offset ?? 0,
    };
  }
  
  static bool hasReachedMax(List items, int limit) {
    return items.length < limit;
  }
  
  static List<T> mergeItems<T>(List<T> currentItems, List<T> newItems) {
    return List.of(currentItems)..addAll(newItems);
  }
}

