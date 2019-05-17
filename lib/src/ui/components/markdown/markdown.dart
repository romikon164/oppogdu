import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/gestures.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:meta/meta.dart';
import 'builder.dart';

typedef void MarkdownTapImageCallback(String href, String title, String alt);

class MarkDownComponent extends StatefulWidget
{
    const MarkDownComponent({
        Key key,
        @required this.data,
        this.styleSheet,
        this.syntaxHighlighter,
        this.onTapLink,
        this.onTapImage,
        this.imageDirectory,
    }) : assert(data != null),
            super(key: key);

    /// The Markdown to display.
    final String data;

    /// The styles to use when displaying the Markdown.
    ///
    /// If null, the styles are inferred from the current [Theme].
    final MarkdownStyleSheet styleSheet;

    /// The syntax highlighter used to color text in `pre` elements.
    ///
    /// If null, the [MarkdownStyleSheet.code] style is used for `pre` elements.
    final SyntaxHighlighter syntaxHighlighter;

    /// Called when the user taps a link.
    final MarkdownTapLinkCallback onTapLink;

    final MarkdownTapImageCallback onTapImage;

    /// The base directory holding images referenced by Img tags with local file paths.
    final Directory imageDirectory;

    Widget build(BuildContext context, List<Widget> children) {
        if (children.length == 1)
            return children.single;
        return new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
        );
    }

    @override
    _MarkDownComponentState createState() => new _MarkDownComponentState();
}

class _MarkDownComponentState extends State<MarkDownComponent> implements MarkDownComponentBuilderDelegate
{
    List<Widget> _children;
    final List<GestureRecognizer> _recognizers = <GestureRecognizer>[];

    @override
    void initState()
    {
        super.initState();
    }

    @override
    void didChangeDependencies() {
        super.didChangeDependencies();

        if(_children == null) {
            _parseMarkdown();
        }
    }

    @override
    void didUpdateWidget(MarkDownComponent oldWidget) {
        super.didUpdateWidget(oldWidget);
//        if (widget.data != oldWidget.data
//            || widget.styleSheet != oldWidget.styleSheet)
//            _parseMarkdown();
    }

    @override
    void dispose() {
        _disposeRecognizers();
        super.dispose();
    }

    void _parseMarkdown() {
        final MarkdownStyleSheet styleSheet = widget.styleSheet ?? new MarkdownStyleSheet.fromTheme(Theme.of(context));

        _disposeRecognizers();

        // TODO: This can be optimized by doing the split and removing \r at the same time
        final List<String> lines = widget.data.replaceAll('\r\n', '\n').split('\n');
        final md.Document document = new md.Document(encodeHtml: false);
        final MarkdownComponentBuilder builder = new MarkdownComponentBuilder(
            delegate: this,
            styleSheet: styleSheet,
            imageDirectory: widget.imageDirectory,
        );
        _children = builder.build(document.parseLines(lines));
    }

    void _disposeRecognizers() {
        if (_recognizers.isEmpty)
            return;
        final List<GestureRecognizer> localRecognizers = new List<GestureRecognizer>.from(_recognizers);
        _recognizers.clear();
        for (GestureRecognizer recognizer in localRecognizers)
            recognizer.dispose();
    }

    @override
    GestureRecognizer createLink(String href) {
        final TapGestureRecognizer recognizer = new TapGestureRecognizer()
            ..onTap = () {
                if (widget.onTapLink != null)
                    widget.onTapLink(href);
            };
        _recognizers.add(recognizer);
        return recognizer;
    }

    @override
    GestureRecognizer createImage(String src, {String title, String alt}) {
        final TapGestureRecognizer recognizer = new TapGestureRecognizer()
            ..onTap = () {
                if (widget.onTapImage != null)
                    widget.onTapImage(src, title, alt);
            };
        _recognizers.add(recognizer);
        return recognizer;
    }

    @override
    TextSpan formatText(MarkdownStyleSheet styleSheet, String code) {
        if (widget.syntaxHighlighter != null)
            return widget.syntaxHighlighter.format(code);
        return new TextSpan(style: styleSheet.code, text: code);
    }

    @override
    Widget build(BuildContext context) => widget.build(context, _children);
}