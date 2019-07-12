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

  def sort_link_to(label, url, param)
    if params[param] == "asc"
      return link_to label, { controller: url, action: 'index', params: { created_at: 'desc' } }, class: 'sort_link_asc'
    elsif params[param] == "desc"
      return link_to label, { controller: url, action: 'index', params: { created_at: 'asc' } }, class: 'sort_link_desc'
      
      # The following for page's default views
    else
      return link_to label, { controller: url, action: 'index', params: { created_at: 'desc' } }
    end
  end
end
