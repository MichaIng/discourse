import Controller, { inject as controller } from "@ember/controller";
import { action } from "@ember/object";
import { alias } from "@ember/object/computed";
import { inject as service } from "@ember/service";
import { popupAjaxError } from "discourse/lib/ajax-error";
import I18n from "discourse-i18n";

export default class AdminWebHooksIndexController extends Controller {
  @service dialog;
  @controller adminWebHooks;

  @alias("adminWebHooks.contentTypes") contentTypes;
  @alias("adminWebHooks.defaultEventTypes") defaultEventTypes;
  @alias("adminWebHooks.deliveryStatuses") deliveryStatuses;
  @alias("adminWebHooks.eventTypes") eventTypes;
  @alias("adminWebHooks.model") model;

  @action
  destroy(webhook) {
    return this.dialog.deleteConfirm({
      message: I18n.t("admin.web_hooks.delete_confirm"),
      didConfirm: async () => {
        try {
          await webhook.destroyRecord();
          this.model.removeObject(webhook);
        } catch (e) {
          popupAjaxError(e);
        }
      },
    });
  }

  @action
  loadMore() {
    this.model.loadMore();
  }
}
