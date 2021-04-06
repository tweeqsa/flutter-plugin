part of '../../pay_ios.dart';

enum ApplePayButtonType {
  plain,
  buy,
  setUp,
  inStore,
  donate,
  checkout,
  book,
  subscribe,
  reload,
  addMoney,
  topUp,
  order,
  rent,
  support,
  contribute,
  tip
}

enum ApplePayButtonStyle {
  white,
  whiteOutline,
  black,
  automatic,
}

extension ApplePayButtonTypeAsset on ApplePayButtonType {
  double get minimumAssetWidth => this == ApplePayButtonType.plain ? 100 : 140;
}

class RawApplePayButton extends StatelessWidget {
  static const double minimumButonWidth = 100;
  static const double minimumButtonHeight = 30;

  final BoxConstraints constraints;
  final VoidCallback? onPressed;
  final ApplePayButtonStyle style;
  final ApplePayButtonType type;

  RawApplePayButton({
    Key? key,
    this.onPressed,
    this.style = ApplePayButtonStyle.black,
    this.type = ApplePayButtonType.plain,
  })  : constraints = BoxConstraints.tightFor(
          width: type.minimumAssetWidth,
          height: minimumButtonHeight,
        ),
        super(key: key) {
    assert(constraints.debugAssertIsValid());
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints,
      child: _platformButton,
    );
  }

  Widget get _platformButton {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return _UiKitApplePayButton(
          onPressed: onPressed,
          style: style,
          type: type,
        );
      default:
        throw UnsupportedError(
            'This platform $defaultTargetPlatform does not support Apple Pay');
    }
  }

  static bool get supported => defaultTargetPlatform == TargetPlatform.iOS;
}

class _UiKitApplePayButton extends StatelessWidget {
  static const buttonId = 'plugins.flutter.io/pay/apple_pay_button';
  late final MethodChannel? methodChannel;

  final VoidCallback? onPressed;
  final ApplePayButtonStyle style;
  final ApplePayButtonType type;

  _UiKitApplePayButton({
    Key? key,
    this.onPressed,
    this.style = ApplePayButtonStyle.black,
    this.type = ApplePayButtonType.plain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UiKitView(
      viewType: buttonId,
      creationParamsCodec: const StandardMessageCodec(),
      creationParams: {'style': style.enumString, 'type': type.enumString},
      onPlatformViewCreated: (viewId) {
        methodChannel = MethodChannel('$buttonId/$viewId');
        methodChannel?.setMethodCallHandler((call) async {
          if (call.method == 'onPressed') onPressed?.call();
          return;
        });
      },
    );
  }
}

extension on ApplePayButtonType {
  static const _defaultType = 'plain';
  String get enumString =>
      {
        ApplePayButtonType.plain: _defaultType,
        ApplePayButtonType.buy: 'buy',
        ApplePayButtonType.setUp: 'setUp',
        ApplePayButtonType.inStore: 'inStore',
        ApplePayButtonType.donate: 'donate',
        ApplePayButtonType.checkout: 'checkout',
        ApplePayButtonType.book: 'book',
        ApplePayButtonType.subscribe: 'subscribe',
        ApplePayButtonType.reload: 'reload',
        ApplePayButtonType.addMoney: 'addMoney',
        ApplePayButtonType.topUp: 'topUp',
        ApplePayButtonType.order: 'order',
        ApplePayButtonType.rent: 'rent',
        ApplePayButtonType.support: 'support',
        ApplePayButtonType.contribute: 'contribute',
        ApplePayButtonType.tip: 'tip',
      }[this] ??
      _defaultType;
}

extension on ApplePayButtonStyle {
  static const _defaultStyle = 'black';
  String get enumString =>
      {
        ApplePayButtonStyle.white: 'white',
        ApplePayButtonStyle.whiteOutline: 'whiteOutline',
        ApplePayButtonStyle.black: _defaultStyle,
        ApplePayButtonStyle.automatic: 'automatic',
      }[this] ??
      _defaultStyle;
}