import '../data/remote/api_problem.dart';
import '../l10n/app_localizations.dart';
import 'status_view.dart';

extension ApiProblemText on ApiProblem {
  String message(AppLocalizations l10n) => switch (this) {
    ApiProblem.offline => l10n.noNetworkNeeded,
    ApiProblem.server => l10n.serverErrorBody,
    ApiProblem.notAllowed => l10n.errorNotAllowed,
    ApiProblem.notFound => l10n.errorNotFound,
    ApiProblem.conflict => l10n.errorConflict,
    ApiProblem.invalid => l10n.errorInvalid,
    ApiProblem.unknown => l10n.listingActionFailed,
  };

  StatusKind get statusKind => this == ApiProblem.offline
      ? StatusKind.noNetwork
      : StatusKind.serverError;
}

String errorMessage(Object? error, AppLocalizations l10n) =>
    ApiProblem.of(error).message(l10n);
