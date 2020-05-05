// userChrome.js

function load_js_script(js_file_name) {
   Services.scriptloader.loadSubScript(Components.stack.filename.substring(0,
	Components.stack.filename.lastIndexOf("/") + 1) + js_file_name, window);
}

//load_js_script("./userChrome/my_script_name.uc.js");
//load_js_script("./userChrome/my_other_script_name.uc.js");

// Automatically toggle the visibility of the TopBar that shows the tabs when displaying the TreeStyleTabs side bad (and vice versa)
(function() {
    var tabbar = document.getElementById("TabsToolbar");
    function showHideTabbar() {
        var sidebarBox = document.getElementById("sidebar-box");
        var sidebarTST = sidebarBox.getAttribute("sidebarcommand");
        if (!sidebarBox.hidden && sidebarTST === "treestyletab_piro_sakura_ne_jp-sidebar-action") {
            tabbar.style.visibility = "collapse";
        }
        else tabbar.style.visibility = "visible";
    }
    var observer = new MutationObserver(showHideTabbar);
    observer.observe(document.getElementById("sidebar-box"), { attributes: true, attributeFilter: ["sidebarcommand", "hidden"] });
})();
