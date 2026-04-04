// lib/src/pii_redactor.dart
//
// PiiRedactor — scrubs personally identifiable information from log messages.
//
// Replaces email addresses, phone numbers, and credit card patterns with
// [REDACTED] before messages are written to any transport.
// Enabled via Config.get('logging.redactPii').

/// Scrubs PII patterns from log message strings.
///
/// Applied to every log message before it reaches a transport when
/// `logging.redactPii` is `true` in the config.
abstract final class PiiRedactor {
  // ── Patterns ──────────────────────────────────────────────────────────────

  /// Matches email addresses.
  static final RegExp _email = RegExp(
    r'[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}',
  );

  /// Matches common phone number formats.
  static final RegExp _phone = RegExp(
    r'(\+?\d[\d\s\-().]{7,}\d)',
  );

  /// Matches 13–19 digit credit card numbers (with optional spaces/dashes).
  static final RegExp _creditCard = RegExp(
    r'\b(?:\d[ \-]?){13,19}\b',
  );

  /// Matches IPv4 addresses.
  static final RegExp _ipv4 = RegExp(
    r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b',
  );

  // ── Public API ────────────────────────────────────────────────────────────

  /// Redacts all known PII patterns from [message].
  ///
  /// Returns the sanitised string with PII replaced by `[REDACTED]`.
  static String redact(String message) {
    return message
        .replaceAll(_email,      '[REDACTED_EMAIL]')
        .replaceAll(_phone,      '[REDACTED_PHONE]')
        .replaceAll(_creditCard, '[REDACTED_CARD]')
        .replaceAll(_ipv4,       '[REDACTED_IP]');
  }
}
