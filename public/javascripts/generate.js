$(document).ready(init);

function init() {
  $('input[type=submit]').click(generate);
}

function generate(e) {
  e.stopPropagation();
  e.preventDefault();

  color = $('input[name=color]').val();
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
}
function error() {
  response('An error occurred. Please try again');
}
function response(text) {
  $('#response').html(text);
}
