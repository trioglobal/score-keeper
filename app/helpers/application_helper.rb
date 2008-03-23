# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(page_title)
    @page_title = page_title
  end
  
  def page_title
    title = 'Score Keeper'[]
    title << ': ' + @page_title unless @page_title.blank?
    title << ' - ' + h(current_account.name)
    title
  end
  
  def user_area(&block)
    if logged_in?
      concat content_tag(:div, capture(&block), :class => 'authenticated'), block.binding
    end
  end
  
  def account_admin_area(&block)
    if account_admin?
      concat content_tag(:div, capture(&block), :class => 'admin'), block.binding
    end
  end
  
  def admin_area(&block)
    if admin?
      concat content_tag(:div, capture(&block), :class => 'admin'), block.binding
    end
  end
  
  def account_admin?
    logged_in? && current_user.is_account_admin? || current_user.is_admin?
  end
  
  def admin?
    logged_in? && current_user.is_admin?
  end
  
  def user_link(user)
    link_to h(user.display_name), user_path(user), :class => 'user'
  end
  
  def user_link_full(user)
    link_to h(user.name), user_path(user), :class => 'user'
  end

  def log_link(log)
    if log.linked_model == 'Match'
      link_to h(log.message), match_path(log.linked_id)
    elsif log.linked_model == 'Comment'
      link_to h(log.message), match_path(Comment.find(log.linked_id).match_id)
    else
      h(log.message)
    end
  end
  
  def graph(url)
    out = ''
    out << '<div id="flashcontent"></div>'
    out << '<script type="text/javascript">'
    out << 'var so = new SWFObject("' + url_for('/flash/open-flash-chart.swf') + '", "chart", "100%", "450", "9", "#FFFFFF");'
    out << 'so.addVariable("width", "100%");'
    out << 'so.addVariable("height", "450");'
    out << 'so.addVariable("data", "' + url + '");'
    out << 'so.addParam("allowScriptAccess", "sameDomain");'
    out << 'so.write("flashcontent");'
    out << '</script>'
    out
  end
end