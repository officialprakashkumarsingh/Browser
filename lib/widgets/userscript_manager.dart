import 'package:flutter/material.dart';
import '../services/userscript_service.dart';
import '../utils/app_colors.dart';

class UserScriptManager extends StatefulWidget {
  final VoidCallback onClose;

  const UserScriptManager({
    super.key,
    required this.onClose,
  });

  @override
  State<UserScriptManager> createState() => _UserScriptManagerState();
}

class _UserScriptManagerState extends State<UserScriptManager> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  List<UserScript> _userScripts = [];
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _loadUserScripts();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadUserScripts() {
    setState(() {
      _userScripts = UserScriptService.instance.userScripts;
    });
  }

  void _showAddScriptDialog() {
    showDialog(
      context: context,
      barrierColor: AppColors.overlay,
      builder: (context) => _AddScriptDialog(
        onScriptAdded: () {
          _loadUserScripts();
        },
      ),
    );
  }

  Future<void> _deleteScript(String id) async {
    await UserScriptService.instance.removeUserScript(id);
    _loadUserScripts();
  }

  Future<void> _toggleScript(String id) async {
    await UserScriptService.instance.toggleUserScript(id);
    _loadUserScripts();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(_slideAnimation),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: AppColors.glassBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          border: Border.all(color: AppColors.glassBorder, width: 0.5),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'User Scripts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _showAddScriptDialog,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTransparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 16,
                        color: AppColors.iconAccent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.iconSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scripts list
            Expanded(
              child: _userScripts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.code,
                            size: 48,
                            color: AppColors.iconInactive,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No user scripts yet',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _showAddScriptDialog,
                            child: const Text(
                              'Add your first script',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _userScripts.length,
                      itemBuilder: (context, index) {
                        final script = _userScripts[index];
                        return _ScriptTile(
                          script: script,
                          onToggle: () => _toggleScript(script.id),
                          onDelete: () => _deleteScript(script.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScriptTile extends StatelessWidget {
  final UserScript script;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _ScriptTile({
    required this.script,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: script.isEnabled ? AppColors.surface : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: script.isEnabled ? AppColors.primaryTransparent : AppColors.border,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: script.isEnabled ? AppColors.success : AppColors.iconInactive,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  script.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: script.isEnabled ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  script.domain,
                  style: TextStyle(
                    fontSize: 11,
                    color: script.isEnabled ? AppColors.textSecondary : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Icon(
                script.isEnabled ? Icons.toggle_on : Icons.toggle_off,
                size: 20,
                color: script.isEnabled ? AppColors.success : AppColors.iconInactive,
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(6),
              child: const Icon(
                Icons.delete_outline,
                size: 16,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddScriptDialog extends StatefulWidget {
  final VoidCallback onScriptAdded;

  const _AddScriptDialog({required this.onScriptAdded});

  @override
  State<_AddScriptDialog> createState() => _AddScriptDialogState();
}

class _AddScriptDialogState extends State<_AddScriptDialog> {
  final _nameController = TextEditingController();
  final _domainController = TextEditingController();
  final _scriptController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _domainController.dispose();
    _scriptController.dispose();
    super.dispose();
  }

  Future<void> _addScript() async {
    if (_nameController.text.trim().isEmpty ||
        _domainController.text.trim().isEmpty ||
        _scriptController.text.trim().isEmpty) {
      return;
    }

    await UserScriptService.instance.addUserScript(
      name: _nameController.text.trim(),
      domain: _domainController.text.trim(),
      script: _scriptController.text.trim(),
    );

    widget.onScriptAdded();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.glassBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add User Script',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildTextField('Script Name', _nameController, 'e.g., Remove Ads'),
            const SizedBox(height: 12),
            
            _buildTextField('Domain', _domainController, 'e.g., google.com or *'),
            const SizedBox(height: 12),
            
            _buildTextField('JavaScript Code', _scriptController, 
              'document.querySelector(\'.ad\')?.remove();', maxLines: 4),
            
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addScript,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Add', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.all(10),
            filled: true,
            fillColor: AppColors.surfaceVariant,
          ),
        ),
      ],
    );
  }
}