module TasksHelper
  def flash_message(message_type)
    %Q(<p class="#{message_type}"\>#{flash[message_type]}</p\>).html_safe
  end

  def delete_link_to(label, url)
    return (
      link_to label, 
      url, 
      method: 'delete', 
      data: { confirm: I18n.t("are_you_sure") } 
    )
  end
end
