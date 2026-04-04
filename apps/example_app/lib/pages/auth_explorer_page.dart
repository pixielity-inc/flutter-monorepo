// ignore_for_file: lines_longer_than_80_chars
//
// auth_explorer_page.dart
//
// Displays the full auth configuration loaded from config/auth.dart.
// Shows strategy, token storage, session settings, biometrics, and
// the OAuth2 sub-section. All values come from Config.get('auth.*').

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:config/pixielity_config.dart';
import 'package:pixielity_example_app/pages/shared/explorer_scaffold.dart';

/// Auth Explorer — displays the full authentication configuration.
///
/// Shows:
///   - Authentication strategy (JWT / OAuth2 / API key / none)
///   - Token storage location and security level
///   - Session and inactivity timeout values
///   - Biometric and PIN fallback settings
///   - OAuth2 / OIDC sub-configuration
///   - Visual security level indicator
class AuthExplorerPage extends StatelessWidget {
  /// Creates the [AuthExplorerPage].
  const AuthExplorerPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Read all auth config values from the registry.
    final strategy          = Config.get<String>('auth.strategy',              fallback: 'jwt');
    final tokenStorage      = Config.get<String>('auth.tokenStorage',          fallback: 'memory');
    final refreshThreshold  = Config.get<int>('auth.refreshThresholdSeconds',  fallback: 300);
    final maxRetries        = Config.get<int>('auth.maxRefreshRetries',        fallback: 3);
    final sessionTimeout    = Config.get<int>('auth.sessionTimeoutSeconds',    fallback: 86400);
    final inactivityTimeout = Config.get<int>('auth.inactivityTimeoutSeconds', fallback: 1800);
    final enableBiometrics  = Config.get<bool>('auth.enableBiometrics',        fallback: false);
    final requirePin        = Config.get<bool>('auth.requirePinFallback',      fallback: false);
    final apiKeyHeader      = Config.get<String>('auth.apiKeyHeaderName',      fallback: 'X-API-Key');

    // OAuth2 sub-section values.
    final oauth2ClientId    = Config.get<String>('auth.oauth2.clientId',              fallback: '');
    final oauth2RedirectUri = Config.get<String>('auth.oauth2.redirectUri',           fallback: '');
    final oauth2AuthEndpoint = Config.get<String>('auth.oauth2.authorizationEndpoint', fallback: '');
    final oauth2Scopes      = Config.get<String>('auth.oauth2.scopes',               fallback: 'openid,profile,email');
    final oauth2UsePkce     = Config.get<bool>('auth.oauth2.usePkce',                fallback: true);

    // Derive security level from config values.
    final securityLevel = _securityLevel(tokenStorage, enableBiometrics, requirePin);

    return ExplorerScaffold(
      title: 'Auth',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // ── Security level indicator ──────────────────────────────────────
          _SecurityLevelCard(level: securityLevel, strategy: strategy),
          const SizedBox(height: 16),

          // ── Strategy ──────────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.shieldCheck,
            title: 'Authentication Strategy',
            children: [
              InfoRow(label: 'auth.strategy',    value: strategy),
              InfoRow(label: 'auth.tokenStorage', value: tokenStorage),
              InfoRow(label: 'auth.apiKeyHeaderName', value: apiKeyHeader),
              const SizedBox(height: 8),
              // Strategy description
              _StrategyDescription(strategy: strategy),
            ],
          ),
          const SizedBox(height: 16),

          // ── Token refresh ─────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.refreshCw,
            title: 'Token Refresh',
            children: [
              InfoRow(
                label: 'auth.refreshThresholdSeconds',
                value: '$refreshThreshold s (${refreshThreshold ~/ 60} min)',
              ),
              InfoRow(
                label: 'auth.maxRefreshRetries',
                value: '$maxRetries attempts',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Session ───────────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.clock,
            title: 'Session',
            children: [
              InfoRow(
                label: 'auth.sessionTimeoutSeconds',
                value: '$sessionTimeout s (${sessionTimeout ~/ 3600} h)',
              ),
              InfoRow(
                label: 'auth.inactivityTimeoutSeconds',
                value: inactivityTimeout == 0
                    ? 'disabled'
                    : '$inactivityTimeout s (${inactivityTimeout ~/ 60} min)',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Biometrics ────────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.scan,
            title: 'Biometrics & PIN',
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusIndicator(label: 'Biometric auth', enabled: enableBiometrics),
                    StatusIndicator(label: 'PIN fallback',   enabled: requirePin),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              InfoRow(label: 'auth.enableBiometrics',  value: enableBiometrics.toString()),
              InfoRow(label: 'auth.requirePinFallback', value: requirePin.toString()),
            ],
          ),
          const SizedBox(height: 16),

          // ── OAuth2 ────────────────────────────────────────────────────────
          SectionCard(
            icon: LucideIcons.keyRound,
            title: 'OAuth2 / OIDC',
            children: [
              InfoRow(
                label: 'auth.oauth2.clientId',
                value: oauth2ClientId.isEmpty ? '(not configured)' : oauth2ClientId,
              ),
              InfoRow(
                label: 'auth.oauth2.redirectUri',
                value: oauth2RedirectUri.isEmpty ? '(not configured)' : oauth2RedirectUri,
              ),
              InfoRow(
                label: 'auth.oauth2.authorizationEndpoint',
                value: oauth2AuthEndpoint.isEmpty ? '(not configured)' : oauth2AuthEndpoint,
              ),
              InfoRow(label: 'auth.oauth2.scopes',  value: oauth2Scopes),
              InfoRow(label: 'auth.oauth2.usePkce', value: oauth2UsePkce.toString()),
            ],
          ),
        ],
      ),
    );
  }

  /// Derives a 1–3 security level from the current config.
  int _securityLevel(String storage, bool biometrics, bool pin) {
    var level = 1;
    if (storage == 'secureStorage') level++;
    if (biometrics || pin) level++;
    return level;
  }
}

// ── Security level card ───────────────────────────────────────────────────────

class _SecurityLevelCard extends StatelessWidget {
  const _SecurityLevelCard({required this.level, required this.strategy});

  final int level;
  final String strategy;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    final (color, label, description) = switch (level) {
      3 => (const Color(0xFF22C55E), 'High Security',   'Secure storage + biometrics/PIN enabled.'),
      2 => (const Color(0xFFF59E0B), 'Medium Security', 'Secure storage enabled. Consider adding biometrics.'),
      _ => (const Color(0xFFEF4444), 'Low Security',    'Using in-memory storage. Suitable for development only.'),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(LucideIcons.shieldCheck, color: color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.typography.md.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    description,
                    style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Strategy: $strategy',
                    style: theme.typography.xs.copyWith(
                      color: theme.colors.foreground,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Strategy description ──────────────────────────────────────────────────────

class _StrategyDescription extends StatelessWidget {
  const _StrategyDescription({required this.strategy});

  final String strategy;

  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);
    final description = switch (strategy) {
      'jwt'           => 'Access + refresh token pair. Tokens are stored in the configured storage and refreshed automatically before expiry.',
      'oauth2'        => 'Authorization code flow with PKCE. Redirects to the identity provider for authentication.',
      'apiKey'        => 'Static API key sent in a request header on every request. No token refresh required.',
      'sessionCookie' => 'Server-managed session cookie. The server controls session lifetime.',
      'none'          => 'No authentication. All API requests are made without credentials.',
      _               => 'Unknown strategy.',
    };

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        description,
        style: theme.typography.xs.copyWith(color: theme.colors.mutedForeground),
      ),
    );
  }
}
