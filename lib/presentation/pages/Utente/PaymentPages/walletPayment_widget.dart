part of 'payment_page.dart';


Widget walletPayment(Event event, Location location, Block block, List<String> seat, List<String> user) {
  return Builder(builder: (context) {
    var common = context.read<CommonInteractor>();
    return StreamBuilder<User?>(
        stream: common.streamUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Errore nel caricamento dei dati'));
          } else {
            var futureuser = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Center(child: Row(
                    children: [
                      const Text('Saldo attuale :    ',
                      style: TextStyle(
                        fontSize: 25,
                      ),),
                      Text('€ ${futureuser.balance}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 25,
                        ),),
                    ],
                  )),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: () async {
                      TapBuyWallet (common,event,location,block, seat, user,futureuser.balance);
                      context.router.pop();
                    },
                    child: Text("Compra",)),
              ],
            );
          }
        });
  });
}

void TapBuyWallet (CommonInteractor common, Event event, Location location, Block block, List<String> seat, List<String> user , double balanceuser) {

  var totalCost = 0.0;
  var plusCost = 0.0;

  if (event.blockCost.containsKey(
      "${block.id}")) {
    plusCost = event.blockCost[
    "${block.id}"] ?? 0.0;
  }

  totalCost = (event.baseCost +
      plusCost) *
      (seat.length);

  if (balanceuser < totalCost) {
    Builder(
      builder: (context) {
        return AlertDialog(
          title: Text("Errore"),
          content: Text("Saldo non sufficiente"),
          actions: [
            TextButton(
                onPressed: () {
                  context.router.pop();
                },
                child: Text("OK")),
          ],
        );
      }
    );
  } else if (user.isEmpty &&
      (seat.length == 1)) {
    common.buyTicketWithBalance(
        event,
        seat.first,
        block.id!,
        location.id!,
        event.baseCost +
            plusCost,
        null);
  } else {
    common.buyTicketWithBalance(
        event,
        seat.first,
        block.id!,
        location.id!,
        event.baseCost +
            plusCost,
        null);

    for (int i = 1;
    i <= seat.length - 1;
    i++) {
      common.buyTicketWithBalance(
        event,
        seat[i],
        block.id!,
        location.id!,
        event.baseCost +
            plusCost,
        user[i - 1],
      );
    }
  }
}