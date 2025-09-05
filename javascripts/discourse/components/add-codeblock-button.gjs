import { action } from "@ember/object";
import { service } from "@ember/service";

import Component from "@glimmer/component";

import { ajax } from "discourse/lib/ajax";
import DButton from "discourse/components/d-button";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default class AddCodeblockButton extends Component {
  @service toasts;

  get topic() {
    return this.args.outletArgs.data.topic;
  }

  get post() {
    return this.topic.postStream.findLoadedPost(
      this.args.data.quoteState.postId
    );
  }

  get selectedText() {
    return this.args.data.quoteState.buffer.trim();
  }

  async getPostRaw() {
    const result = await ajax(`/posts/${this.post.id}`);
    return result.raw.trim();
  }

  replaceSelection(rawPost, selectedText) {
    const startIndex = rawPost.indexOf(selectedText);
    if (startIndex === -1) {
      this.toasts.error({
        duration: "short",
        data: {
          message: I18n.t(themePrefix("add_code_fence_faliure_message")),
        },
      });
      return rawPost;
    }
  
    const endIndex = startIndex + selectedText.length;
    const newText = "\n```\n" + selectedText + "\n```\n";
  
    return rawPost.slice(0, startIndex) + newText + rawPost.slice(endIndex);
  }


  @action
  async addCodeFences() {
    let selectedText = this.selectedText;
    // let newText = "\n" + "```" + "\n" + selectedText + "\n" + "```" + "\n";
    let rawPost;
    const post = this.post;

    try {
      rawPost = await this.getPostRaw();
    } catch (e) {
      popupAjaxError(e);
    }

    // const newRawPost = rawPost.replaceAll(selectedText, newText);
    // console.log(rawPost.includes(selectedText));
    // console.log(selectedRange());

    console.log(this.replaceSelection(rawPost, selectedText);
    console.log({ selectedText, /* newText,*/ newRawPost, rawPost });

    try {
      await post.save({
        raw: newRawPost,
        edit_reason: I18n.t(themePrefix("add_code_fence_edit_reason"))
      }).then(() => {
        this.toasts.success({
          duration: "short",
          data: {
            message: I18n.t(themePrefix("add_code_fence_success_message")),
          },
        });
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
