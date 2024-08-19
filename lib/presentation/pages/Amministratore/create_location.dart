part of 'home_amministratore.dart';

class ListFieldFormBloc extends FormBloc<String, String> {
  late Location location;
  List<Block> blocks = [];

  final nameLocation = TextFieldBloc(validators: [
    FieldBlocValidators.required,
  ]);
  final addressLocation = TextFieldBloc(validators: [
    FieldBlocValidators.required,
  ]);
  final blocksLocation = ListFieldBloc<BlockFieldBloc, dynamic>(name: 'block');

  ListFieldFormBloc() {
    addFieldBlocs(
      fieldBlocs: [nameLocation, addressLocation, blocksLocation],
    );
  }

  void addBlock() {
    blocksLocation.addFieldBloc(BlockFieldBloc(
      name: 'Block',
      totalSeats: TextFieldBloc(),
      numberOfColumns: TextFieldBloc(),
    ));
  }

  void removeBlock(int index) {
    blocksLocation.removeFieldBlocAt(index);
  }

  @override
  void onSubmitting() async {
    var name = nameLocation.value;
    var address = addressLocation.value;
    location = Location(name: name, address: address);

    var nBlock = 0;
    var blocksBloc = blocksLocation.value;

    for (var element in blocksBloc) {
      Block blockEntity = Block(
          nBlock: nBlock,
          totalSeats: element.totalSeats.valueToInt!,
          numberOfColumns: element.numberOfColumns.valueToInt!);
      blocks.add(blockEntity);
      nBlock++;
    }

    emitSuccess();
  }
}

class BlockFieldBloc extends GroupFieldBloc {
  final TextFieldBloc totalSeats;
  final TextFieldBloc numberOfColumns;

  BlockFieldBloc({
    required this.totalSeats,
    required this.numberOfColumns,
    String? name,
  }) : super(name: name, fieldBlocs: [totalSeats, numberOfColumns]);
}

class CreateLocation extends StatelessWidget {
  const CreateLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListFieldFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<ListFieldFormBloc>();
          final admin = context.read<AdminInteractor>();

          return Scaffold(
              backgroundColor: background,
              resizeToAvoidBottomInset: false,

              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  formBloc.submit();
                  if (formBloc.blocks.isNotEmpty) {
                    admin.createLocation(formBloc.location, formBloc.blocks);
                    formBloc.clear();
                  }
                },
                child: const Icon(Icons.send),
              ),
              body: FormBlocListener<ListFieldFormBloc, String, String>(
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);
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
                      Container(
                        decoration: BoxDecoration(
                            color: secondary,
                            border: Border.all(
                              color: secondary,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFieldBlocBuilder(
                            textFieldBloc: formBloc.nameLocation,
                            decoration: const InputDecoration(
                              focusColor: primary,
                              prefixIconColor: primary,
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.house),
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 4),
                      Container(
                        decoration: BoxDecoration(
                            color: secondary,
                            border: Border.all(
                              color: secondary,
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFieldBlocBuilder(
                            textFieldBloc: formBloc.addressLocation,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              prefixIcon: Icon(Icons.place),
                            ),
                          ),
                        ),
                      ),
                      BlocBuilder<ListFieldBloc<BlockFieldBloc, dynamic>,
                          ListFieldBlocState<BlockFieldBloc, dynamic>>(
                        bloc: formBloc.blocksLocation,
                        builder: (context, state) {
                          if (state.fieldBlocs.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.fieldBlocs.length,
                              itemBuilder: (context, i) {
                                return MemberCard(
                                  memberIndex: i,
                                  memberField: state.fieldBlocs[i],
                                  onRemoveMember: () => formBloc.removeBlock(i),
                                );
                              },
                            );
                          }
                          return Container();
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: primary),
                        onPressed: () {
                          formBloc.addBlock();
                        },
                        child: const Text('add block'),
                      ),
                    ],
                  ),
                ),
              ),
          );
        },
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final int memberIndex;
  final BlockFieldBloc memberField;

  final VoidCallback onRemoveMember;

  const MemberCard({
    Key? key,
    required this.memberIndex,
    required this.memberField,
    required this.onRemoveMember,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: secondary,
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
                    'Block #${memberIndex + 1}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onRemoveMember,
                ),
              ],
            ),
            TextFieldBlocBuilder(
              textFieldBloc: memberField.totalSeats,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Numero totale di posti',
              ),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: memberField.numberOfColumns,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Numero di Colonne',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
