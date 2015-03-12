require(["nb-mermaid/mermaid.full.js"], function(events){
  mermaid.init();
});

require(["base/js/events", "jquery"], function(events, $){
  events.on("rendered.MarkdownCell", function(evt, data){
    data.cell.element.find(".mermaid").each(function(idx, node){
      try{
        mermaid.init(undefined, node);
      }catch(err){
        $(node).prepend(
          $("<div/>", {"class": "alert alert-warning"})
            .text("Mermaid couldn't parse your diagram. Check the console (F12) for details.")
          );
      }
    })
  });
});
