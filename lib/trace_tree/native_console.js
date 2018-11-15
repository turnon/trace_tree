(function(){
  TreeHtml.hover_press('r', function(n){
    var a = n.querySelector('a');
    var repl = '> ' + a.querySelector('span').innerText + "\n" + a.getAttribute('data-return');
    console.log(repl);
  });
})();
