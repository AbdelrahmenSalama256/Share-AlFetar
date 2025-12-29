import 'package:bloc/bloc.dart';

import '../../data/model/wishlist_model.dart';
import '../../data/repo/wishlist_repo.dart';
import 'wishlist_state.dart';

//! WishlistCubit
class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepo wishlistRepo;

  WishlistCubit(this.wishlistRepo) : super(WishlistInitial()) {
    fetchWishlist();
  }

  Wishlist? wishlist;

  Future<void> fetchWishlist() async {
    emit(WishlistLoading());
    final result = await wishlistRepo.getWishlist();
    result.fold(
      (error) => emit(WishlistError(error)),
      (wishlistData) {
        wishlist = wishlistData;
        emit(WishlistLoaded());
      },
    );
  }

  Future<void> removeFromWishlist(int id) async {
    emit(WishlistItemRemovedLoading());
    final result = await wishlistRepo.removeFromWishlist(id);
    result.fold(
      (error) => emit(WishlistItemRemovedError(error)),
      (message) {
        emit(WishlistItemRemovedSuccess(message));
        fetchWishlist();
      },
    );
  }
}
