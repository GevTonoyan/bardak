import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:bardak/core/router/invite_links.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class _MockAppLinks extends Mock implements AppLinks {}

class _MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('initialLocationFor', () {
    test('an invite opens straight on its join screen', () {
      expect(
        initialLocationFor(Uri.parse('https://bardakgames.com/join/abc234')),
        '/home/seaBattleSettings/seaBattleJoin/ABC234',
      );
    });

    test('no link, or another link, opens as usual', () {
      expect(initialLocationFor(null), isNull);
      expect(initialLocationFor(Uri.parse('https://bardakgames.com/')), isNull);
      expect(
        initialLocationFor(Uri.parse('https://example.com/join/ABC234')),
        isNull,
      );
      expect(
        initialLocationFor(Uri.parse('https://bardakgames.com/blog/x/y')),
        isNull,
      );
    });
  });

  group('listenToInviteLinks', () {
    late _MockAppLinks appLinks;
    late _MockGoRouter router;
    late StreamController<Uri> links;

    final invite = Uri.parse('https://bardakgames.com/join/ABC234');
    final otherInvite = Uri.parse('https://bardakgames.com/join/XYZ789');

    setUp(() {
      appLinks = _MockAppLinks();
      router = _MockGoRouter();
      links = StreamController<Uri>();
      when(() => appLinks.uriLinkStream).thenAnswer((_) => links.stream);
    });

    tearDown(() => links.close());

    test('invites that arrive while the app runs are opened', () async {
      final subscription = listenToInviteLinks(router, appLinks: appLinks);
      addTearDown(subscription.cancel);

      links
        ..add(invite)
        ..add(Uri.parse('https://bardakgames.com/blog/'));
      await pumpEventQueue();

      verify(() => router.go('/join/ABC234')).called(1);
      verifyNoMoreInteractions(router);
    });

    test('the link the app was opened with is not opened twice', () async {
      final subscription = listenToInviteLinks(
        router,
        appLinks: appLinks,
        initialLink: invite,
      );
      addTearDown(subscription.cancel);

      links
        ..add(invite)
        ..add(otherInvite);
      await pumpEventQueue();

      verify(() => router.go('/join/XYZ789')).called(1);
      verifyNever(() => router.go('/join/ABC234'));
    });
  });
}
