function scrollToBottom() {
  var $messages = $('#messages');

  if ($messages.length > 0) {
    $messages.scrollTop($messages[0].scrollHeight);
  }
}

$(document).ready(scrollToBottom);
