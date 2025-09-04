import { apiInitializer } from "discourse/lib/api";
import AddCodeblockButton from "../components/add-codeblock-button";

export default apiInitializer((api) => {
  api.renderInOutlet("quote-share-buttons-before", AddCodeblockButton);
});
