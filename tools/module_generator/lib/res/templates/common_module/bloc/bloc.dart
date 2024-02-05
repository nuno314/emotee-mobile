import '../../../../common/definations.dart';

const commonModuleBloc = '''import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '${importPartKey}base/base.dart';
import '../interactor/${moduleNameKey}_interactor.dart';
import '../repository/${moduleNameKey}_repository.dart';

part '${moduleNameKey}_event.dart';
part '${moduleNameKey}_state.dart';

@Injectable()
class ${classNameKey}Bloc extends AppBlocBase<${classNameKey}Event, ${classNameKey}State> {
  final ${classNameKey}Interactor _interactor;
  
  ${classNameKey}Bloc(this._interactor) : 
    super(${classNameKey}Initial(viewModel: const _ViewModel())) {
    on<${classNameKey}Event>(_on${classNameKey}Event);
  }

  Future<void> _on${classNameKey}Event(
    ${classNameKey}Event event,
    Emitter<${classNameKey}State> emit,
  ) async {}
}''';
