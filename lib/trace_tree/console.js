(function(){
  var footer = document.createElement('div'),
      border = document.createElement('div'),
      consl = document.createElement('div'),
      body = document.getElementsByTagName('body')[0];

  border.id = 'consl-border';
  consl.id = 'consl';
  footer.id = 'footer';
  body.appendChild(footer);
  body.appendChild(border);
  border.appendChild(consl);

  (function sync_height(){
    footer.style.height = consl.offsetHeight + 'px';
    setTimeout(sync_height, 500);
  })();

  var repl_sum = '';

  TreeHtml.hover_press('r', function(n){
    var a = n.querySelector('a');
    var repl = '> ' + a.querySelector('span').innerText + "\n" + a.getAttribute('data-return');
    repl_sum = repl_sum + "\n" + repl;
    consl.innerText = "\n" + repl_sum;
    consl.scroll(0, consl.scrollHeight);
  });
})();
