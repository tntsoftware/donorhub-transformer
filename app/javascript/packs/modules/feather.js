// Usage: https://feathericons.com/
import feather from "feather-icons";

document.addEventListener("turbolinks:load", () => {
  feather.replace();
});

window.feather = feather;
