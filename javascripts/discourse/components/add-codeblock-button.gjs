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
    let newText = "```" + "\n" + selectedText + "\n" + "```";
    let post = this.post;

    const rawPost = this.getPostRaw();
    rawPost.replace(selectedText, "\n" + newText + "\n");

    try {
      await this.post.save({
        raw: "New raw of the contents. I hope you find it interesting." /* rawPost */,
        edit_reason: I18n.t(themePrefix("add_code_fence_edit_reason"))
      });
    } catch (e) {
      popupAjaxError(e);
    }

    // console.log(this.store);
    // https://github.com/discourse/discourse/blob/main/app/assets/javascripts/discourse/app/routes/post.js#L4
    // console.log(this.store.find("post", this.post.id));
    // this.args.outletArgs.data.editPost(this.post);
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
