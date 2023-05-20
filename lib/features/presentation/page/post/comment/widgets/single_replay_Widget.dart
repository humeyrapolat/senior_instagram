import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:senior_instagram/features/domain/entities/replay/replay_entity.dart';
import 'package:senior_instagram/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:senior_instagram/profile_widget.dart';
import 'package:senior_instagram/util/consts.dart';
import 'package:senior_instagram/injection_container.dart' as di;

class SingleReplayWidget extends StatefulWidget {
  final ReplayEntity replay;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikePressListener;
  const SingleReplayWidget(
      {super.key,
      required this.replay,
      this.onLongPressListener,
      this.onLikePressListener});

  @override
  State<SingleReplayWidget> createState() => _SingleReplayWidgetState();
}

class _SingleReplayWidgetState extends State<SingleReplayWidget> {
  String _currentUUid = " ";

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUUid = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.onLongPressListener,
      child: Container(
        margin: const EdgeInsets.only(
          left: 10,
          top: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(imageUrl: widget.replay.userProfileUrl),
              ),
            ),
            sizeHorizontal(10),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.replay.username}",
                            style: const TextStyle(
                                color: primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                              onTap: widget.onLikePressListener,
                              child: Icon(
                                widget.replay.likes!.contains(_currentUUid)
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                color:
                                    widget.replay.likes!.contains(_currentUUid)
                                        ? Colors.red
                                        : secondaryColor,
                                size: 20,
                              )),
                        ],
                      ),
                      sizeVertical(4),
                      Text(
                        "${widget.replay.description}",
                        style: const TextStyle(
                            color: primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                      sizeVertical(4),
                      Text(
                        DateFormat('dd MMM yyyy')
                            .format(widget.replay.createAt!.toDate()),
                        style: const TextStyle(
                          color: secondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
