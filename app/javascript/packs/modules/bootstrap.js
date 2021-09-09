import * as bootstrap from "bootstrap";

// Bootstrap
// Note: If you want to make bootstrap globally available, e.g. for using `bootstrap.modal`
window.bootstrap = bootstrap;

document.addEventListener("turbolinks:load", () => {
  var tooltipTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="tooltip"]')
  );
  tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl);
  });
});
