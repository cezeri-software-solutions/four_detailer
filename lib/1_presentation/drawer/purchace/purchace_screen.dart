import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:four_detailer/core/core.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '/2_application/purchace/purchace_bloc.dart';
import '/2_application/purchace/purchace_event.dart';
import '/2_application/purchace/purchace_state.dart';
import '/injection.dart';

@RoutePage()
class PurchaceScreen extends StatefulWidget {
  const PurchaceScreen({super.key});

  @override
  State<PurchaceScreen> createState() => _PurchaceScreenState();
}

class _PurchaceScreenState extends State<PurchaceScreen> with AutomaticKeepAliveClientMixin {
  WebViewController? _controller;
  late final PurchaceBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<PurchaceBloc>();
    _initWebView();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<PurchaceBloc, PurchaceState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          drawer: context.breakpoint.isMobile ? const AppDrawer() : null,
          appBar: AppBar(
            title: const Text('CCF Autopflege'),
            actions: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  final canGoBack = await _controller?.canGoBack() ?? false;
                  if (canGoBack) {
                    await _controller?.goBack();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () async {
                  final canGoForward = await _controller?.canGoForward() ?? false;
                  if (canGoForward) {
                    await _controller?.goForward();
                  }
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                if (_controller != null) WebViewWidget(controller: _controller!) else const SizedBox(),
                if (state.isLoading) const Center(child: MyLoadingDialog()),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _initWebView() async {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              _bloc.add(const PurchaceEvent.loadingChanged(false));
            }
          },
          onPageStarted: (String url) {
            _bloc.add(const PurchaceEvent.loadingChanged(true));
          },
          onPageFinished: (String url) {
            _bloc.add(PurchaceEvent.urlChanged(url));
            _bloc.add(const PurchaceEvent.loadingChanged(false));
          },
          onWebResourceError: (error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      );

    await controller.loadRequest(Uri.parse(_bloc.state.currentUrl));

    if (mounted) {
      setState(() => _controller = controller);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
