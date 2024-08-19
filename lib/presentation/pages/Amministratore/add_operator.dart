part of 'home_amministratore.dart';

class AddOperator extends StatefulWidget {
  const AddOperator({super.key});

  @override
  State<AddOperator> createState() => _AddOperatorState();
}

class _AddOperatorState extends State<AddOperator> {

  @override
  Widget build(BuildContext context) {
    var admin = context.read<AdminInteractor>();

    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          color: primary,
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: const Center(child: Text("Tutti gli utenti")),
        ),
        Container(
          color: secondary,
          height: 400,
          width: MediaQuery.of(context).size.width,
          child: StreamUserList(admin),
        ),
      ],
    );
  }






}
