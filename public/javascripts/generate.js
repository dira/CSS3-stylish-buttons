$(document).ready(init);

function init() {
  submit_field().click(generate);

  color = document.location.hash.substr(1);
  if (color != "") {
    color_field().val(color);
  }
  submit_field().click();
}

function submit_field() {
  return $('input[type=submit]')
}

function color_field() {
  return $('input[name=color]')
}

function generate(e) {
  e.stopPropagation();
  e.preventDefault();

  color = color_field().val();
  form = $('form');
  $.ajax({
    type: form.attr('method'),
    url:  form.attr('action') + '.part',
    data: { color: color },
    beforeSend: reset,
    success:    success,
    error:      error
  })
}

function reset() {
  response('Loading...');
}
function success(html) {
  response(html);
  document.location.hash = color_field().val();
}
function error() {
  response('An error occurred. Please try again');
}
function response(text) {
  $('#response').html(text);
}
