import 'package:dash_chat/dash_chat.dart';

import 'package:agree_n/app/data/models/user.model.dart';

extension ChatUserExtend on ChatUser {
  dynamic _getCustomProperty(String key, [dynamic defaultValue]) {
    if (this.customProperties == null || this.customProperties[key] == null)
      return defaultValue;
    return this.customProperties[key];
  }

  void _setCustomProperty(String key, dynamic value) {
    if (this.customProperties == null) this.customProperties = {};
    this.customProperties[key] = value;
  }

  void setCustomProperties({UserModel user}) {
    this.loggedUser = user;
  }

  UserModel get loggedUser {
    return this._getCustomProperty('loggedUser');
  }

  set loggedUser(UserModel value) {
    this._setCustomProperty('loggedUser', value);
  }
}

extension ChatMessageExtend on ChatMessage {
  dynamic _getCustomProperty(String key, [dynamic defaultValue]) {
    if (this.customProperties == null || this.customProperties[key] == null)
      return defaultValue;
    return this.customProperties[key];
  }

  void _setCustomProperty(String key, dynamic value) {
    if (this.customProperties == null) this.customProperties = {};
    this.customProperties[key] = value;
  }

  String get messageName {
    return this._getCustomProperty('messageName');
  }

  set messageName(String value) {
    this._setCustomProperty('messageName', value);
  }

  int get termId {
    return this._getCustomProperty('type');
  }

  set termId(int value) {
    this._setCustomProperty('type', value);
  }

  int get termStatus {
    return this._getCustomProperty('status');
  }

  set termStatus(int value) {
    this._setCustomProperty('status', value);
  }

  void setCustomProperties({
    String messageName,
    int termId,
    int termStatus,
  }) {
    this.messageName = messageName;
    this.termId = termId;
    this.termStatus = termStatus;
  }
}
