import Component from "@glimmer/component";
import DButton from "discourse/components/d-button";
import { action } from "@ember/object";
import { selectedRange } from "discourse/lib/utilities";

export default class AddCodeblockButton extends Component {
  get selectedText() {
    return this.args.outletArgs.data.quoteState.buffer.trim();
  }

  @action
  addCodeFences() {
    let selectedText = this.selectedText;
    let newText = "```" + "\n" + selectedText + "\n" + "```";
    console.log(newText);
  }

  <template>
    <DButton
    @icon="code"
    @action={{this.addCodeFences}}
    class="btn-flat"
    />
  </template>
}
