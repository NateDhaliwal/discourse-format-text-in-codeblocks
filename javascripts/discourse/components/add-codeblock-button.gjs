import Component from "@glimmer/component";
import DButton from "discourse/components/d-button";
import { selectedRange } from "discourse/lib/utilities";

export default class AddCodeblockButton extends Component {
  menuData = {
    ...this.args.outletArgs.data,
    quoteState: {
      buffer: this.args.outletArgs.data.quoteState.buffer,
      opts: this.args.outletArgs.data.quoteState.opts,
      postId: this.args.outletArgs.data.quoteState.postId,
    },
    post: this.args.outletArgs.post,
    selectedRange: selectedRange(),
  };

  console.log(menuData);

  <template>
    <DButton
    @icon="code"
    class="btn-flat"
    />
  </template>
}
