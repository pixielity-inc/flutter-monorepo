// ignore_for_file: lines_longer_than_80_chars
//
// api_explorer_page.dart
//
// Displays the full API configuration and lets the user fire a test HTTP
// request to the configured base URL. Shows timeout, retry policy,
// certificate pinning, proxy settings, and default headers.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pixielity_config/pixielity_config.dart';
import 'package:pixielity_example_app/pages/shared/explorer_scaffold.dart';

/// The result of a test HTTP request.
class _RequestResult {
  const _RequestResult({
    required this.statusCode,
    required this.durationMs,
    required this.error,
  });

  final int? statusCode;
  final int durationMs;
  final String? error;

  bool get isSuccess => statusCode != null && statusCode! < 400;
}

/// API Explorer — displays the full HTTP client configuration.
///
/// Shows:
///   - Base URL and versioned URL
///   - Connect / receive / send timeouts
///   - Retry policy (max attempts, backoff, status codes)
///   - Security settings (logging, certificate pinning)
///   - Proxy configuration
///   - Default request headers
///   - Live test request with timing and status display
class ApiExplorerPage extends StatefulWidget {
  /// Creates the [ApiExplorerPage].
  const ApiExplorerPage({super.key});

  @override
  State<ApiExplorerPage> createState() => _ApiExplorerPageState();
}

class _ApiExplorerPageState extends State<ApiExplorerPage> {
  // ── State ──────────────────────────────────────────────────────────────────

  /// Whether a test request is currently in-flight.
  bool _loading = false;

  /// The result of the most recent test request.
  _RequestResult? _result;

  // ── Test request ───────────────────────────────────────────────────────────

  /// Fires a test GET request to the configured base URL.
  ///
  /// Uses [HttpClient] from dart:io to avoid adding an http package dep.
  /// Records the round-trip duration and HTTP status code.
  Future<void> _fireTestRequest() async {
    final baseUrl = Config.get<String>('api.baseUrl', fallback: 'http://localhost:8080');
    final connectTimeout = Config.get<int>('api.connectTimeoutSeconds', fallback: 10);

    setState(() {
      _loading = true;
      _result  = null;
    });

    final stopwatch = Stopwatch()..start();

    try {
      final client = HttpClient()
        ..connectionTimeout = Duration(seconds: connectTimeout);

      final request  = await client.getUrl(Uri.parse(baseUrl));
      final response = await request.close().timeout(
        Duration(seconds: connectTimeout),
      );
      stopwatch.stop();
      client.close();

      setState(() {
        _loading = false;
        _result  = _RequestResult(
          statusCode: response.statusCode,
          durationMs: stopwatch.elapsedMilliseconds,
          error: null,
        );
      });
    } on TimeoutException {
      stopwatch.stop();
      setState(() {
        _loading = false;
        _result  = _RequestResult(
          statusCode: null,
          durationMs: stopwatch.elapsedMilliseconds,
          error: 'Request timed out after ${connectTimeout}s',
        );
      });
    } catch (e) {
      stopwatch.stop();
      setState(() {
        _loading = false;
        _result  = _RequestResult(
          statusCode: null,
          durationMs: stopwatch.elapsedMilliseconds,
          error: e.toString(),
        );
      });
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Read all API config values from the registry.
    final baseUrl           = Config.get<String>('api.baseUrl',              fallback: 'http://localhost:8080');
    final version           = Config.get<String>('api.version',              fallback: 'v1');
    final versionedUrl      = Config.get<String>('api.versionedBaseUrl',     fallback: '$baseUrl/$version');
    final connectTimeout    = Config.get<int>('api.connectTimeoutSeconds',   fallback: 10);
    final receiveTimeout    = Config.get<int>('api.receiveTimeoutSeconds',   fallback: 30);
    final sendTimeout       = Config.get<int>('api.sendTimeoutSeconds',      fallback: 30);
    final maxRetries        = Config.get<int>('api.maxRetries',              fallback: 3);
    final retryBackoff      = Config.get<String>('api.retryBackoff',         fallback: 'exponential');
    final retryInitialDelay = Config.get<int>('api.retryInitialDelayMs',     fallback: 500);
    final retryStatusCodes  = Config.get<String>('api.retryOnStatusCodes',   fallback: '408,429,500,502,503,504');
    final enableLogging     = Config.get<bool>('api.enableLogging',          fallback: true);
    final enablePinning     = Config.get<bool>('api.enableCertificatePinning', fallback: false);
    final maxConcurrent     = Config.get<int>('api.maxConcurrentRequests',   fallback: 10);
    final proxyHost         = Config.get<String>('api.proxyHost',            fallback: '');
    final proxyPort         = Config.get<int>('api.proxyPort',               fallback: 0);

    return ExplorerScaffold(
      title: 'API Client',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // ── Endpoint ──────────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.globe,
            title: 'Endpoint',
            children: [
              InfoRow(label: 'api.baseUrl',         value: baseUrl,       monospace: true),
              InfoRow(label: 'api.version',         value: version,       monospace: true),
              InfoRow(label: 'api.versionedBaseUrl', value: versionedUrl, monospace: true),
            ],
          ),
          const SizedBox(height: 16),

          // ── Timeouts ──────────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.timer,
            title: 'Timeouts',
            children: [
              InfoRow(label: 'api.connectTimeoutSeconds', value: '${connectTimeout}s'),
              InfoRow(label: 'api.receiveTimeoutSeconds', value: '${receiveTimeout}s'),
              InfoRow(label: 'api.sendTimeoutSeconds',    value: '${sendTimeout}s'),
              const SizedBox(height: 8),
              // Visual timeout bar
              _TimeoutBar(label: 'connect', seconds: connectTimeout, maxSeconds: 60),
              _TimeoutBar(label: 'receive', seconds: receiveTimeout, maxSeconds: 60),
              _TimeoutBar(label: 'send',    seconds: sendTimeout,    maxSeconds: 60),
            ],
          ),
          const SizedBox(height: 16),

          // ── Retry policy ──────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.refreshCw,
            title: 'Retry Policy',
            children: [
              InfoRow(label: 'api.maxRetries',          value: '$maxRetries attempts'),
              InfoRow(label: 'api.retryBackoff',        value: retryBackoff),
              InfoRow(label: 'api.retryInitialDelayMs', value: '${retryInitialDelay}ms'),
              InfoRow(label: 'api.retryOnStatusCodes',  value: retryStatusCodes, monospace: true),
            ],
          ),
          const SizedBox(height: 16),

          // ── Security ──────────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.lock,
            title: 'Security',
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusIndicator(label: 'Request logging',    enabled: enableLogging),
                    StatusIndicator(label: 'Certificate pinning', enabled: enablePinning),
                  ],
                ),
              ),
              InfoRow(label: 'api.maxConcurrentRequests', value: '$maxConcurrent'),
              if (proxyHost.isNotEmpty)
                InfoRow(label: 'api.proxy', value: '$proxyHost:$proxyPort', monospace: true)
              else
                const InfoRow(label: 'api.proxy', value: 'disabled'),
            ],
          ),
          const SizedBox(height: 16),

          // ── Default headers ───────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.fileCode,
            title: 'Default Headers',
            children: [
              const InfoRow(label: 'Accept',        value: 'application/json', monospace: true),
              const InfoRow(label: 'Content-Type',  value: 'application/json', monospace: true),
              InfoRow(
                label: 'X-App-Version',
                value: Config.get<String>('app.version', fallback: '1.0.0'),
                monospace: true,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Test request ──────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.send,
            title: 'Test Request',
            children: [
              Text(
                'Fires a GET request to the configured base URL and measures the round-trip time.',
                style: FTheme.of(context).typography.xs.copyWith(
                  color: FTheme.of(context).colors.mutedForeground,
                ),
              ),
              const SizedBox(height: 12),
              FButton(
                onPress: _loading ? null : _fireTestRequest,
                prefix: _loading
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(LucideIcons.send),
                child: Text(_loading ? 'Sending...' : 'Send GET $baseUrl'),
              ),
              if (_result != null) ...[
                const SizedBox(height: 12),
                _RequestResultCard(result: _result!),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ── Timeout bar ───────────────────────────────────────────────────────────────

class _TimeoutBar extends StatelessWidget {
  const _TimeoutBar({required this.label, required this.seconds, required this.maxSeconds});

  final String label;
  final int seconds;
  final int maxSeconds;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    final fraction = (seconds / maxSeconds).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(label, style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: fraction,
                backgroundColor: theme.colors.muted,
                valueColor: AlwaysStoppedAnimation<Color>(theme.colors.primary),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('${seconds}s', style: theme.typography.xs.copyWith(color: theme.colors.foreground)),
        ],
      ),
    );
  }
}

// ── Request result card ───────────────────────────────────────────────────────

class _RequestResultCard extends StatelessWidget {
  const _RequestResultCard({required this.result});

  final _RequestResult result;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    final isSuccess = result.isSuccess;
    final color = result.error != null
        ? const Color(0xFFEF4444)
        : isSuccess
        ? const Color(0xFF22C55E)
        : const Color(0xFFF59E0B);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  result.error != null ? LucideIcons.circleX : LucideIcons.circleCheck,
                  color: color,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  result.error != null
                      ? 'Request failed'
                      : 'HTTP ${result.statusCode}',
                  style: theme.typography.sm.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${result.durationMs}ms',
                  style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
                ),
              ],
            ),
            if (result.error != null) ...[
              const SizedBox(height: 4),
              Text(
                result.error!,
                style: theme.typography.xs.copyWith(
                  color: theme.colors.mutedForeground,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
