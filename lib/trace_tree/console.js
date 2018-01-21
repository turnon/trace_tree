(function(){
  var y = undefined,
      min = 11,
      footer = document.createElement('div'),
      border = document.createElement('div'),
      consl = document.createElement('div'),
      body = document.getElementsByTagName('body')[0];

  border.id = 'consl-border';
  consl.id = 'consl';
  body.appendChild(footer);
  body.appendChild(border);
  body.appendChild(consl);

  function drag(e){
    var distance = e.clientY - y,
        h = border.style.bottom;
    y = e.clientY;
    var new_h = parseInt(h) - distance;
    border.style.bottom = new_h + 'px';
    consl.style.height = consl.style['max-height'] = new_h + 'px';
    footer.style.height = new_h + 'px';
    consl.scroll(0, consl.scrollHeight);
  }

  border.addEventListener('dragstart',function(e){y = e.clientY;});
  border.addEventListener('drag', drag);
  border.addEventListener('dragend', drag);

  function init_height(){
    border.style.bottom = min + 'px';
    consl.style.height = consl.style['max-height'] = min + 'px';
    footer.style.height = min + 'px';
  }

  init_height();

  (function fix_abnormal_height(){
    var max = window.innerHeight - 10,
        consl_h = parseInt(consl.style.height),
    border_h = parseInt(border.style.bottom);
    if(consl_h > max || border_h > max || consl_h < min || border_h < min){
      init_height();
    }
    setTimeout(fix_abnormal_height, 200);
  })();
})();

TreeHtml.hover_press('r', function(n){
  var a = n.querySelector('a');
  var repl = '> ' + a.querySelector('span').innerText + "\n" + a.getAttribute('data-return');
  console.log(repl);
  var consl = document.getElementById('consl');
  consl.innerText = consl.innerText + repl + "\n";
  consl.scroll(0, consl.scrollHeight);
});
