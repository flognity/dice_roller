import 'dart:collection';

import 'package:dice_roller/util/language_provider/language_text_provider.dart'
    show BaseTextProvider;

class LangCode {
  static const en = 'en';
  static const de = 'de';
  static const fr = 'fr';
  static const es = 'es';
}

class TextProvider implements BaseTextProvider {
  static final List<String> _supportedLanguages = [
    LangCode.en,
    LangCode.de,
    LangCode.fr,
    LangCode.es,
  ];
  static final Map<String, Map<String, String>> _textProviderValues =
      <String, Map<String, String>>{
    'total': {
      LangCode.en: 'Total',
      LangCode.de: 'Gesamt',
      LangCode.fr: 'Résultat',
      LangCode.es: 'Resultado',
    },
    'roll_die': {
      LangCode.en: 'Roll die',
      LangCode.de: 'Würfeln',
      LangCode.fr: 'Lancer',
      LangCode.es: 'Tirar',
    },
    'roll_dice': {
      LangCode.en: 'Roll dice',
      LangCode.de: 'Würfeln',
      LangCode.fr: 'Lancer',
      LangCode.es: 'Tirar',
    },
    'number_of_dice': {
      LangCode.en: 'Number of dice',
      LangCode.de: 'Anzahl der Würfel',
      LangCode.fr: 'Nombre de dés',
      LangCode.es: 'Número de dados',
    },
    'reset': {
      LangCode.en: 'Reset',
      LangCode.de: 'Zurücksetzen',
      LangCode.fr: 'Réinitialiser',
      LangCode.es: 'Reiniciar',
    },
    'faces_of_the_dice': {
      LangCode.en: 'Faces of the dice',
      LangCode.de: 'Augenzahl der Würfel',
      LangCode.fr: 'Nombre de faces',
      LangCode.es: 'Número de caras',
    },
    'shake_to_roll': {
      LangCode.en: 'Shake phone to roll dice',
      LangCode.de: 'Schütteln um Würfel zu würfeln',
      LangCode.fr: 'Secouez pour lancer les dés',
      LangCode.es: 'Agitar para lanzar los dados',
    },
    'ok': {
      LangCode.en: 'OK',
      LangCode.de: 'OK',
      LangCode.fr: 'D\'accord',
      LangCode.es: 'OK',
    },
    'press_button_or_shake_to_roll_dice': {
      LangCode.en:
          'Press button or shake your device to roll all dice. Touch dice to roll them individually.',
      LangCode.de:
          'Knopf drücken oder schütteln, um alle Würfel zu würfeln. Würfel berühren, um sie einzeln zu würfeln.',
      LangCode.fr:
          'Appuyez sur le bouton ou secouez votre appareil pour lancer tous les dés. Touchez les dés pour les lancer individuellement.',
      LangCode.es:
          'Presione el botón o agite su dispositivo para lanzar todos los dados. Toque los dados para lanzarlos individualmente.',
    },
    'press_button_or_shake_to_roll_die': {
      LangCode.en: 'Press button, shake your device or touch die to roll.',
      LangCode.de:
          'Knopf drücken, schütteln oder Würfel berühren, um zu würfeln.',
      LangCode.fr:
          'Appuyez sur le bouton, secouez votre appareil ou touchez le dé pour rouler.',
      LangCode.es:
          'Presione el botón, agite su dispositivo o toque el dado para rodar.',
    },
    'press_button_to_roll_dice': {
      LangCode.en:
          'Press button to roll all dice. Touch dice to roll them individually.',
      LangCode.de:
          'Knopf drücken, um alle Würfel zu würfeln. Würfel berühren, um sie einzeln zu würfeln.',
      LangCode.fr:
          'Appuyez sur le bouton pour lancer tous les dés. Touchez les dés pour les lancer individuellement.',
      LangCode.es:
          'Presione el botón para lanzar todos los dados. Toque los dados para lanzarlos individualmente.',
    },
    'press_button_to_roll_die': {
      LangCode.en: 'Press button or touch die to roll.',
      LangCode.de: 'Knopf drücken oder Würfel berühren, um zu würfeln.',
      LangCode.fr: 'Appuyez sur le bouton ou touchez le dé pour rouler.',
      LangCode.es: 'Presione el botón o toque el dado para rodar.',
    },
    'roll_animation': {
      LangCode.en: 'Dice roll duration (s)',
      LangCode.de: 'Würfelwurfdauer (s)',
      LangCode.fr: 'Durée du lancer de dés (s)',
      LangCode.es: 'Duración de la tirada de dados (s)',
    },
    'dice_color': {
      LangCode.en: 'Dice color',
      LangCode.de: 'Würfelfarbe',
      LangCode.fr: 'Couleur des dés',
      LangCode.es: 'Color de los dados',
    },
    'dice': {
      LangCode.en: 'Dice',
      LangCode.de: 'Würfel',
      LangCode.fr: 'Dés',
      LangCode.es: 'Dados',
    },
    'history': {
      LangCode.en: 'History',
      LangCode.de: 'Historie',
      LangCode.fr: 'Historique',
      LangCode.es: 'Historia',
    },
    'delete_history': {
      LangCode.en: 'Delete History',
      LangCode.de: 'Historie löschen',
      LangCode.fr: 'Supprimer l\'historique',
      LangCode.es: 'Borrar historial',
    },
    'ask_delete_history': {
      LangCode.en: 'Do you want to delete the history?',
      LangCode.de: 'Möchten Sie den Verlauf löschen?',
      LangCode.fr: 'Voulez-vous supprimer l\'historique?',
      LangCode.es: '¿Quieres borrar el historial?',
    },
    'delete': {
      LangCode.en: 'delete',
      LangCode.de: 'löschen',
      LangCode.fr: 'supprimer',
      LangCode.es: 'Borrar',
    },
    'cancel': {
      LangCode.en: 'cancel',
      LangCode.de: 'abbrechen',
      LangCode.fr: 'annuler',
      LangCode.es: 'cancelar',
    },
    'app_theme': {
      LangCode.en: 'App theme',
      LangCode.de: 'App Design',
      LangCode.fr: 'Thème de l\'application',
      LangCode.es: 'Tema de la aplicación',
    },
    'system_default': {
      LangCode.en: 'System default',
      LangCode.de: 'System-Standard',
      LangCode.fr: 'Norme du système',
      LangCode.es: 'Estándar del sistema',
    },
    'dark_mode': {
      LangCode.en: 'Dark',
      LangCode.de: 'Dunkel',
      LangCode.fr: 'Sombre',
      LangCode.es: 'Oscuro',
    },
    'light_mode': {
      LangCode.en: 'Light',
      LangCode.de: 'Hell',
      LangCode.fr: 'Clair',
      LangCode.es: 'Ligero',
    },
    'settings': {
      LangCode.en: 'Settings',
      LangCode.de: 'Einstellungen',
      LangCode.fr: 'Paramètres',
      LangCode.es: 'Ajustes',
    },
  };
  TextProvider();

  @override
  UnmodifiableListView<String> get getSupportedLanguages =>
      UnmodifiableListView(_supportedLanguages);

  @override
  UnmodifiableMapView<String, Map<String, String>> get getTextProviderValues =>
      UnmodifiableMapView(_textProviderValues);
}
