// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

function clipboard_success() {
  $('.copied-notice').show();
  $('.copied-notice').fadeOut(1000);
  $('[data-behaviour="clipboard-copy"]').blur();
}

function toggle_submission_details() {
  var submission_id = $(this).parents('tr').data('id');

  $('[data-details-for="' + submission_id + '"]').toggle();

  return false;
}

function edit_name() {
  $('[data-behaviour="edit-form-name"]').hide();
  var name_element = $('[data-behaviour="form-name"]');

  var value = name_element.text();
  name_element.data('old_value', value);

  name_element.prop('contenteditable', true);
  name_element.focus();
  select_contents(name_element[0]);

  name_element.off('blur keyup');
  name_element.on('blur', update_name);
  name_element.on('keyup', function(e) {
    if (e.which === 13) {
      name_element.off('blur');
      update_name.call(name_element[0]);
    }
  });
}

function update_name() {
  var name_element = $(this);
  var value = name_element.text().replace(/\s+$/g, '');

  name_element.prop('contenteditable', false);
  $('[data-behaviour="edit-form-name"]').show();

  if (value.length !== 0) {
    name_element.text(value);
    var url = name_element.data('url');
    var token = name_element.data('token');

    $.ajax({
      url: url,
      type: 'POST',
      beforeSend: function(xhr) {
        xhr.setRequestHeader('x-csrf-token', token);
      },
      data: {
        _method: "patch",
        name: value
      },
      success: function(response) {
      }
    });

  } else {
    name_element.text(name_element.data('old_value'));
  }
}

function select_contents(element) {
  var range = document.createRange();
  range.selectNodeContents(element);
  var selection = window.getSelection();
  selection.removeAllRanges();
  selection.addRange(range);
}

function show_dialog() {
  $.fancybox.open({
    type: 'ajax',
    padding: 0,
    href: $(this).attr('href'),
    beforeShow: function() {
      componentHandler.upgradeDom();
    }
  });
  return false;
}

function submit_form() {
  var form = $(this).parents('form');
  var url = form.attr('action');

  $.post(url, form.serialize(), function() {
    window.location.reload();
  });

  return false;
}

$(function() {
  $('[data-behaviour="clipboard-copy"]').each(function() {
    var clipboard = new Clipboard(this);
    clipboard.on('success', clipboard_success);
  });

  $('[data-behaviour="toggle-submission-details"]').on('click', toggle_submission_details);

  $('[data-behaviour="edit-form-name"]').on('click', edit_name);

  $('[data-behaviour="dialog"]').on('click', show_dialog);

  $(document).on('click', '[data-behaviour="submit-form"]', submit_form);
});
