var sw = TreeHtmlGroup({
  name: 'by_file',
  key: function get_path(li) {
    var p = li.querySelector('a').innerText.replace(/.*\s(.*):\d+/, '$1')
    if (p === '') {
      var callees = li.querySelector('ul')
      if (callees !== null) {
        return get_path(callees.children[0])
      }
    }
    return '<b>' + p + '</b>'
  }
})
