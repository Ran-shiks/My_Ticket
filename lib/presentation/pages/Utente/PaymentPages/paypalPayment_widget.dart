part of 'payment_page.dart';

Widget paypalPayment(Event event, Location location, Block block, List<String> seat, List<String> user) {
  return Builder(builder: (context) {
    var common = context.read<CommonInteractor>();
    return Center(
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          ),
          onPressed: () async {
            TapBuy(common, event, location, block, seat, user);
            context.router.pop();
          },
          child: Text("Compra traminte paypal")),
    );
  });
}
