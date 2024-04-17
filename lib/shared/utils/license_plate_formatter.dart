import 'package:flutter/services.dart';

class PlacaVeiculoInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Obtém o texto inserido pelo usuário
    String newText = newValue.text;

    // Remove caracteres não alfanuméricos
    newText = newText.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    // Converte todas as letras para maiúsculas
    newText = newText.toUpperCase().trim();

    // Aplica a formatação somente se o novo valor for válido
    if (newText.length < 8) {
      // Retorna o valor formatado
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    } else {
      // Se o novo valor não for válido, mantém o valor antigo
      return oldValue;
    }
  }
}
