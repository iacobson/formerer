let Form = {
  init(){

    for (var clip of $('[data-behaviour="clipboard-copy"]')){
      let clipboard = new Clipboard(clip)
      clipboard.on('success', this.clipboard_success)
    }

    $('[data-behaviour="toggle-submission-details"]').on('click', this.toggle_submission_details)

    // pass this object (Form) to the edit_name
    $('[data-behaviour="edit-form-name"]').on('click', () => this.edit_name())

    $('[data-behaviour="dialog"]').on('click', this.show_dialog)

    $(document).on('click', '[data-behaviour="submit-form"]', this.submit_form)
  },

  clipboard_success(){
    $('.copied-notice').show()
    $('.copied-notice').fadeOut(1000)
    $('[data-behaviour="clipboard-copy"]').blur()
  },

  toggle_submission_details(){
    let submission_id = $(this).parents('tr').data('id')
    $('[data-details-for="' + submission_id + '"]').toggle()
    return false;
  },

  edit_name(){
    $('[data-behaviour="edit-form-name"]').hide()
    let name_element = $('[data-behaviour="form-name"]')

    let value = name_element.text()
    name_element.data('old_value', value)

    name_element.prop('contenteditable', true)
    name_element.focus()

    this.select_contents(name_element[0])

    name_element.off('blur keyup')
    name_element.on('blur', this.update_name)
    name_element.on('keyup', (e) => {
      if (e.which === 13) {
        name_element.off('blur')
        this.update_name.call(name_element[0])
      }
    })
  },

  update_name(){
    var name_element = $(this)
    var value = name_element.text().replace(/\s+$/g, '')

    name_element.prop('contenteditable', false)
    $('[data-behaviour="edit-form-name"]').show()

    if (value.length !== 0) {
      name_element.text(value)
      var url = name_element.data('url')
      var token = name_element.data('token')

      $.ajax({
        url: url,
        type: 'POST',
        beforeSend: function(xhr) {
          xhr.setRequestHeader('x-csrf-token', token)
        },
        data: {
          _method: "patch",
          name: value
        },
        success: function(response) {
        }
      })

    } else {
      name_element.text(name_element.data('old_value'))
    }
  },

  select_contents(element){
    var range = document.createRange()
    range.selectNodeContents(element)
    var selection = window.getSelection()
    selection.removeAllRanges()
    selection.addRange(range)
  },

  show_dialog(){
    $.fancybox.open({
      type: 'ajax',
      padding: 0,
      href: $(this).attr('href'),
      beforeShow: function() {
        componentHandler.upgradeDom()
      }
    })
    return false
  },

  submit_form(){
    var form = $(this).parents('form')
    var url = form.attr('action')

    $.post(url, form.serialize(), function() {
      window.location.reload()
    })
    return false
  }
}

export default Form
