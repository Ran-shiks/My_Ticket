part of 'home_amministratore.dart';

class EventFormBloc extends FormBloc<String, String> {
  Event? event;

  List<String> locStringId = [];
  List<String> operStringId = [];
  Map<String, double> blockCost = {};

  final nome = TextFieldBloc(validators: [FieldBlocValidators.required,],);
  final cost = TextFieldBloc(validators: [FieldBlocValidators.required,],);
  final credits = TextFieldBloc(validators: [FieldBlocValidators.required,],);
  final description = TextFieldBloc(validators: [],);
  final date = InputFieldBloc<DateTime?, Object>(name: 'Date', initialValue: DateTime.now(), toJson: (value) => value!.toUtc().toIso8601String(),);
  final members = ListFieldBloc<UserFieldBloc, dynamic>(name: 'Operator');
  final locations = ListFieldBloc<LocationFieldBloc, dynamic>(name: 'Location');

  EventFormBloc() {addFieldBlocs(fieldBlocs: [nome, cost, credits, description, date, members, locations],);}

  void addMember() {
    members.addFieldBloc(UserFieldBloc(
      name: 'Operator',
      user: SelectFieldBloc<User, dynamic>(
        items: [],
      ),
    ));
  }
  void addLocation() {
    locations.addFieldBloc(LocationFieldBloc(
      name: 'Location',
      locations: SelectFieldBloc<Location, dynamic>(
        items: [],
      ),
      cost: ListFieldBloc(name: 'costPerBlock'),
    ));
  }
  void addCostToBlock(int memberIndex) {
    locations.value[memberIndex].cost.addFieldBloc(TextFieldBloc());
  }
  void removecostfromblock({required int memberIndex, required int hobbyIndex}) {
    locations.value[memberIndex].cost.removeFieldBlocAt(hobbyIndex);
  }
  void removeMember(int index) {
    members.removeFieldBlocAt(index);
  }
  void removeLocation(int index) {
    locations.removeFieldBlocAt(index);
  }

  @override
  FutureOr<void> onSubmitting() {
    try {
      locStringId = locations.value.map((e) => e.locations.value!.id!).toList();
      operStringId = members.value.map((e) => e.user.value!.uid).toList();

      for (var loc in locations.value) {
        var locId = loc.locations.value!.id!;
        var blockId = loc.locations.value!.blocks;
        var blockCos = loc.cost.value.map((e) {
          return e.valueToDouble!;
        }).toList();
        
        for (int i = 0; i<= blockId.length;i++ ) {
          blockCost.addAll({blockId[i] : blockCos[i]});
          Fimber.e("$locId - ${blockId[i]}");
        }
      }
      emitSuccess();
    } catch (e) {
      emitFailure();
    }
  }
}

class UserFieldBloc extends GroupFieldBloc {
  final SelectFieldBloc<User, dynamic> user;

  UserFieldBloc({
    required this.user,
    String? name,
  }) : super(name: name, fieldBlocs: [user]);
}

class LocationFieldBloc extends GroupFieldBloc {
  final SelectFieldBloc<Location, dynamic> locations;
  final ListFieldBloc<TextFieldBloc, dynamic> cost;

  LocationFieldBloc({
    required this.locations,
    required this.cost,
    String? name,
  }) : super(name: name, fieldBlocs: [locations, cost]);
}

class CreateEvent extends StatelessWidget {
  const CreateEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EventFormBloc(),
        child: Builder(builder: (context) {
          final eventFormBloc = context.read<EventFormBloc>();
          var admininteractor = context.read<AdminInteractor>();

          var idEvent;
          var loc;
          return Scaffold(
            backgroundColor: background,

            body: ListView(
              children: [
                FormBlocListener<EventFormBloc, String, String>(
                  onSubmitting: (context, state)  {
                    LoadingDialog.show(context);

                    eventFormBloc.event = Event(
                        name: eventFormBloc.nome.value,
                        startdate: Timestamp.fromDate(eventFormBloc.date.value!),
                        credits: eventFormBloc.credits.value,
                        favCounter: 0,
                        description: eventFormBloc.description.value,
                        baseCost: eventFormBloc.cost.valueToInt!.toDouble(),
                        blockCost: eventFormBloc.blockCost,
                        locations: eventFormBloc.locStringId,
                        operators: eventFormBloc.operStringId,
                        imagepath: " "
                    );

                    admininteractor.createEvent(eventFormBloc.event!).then((String value) async {
                      for (var element in eventFormBloc.locStringId) {
                        loc = await admininteractor.searchLocationById(element);
                        loc!.calendar.addAll({value: eventFormBloc.event!.startdate});
                        admininteractor.updateLocation(loc);
                      }
                    });

                  },
                  onSuccess: (context, state) {
                    LoadingDialog.hide(context);
                    SuccessDialog.show(context);
                  },

                  onFailure: (context, state) {
                    LoadingDialog.hide(context);
                  },
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: AutofillGroup(
                      child: Column(
                        children: <Widget>[
                          Card(
                            elevation: 10,
                            color: secondary,
                            shadowColor: secondary,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFieldBlocBuilder(
                                    textFieldBloc: eventFormBloc.nome,
                                    decoration: const InputDecoration(
                                      prefixIconColor: primary,
                                      labelText: 'Nome Evento',
                                      prefixIcon: Icon(Icons.event),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFieldBlocBuilder(
                                    textFieldBloc: eventFormBloc.cost,
                                    decoration: const InputDecoration(
                                      prefixIconColor: primary,
                                      labelText: 'Costo Evento',
                                      prefixIcon: Icon(Icons.attach_money_outlined),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DateTimeFieldBlocBuilder(
                                    dateTimeFieldBloc: eventFormBloc.date,
                                    format: DateFormat('dd-MM-yyyy'),
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    decoration: const InputDecoration(
                                      prefixIconColor: primary,
                                      labelText: "Data dell'evento",
                                      prefixIcon: Icon(Icons.calendar_today),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFieldBlocBuilder(
                                    textFieldBloc: eventFormBloc.description,
                                    decoration: const InputDecoration(
                                      prefixIconColor: primary,
                                      labelText: 'Descrizione',
                                      prefixIcon: Icon(Icons.description),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFieldBlocBuilder(
                                    textFieldBloc: eventFormBloc.credits,
                                    decoration: const InputDecoration(
                                      prefixIconColor: primary,
                                      labelText: 'Nome Artisti',
                                      prefixIcon: Icon(Icons.mic),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          BlocBuilder<ListFieldBloc<UserFieldBloc, dynamic>,
                              ListFieldBlocState<UserFieldBloc, dynamic>>(
                            bloc: eventFormBloc.members,
                            builder: (context, state) {
                              if (state.fieldBlocs.isNotEmpty) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.fieldBlocs.length,
                                  itemBuilder: (context, i) {
                                    return UserCard(
                                      memberIndex: i,
                                      memberField: state.fieldBlocs[i],
                                      onRemoveMember: () =>
                                          eventFormBloc.removeMember(i),
                                    );
                                  },
                                );
                              }
                              return Container();
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: secondary),
                            onPressed: eventFormBloc.addMember,
                            child: const Text('add Operator'),
                          ),
                          BlocBuilder<ListFieldBloc<LocationFieldBloc, dynamic>,
                              ListFieldBlocState<LocationFieldBloc, dynamic>>(
                            bloc: eventFormBloc.locations,
                            builder: (context, state) {
                              if (state.fieldBlocs.isNotEmpty) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.fieldBlocs.length,
                                  itemBuilder: (context, i) {
                                    return LocationCard(
                                      memberIndex: i,
                                      locationField: state.fieldBlocs[i],
                                      onRemoveMember: () =>
                                          eventFormBloc.removeLocation(i),
                                      onAddCost: () =>
                                          eventFormBloc.addCostToBlock(i),
                                    );
                                  },
                                );
                              }
                              return Container();
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: secondary),
                            onPressed: eventFormBloc.addLocation,
                            child: const Text('add Location'),
                          ),
                           ElevatedButton(
                             style: ElevatedButton.styleFrom(backgroundColor: primary),
                            onPressed: () {
                              eventFormBloc.submit();
                            },
                            child: const Text('Crea Evento'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}

class UserCard extends StatelessWidget {
  final int memberIndex;
  final UserFieldBloc memberField;

  final VoidCallback onRemoveMember;

  const UserCard({
    Key? key,
    required this.memberIndex,
    required this.memberField,
    required this.onRemoveMember,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var admininteractor = context.read<AdminInteractor>();

    admininteractor.listOfUser().then((value) => value.forEach((User element) {
          memberField.user.addItem(element);
        }));

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
                    'Member #${memberIndex + 1}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onRemoveMember,
                ),
              ],
            ),
            DropdownFieldBlocBuilder<User>(
              selectFieldBloc: memberField.user,
              decoration: const InputDecoration(
                labelText: 'Operatore',
                prefixIcon: Icon(Icons.people),
              ),
              itemBuilder: (context, value) => FieldItem(
                child: Text("${value.surname} ${value.name}"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationCard extends StatelessWidget {
  final int memberIndex;
  final LocationFieldBloc locationField;

  final VoidCallback onRemoveMember;
  final VoidCallback onAddCost;

  const LocationCard(
      {Key? key,
      required this.memberIndex,
      required this.locationField,
      required this.onRemoveMember,
      required this.onAddCost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var admininteractor = context.read<AdminInteractor>();

    admininteractor
        .listOfLocation()
        .then((value) => value.forEach((Location element) {
              locationField.locations.addItem(element);
            }));

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
                    'Location #${memberIndex + 1}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onRemoveMember,
                ),
              ],
            ),
            DropdownFieldBlocBuilder<Location>(
              selectFieldBloc: locationField.locations,
              decoration: const InputDecoration(
                labelText: 'Location',
                prefixIcon: Icon(Icons.add_business),
              ),
              itemBuilder: (context, value) => FieldItem(
                child: Text(value.name),
              ),
            ),
            BlocBuilder<ListFieldBloc<TextFieldBloc, dynamic>,
                ListFieldBlocState<TextFieldBloc, dynamic>>(
              bloc: locationField.cost,
              builder: (context, state) {
                if (state.fieldBlocs.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.fieldBlocs.length,
                    itemBuilder: (context, i) {
                      final costFieldBloc = state.fieldBlocs[i];
                      return Card(
                        color: Colors.blue[50],
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFieldBlocBuilder(
                                textFieldBloc: costFieldBloc,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Costo del Blocco #$i',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  locationField.cost.removeFieldBlocAt(i),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: background),
              onPressed: () {
                if (locationField.locations.value != null) {
                  for (var element in locationField.locations.value!.blocks) {
                    onAddCost.call();
                  }
                }
              },
              child: const Text('add Cost to block'),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => SuccessDialog(),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("L'evento è stato creato"),
      actions: [
        TextButton(
            onPressed: () {
              context.router.pop();
            },
            child: const Text("Ok")),
      ],
      elevation: 24,
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
