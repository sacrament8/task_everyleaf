document.addEventListener("turbolinks:load", function(){
  //優先順位アイコンのクラス書き換え分岐
  $(".priority").each(function(i, el) {
    if ($(this).text() == "高") {
      $(this).removeClass()
      $(this).addClass("btn-danger btn priority");
    } else if ($(this).text() == "中") {
      $(this).removeClass()
      $(this).addClass("btn-warning btn text-light priority");
    } else if ($(this).text() == "低") {
      $(this).removeClass()
      $(this).addClass("btn-success btn priority");
  }
  })
  setTimeout("$('.vani_fla').fadeOut('slow')", 2000) 
  
});