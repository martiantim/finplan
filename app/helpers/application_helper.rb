module ApplicationHelper
  def errors_for(object, message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class='formErrors #{object.class.name.humanize.downcase}Errors'>\n"
      if message.blank?
        if object.new_record?
          html << "\t\t<h5>There was a problem creating the #{object.class.name.humanize.downcase}</h5>\n"
        else
          html << "\t\t<h5>There was a problem updating the #{object.class.name.humanize.downcase}</h5>\n"
        end    
      else
        html << "<h5>#{message}</h5>"
      end  
      html << "\t\t<ul>\n"
      object.errors.full_messages.each do |error|
        html << "\t\t\t<li>#{error}</li>\n"
      end
      html << "\t\t</ul>\n"
      html << "\t</div>\n"
    end
    html
  end


  def description_block(desc, more_link)
    return "" if desc.blank?

    html = "<span class=\"help-block\">#{desc}"
    if more_link
      html += ' <span class="more">'
      html += link_to "more", more_link, :target => "_blank"
      html += ' <span class="glyphicon glyphicon-new-window"></span>'
      html += '</span>'
    end
    html += '</span'
    raw html
  end
end
