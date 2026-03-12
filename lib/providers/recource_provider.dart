import 'package:flutter_riverpod/legacy.dart';

class ResourceState {
  final int tabId;
  const ResourceState({this.tabId = 0});

  ResourceState copyWith({int? tabId}) {
    return ResourceState(tabId: tabId ?? this.tabId);
  }
}

class ResourceNotifier extends StateNotifier<ResourceState> {
  ResourceNotifier() : super(const ResourceState());
  void setTab(int id) {
    state = state.copyWith(tabId: id);
  }
}

final resourceProvider = StateNotifierProvider<ResourceNotifier, ResourceState>(
  (ref) => ResourceNotifier(),
);
