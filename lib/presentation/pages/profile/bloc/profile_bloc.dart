import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:paml_20190140086_ewallet/domain/models/user/user_model.dart';
import 'package:paml_20190140086_ewallet/domain/repositories/profile/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    final profileRepository = ProfileRepository();

    on<ProfileEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetDataProfile>((event, emit) async {
      try {
        emit(ProfileLoading());
        final response = await profileRepository.get();
          
        emit(ProfileLoaded(data: response));
      } catch (e) {
        emit(ProfileError(error: e.toString()));
      }
    });
  }
}
