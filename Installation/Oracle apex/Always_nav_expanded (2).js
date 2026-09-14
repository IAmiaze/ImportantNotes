apex.jQuery(function() {
  setTimeout(function() {
    var btn = document.getElementById("t_Button_navControl");
    var body = document.body;

    if (btn && body) {
      var isExpanded = btn.getAttribute("aria-expanded") === "true";
      if (!isExpanded || !btn.classList.contains("is-active")) {
        btn.click();
        btn.classList.add("is-active");
        btn.setAttribute("aria-expanded", "true");
        body.classList.remove("t-Body-navCollapsed");
        body.classList.add("t-Body-navExpanded");
      } else {
        btn.classList.add("is-active");
        btn.setAttribute("aria-expanded", "true");
        body.classList.remove("t-Body-navCollapsed");
        body.classList.add("t-Body-navExpanded");
      }
    }
  }, 50);
});
