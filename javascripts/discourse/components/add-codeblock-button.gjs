import Component from "@glimmer/component";
import DButton from "discourse/components/d-button";
import { action } from "@ember/object";
import { selectedRange } from "discourse/lib/utilities";
import { i18n } from "discourse-i18n";

export default class AddCodeblockButton extends Component {
  if (this.args.outletArgs.data.canEdit === false) {
    return;
  }

  get selectedText() {
    console.log(this.args.outletArgs);
    return this.args.outletArgs.data.quoteState.buffer.trim();
  }

  @action
  addCodeFences() {
    let selectedText = this.selectedText;
    let newText = "```" + "\n" + selectedText + "\n" + "```";
    console.log(newText);
    this.args.outletArgs.data.editPost();
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
