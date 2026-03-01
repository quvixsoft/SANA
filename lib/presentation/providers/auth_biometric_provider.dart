import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final toogleBiometricProvider =
    StateNotifierProvider<BiometricNotifier, BiometricState>((ref) {
      return BiometricNotifier();
    });

class BiometricState {
  final bool isToogle;
  final Color colorFingPrint;

  BiometricState({this.isToogle = false, this.colorFingPrint = Colors.grey});

  BiometricState copyWith({bool? isToogle, Color? colorFingPrint}) {
    return BiometricState(
      isToogle: isToogle ?? this.isToogle,
      colorFingPrint: colorFingPrint ?? this.colorFingPrint,
    );
  }
}

class BiometricNotifier extends StateNotifier<BiometricState> {
  BiometricNotifier() : super(BiometricState());

  void biometricEnabled({required bool isToogle}) {
    state = state.copyWith(isToogle: isToogle);
  }

  void changeFingerprintColor({required Color colorFingPrint}) {
    state = state.copyWith(colorFingPrint: colorFingPrint);
  }

  void reset() {
    state = BiometricState();
  }
}
