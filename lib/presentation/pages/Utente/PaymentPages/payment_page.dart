import 'package:auto_route/auto_route.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:my_ticket/core/resources/constants/constants.dart';
import 'package:my_ticket/domain/use_cases/common_usecases.dart';

import '../../../../domain/entities/block.dart';
import '../../../../domain/entities/event.dart';
import '../../../../domain/entities/location.dart';
import '../../../../domain/entities/user.dart';
part 'cardPayment_widget.dart';
part 'paypalPayment_widget.dart';
part 'walletPayment_widget.dart';


class ListFieldFormBloc extends FormBloc<String, String> {
  List<String> lista = [];

  final email = ListFieldBloc<MemberFieldBloc, dynamic>(name: 'members');

  ListFieldFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        email,
      ],
    );
  }

  void addEmail() {
    email.addFieldBloc(MemberFieldBloc(
      name: 'email',
      email: TextFieldBloc(name: 'email', validators: [FieldBlocValidators.required]),
    ));
  }

  void removeEmail(int index) {
    email.removeFieldBlocAt(index);
  }

  @override
  void onSubmitting() async {

    lista = email.value.map<String>((memberField) {
      return memberField.email.value;
    }).toList();

    emitSuccess();
  }
}

class MemberFieldBloc extends GroupFieldBloc {
  final TextFieldBloc email;

  MemberFieldBloc({
    required this.email,
    String? name,
  }) : super(name: name, fieldBlocs: [email]);
}



@RoutePage()
class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.location, required this.block, required this.seats, required this.event});

  final Location location;
  final Block block;
  final List<String> seats;
  final Event event;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late int _Index;
  List<String> seat = [];
  List<String> user =[]; //utenti selezionati dall' utente (ID)

  late Location location;
  late Block block;
  late Event event;


  Widget _onTapPage(int index){
    switch (index) {
      case 0 : {
        return cardPayment(event, location, block, seat, user);
      }
      case 1 : {
        return paypalPayment(event, location, block, seat, user);
      }
      case 2 : {
        return walletPayment(event, location, block, seat, user);
      }
      default : {
        return Container(
          child: const Center(
            child: Text("Conferma le email"),
          ),
        );
      }
    }
  }


  void _onItemTapped(int index) {
    setState(() {
      _Index = index;
    });
  }

  @override
  void initState() {
    super.initState();
    seat = widget.seats;
    location = widget.location;
    event = widget.event;
    block = widget.block;

    if (seat.length > 1) {
      _Index = -1;
    } else {
      _Index = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        shadowColor: secondary,
        backgroundColor: background,
        foregroundColor: primary,
        title: const Text("Check-Out"),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primary,
                  border: Border.all(
                    color: secondary,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: _onTapPage(_Index)),
          ),
          Container(
            decoration: BoxDecoration(
              color: primary,
              border: Border.all(
                color: secondary,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: background, foregroundColor: selected),
                    onPressed: () {
                      _onItemTapped(0);
                    },
                    child: Text("Carta")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: background, foregroundColor: selected),
                    onPressed: () {
                      _onItemTapped(1);
                    },
                    child: Text("Paypal")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: background, foregroundColor: selected),
                    onPressed: () {
                      _onItemTapped(2);
                    },
                    child: Text("Saldo")),
              ],
            ),
          ),
          BlocProvider(
            create: (context) => ListFieldFormBloc(),
            child: Builder(
              builder: (context) {
                final formBloc = context.read<ListFieldFormBloc>();
                final common = context.read<CommonInteractor>();

                for(int i =0;i < seat.length-1; i++){
                  formBloc.addEmail();
                }

                return Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: FormBlocListener<ListFieldFormBloc, String, String>(
                      onSubmitting: (context, state) {
                        LoadingDialog.show(context);
                      },

                      onSuccess: (context, state) async {
                        for (var element in formBloc.lista) {
                          await common.searchUserByEmail(element).then((value) {
                            Fimber.e(value.first.uid);
                            user.add(value.first.uid);
                          });
                        }

                        LoadingDialog.hide(context);

                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: SingleChildScrollView(
                              child: Text("User verificati")),
                          duration: Duration(milliseconds: 1500),
                        ));
                      },
                      onFailure: (context, state) {
                        LoadingDialog.hide(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.failureResponse!)));
                      },
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children: <Widget>[
                            BlocBuilder<ListFieldBloc<MemberFieldBloc, dynamic>,
                                ListFieldBlocState<MemberFieldBloc, dynamic>>(
                              bloc: formBloc.email,
                              builder: (context, state) {
                                if (state.fieldBlocs.isNotEmpty) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: seat.length-1,
                                    itemBuilder: (context, i) {
                                      return EmailCard(
                                        memberIndex: i,
                                        memberField: state.fieldBlocs[i],
                                        onRemoveMember: () =>
                                            formBloc.removeEmail(i),
                                      );
                                    },
                                  );
                                }
                                return Container();
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: background, foregroundColor: selected),
                                onPressed: () {
                                  formBloc.submit();

                                  _onItemTapped(0);
                                },
                                  child: const Text('Conferma'),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}




class EmailCard extends StatelessWidget {
  final int memberIndex;
  final MemberFieldBloc memberField;

  final VoidCallback onRemoveMember;

  const EmailCard({
    Key? key,
    required this.memberIndex,
    required this.memberField,
    required this.onRemoveMember,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'User #${memberIndex + 1}',
                    style: const TextStyle(fontSize: 20, color: background),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onRemoveMember,
                ),
              ],
            ),
            TextFieldBlocBuilder(
              textFieldBloc: memberField.email,
              decoration: const InputDecoration(
                labelText: 'First Name',
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (_) => LoadingDialog(key: key),
  ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(12.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}


Future<void> TapBuy(CommonInteractor common, Event event, Location location, Block block, List<String> seat, List<String> user) async {
  var plusCost = 0.0;

  Fimber.e(" ${event.name} - ${location.name} - ${block.nBlock} - ${seat.length} - ${user.length}");

  if (event.blockCost.containsKey(
      block.id!)) {
    plusCost = event.blockCost[
    block.id] ?? 0.0;
  }

  if (user.isEmpty &&
      (seat.length == 1)) {
    common.buyTicket(
        event,
        seat.first,
        block.id!,
        location.id!,
        event.baseCost + plusCost,
        null);
    Fimber.e("Compro il biglietto per me");
  } else {
    common.buyTicket(
        event,
        seat.first,
        block.id!,
        location.id!,
        event.baseCost + plusCost,
        null);
    Fimber.e("Compro il biglietto per me");

    for (int i=1; i<=seat.length-1; i++) {
      common.buyTicket(
        event,
        seat[i],
        block.id!,
        location.id!,
        event.baseCost + plusCost,
        user[i-1],
      );
    }
    Fimber.e("E per gli altri");

  }
}