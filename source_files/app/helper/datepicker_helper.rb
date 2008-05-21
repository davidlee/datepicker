module DatepickerHelper
  
  def date_picker(object, method)
    obj = instance_eval("@#{object}")
    value = obj.send(method)
    display_value = value.respond_to?(:strftime) ? value.strftime('%d %b %Y') : value.to_s
    display_value = '[ choose date ]' if display_value.blank?

    out = hidden_field(object, method)
    out << content_tag('a', display_value, :href => '#',
        :id => "_#{object}_#{method}_link", :class => '_demo_link',
        :onclick => "DatePicker.toggleDatePicker('#{object}_#{method}'); return false;")
    out << content_tag('div', ' ', {:class => 'date_picker', :style => 'display: none',
                      :id => "_#{object}_#{method}_calendar"})
    if obj.respond_to?(:errors) and obj.errors.on(method) then
      ActionView::Base.field_error_proc.call(out, nil) # What should I pass ?
    else
      out
    end
  end

  def date_picker_tag(name, default=nil)
    linktext = case default
      when String: default
      when Date:   default.strftime "%d %b %Y"
      when Time:   default.strftime "%d %b %Y"
      else '[ choose date ]'.gsub(' ','&nbsp;')
    end

    initv = case default
      when String: linktext
      when Date:   default.strftime "%Y-%m-%d"
      when Time:   default.strftime "%Y-%m-%d"
      else ''
    end
    
    "<input id=\"#{name}\" 
      name=\"#{name}\" 
      value=\"#{initv}\" 
      type=\"hidden\"
      size=\"10\" />" + 
    "<a id=\"_#{name}_link\" 
      href=\"#\" 
      onclick=\"DatePicker.toggleDatePicker('#{name}')\"
      class=\"demo_link\">#{linktext}</a>" +
    "<div id=\"_#{name}_calendar\" 
      class=\"date_picker\"
      style=\"display:none\"></div>"
  end
end
