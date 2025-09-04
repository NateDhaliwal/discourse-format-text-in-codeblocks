import { apiInitializer } from "discourse/lib/api";
import AddCodeblockButton from "../components/add-codeblock-button";

export default apiInitializer((api) => {
  api.registerValueTransformer(
    "post-menu-buttons",
    ({
      value: dag,
      context: { lastHiddenButtonKey, secondLastHiddenButtonKey },
    }) => {
      dag.add("show-raw", AddCodeblockButton, {
        before: lastHiddenButtonKey,
        after: secondLastHiddenButtonKey,
      });
    }
  );
});
