import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/confirm_transfer_usecase.dart';
import '../../domain/usecases/create_transfer_usecase.dart';
import '../../domain/usecases/get_beneficiaries_usecase.dart';
import 'transfers_event.dart';
import 'transfers_state.dart';

class TransfersBloc extends Bloc<TransfersEvent, TransfersState> {
  final GetBeneficiariesUseCase getBeneficiariesUseCase;
  final CreateTransferUseCase createTransferUseCase;
  final ConfirmTransferUseCase confirmTransferUseCase;

  TransfersBloc({
    required this.getBeneficiariesUseCase,
    required this.createTransferUseCase,
    required this.confirmTransferUseCase,
  }) : super(const TransfersInitial()) {
    on<BeneficiariesLoadRequested>(_onLoadBeneficiaries);
    on<CreateTransferRequested>(_onCreateTransfer);
    on<ConfirmTransferRequested>(_onConfirmTransfer);
    on<TransferReset>(_onReset);
  }

  Future<void> _onLoadBeneficiaries(
    BeneficiariesLoadRequested event,
    Emitter<TransfersState> emit,
  ) async {
    emit(const BeneficiariesLoading());

    final result = await getBeneficiariesUseCase();

    result.fold(
      (failure) => emit(BeneficiariesError(failure.message)),
      (beneficiaries) => emit(BeneficiariesLoaded(beneficiaries)),
    );
  }

  Future<void> _onCreateTransfer(
    CreateTransferRequested event,
    Emitter<TransfersState> emit,
  ) async {
    emit(const TransferCreating());

    final result = await createTransferUseCase(
      fromAccountId: event.fromAccountId,
      beneficiaryId: event.beneficiaryId,
      amount: event.amount,
      currency: event.currency,
      description: event.description,
    );

    result.fold(
      (failure) => emit(TransferError(failure.message)),
      (transfer) => emit(TransferCreated(transfer)),
    );
  }

  Future<void> _onConfirmTransfer(
    ConfirmTransferRequested event,
    Emitter<TransfersState> emit,
  ) async {
    emit(const TransferConfirming());

    final result = await confirmTransferUseCase(event.transferId);

    result.fold(
      (failure) => emit(TransferError(failure.message)),
      (transfer) => emit(TransferConfirmed(transfer)),
    );
  }

  void _onReset(TransferReset event, Emitter<TransfersState> emit) {
    emit(const TransfersInitial());
  }
}
