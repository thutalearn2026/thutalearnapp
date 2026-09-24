import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thuta_learn/core/core.dart';

void main() {
  testWidgets('phone layout keeps the full available width', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: TtResponsiveAppFrame(
          child: _ResponsiveProbe(),
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(const ValueKey('content'))).width,
      390,
    );
    expect(find.text('2 columns'), findsOneWidget);
  });

  testWidgets('tablet portrait scales UI and stays full-screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1024, 1366);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: TtResponsiveAppFrame(
          child: _ResponsiveProbe(),
        ),
      ),
    );

    expect(
      tester.getSize(
        find.byKey(
          const ValueKey('tablet-responsive-frame'),
        ),
      ),
      const Size(1024, 1366),
    );
    expect(
      _paintedSize(
        tester,
        find.byKey(const ValueKey('content')),
      ).width,
      closeTo(1024, 0.01),
    );
    expect(find.text('3 columns'), findsOneWidget);
  });

  testWidgets('tablet landscape scales UI and stays full-screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1366, 1024);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: TtResponsiveAppFrame(
          child: _ResponsiveProbe(),
        ),
      ),
    );

    expect(
      tester.getSize(
        find.byKey(
          const ValueKey('tablet-responsive-frame'),
        ),
      ),
      const Size(1366, 1024),
    );
    expect(
      _paintedSize(
        tester,
        find.byKey(const ValueKey('content')),
      ).width,
      closeTo(1366, 0.01),
    );
    expect(find.text('4 columns'), findsOneWidget);
  });
}

Size _paintedSize(
  WidgetTester tester,
  Finder finder,
) {
  final renderBox = tester.renderObject<RenderBox>(finder);
  final topLeft = renderBox.localToGlobal(Offset.zero);
  final bottomRight = renderBox.localToGlobal(
    renderBox.size.bottomRight(Offset.zero),
  );

  return Size(
    bottomRight.dx - topLeft.dx,
    bottomRight.dy - topLeft.dy,
  );
}

class _ResponsiveProbe extends StatelessWidget {
  const _ResponsiveProbe();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: const ValueKey('content'),
      color: Colors.white,
      child: Center(
        child: Text(
          '${context.adaptiveGridColumnCount()} columns',
        ),
      ),
    );
  }
}
