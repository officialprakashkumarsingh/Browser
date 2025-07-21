import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserScript {
  final String id;
  final String name;
  final String script;
  final String domain;
  final bool isEnabled;
  final DateTime createdAt;

  UserScript({
    required this.id,
    required this.name,
    required this.script,
    required this.domain,
    this.isEnabled = true,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'script': script,
    'domain': domain,
    'isEnabled': isEnabled,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserScript.fromJson(Map<String, dynamic> json) => UserScript(
    id: json['id'],
    name: json['name'],
    script: json['script'],
    domain: json['domain'],
    isEnabled: json['isEnabled'] ?? true,
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class UserScriptService {
  static const String _storageKey = 'user_scripts';
  static UserScriptService? _instance;
  List<UserScript> _userScripts = [];
  
  static UserScriptService get instance {
    _instance ??= UserScriptService._();
    return _instance!;
  }
  
  UserScriptService._();

  List<UserScript> get userScripts => List.unmodifiable(_userScripts);

  Future<void> initialize() async {
    await _loadUserScripts();
  }

  Future<void> _loadUserScripts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scriptsJson = prefs.getStringList(_storageKey) ?? [];
      
      _userScripts = scriptsJson
          .map((json) => UserScript.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      _userScripts = [];
    }
  }

  Future<void> _saveUserScripts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scriptsJson = _userScripts
          .map((script) => jsonEncode(script.toJson()))
          .toList();
      
      await prefs.setStringList(_storageKey, scriptsJson);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> addUserScript({
    required String name,
    required String script,
    required String domain,
  }) async {
    final userScript = UserScript(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      script: script,
      domain: domain,
      createdAt: DateTime.now(),
    );
    
    _userScripts.add(userScript);
    await _saveUserScripts();
  }

  Future<void> removeUserScript(String id) async {
    _userScripts.removeWhere((script) => script.id == id);
    await _saveUserScripts();
  }

  Future<void> toggleUserScript(String id) async {
    final index = _userScripts.indexWhere((script) => script.id == id);
    if (index != -1) {
      final script = _userScripts[index];
      _userScripts[index] = UserScript(
        id: script.id,
        name: script.name,
        script: script.script,
        domain: script.domain,
        isEnabled: !script.isEnabled,
        createdAt: script.createdAt,
      );
      await _saveUserScripts();
    }
  }

  List<UserScript> getScriptsForDomain(String domain) {
    return _userScripts.where((script) => 
      script.isEnabled && 
      (script.domain == '*' || domain.contains(script.domain))
    ).toList();
  }

  String getInjectableScript(String domain) {
    final scripts = getScriptsForDomain(domain);
    if (scripts.isEmpty) return '';
    
    final combinedScript = scripts.map((s) => s.script).join('\n\n');
    return '''
(function() {
  try {
    $combinedScript
  } catch (e) {
    console.log('UserScript error:', e);
  }
})();
''';
  }
}