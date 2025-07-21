import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/url_helper.dart';

class UrlBar extends StatefulWidget {
  final String currentUrl;
  final Function(String) onUrlSubmitted;
  final bool isLoading;
  final double loadingProgress;

  const UrlBar({
    super.key,
    required this.currentUrl,
    required this.onUrlSubmitted,
    required this.isLoading,
    required this.loadingProgress,
  });

  @override
  State<UrlBar> createState() => _UrlBarState();
}

class _UrlBarState extends State<UrlBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    
    _focusNode.addListener(() {
      setState(() {
        _isEditing = _focusNode.hasFocus;
      });
      
      if (_focusNode.hasFocus) {
        _controller.text = widget.currentUrl;
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(UrlBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && widget.currentUrl != oldWidget.currentUrl) {
      _controller.text = UrlHelper.getDisplayUrl(widget.currentUrl);
    }
  }

  void _onSubmitted(String value) {
    _focusNode.unfocus();
    widget.onUrlSubmitted(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.urlBarBackground,
        borderRadius: BorderRadius.circular(10),
        border: _isEditing ? Border.all(
          color: AppColors.primary,
          width: 1.5,
        ) : null,
      ),
      child: Column(
        children: [
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                // Search/URL icon
                Icon(
                  _isEditing ? Icons.search : Icons.lock_outline,
                  size: 16,
                  color: AppColors.iconSecondary,
                ),
                
                const SizedBox(width: 8),
                
                // URL/Search text field
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: _onSubmitted,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search or enter URL',
                      hintStyle: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                
                // Clear button (when editing)
                if (_isEditing && _controller.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _controller.clear();
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.cancel,
                      size: 16,
                      color: AppColors.iconSecondary,
                    ),
                  ),
              ],
            ),
          ),
          
          // Loading progress bar
          if (widget.isLoading && widget.loadingProgress > 0)
            Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: LinearProgressIndicator(
                value: widget.loadingProgress,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.loadingBar,
                ),
              ),
            ),
        ],
      ),
    );
  }
}