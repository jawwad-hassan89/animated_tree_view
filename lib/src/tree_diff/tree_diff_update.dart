import 'package:animated_tree_view/animated_tree_view.dart';

abstract class TreeDiffUpdate {
  const factory TreeDiffUpdate.insert(
      {required int position, required INode data}) = NodeInsert;

  const factory TreeDiffUpdate.add(INode data) = NodeAdd;

  const factory TreeDiffUpdate.remove(INode data) = NodeRemove;

  /// call one of the given callback functions depending on the type of this object.
  ///
  /// @param insert callback function to be called if this object is of type [NodeInsert]
  /// @param remove callback function to be called if this object is of type [DateRemove]
  /// @param change callback function to be called if this object is of type [DateChange]
  /// @param move callback function to be called if this object is of type [DateMove]
  ///
  S when<S>({
    required S Function(int position, INode data) insert,
    required S Function(INode data) remove,
    required S Function(INode data) add,
  });
}

class NodeInsert implements TreeDiffUpdate {
  final int position;

  final INode data;

  const NodeInsert({
    required this.position,
    required this.data,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeInsert &&
          runtimeType == other.runtimeType &&
          position == other.position &&
          data == other.data;

  @override
  int get hashCode => position.hashCode ^ data.hashCode;

  @override
  S when<S>({
    required S Function(int pos, INode data) insert,
    S Function(INode data)? remove,
    S Function(INode data)? add,
  }) {
    return insert(position, data);
  }

  @override
  String toString() {
    return 'Insert{position: $position, data: $data}';
  }
}

class NodeRemove implements TreeDiffUpdate {
  final INode data;
  final int? position;

  const NodeRemove(this.data, {this.position});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeRemove &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  S when<S>({
    S Function(int pos, INode data)? insert,
    required S Function(INode data) remove,
    S Function(INode data)? add,
  }) {
    return remove(data);
  }

  @override
  String toString() {
    return 'Remove{data: $data}';
  }
}

class NodeAdd implements TreeDiffUpdate {
  final INode data;

  const NodeAdd(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeAdd &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  S when<S>({
    S Function(int pos, INode data)? insert,
    S Function(INode data)? remove,
    required S Function(INode data) add,
  }) {
    return add(data);
  }

  @override
  String toString() {
    return 'Add{data: $data}';
  }
}
