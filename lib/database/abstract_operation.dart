import '../model/abstract_model.dart';

abstract class CrudOperation
{
  void insert(Model model);
  void delete(int id);
  void update(int id,Model model);
  Future<List<Model>> getAll();
}