import Component from "@glimmer/component";
import DButton from "discourse/components/d-button";
import { action } from "@ember/object";
import { selectedRange } from "discourse/lib/utilities";
//import { i18n } from "discourse-i18n";

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
    console.log(this.args.outletArgs);
    return this.args.outletArgs.data.quoteState.buffer.trim();
  }

  @action
  async addCodeFences() {
    let selectedText = this.selectedText;
    let newText = "```" + "\n" + selectedText + "\n" + "```";
    let post = this.post;
    console.log(post);
    console.log(I18n.t(themePrefix("add_code_fence_edit_reason")));
    let rawPost = post.raw;

    rawPost.replace(selectedText, "\n" + newText + "\n");

    await this.post.save({
      raw: rawPost,
      edit_reason: I18n.t(themePrefix("add_code_fence_edit_reason"))
    });

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
