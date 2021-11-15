ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| 
    "<div class=\"field_with_errors has-error\">#{html_tag}</div>".html_safe
}