import { action } from "@ember/object";
import Component from "@glimmer/component";

import { ajax } from "discourse/lib/ajax";
import DButton from "discourse/components/d-button";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { selectedRange } from "discourse/lib/utilities";

export default class AddCodeblockButton extends Component {
  get topic() {
    return this.args.outletArgs.data.topic;
  }

  get post() {
    return this.topic.postStream.findLoadedPost(
      this.args.data.quoteState.postId
    );
  }

  get selectedText() {
    return this.args.outletArgs.data.quoteState.buffer.trim();
  }

  async getPostRaw() {
    const result = await ajax(`/posts/${this.post.id}`);
    return result.raw.trim();
  }

  @action
  async addCodeFences() {
    let selectedText = this.selectedText;
    let newText = "\n" + "```" + "\n" + selectedText + "\n" + "```" + "\n";
    let rawPost;
    const post = this.post;

    try {
      rawPost = await this.getPostRaw();
    } catch (e) {
      popupAjaxError(e);
    }

    const newRawPost = rawPost.replaceAll(selectedText, newText);
    let a = rawPost.replaceAll("\n", "|$|$|$|");
    console.log({ selectedText, escapedTarget, regex, newRawPost, a });

    try {
      await post.save({
        raw: newRawPost,
        edit_reason: I18n.t(themePrefix("add_code_fence_edit_reason"))
      });
    } catch (e) {
      popupAjaxError(e);
    }
  }

  <template>
    <DButton
      @icon="code"
      @action={{this.addCodeFences}}
      @label={{themePrefix "add_code_fence_btn_label"}}
      @title={{themePrefix "add_code_fence_btn_title"}}
      class="btn-flat"
    />
  </template>
}
