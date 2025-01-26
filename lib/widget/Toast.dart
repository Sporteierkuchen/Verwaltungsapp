import 'package:flutter/material.dart';

showInfo(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
                child:
                Icon(color: Colors.blue, size: 40, Icons.info_outlined),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                   text,
                    softWrap: true,
                    style: const TextStyle(
                      height: 0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
    )
  );
}

showSuccess(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child:
              Icon(color: Colors.green, size: 40, Icons.check),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  text,
                  softWrap: true,
                  style: const TextStyle(
                    height: 0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
  );
}

showWarning(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child:
              Icon(color: Colors.orange, size: 40, Icons.warning_outlined),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  text,
                  softWrap: true,
                  style: const TextStyle(
                    height: 0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
  );
}

showError(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
              child:
              Icon(color: Colors.red, size: 40, Icons.error_outlined),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  text,
                  softWrap: true,
                  style: const TextStyle(
                    height: 0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
  );
}