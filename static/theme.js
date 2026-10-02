(function () {
  var KEY = "bjjmap-theme";
  var root = document.documentElement;
  var media = window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)");
  function effectiveTheme() {
    return root.dataset.theme || (media && media.matches ? "dark" : "light");
  }
  function updateControls() {
    var current = effectiveTheme();
    document.querySelectorAll('meta[name="theme-color"]').forEach(function (meta) {
      meta.setAttribute("content", current === "dark" ? "#0b1118" : "#f5f7fa");
    });
    document.querySelectorAll(".theme-toggle").forEach(function (button) {
      button.setAttribute("aria-label", "Use " + (current === "dark" ? "light" : "dark") + " theme");
      button.setAttribute("title", "Use " + (current === "dark" ? "light" : "dark") + " theme");
      var icon = button.querySelector("span");
      if (icon) icon.textContent = current === "dark" ? "☀" : "☾";
    });
  }
  document.addEventListener("click", function (event) {
    var button = event.target.closest(".theme-toggle");
    if (!button) return;
    var next = effectiveTheme() === "dark" ? "light" : "dark";
    root.dataset.theme = next;
    try { localStorage.setItem(KEY, next); } catch (error) {}
    updateControls();
    window.dispatchEvent(new CustomEvent("bjjmap-themechange", {detail: {theme: next}}));
  });
  if (media) media.addEventListener("change", function () {
    if (!root.dataset.theme) {
      updateControls();
      window.dispatchEvent(new CustomEvent("bjjmap-themechange", {detail: {theme: effectiveTheme()}}));
    }
  });
  updateControls();
})();
