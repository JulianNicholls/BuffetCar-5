function scrollToBottom() {
  var $messages = $('#messages');

  if ($messages.length > 0) {
    $messages.scrollTop($messages[0].scrollHeight);
  }
}

function submitMessage(event) {
  event.preventDefault();
  $('#new_message').submit();
}

$(document).ready(scrollToBottom);
$(document).on('turbolinks:load', scrollToBottom);

$(document).on('keypress', '[data-behavior~=room_speaker]', function (event) {
  if (event.keyCode == 13)        // Enter
    submitMessage(event)
});
